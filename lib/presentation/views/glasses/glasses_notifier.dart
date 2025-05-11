import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'glasses_notifier.g.dart';

/// The Notifier enclosing the `GlassesView` logic.
@riverpod
class GlassesNotifier extends _$GlassesNotifier with PaginationNotifierMixin<Glass> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<PaginationState<Glass>> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  Future<PaginationState<Glass>> _load() async {
    final result = await ref.read(drinksRepositoryProvider).getGlassesList();

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return PaginationState(
      items: response?.glasses ?? [],
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
          isReloading: data.isReloading,
        ),
      );
    }

    return state.maybeWhen(
      data: (state) async {
        final result = await ref.read(drinksRepositoryProvider).getGlassesList(
          page: page,
          pageSize: 20,
          query: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        );

        return result.when(
          success: (response) {
            final newItems = response.glasses;
            final updatedItems = resetList ? newItems : state.items + newItems;
            
            this.state = AsyncData(
              state.copyWith(
                items: updatedItems,
                isUpToDate: newItems.isEmpty, // If we get an empty response, we've reached the end
                isReloading: false
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

  /// Creates a new glass
  Future<bool> createGlass({
    required GlassesCreateRequest request,
  }) async {
    final result = await ref.read(drinksRepositoryProvider).createGlass(
      request: request,
    );

    return result.when(
      success: (response) {
        // Add the new glass to the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: [response.glass, ...data.items],
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  /// Updates an existing glass
  Future<bool> updateGlass(
    String id, {
    required GlassPatchRequest request,
  }) async {
    final result = await ref.read(drinksRepositoryProvider).patchGlass(
      id,
      request,
    );

    return result.when(
      success: (response) {
        // Update the glass in the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.map((glass) {
              if (glass.id == id) {
                return response.glass;
              }
              return glass;
            }).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }

  /// Deletes a glass
  Future<bool> deleteGlass(String id) async {
    final result = await ref.read(drinksRepositoryProvider).deleteGlass(id);

    return result.when(
      success: (_) {
        // Remove the glass from the current list
        state = state.whenData(
          (data) => data.copyWith(
            items: data.items.where((glass) => glass.id != id).toList(),
          ),
        );
        return true;
      },
      failure: (_) => false,
    );
  }
}
