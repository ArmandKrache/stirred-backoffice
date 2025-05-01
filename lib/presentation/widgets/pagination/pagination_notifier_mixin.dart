import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';

/// A mixin that provides pagination functionality for notifiers
mixin PaginationNotifierMixin<T> {
  /// The current state of the pagination
  AsyncValue<PaginationState<T>> get state;

  /// Set the current state
  set state(AsyncValue<PaginationState<T>> value);

  /// Load more items
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null ||
        currentState.isUpToDate ||
        currentState.isLoadingMore) {
      return;
    }

    state = state.whenData(
      (state) => state.copyWith(isLoadingMore: true),
    );

    try {
      final hasLoadedMore = await fetchItems(offset: currentState.items.length);
      state = state.whenData(
        (state) => state.copyWith(
          isLoadingMore: false,
          isUpToDate: !hasLoadedMore,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    state = state.whenData(
      (state) => state.copyWith(isReloading: true),
    );

    try {
      await fetchItems(resetList: true);
      state = state.whenData(
        (state) => state.copyWith(isReloading: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Search items
  Future<void> search(String query) async {
    state = state.whenData(
      (state) => state.copyWith(
        searchQuery: query,
        isReloading: true,
      ),
    );

    try {
      await fetchItems(resetList: true);
      state = state.whenData(
        (state) => state.copyWith(isReloading: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Apply filters
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    state = state.whenData(
      (state) => state.copyWith(
        activeFilters: filters,
        isReloading: true,
      ),
    );

    try {
      await fetchItems(resetList: true);
      state = state.whenData(
        (state) => state.copyWith(isReloading: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Clear filters
  void clearFilters() {
    state = state.whenData(
      (state) => state.copyWith(
        activeFilters: {},
        searchQuery: '',
      ),
    );
  }

  /// Fetch items from the backend
  /// Returns true if more items were loaded
  Future<bool> fetchItems({
    bool resetList = false,
    int offset = 0,
  });
} 