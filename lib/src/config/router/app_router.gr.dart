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
    DrinksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DrinksView(),
      );
    },
    GlassesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GlassesView(),
      );
    },
    IngredientsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IngredientsView(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginView(key: args.key),
      );
    },
    ProfilesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilesView(),
      );
    },
    RecipesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RecipesView(),
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
/// [DrinksView]
class DrinksRoute extends PageRouteInfo<void> {
  const DrinksRoute({List<PageRouteInfo>? children})
      : super(
          DrinksRoute.name,
          initialChildren: children,
        );

  static const String name = 'DrinksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GlassesView]
class GlassesRoute extends PageRouteInfo<void> {
  const GlassesRoute({List<PageRouteInfo>? children})
      : super(
          GlassesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GlassesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IngredientsView]
class IngredientsRoute extends PageRouteInfo<void> {
  const IngredientsRoute({List<PageRouteInfo>? children})
      : super(
          IngredientsRoute.name,
          initialChildren: children,
        );

  static const String name = 'IngredientsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ProfilesView]
class ProfilesRoute extends PageRouteInfo<void> {
  const ProfilesRoute({List<PageRouteInfo>? children})
      : super(
          ProfilesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfilesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RecipesView]
class RecipesRoute extends PageRouteInfo<void> {
  const RecipesRoute({List<PageRouteInfo>? children})
      : super(
          RecipesRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecipesRoute';

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
