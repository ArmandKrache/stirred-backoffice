// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/ingredients/ingredients_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
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
            itemBuilder: (context, ingredient) => _IngredientRow(
              ingredient: ingredient,
              onTap: () {
                // TODO: Navigate to ingredient details
              },
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

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.onTap,
  });

  final Ingredient ingredient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: StirSpacings.small16,
          vertical: StirSpacings.small12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Name
            Expanded(
              flex: 3,
              child: Text(
                ingredient.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Category
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: _CategoryChip(category: ingredient.categories.keywords.firstOrNull ?? ''),
              ),
            ),
            // Actions
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onTap,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // TODO: Implement delete
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StirSpacings.small16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: StirSpacings.small16),
          // TODO: Add filter options here
          const SizedBox(height: StirSpacings.small16),
          FilledButton(
            onPressed: () => onApplyFilters({}),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
