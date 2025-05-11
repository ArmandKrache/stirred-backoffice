import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks_notifier.dart';
import 'package:stirred_backoffice/presentation/views/drinks/widgets/drinks_filter_dialog.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/drink_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/list_item_row.dart';
import 'package:stirred_backoffice/presentation/widgets/list/name_id_column.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/paginated_list_view.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
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
            onFilterPressed: () => _showFilterDialog(context, drinksNotifier),
            onLoadMore: drinksNotifier.loadMore,
            title: 'Drinks Overview',
            searchHint: 'Search drinks...',
            onCreatePressed: () => _showCreateDrinkModal(context, ref),
            createButtonLabel: 'Add New Drink',
            columns: const [
              'Name',
            ],
            itemBuilder: (context, drink) => ListItemRow(
              picture: drink.picture,
              pictureIcon: Icons.local_bar,
              onTap: () => _showDrinkModal(context, drink, EntityModalMode.view, ref),
              children: [
                NameIdColumn(
                  name: drink.name,
                  id: drink.id,
                ),
              ],
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

  void _showFilterDialog(BuildContext context, DrinksNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => DrinksFilterDialog(
        currentOrdering: notifier.currentOrdering,
        isFavoritesOnly: notifier.isFavoritesOnly,
        onApply: (ordering, favoritesOnly) {
          notifier.applyFilters({
            'ordering': ordering,
            'favoritesOnly': favoritesOnly,
          });
        },
      ),
    );
  }

  void _showDrinkModal(BuildContext context, Drink drink, EntityModalMode mode, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => DrinkModal(
        mode: mode,
        entity: drink,
        onSave: (data) async {
          if (mode == EntityModalMode.create) {
            final success = await ref.read(drinksNotifierProvider.notifier).createDrink(data);
            if (success) {
              ref.read(drinksNotifierProvider.notifier).fetchItems(resetList: true);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to create drink')),
              );
            }
          } else {
            final success = await ref.read(drinksNotifierProvider.notifier).updateDrink(drink.id, data);
            if (success) {
              ref.read(drinksNotifierProvider.notifier).fetchItems(resetList: true);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update drink')),
              );
            }
          }
        },
        onDelete: mode == EntityModalMode.view ? () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Drink'),
              content: const Text('Are you sure you want to delete this drink? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (shouldDelete == true) {
            final success = await ref.read(drinksNotifierProvider.notifier).deleteDrink(drink.id);
            if (success) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete drink')),
              );
            }
          }
        } : null,
      ),
    );
  }

  void _showCreateDrinkModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => DrinkModal(
        mode: EntityModalMode.create,
        entity: null,
        onSave: (request) async {
          final success = await ref.read(drinksNotifierProvider.notifier).createDrink(request);

          if (success) {
            ref.read(drinksNotifierProvider.notifier).fetchItems(resetList: true);
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create drink')),
            );
          }
        },
      ),
    );
  }
}
