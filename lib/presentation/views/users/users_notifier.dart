import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_notifier_mixin.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'users_notifier.g.dart';

/// The Notifier enclosing the `UsersView` logic.
@riverpod
class UsersNotifier extends _$UsersNotifier with PaginationNotifierMixin<Profile> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<PaginationState<Profile>> build() async {
    final controller = await _load();

    state = AsyncData(controller);

    return controller;
  }

  Future<PaginationState<Profile>> _load() async {
    final result = await ref.read(profileRepositoryProvider).getProfilesList();

    final response = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return PaginationState(
      items: response?.profiles ?? [],
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
        final result = await ref.read(profileRepositoryProvider).getProfilesList(
          page: page,
          pageSize: 20,
          query: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        );

        return result.when(
          success: (response) {
            final newItems = response.profiles;
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