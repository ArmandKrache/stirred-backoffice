// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/ingredients/ingredients_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/ingredient_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
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
            onLoadMore: ingredientsNotifier.loadMore,
            title: 'Ingredients Overview',
            searchHint: 'Search ingredients...',
            onCreatePressed: () => _showCreateIngredientModal(context, ref),
            createButtonLabel: 'Add New Ingredient',
            columns: const [
              'Name',
            ],
            itemBuilder: (context, ingredient) => ListItemRow(
              picture: ingredient.picture,
              pictureIcon: Icons.local_bar,
              onTap: () => _showEditIngredientModal(context, ref, ingredient),
              children: [
                NameIdColumn(
                  name: ingredient.name,
                  id: ingredient.id,
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

  void _showCreateIngredientModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => IngredientModal(
        mode: EntityModalMode.create,
        entity: null,
        onSave: (request) async {
          final success = await ref.read(ingredientsNotifierProvider.notifier).createIngredient(request);
          if (success) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to create ingredient')),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditIngredientModal(BuildContext context, WidgetRef ref, Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (context) => IngredientModal(
        mode: EntityModalMode.view,
        entity: ingredient,
        onSave: (request) async {
          final success = await ref.read(ingredientsNotifierProvider.notifier).updateIngredient(ingredient.id, request);
          if (success) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update ingredient')),
              );
            }
          }
        },
        onDelete: () async {
          final success = await ref.read(ingredientsNotifierProvider.notifier).deleteIngredient(ingredient.id);
          if (success) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete ingredient')),
              );
            }
          }
        },
      ),
    );
  }
}
