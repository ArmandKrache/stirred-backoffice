import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
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
            itemBuilder: (context, drink) => _DrinkRow(
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

class _DrinkRow extends StatelessWidget {
  const _DrinkRow({
    required this.drink,
    required this.onTap,
  });

  final Drink drink;
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
            // ID
            Expanded(
              flex: 1,
              child: StirText.labelSmall(drink.id, overflow: TextOverflow.ellipsis),
            ),
            const Gap(StirSpacings.small4),
            Expanded(
              flex: 3,
              child: StirText.titleSmall(drink.name),
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: _CategoryChip(category: drink.categories?.toString() ?? 'Uncategorized'),
              ),
            ),
            // Difficulty
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: _DifficultyChip(difficulty: _getDifficulty(drink)),
              ),
            ),
            // Prep Time
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: Text('${drink.recipe?.preparationTime ?? 5} min'),
              ),
            ),
            // Status
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: const _StatusChip(status: 'Published'),
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
                      logger.d('Delete drink ${drink.id}');
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

  String _getDifficulty(Drink drink) {
    final time = drink.recipe?.preparationTime ?? 5;
    if (time <= 5) return 'Easy';
    if (time <= 10) return 'Medium';
    return 'Hard';
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
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(color: Colors.orange.shade700),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty.toLowerCase()) {
      'easy' => Colors.green,
      'medium' => Colors.orange,
      'hard' => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(color: color),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'published' => Colors.green,
      'draft' => Colors.orange,
      'archived' => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color),
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
              const StirText.titleLarge('Filters'),
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
