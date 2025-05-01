import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';

/// A generic paginated list view widget that can be used across different entity types
class PaginatedListView<T> extends ConsumerWidget {
  const PaginatedListView({
    super.key,
    required this.state,
    required this.onSearch,
    required this.onFilterPressed,
    required this.onLoadMore,
    required this.itemBuilder,
    this.searchHint = 'Search',
    this.filterBottomSheet,
    this.title = 'Items',
    this.columns = const [],
  });

  /// The current state of the pagination
  final PaginationState<T> state;

  /// Callback when search query changes
  final Function(String) onSearch;

  /// Callback when filter button is pressed
  final VoidCallback onFilterPressed;

  /// Callback when more items should be loaded
  final VoidCallback onLoadMore;

  /// Builder for individual items
  final Widget Function(BuildContext, T) itemBuilder;

  /// Hint text for the search field
  final String searchHint;

  /// Optional bottom sheet for filters
  final Widget? filterBottomSheet;

  /// Title for the list
  final String title;

  /// Column headers for the table
  final List<String> columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isReloading) {
      return const LoadingPlaceholder();
    }

    return Column(
      children: [
        const Gap(StirSpacings.small16),
        _buildHeader(context),
        const SizedBox(height: StirSpacings.small16),
        if (columns.isNotEmpty) _buildTableHeader(),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200 &&
                  !state.isLoadingMore &&
                  !state.isUpToDate) {
                onLoadMore();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return itemBuilder(context, state.items[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const StirText.titleLarge('Items'),
        const SizedBox(width: StirSpacings.medium24),
        Expanded(
          child: StirTextField(
            hint: searchHint,
            onChanged: onSearch,
            leadingIconData: Icons.search,
            showLabel: false,
          ),
        ),
        const SizedBox(width: StirSpacings.small16),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: onFilterPressed,
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: StirSpacings.small16,
        vertical: StirSpacings.small12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.shade200,
              ),
            Expanded(
              flex: i == 0 ? 3 : 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: Text(
                  columns[i],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 