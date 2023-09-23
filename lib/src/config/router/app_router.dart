import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glasses_view.dart';
import 'package:cocktail_app/src/presentation/views/glasses/glass_details_view.dart';
import 'package:cocktail_app/src/presentation/views/ingredients/ingredients_view.dart';
import 'package:cocktail_app/src/presentation/views/ingredients/ingredient_details_view.dart';
import 'package:cocktail_app/src/presentation/views/login_view.dart';
import 'package:cocktail_app/src/presentation/views/profiles/profiles_view.dart';
import 'package:cocktail_app/src/presentation/views/profiles/profiles_details_view.dart';
import 'package:cocktail_app/src/presentation/views/recipes/recipe_details_view.dart';
import 'package:cocktail_app/src/presentation/views/recipes/recipes_view.dart';
import 'package:cocktail_app/src/presentation/views/root_view.dart';
import 'package:cocktail_app/src/presentation/views/drinks/drinks_view.dart';
import 'package:flutter/cupertino.dart';
part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {

    @override
    List<AutoRoute> get routes => [
        AutoRoute(page: RootRoute.page,),
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: DrinksRoute.page,),
        AutoRoute(page: RecipesRoute.page,),
        AutoRoute(page: RecipeDetailsRoute.page,),
        AutoRoute(page: IngredientsRoute.page,),
        AutoRoute(page: IngredientDetailsRoute.page),
        AutoRoute(page: GlassesRoute.page,),
        AutoRoute(page: GlassDetailsRoute.page),
        AutoRoute(page: ProfilesRoute.page,),
        AutoRoute(page: ProfileDetailsRoute.page),
    ];
}

final appRouter = AppRouter();