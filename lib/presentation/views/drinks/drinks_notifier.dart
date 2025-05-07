import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/providers/current_data.dart';
import 'package:stirred_backoffice/presentation/views/drinks/widgets/drinks_filter_dialog.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drinks_notifier.g.dart';

/// The Notifier enclosing the `DrinksView` logic.
@riverpod
class DrinksNotifier extends _$DrinksNotifier with PaginationNotifierMixin<Drink> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  DrinksOrdering _currentOrdering = DrinksOrdering.trending;
  bool _isFavoritesOnly = false;

  DrinksOrdering get currentOrdering => _currentOrdering;
  bool get isFavoritesOnly => _isFavoritesOnly;

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<PaginationState<Drink>> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  Future<PaginationState<Drink>> _load() async {
    final result = await ref.read(drinksRepositoryProvider).getDrinksList(
      ordering: _currentOrdering.value,
      favoritesOnly: _isFavoritesOnly,
    );

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
        final result = await ref.read(drinksRepositoryProvider).getDrinksList(
          page: page,
          pageSize: 20,
          query: state.searchQuery.isNotEmpty ? state.searchQuery : null,
          ordering: _currentOrdering.value,
          favoritesOnly: _isFavoritesOnly,
        );

        return result.when(
          success: (response) {
            final newItems = response.drinks;
            final updatedItems = resetList ? newItems : state.items + newItems;
            
            this.state = AsyncData(
              state.copyWith(
                items: updatedItems,
                isUpToDate: newItems.isEmpty, // If we get an empty response, we've reached the end
                isReloading: false,
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
    // Only update the search query in the state, don't trigger a reload yet
    state = state.whenData(
      (data) => data.copyWith(searchQuery: query),
    );

    _debouncer.debounce(() async {
      // Only update the loading state, don't modify the search query
      state = state.whenData(
        (data) => data.copyWith(isReloading: true),
      );

      try {
        await fetchItems(resetList: true);
      } catch (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      }
    });
  }

  @override
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    _currentOrdering = filters['ordering'] as DrinksOrdering;
    _isFavoritesOnly = filters['favoritesOnly'] as bool;

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
    _currentOrdering = DrinksOrdering.trending;
    _isFavoritesOnly = false;

    state = state.whenData(
      (data) => data.copyWith(
        searchQuery: '',
        activeFilters: {},
      ),
    );
  }


  Future<bool> createDrink(Map<String, dynamic> body) async {
    final recipe = RecipeCreateRequest(
      name: body['name'],
      description: body['description'],
      ingredients: body['recipe']['ingredients'],
      instructions: body['recipe']['instructions'],
      preparationTime: body['recipe']['preparation_time'],
      difficulty: body['recipe']['difficulty'],
    );

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

    return drinkResult.when(
      success: (response) {
        // Add the new drink to the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: [response.drink, ...data.items],
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  /// Deletes a drink and its associated recipe
  Future<bool> deleteDrink(String drinkId) async {
    final result = await ref.read(drinksRepositoryProvider).deleteDrink(drinkId);

    return result.when(
      success: (_) {
        // Remove the drink from the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.where((drink) => drink.id != drinkId).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  Future<bool> updateDrink(String drinkId, Map<String, dynamic> body) async {
    final recipe = RecipePatchRequest(
      id: body['recipe']['id'],
      name: body['name'],
      description: body['description'],
      ingredients: body['recipe']['ingredients'],
      instructions: body['recipe']['instructions'],
      difficulty: body['recipe']['difficulty'],
      preparationTime: body['recipe']['preparation_time'],
    );

    final result = await ref.read(drinksRepositoryProvider).patchRecipe(body['recipe']['id'], recipe);

    final newRecipeId = result.when(
      success: (response) => response.recipe.id,
      failure: (_) => null,
    );

    if (newRecipeId == null) {
      return false;
    }

    final drink = DrinkPatchRequest(
      id: drinkId,
      name: body['name'],
      description: body['description'],
      picture: body['picture'],
      categories: body['categories'],
      glass: body['glass'],
    );

    final drinkResult = await ref.read(drinksRepositoryProvider).patchDrink(drinkId, drink);

    return drinkResult.when(
      success: (response) {
        // Update the drink in the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.map((drink) {
              if (drink.id == drinkId) {
                return response.drink;
              }
              return drink;
            }).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }
}
