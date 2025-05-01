import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/users/users_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
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
              'Actions',
            ],
            itemBuilder: (context, user) => _UserRow(
              user: user,
              onTap: () {
                // TODO: Navigate to user details
              },
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

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.onTap,
  });

  final Profile user;
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
              flex: 2,
              child: Text(
                user.name ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Email
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: Text(user.email ?? 'Unknown'),
              ),
            ),
            // Role
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: _RoleChip(role: user.dateOfBirth ?? 'Unknown'),
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
