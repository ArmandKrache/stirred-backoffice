
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/constants.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/providers/current_data.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_notification_badge.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// The navigation rail for landscape mode.
class LandscapeNavigationRail extends ConsumerWidget {
  const LandscapeNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
    required this.navigationItems,
    required this.body,
  });

  /// The navigation shell to display.
  final int currentIndex;

  /// The callback to call when a tab is tapped.
  final Function(int, WidgetRef) onItemTapped;

  /// The navigation items to display.
  final List<BottomNavigationBarItem> navigationItems;

  /// The body to display.
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railWidth = min(MediaQuery.of(context).size.width * 0.3, StirConstants.navigationRaidMaxWidth);
    final items = <Widget>[];
    for (final entry in navigationItems.asMap().entries) {
      items.add(
        LandscapeNavigationTab(
          key: key,
          index: entry.key,
          navigationItem: entry.value,
          isSelected: currentIndex == entry.key,
          onItemTapped: onItemTapped,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: railWidth,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ref.colors.surfaceContainer,
                border: Border(
                  right: BorderSide(color: ref.colors.disabled),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(StirSpacings.small16),
                    child: StirText.lsdHeadlineSmall(
                      'Stirred - Chef',
                      color: ref.colors.primary,
                    ),
                  ),
                  Divider(
                    color: ref.colors.disabled,
                    height: StirSpacings.small8,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(StirSpacings.small8),
                    child: Column(
                      children: items,
                    ),
                  ),
                  const Spacer(),
                  Divider(
                    color: ref.colors.disabled,
                    height: StirSpacings.small8,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(StirSpacings.small16),
                    child: const ProfileTab(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

/// A tab to be displayed in the navigation rail.
class LandscapeNavigationTab extends ConsumerWidget {
  LandscapeNavigationTab({
    super.key,
    required this.index,
    required this.navigationItem,
    required this.isSelected,
    required this.onItemTapped,
  }) : assert(navigationItem.icon is StirIconNotificationBadge);

  /// The index of the tab.
  final int index;

  /// The navigation item to display.
  final BottomNavigationBarItem navigationItem;

  /// Indicates if the tab is selected.
  final bool isSelected;

  /// The callback to call when the tab is tapped.
  final Function(int, WidgetRef) onItemTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StirIconNotificationBadge icon = navigationItem.icon as StirIconNotificationBadge;
    final colors = ref.colors;


    return GestureDetector(
      onTap: () async {
        onItemTapped(index, ref);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? colors.secondary : colors.surfaceContainer,
          borderRadius: BorderRadius.circular(StirSpacings.small12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(StirSpacings.small8),
          child: Row(
              children: [
                StirIconNotificationBadge(
                  iconData: icon.iconData,
                  showNotificationBadge: icon.showNotificationBadge,
                  color: isSelected ? colors.onSecondary : colors.onSurface,
                ),
                const Gap(StirSpacings.small8),
                StirText.titleMedium(
                  '${navigationItem.label}',
                  color: isSelected ? colors.onSecondary : colors.onSurface,
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentDataNotifierProvider).value?.when(
          authentified: (user) => user,
          unauthentified: (_) => null,
        );

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(StirSpacings.large96),
          child: Image.network(
            user.picture ?? '',
            width: StirSpacings.large48,
            height: StirSpacings.large48,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(StirSpacings.small8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StirText.titleMedium(
                '${user.name}',
                color: ref.colors.onSurface,
              ),
              StirText.labelMedium(
                '${user.email}',
                color: ref.colors.onSurfaceVariantLowEmphasis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
