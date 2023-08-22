// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    DrinkDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<DrinkDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DrinkDetailsView(
          key: args.key,
          drink: args.drink,
        ),
      );
    },
    HomepageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomepageView(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginView(),
      );
    },
    RootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RootView(),
      );
    },
    SavedDrinksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SavedDrinksView(),
      );
    },
  };
}

/// generated route for
/// [DrinkDetailsView]
class DrinkDetailsRoute extends PageRouteInfo<DrinkDetailsRouteArgs> {
  DrinkDetailsRoute({
    Key? key,
    required Drink drink,
    List<PageRouteInfo>? children,
  }) : super(
          DrinkDetailsRoute.name,
          args: DrinkDetailsRouteArgs(
            key: key,
            drink: drink,
          ),
          initialChildren: children,
        );

  static const String name = 'DrinkDetailsRoute';

  static const PageInfo<DrinkDetailsRouteArgs> page =
      PageInfo<DrinkDetailsRouteArgs>(name);
}

class DrinkDetailsRouteArgs {
  const DrinkDetailsRouteArgs({
    this.key,
    required this.drink,
  });

  final Key? key;

  final Drink drink;

  @override
  String toString() {
    return 'DrinkDetailsRouteArgs{key: $key, drink: $drink}';
  }
}

/// generated route for
/// [HomepageView]
class HomepageRoute extends PageRouteInfo<void> {
  const HomepageRoute({List<PageRouteInfo>? children})
      : super(
          HomepageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomepageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RootView]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SavedDrinksView]
class SavedDrinksRoute extends PageRouteInfo<void> {
  const SavedDrinksRoute({List<PageRouteInfo>? children})
      : super(
          SavedDrinksRoute.name,
          initialChildren: children,
        );

  static const String name = 'SavedDrinksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
