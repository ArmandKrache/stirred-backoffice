import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'glasses_notifier.g.dart';

/// The Notifier enclosing the `GlassesView` logic.
@riverpod
class GlassesNotifier extends _$GlassesNotifier with PaginationNotifierMixin<Glass> {
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
    int page = 0,
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
        final result = await ref.read(drinksRepositoryProvider).getGlassesList();

        return result.when(
          success: (response) {
            this.state = AsyncData(
              state.copyWith(
                items: state.items + response.glasses,
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

  /// Creates a new glass
  Future<bool> createGlass({
    required GlassesCreateRequest request,
  }) async {
    final result = await ref.read(drinksRepositoryProvider).createGlass(
      request: request,
    );

    return result.when(
      success: (_) {
        // Refresh the list
        fetchItems(resetList: true);
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
      success: (_) {
        // Refresh the list
        fetchItems(resetList: true);
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
        // Refresh the list
        fetchItems(resetList: true);
        return true;
      },
      failure: (_) => false,
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
}
