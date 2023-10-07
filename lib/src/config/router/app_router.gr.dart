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
    GlassDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<GlassDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GlassDetailsView(
          key: args.key,
          glass: args.glass,
        ),
      );
    },
    GlassesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GlassesView(),
      );
    },
    IngredientDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<IngredientDetailsRouteArgs>(
          orElse: () => const IngredientDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IngredientDetailsView(
          key: args.key,
          ingredient: args.ingredient,
          id: args.id,
          editButtonsVisibility: args.editButtonsVisibility,
        ),
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
    ProfileDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileDetailsView(
          key: args.key,
          profile: args.profile,
        ),
      );
    },
    ProfilesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilesView(),
      );
    },
    RecipeDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<RecipeDetailsRouteArgs>(
          orElse: () => const RecipeDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecipeDetailsView(
          key: args.key,
          recipe: args.recipe,
          id: args.id,
          editButtonsVisibility: args.editButtonsVisibility,
        ),
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
/// [GlassDetailsView]
class GlassDetailsRoute extends PageRouteInfo<GlassDetailsRouteArgs> {
  GlassDetailsRoute({
    Key? key,
    required Glass glass,
    List<PageRouteInfo>? children,
  }) : super(
          GlassDetailsRoute.name,
          args: GlassDetailsRouteArgs(
            key: key,
            glass: glass,
          ),
          initialChildren: children,
        );

  static const String name = 'GlassDetailsRoute';

  static const PageInfo<GlassDetailsRouteArgs> page =
      PageInfo<GlassDetailsRouteArgs>(name);
}

class GlassDetailsRouteArgs {
  const GlassDetailsRouteArgs({
    this.key,
    required this.glass,
  });

  final Key? key;

  final Glass glass;

  @override
  String toString() {
    return 'GlassDetailsRouteArgs{key: $key, glass: $glass}';
  }
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
/// [IngredientDetailsView]
class IngredientDetailsRoute extends PageRouteInfo<IngredientDetailsRouteArgs> {
  IngredientDetailsRoute({
    Key? key,
    Ingredient? ingredient,
    String? id,
    bool editButtonsVisibility = true,
    List<PageRouteInfo>? children,
  }) : super(
          IngredientDetailsRoute.name,
          args: IngredientDetailsRouteArgs(
            key: key,
            ingredient: ingredient,
            id: id,
            editButtonsVisibility: editButtonsVisibility,
          ),
          initialChildren: children,
        );

  static const String name = 'IngredientDetailsRoute';

  static const PageInfo<IngredientDetailsRouteArgs> page =
      PageInfo<IngredientDetailsRouteArgs>(name);
}

class IngredientDetailsRouteArgs {
  const IngredientDetailsRouteArgs({
    this.key,
    this.ingredient,
    this.id,
    this.editButtonsVisibility = true,
  });

  final Key? key;

  final Ingredient? ingredient;

  final String? id;

  final bool editButtonsVisibility;

  @override
  String toString() {
    return 'IngredientDetailsRouteArgs{key: $key, ingredient: $ingredient, id: $id, editButtonsVisibility: $editButtonsVisibility}';
  }
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
/// [ProfileDetailsView]
class ProfileDetailsRoute extends PageRouteInfo<ProfileDetailsRouteArgs> {
  ProfileDetailsRoute({
    Key? key,
    required Profile profile,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileDetailsRoute.name,
          args: ProfileDetailsRouteArgs(
            key: key,
            profile: profile,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileDetailsRoute';

  static const PageInfo<ProfileDetailsRouteArgs> page =
      PageInfo<ProfileDetailsRouteArgs>(name);
}

class ProfileDetailsRouteArgs {
  const ProfileDetailsRouteArgs({
    this.key,
    required this.profile,
  });

  final Key? key;

  final Profile profile;

  @override
  String toString() {
    return 'ProfileDetailsRouteArgs{key: $key, profile: $profile}';
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
/// [RecipeDetailsView]
class RecipeDetailsRoute extends PageRouteInfo<RecipeDetailsRouteArgs> {
  RecipeDetailsRoute({
    Key? key,
    Recipe? recipe,
    String? id,
    bool editButtonsVisibility = true,
    List<PageRouteInfo>? children,
  }) : super(
          RecipeDetailsRoute.name,
          args: RecipeDetailsRouteArgs(
            key: key,
            recipe: recipe,
            id: id,
            editButtonsVisibility: editButtonsVisibility,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeDetailsRoute';

  static const PageInfo<RecipeDetailsRouteArgs> page =
      PageInfo<RecipeDetailsRouteArgs>(name);
}

class RecipeDetailsRouteArgs {
  const RecipeDetailsRouteArgs({
    this.key,
    this.recipe,
    this.id,
    this.editButtonsVisibility = true,
  });

  final Key? key;

  final Recipe? recipe;

  final String? id;

  final bool editButtonsVisibility;

  @override
  String toString() {
    return 'RecipeDetailsRouteArgs{key: $key, recipe: $recipe, id: $id, editButtonsVisibility: $editButtonsVisibility}';
  }
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
