import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/glasses/glasses_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
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
              'Volume (ml)',
              'Status',
              'Actions',
            ],
            itemBuilder: (context, glass) => _GlassRow(
              glass: glass,
              onTap: () {
                // TODO: Navigate to glass details
              },
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

class _GlassRow extends StatelessWidget {
  const _GlassRow({
    required this.glass,
    required this.onTap,
  });

  final Glass glass;
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
                glass.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
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
