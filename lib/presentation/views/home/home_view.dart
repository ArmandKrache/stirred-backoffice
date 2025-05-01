import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/views/home/widgets/navigation_rail.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_notification_badge.dart';

/// The home page of the application.
class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('HomePage'));

  /// The navigation shell to display.
  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index, WidgetRef ref) {
    final scrollToTop = index == HomeTabConstants.drinksTabIndex && router.currentRoute == DrinksRoute.route;
    final initialLocation = !scrollToTop && index == navigationShell.currentIndex;

    navigationShell.goBranch(
      index,
      initialLocation: initialLocation,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationItems = buildNavigationItems(context, ref);
    return LandscapeNavigationRail(
        currentIndex: navigationShell.currentIndex,
        body: navigationShell,
        onItemTapped: _onItemTapped,
        navigationItems: navigationItems,
      );
  }

  List<BottomNavigationBarItem> buildNavigationItems(BuildContext context, WidgetRef ref) {
    return [
      const BottomNavigationBarItem(
        icon: StirIconNotificationBadge(
          iconData: Icons.local_bar_outlined,
        ),
        activeIcon: StirIconNotificationBadge(
          iconData: Icons.local_bar,
        ),
        label: 'Drinks',
      ),
      const BottomNavigationBarItem(
        icon: StirIconNotificationBadge(
          iconData: Icons.add_shopping_cart_outlined,
        ),
        activeIcon: StirIconNotificationBadge(
          iconData: Icons.add_shopping_cart,
        ),
        label: 'Ingredients',
      ),
      const BottomNavigationBarItem(
        icon: StirIconNotificationBadge(
          iconData: Icons.wine_bar_outlined,
        ),
        activeIcon: StirIconNotificationBadge(
          iconData: Icons.wine_bar,
        ),
        label: 'Glasses',
      ),
      const BottomNavigationBarItem(
        icon: StirIconNotificationBadge(
          iconData: Icons.person_outline,
        ),
        activeIcon: StirIconNotificationBadge(
          iconData: Icons.person,
        ),
        label: 'Users',
      ),
      const BottomNavigationBarItem(
        icon: StirIconNotificationBadge(
          iconData: Icons.dashboard_outlined,
        ),
        activeIcon: StirIconNotificationBadge(
          iconData: Icons.dashboard,
        ),
        label: 'Dashboard',
      ),
    ];
  }
}
