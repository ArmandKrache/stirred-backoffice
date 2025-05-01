import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drinks_notifier.freezed.dart';
part 'drinks_notifier.g.dart';

/// The Notifier enclosing the `FeedPage` logic.
@riverpod
class DrinksNotifier extends _$DrinksNotifier {

  /// Loads the page data.
  @override
  Future<DrinksNotifierState> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  /// Launches a reload of the notifier (e.g. when the current store has
  /// changed, we need to change the stream subscriptions and refetch alerts).
  // ignore: unused_element
  Future<void> _reload() async {
    state = const AsyncLoading();

    try {
      final controller = await _load();

      state = AsyncData(controller);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<DrinksNotifierState> _load() async {
    final result = await ref.read(drinksRepositoryProvider).getDrinksList();

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return DrinksNotifierState(
      drinks: response?.drinks ?? [],
    );
  }

  /// Refresh the theft page alerts by refetching data.
  /// Use [reloadState] to reload the state of the notifier during the refresh.
  Future<void> refreshDrinks({
    bool reloadState = true,
  }) async {
    if (reloadState) _setIsReloading(true);
    await state.whenOrNull(
      data: (state) async {
        await _fetchDrinks();
      },
    );
    if (reloadState) _setIsReloading(false);
  }

  Future<bool> loadMoreDrinks() async {
    final drinksLength = state.value?.drinks.length;
    final data = state.asData?.value;

    if (data == null || data.isUpToDate || data.isLoadingMoreDrinks || drinksLength == null) {
      return false;
    }

    _setIsLoadingMoreDrinks(true);
    final hasLoadedMoreDrinks = await _fetchDrinks(offset: drinksLength);
    _setIsLoadingMoreDrinks(false);

    return hasLoadedMoreDrinks;
  }

  void _setIsUpToDate(bool isUpToDate) {
    state = state.whenData(
      (state) => state.copyWith(isUpToDate: isUpToDate),
    );
  }

  void _setIsLoadingMoreDrinks(bool isLoadingMoreDrinks) {
    state = state.whenData(
      (state) => state.copyWith(isLoadingMoreDrinks: isLoadingMoreDrinks),
    );
  }

  void _setIsReloading(bool isReloading) {
    state = state.whenData(
      (state) => state.copyWith(isReloading: isReloading),
    );
  }

  void _setDrinks(List<Drink> drinks) {
    state = state.whenData(
      (state) => state.copyWith(drinks: drinks),
    );
  }

  Future<bool> _fetchDrinks({
    bool resetDrinksList = false,
    int offset = 0,
  }) async {
    if (resetDrinksList) {
      _setIsUpToDate(false);
      _setDrinks([]);
    }

    return state.maybeWhen(
      data: (state) async {
        final result = await ref.read(drinksRepositoryProvider).getDrinksList(
            offset: offset,
          );

        return result.when(
          success: (response) {
            _setDrinks(state.drinks + response.drinks);

            return true;
          },
          failure: (_) => false,
        );
      },
      orElse: () => false,
    );
  }

  // Search and filter methods
  Future<void> searchDrinks(String query) async {
    throw UnimplementedError('searchDrinks not implemented');
  }

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    throw UnimplementedError('applyFilters not implemented');
  }

  void clearFilters() {
    state = state.whenData(
      (state) => state.copyWith(
        searchQuery: '',
        activeFilters: {},
      ),
    );
  }
}

/// The state enclosed by `Theftnotifier`.
@freezed
class DrinksNotifierState with _$DrinksNotifierState {
  const factory DrinksNotifierState({
    /// The drinks list.
    @Default([]) List<Drink> drinks,
    @Default(false) bool isLoadingMoreDrinks,
    @Default(false) bool isReloading,
    @Default(false) bool isUpToDate,
    @Default('') String searchQuery,
    @Default({}) Map<String, dynamic> activeFilters,
  }) = _DrinksNotifierStateData;
}
