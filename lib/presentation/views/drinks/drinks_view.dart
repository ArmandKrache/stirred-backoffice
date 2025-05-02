import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks_notifier.dart';
import 'package:stirred_backoffice/presentation/views/drinks/widgets/drinks_row.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/filter_bottom_sheet.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/paginated_list_view.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinksView extends ConsumerWidget {
  const DrinksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(drinksNotifierProvider);
    final drinksNotifier = ref.read(drinksNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(StirSpacings.small16),
        child: notifier.when(
          data: (data) => PaginatedListView<Drink>(
            state: data,
            onSearch: drinksNotifier.search,
            onFilterPressed: () => _showFilterBottomSheet(context, drinksNotifier),
            onLoadMore: drinksNotifier.loadMore,
            title: 'Drinks Overview',
            searchHint: 'Search drinks...',
            onCreatePressed: () => _showCreateDrinkModal(context),
            createButtonLabel: 'Add New Drink',
            itemBuilder: (context, drink) => DrinkRow(
              drink: drink,
              onTap: () {
                context.push(
                  DrinkDetailsRoute.route(drink.id),
                  extra: drink,
                );
              },
            ),
            filterBottomSheet: FilterBottomSheet(
              onApplyFilters: (filters) {
                drinksNotifier.applyFilters(filters);
                Navigator.pop(context);
              },
              onClearFilters: () {
                drinksNotifier.clearFilters();
                Navigator.pop(context);
              },
            ),
          ),
          error: (error, stacktrace) => ErrorPlaceholder(
            message: error.toString(),
            stackTrace: stacktrace,
          ),
          loading: () => const LoadingPlaceholder(),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, DrinksNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        onApplyFilters: (filters) {
          notifier.applyFilters(filters);
          Navigator.pop(context);
        },
        onClearFilters: () {
          notifier.clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCreateDrinkModal(BuildContext context) {
    StirModal.show(
      context: context,
      title: 'Create New Drink',
      content: const Center(
        child: Text('Form content will go here'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // TODO: Implement create drink
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
