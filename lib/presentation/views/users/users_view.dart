import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/users/users_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/column_divider.dart';
import 'package:stirred_backoffice/presentation/widgets/list/filter_bottom_sheet.dart';
import 'package:stirred_backoffice/presentation/widgets/list/list_item_row.dart';
import 'package:stirred_backoffice/presentation/widgets/list/name_id_column.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/paginated_list_view.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class UsersView extends ConsumerWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(usersNotifierProvider);
    final usersNotifier = ref.read(usersNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(StirSpacings.small16),
        child: notifier.when(
          data: (data) => PaginatedListView<Profile>(
            state: data,
            onSearch: usersNotifier.search,
            onFilterPressed: () => _showFilterBottomSheet(context, usersNotifier),
            onLoadMore: usersNotifier.loadMore,
            title: 'Users Overview',
            searchHint: 'Search users...',
            createButtonLabel: 'Add New User',
            columns: const [
              'Name',
              'Email',
              'Date of Birth',
            ],
            itemBuilder: (context, user) => ListItemRow(
              picture: user.picture,
              pictureIcon: Icons.person,
              onTap: () {
                // TODO: Navigate to user details
              },
              children: [
                NameIdColumn(
                  name: user.name ?? 'Unknown',
                  id: user.id,
                ),
                const ColumnDivider(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                    child: Text(user.email ?? 'Unknown'),
                  ),
                ),
                const ColumnDivider(),
                SizedBox(
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                    child: _RoleChip(role: user.dateOfBirth ?? 'Unknown'),
                  ),
                ),
              ],
            ),
            filterBottomSheet: FilterBottomSheet(
              onApplyFilters: (filters) {
                usersNotifier.applyFilters(filters);
                Navigator.pop(context);
              },
              onClearFilters: () {
                usersNotifier.clearFilters();
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

  void _showFilterBottomSheet(BuildContext context, UsersNotifier notifier) {
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
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role,
        style: const TextStyle(color: Colors.purple),
      ),
    );
  }
}
