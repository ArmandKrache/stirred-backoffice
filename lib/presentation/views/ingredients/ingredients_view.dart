// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/ingredients/ingredients_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/actions_column.dart';
import 'package:stirred_backoffice/presentation/widgets/list/column_divider.dart';
import 'package:stirred_backoffice/presentation/widgets/list/filter_bottom_sheet.dart';
import 'package:stirred_backoffice/presentation/widgets/list/list_item_row.dart';
import 'package:stirred_backoffice/presentation/widgets/list/name_id_column.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/paginated_list_view.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class IngredientsView extends ConsumerWidget {
  const IngredientsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(ingredientsNotifierProvider);
    final ingredientsNotifier = ref.read(ingredientsNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
        child: notifier.when(
          data: (data) => PaginatedListView<Ingredient>(
            state: data,
            onSearch: ingredientsNotifier.search,
            onFilterPressed: () => _showFilterBottomSheet(context, ingredientsNotifier),
            onLoadMore: ingredientsNotifier.loadMore,
            title: 'Ingredients Overview',
            searchHint: 'Search ingredients...',
            onCreatePressed: () => _showCreateIngredientModal(context),
            createButtonLabel: 'Add New Ingredient',
            columns: const [
              'Name',
              'Category',
              'Actions',
            ],
            itemBuilder: (context, ingredient) => ListItemRow(
              picture: ingredient.picture,
              pictureIcon: Icons.local_bar,
              onTap: () {
                // TODO: Navigate to ingredient details
              },
              children: [
                NameIdColumn(
                  name: ingredient.name,
                  id: ingredient.id,
                ),
                const ColumnDivider(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                    child: _CategoryChip(category: 'Categories'),
                  ),
                ),
                const ColumnDivider(),
                ActionsColumn(
                  onEdit: () {
                    // TODO: Navigate to ingredient details
                  },
                  onDelete: () {
                    // TODO: Implement delete
                  },
                ),
              ],
            ),
            filterBottomSheet: FilterBottomSheet(
              onApplyFilters: (filters) {
                ingredientsNotifier.applyFilters(filters);
                Navigator.pop(context);
              },
              onClearFilters: () {
                ingredientsNotifier.clearFilters();
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

  void _showFilterBottomSheet(BuildContext context, IngredientsNotifier notifier) {
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

  void _showCreateIngredientModal(BuildContext context) {
    StirModal.show(
      context: context,
      title: 'Create New Ingredient',
      content: const Center(
        child: Text('Ingredient form content will go here'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // TODO: Implement create ingredient
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
