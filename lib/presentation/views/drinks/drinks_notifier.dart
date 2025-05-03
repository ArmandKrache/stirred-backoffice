import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/providers/current_data.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drinks_notifier.g.dart';

/// The Notifier enclosing the `DrinksView` logic.
@riverpod
class DrinksNotifier extends _$DrinksNotifier with PaginationNotifierMixin<Drink> {
  @override
  Future<PaginationState<Drink>> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  Future<PaginationState<Drink>> _load() async {
    final result = await ref.read(drinksRepositoryProvider).getDrinksList();

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return PaginationState(
      items: response?.drinks ?? [],
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
        final result = await ref.read(drinksRepositoryProvider).getDrinksList(
          offset: offset,
        );

        return result.when(
          success: (response) {
            this.state = AsyncData(
              state.copyWith(
                items: state.items + response.drinks,
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

  Future<bool> createDrink(Map<String, dynamic> body) async {
    logger.d(body);
    final recipe = RecipeCreateRequest(
      name: body['name'],
      description: body['description'],
      ingredients: body['recipe']['ingredients'],
      instructions: body['recipe']['instructions'],
      preparationTime: body['recipe']['preparation_time'],
      difficulty: body['recipe']['difficulty'],
    );
    logger.d(recipe);

    final result = await ref.read(drinksRepositoryProvider).createRecipe(recipe);

    final recipeId = result.when(
      success: (response) => response.recipe.id,
      failure: (_) => null,
    );

    final user = ref.read(currentDataNotifierProvider).whenOrNull(
          data: (data) => data.whenOrNull(
            authentified: (data) => data,
            unauthentified: (_) => null,
          ),
        );

    if (recipeId == null || user == null) {
      return false;
    }

    final drink = DrinkCreateRequest(
      name: body['name'],
      description: body['description'],
      picture: body['picture'],
      categories: body['categories'],
      recipe: recipeId,
      author: user.id,
      glass: body['glass'],
    );

    final drinkResult = await ref.read(drinksRepositoryProvider).createDrink(request: drink);

    return drinkResult.when(success: (response) => true, failure: (_) => false);
  }
}
