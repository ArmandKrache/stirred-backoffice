import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'ingredients_notifier.g.dart';

/// The Notifier enclosing the `IngredientsView` logic.
@riverpod
class IngredientsNotifier extends _$IngredientsNotifier with PaginationNotifierMixin<Ingredient> {
  @override
  Future<PaginationState<Ingredient>> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  Future<PaginationState<Ingredient>> _load() async {
    final result = await ref.read(drinksRepositoryProvider).getIngredientsList();

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return PaginationState(
      items: response?.ingredients ?? [],
    );
  }

  @override
  Future<bool> fetchItems({
    bool resetList = false,
    int page = 1,
  }) async {
    if (resetList) {
      state = state.whenData(
        (data) => data.copyWith(
          items: [],
          isUpToDate: false,
        ),
      );
    }

    return state.maybeWhen(
      data: (state) async {
        final result = await ref.read(drinksRepositoryProvider).getIngredientsList(
          page: page,
          pageSize: 20,
        );

        return result.when(
          success: (response) {
            final newItems = response.ingredients;
            final updatedItems = resetList ? newItems : state.items + newItems;
            
            this.state = AsyncData(
              state.copyWith(
                items: updatedItems,
                isUpToDate: newItems.isEmpty, // If we get an empty response, we've reached the end
              ),
            );
            return true;
          },
          failure: (_) => false,
        );
      },
      orElse: () => false,
    );
  }

  @override
  Future<void> search(String query) async {
    state = state.whenData(
      (data) => data.copyWith(
        searchQuery: query,
        isReloading: true,
      ),
    );

    try {
      await fetchItems(resetList: true);
      state = state.whenData(
        (data) => data.copyWith(isReloading: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  @override
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    state = state.whenData(
      (data) => data.copyWith(
        activeFilters: filters,
        isReloading: true,
      ),
    );

    try {
      await fetchItems(resetList: true);
      state = state.whenData(
        (data) => data.copyWith(isReloading: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  @override
  void clearFilters() {
    state = state.whenData(
      (data) => data.copyWith(
        searchQuery: '',
        activeFilters: {},
      ),
    );
  }

  /// Creates a new ingredient
  Future<bool> createIngredient(Map<String, dynamic> body) async {
    logger.d(body);
    final result = await ref.read(drinksRepositoryProvider).createIngredient(
      request: IngredientCreateRequest(
        name: body['name'],
        description: body['description'],
        picture: body['picture'],
        matches: body['matches'],
        categories: body['categories'],
      ),
    );

    return result.when(
      success: (response) {
        // Add the new ingredient to the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: [response.ingredient, ...data.items],
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  /// Updates an existing ingredient
  Future<bool> updateIngredient(String ingredientId, Map<String, dynamic> body) async {
    final result = await ref.read(drinksRepositoryProvider).patchIngredient(
      ingredientId,
      name: body['name'],
      description: body['description'],
      picture: body['picture'],
      matches: body['matches'],
      categories: body['categories'],
    );

    return result.when(
      success: (response) {
        // Update the ingredient in the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.map((ingredient) {
              if (ingredient.id == ingredientId) {
                return response.ingredient;
              }
              return ingredient;
            }).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  /// Deletes an ingredient
  Future<bool> deleteIngredient(String ingredientId) async {
    final result = await ref.read(drinksRepositoryProvider).deleteIngredient(ingredientId);

    return result.when(
      success: (_) {
        // Remove the ingredient from the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.where((ingredient) => ingredient.id != ingredientId).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }
} 