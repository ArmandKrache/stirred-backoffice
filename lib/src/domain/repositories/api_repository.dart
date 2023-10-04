import 'package:cocktail_app/src/domain/models/requests/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glass_patch_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_create_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/models/responses/all_choices_response.dart';
import 'package:cocktail_app/src/domain/models/responses/drinks/drink_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/drinks/drinks_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profiles/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/recipes/recipe_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/recipes/recipe_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/recipes/recipes_list_reponse.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

abstract class ApiRepository {

  Future<DataState<AllChoicesResponse>> getAllChoices();

  Future<DataState<LoginResponse>> getTokens({
    required LoginRequest request,
  });

  /// Profiles
  Future<DataState<ProfileListResponse>> getProfileList({
    required ProfileListRequest request,
  });

  Future<DataState<ProfileListResponse>> searchProfiles({
    required ProfilesSearchRequest request,
  });

  /// Glasses
  Future<DataState<GlassesListResponse>> getGlassesList({
    required GlassesListRequest request,
  });

  Future<DataState<GlassesListResponse>> searchGlasses({
    required GlassesSearchRequest request,
  });

  Future<DataState<GlassesCreateResponse>> createGlass({
    required GlassesCreateRequest request,
  });

  Future<DataState<GlassPatchResponse>> patchGlass({
    required GlassPatchRequest request,
  });

  Future<void> deleteGlass({
    required GlassDeleteRequest request,
  });

  /// Ingredients
  Future<DataState<IngredientsListResponse>> getIngredientsList({
    required IngredientsListRequest request,
  });

  Future<DataState<IngredientCreateResponse>> createIngredient({
    required IngredientCreateRequest request,
  });

  Future<DataState<IngredientPatchResponse>> patchIngredient({
    required IngredientPatchRequest request,
  });

  Future<void> deleteIngredient({
    required IngredientDeleteRequest request,
  });

  Future<DataState<IngredientsListResponse>> searchIngredients({
    required IngredientsSearchRequest request,
  });

  /// Recipes
  Future<DataState<RecipesListResponse>> getRecipesList({
    required RecipesListRequest request,
  });

  Future<DataState<RecipesListResponse>> searchRecipes({
    required RecipesSearchRequest request,
  });

  Future<DataState<RecipeCreateResponse>> createRecipe({
    required RecipeCreateRequest request,
  });

  Future<DataState<RecipePatchResponse>> patchRecipe({
    required RecipePatchRequest request,
  });

  Future<void> deleteRecipe({
    required RecipeDeleteRequest request,
  });


  /// Drinks
  Future<DataState<DrinksListResponse>> getDrinksList({
    required DrinksListRequest request,
  });

  Future<DataState<DrinkCreateResponse>> createDrink({
    required DrinkCreateRequest request,
  });

}