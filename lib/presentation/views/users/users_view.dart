import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/users/users_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/list/column_divider.dart';
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
                // TODO: Open Profile Details View
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
