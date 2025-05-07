import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/glasses/glasses_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/list_item_row.dart';
import 'package:stirred_backoffice/presentation/widgets/list/name_id_column.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/paginated_list_view.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/glass_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class GlassesView extends ConsumerWidget {
  const GlassesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(glassesNotifierProvider);
    final glassesNotifier = ref.read(glassesNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(StirSpacings.small16),
        child: notifier.when(
          data: (data) => PaginatedListView<Glass>(
            state: data,
            onSearch: glassesNotifier.search,
            onLoadMore: glassesNotifier.loadMore,
            title: 'Glasses Overview',
            searchHint: 'Search glasses...',
            onCreatePressed: () => _showCreateGlassModal(context, ref),
            createButtonLabel: 'Add New Glass',
            columns: const [
              'Name',
            ],
            itemBuilder: (context, glass) => ListItemRow(
              picture: glass.picture,
              pictureIcon: Icons.wine_bar,
              onTap: () => _showGlassModal(context, glass, EntityModalMode.view, ref),
              children: [
                NameIdColumn(
                  name: glass.name,
                  id: glass.id,
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

  void _showGlassModal(BuildContext context, Glass glass, EntityModalMode mode, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => GlassModal(
        mode: mode,
        entity: glass,
        onSave: (data) async {
          if (mode == EntityModalMode.create) {
            final request = data as GlassesCreateRequest;
            final success = await ref.read(glassesNotifierProvider.notifier).createGlass(
              request: request,
            );

            if (success) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to create glass')),
              );
            }
          } else {
            final request = data as GlassPatchRequest;
            final success = await ref.read(glassesNotifierProvider.notifier).updateGlass(
              request.id,
              request: request,
            );

            if (success) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update glass')),
              );
            }
          }
        },
        onDelete: mode == EntityModalMode.view ? () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Glass'),
              content: const Text('Are you sure you want to delete this glass? This action cannot be undone.'),
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
            final success = await ref.read(glassesNotifierProvider.notifier).deleteGlass(glass.id);
            if (success) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete glass')),
              );
            }
          }
        } : null,
      ),
    );
  }

  void _showCreateGlassModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => GlassModal(
        mode: EntityModalMode.create,
        entity: null,
        onSave: (request) async {
          final success = await ref.read(glassesNotifierProvider.notifier).createGlass(
            request: request as GlassesCreateRequest,
          );

          if (success) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create glass')),
            );
          }
        },
      ),
    );
  }
}
