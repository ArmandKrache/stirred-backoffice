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

    logger.d(result);

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    logger.d(response);

    return PaginationState(
      items: response?.ingredients ?? [],
    );
  }

  @override
  Future<bool> fetchItems({
    bool resetList = false,
    int offset = 0,
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
        final result = await ref.read(drinksRepositoryProvider).getIngredientsList();

        return result.when(
          success: (response) {
            this.state = AsyncData(
              state.copyWith(
                items: state.items + response.ingredients,
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

    if (result.when(success: (_) => true, failure: (_) => false)) {
      // Refresh the list to show the new ingredient
      await fetchItems(resetList: true);
      return true;
    }

    return false;
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

    if (result.when(success: (_) => true, failure: (_) => false)) {
      // Refresh the list to show the updated ingredient
      await fetchItems(resetList: true);
      return true;
    }

    return false;
  }

  /// Deletes an ingredient
  Future<bool> deleteIngredient(String ingredientId) async {
    final result = await ref.read(drinksRepositoryProvider).deleteIngredient(ingredientId);

    if (result.when(success: (_) => true, failure: (_) => false)) {
      // Refresh the list to remove the deleted ingredient
      await fetchItems(resetList: true);
      return true;
    }

    return false;
  }
} 