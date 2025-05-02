import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/glasses/glasses_notifier.dart';
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
            onFilterPressed: () => _showFilterBottomSheet(context, glassesNotifier),
            onLoadMore: glassesNotifier.loadMore,
            title: 'Glasses Overview',
            searchHint: 'Search glasses...',
            onCreatePressed: () => _showCreateGlassModal(context),
            createButtonLabel: 'Add New Glass',
            columns: const [
              'Name',
              'Actions',
            ],
            itemBuilder: (context, glass) => ListItemRow(
              picture: glass.picture,
              pictureIcon: Icons.wine_bar,
              onTap: () {
                // TODO: Navigate to glass details
              },
              children: [
                NameIdColumn(
                  name: glass.name,
                  id: glass.id,
                ),
                const ColumnDivider(),
                ActionsColumn(
                  onEdit: () {
                    // TODO: Navigate to glass details
                  },
                  onDelete: () {
                    // TODO: Implement delete
                  },
                ),
              ],
            ),
            filterBottomSheet: FilterBottomSheet(
              onApplyFilters: (filters) {
                glassesNotifier.applyFilters(filters);
                Navigator.pop(context);
              },
              onClearFilters: () {
                glassesNotifier.clearFilters();
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

  void _showFilterBottomSheet(BuildContext context, GlassesNotifier notifier) {
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

  void _showCreateGlassModal(BuildContext context) {
    StirModal.show(
      context: context,
      title: 'Create New Glass',
      content: const Center(
        child: Text('Glass form content will go here'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // TODO: Implement create glass
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
