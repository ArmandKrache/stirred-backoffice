import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stirred_backoffice/presentation/views/dashboard/dashboard_view.dart';
import 'package:stirred_backoffice/presentation/views/recipes/recipes_view.dart';
import 'package:stirred_backoffice/presentation/views/glasses/glasses_view.dart';
import 'package:stirred_backoffice/presentation/views/ingredients/ingredients_view.dart';
import 'package:stirred_backoffice/presentation/views/drink_details/drink_details_view.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks.dart';
import 'package:stirred_backoffice/presentation/views/home/home_view.dart';
import 'package:stirred_backoffice/presentation/views/login/login_view.dart';
import 'package:stirred_backoffice/presentation/views/root.dart';
import 'package:stirred_backoffice/presentation/views/users/users_view.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/tools/page_transitions.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _drinksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'drinks');
final _recipesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'recipes');
final _ingredientsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ingredients');
final _glassesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'glasses');
final _usersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'users');
final _dashboardNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');

bool routerInitialized = false;

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: _RootRoute.route,
  errorPageBuilder: (context, state) {

    return MaterialPage<void>(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ErrorPlaceholder(
              message: 'Page Not found',
              error: state.error,
              action: () => context.go(HomeRoute.route(HomeTabConstants.defaultTabIndex)),
              actionLabel: 'Back to Home',
            ),
          ),
        ),
      ),
    );
  },
  routes: [
    _RootRoute(),
    LoginRoute(),
    HomeRoute(),
  ],
);

extension RouterExtensions on GoRouter {
  String get currentRoute => routeInformationProvider.value.uri.path;
}

class _RootRoute extends GoRoute {
  _RootRoute()
      : super(
          path: route,
          pageBuilder: (context, state) => const NoTransitionPage(child: RootView(),),
        );

  static const String route = '/';
}

class LoginRoute extends GoRoute {
  LoginRoute()
      : super(
          path: route,
          pageBuilder: (context, state) => const NoTransitionPage(child: LoginView(),),
        );

  static const String route = '/login';
}

class HomeTabConstants {
  static const int defaultTabIndex = drinksTabIndex;
  static const int drinksTabIndex = 0;
  static const int recipesTabIndex = 1;
  static const int ingredientsTabIndex = 2;
  static const int glassesTabIndex = 3;
  static const int usersTabIndex = 4;
  static const int dashboardTabIndex = 5;

  static const Map<int, String> routesName = {
    drinksTabIndex: DrinksRoute.route,
    recipesTabIndex: RecipesRoute.route,
    ingredientsTabIndex: IngredientsRoute.route,
    glassesTabIndex: GlassesRoute.route,
    usersTabIndex: UsersRoute.route,
    dashboardTabIndex: DashboardRoute.route,
  };
}

class HomeRoute extends StatefulShellRoute {
  HomeRoute()
      : super.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeView(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _drinksNavigatorKey,
              observers: [],
              routes: [
                DrinksRoute(),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _recipesNavigatorKey,
              observers: [],
              routes: [
                RecipesRoute(),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _ingredientsNavigatorKey,
              observers: [],
              routes: [
                IngredientsRoute(),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _glassesNavigatorKey,
              observers: [],
              routes: [
                GlassesRoute(),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _usersNavigatorKey,
              observers: [],
              routes: [
                UsersRoute(),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _dashboardNavigatorKey,
              observers: [],
              routes: [
                DashboardRoute(),
              ],
            ),
          ],
        );

  static String route(int index) {
    return switch (index) {
      0 => DrinksRoute.route,
      1 => RecipesRoute.route,
      2 => IngredientsRoute.route,
      3 => GlassesRoute.route,
      4 => UsersRoute.route,
      5 => DashboardRoute.route,
      _ => DrinksRoute.route,
    };
  }
}

class DrinksRoute extends GoRoute {
  DrinksRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: DrinksView(),
            );
          },
          routes: [
            DrinkDetailsRoute(),
          ],
        );

  static const String route = '/drinks';
}

class RecipesRoute extends GoRoute {
  RecipesRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: RecipesView(),
            );
          },
        );

  static const String route = '/recipes';
}

class IngredientsRoute extends GoRoute {
  IngredientsRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: IngredientsView(),
            );
          },
        );

  static const String route = '/ingredients'; 
}

class GlassesRoute extends GoRoute {
  GlassesRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: GlassesView(),
            );
          },
        );

  static const String route = '/glasses';
}

class UsersRoute extends GoRoute {
  UsersRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: UsersView(),
            );
          },
        );

  static const String route = '/users';
} 

class DashboardRoute extends GoRoute {
  DashboardRoute()
      : super(
          path: route,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: DashboardView(),
            );
          },
        );

  static const String route = '/dashboard';
}

class DrinkDetailsRoute extends GoRoute {
  DrinkDetailsRoute()
      : super(
          path: '$_subRoute/:$_drinkIdKey',
          pageBuilder: (context, state) {
            final drinkId = state.pathParameters[_drinkIdKey] ?? '';
            final initialDrink = state.extra! as Drink;
            
            return FadeTransitionPage(
              child: DrinkDetailsView(
                drinkId: drinkId,
                initialDrink: initialDrink,
              ),
            );
          },
        );

  static const String _drinkIdKey = 'drinkId';
  static const String _subRoute = 'details';

  static String route(String drinkId) {
    return '${DrinksRoute.route}/$_subRoute/$drinkId';
  }
}
