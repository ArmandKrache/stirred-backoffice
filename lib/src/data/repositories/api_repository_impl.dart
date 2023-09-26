
import 'package:cocktail_app/src/data/datasources/remote/base/base_api_repository.dart';
import 'package:cocktail_app/src/data/datasources/remote/admin_api_service.dart';
import 'package:cocktail_app/src/data/datasources/remote/stirred_api_service.dart';
import 'package:cocktail_app/src/domain/models/requests/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glass_patch_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_create_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/models/responses/all_choices_response.dart';
import 'package:cocktail_app/src/domain/models/responses/drinks/drinks_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profiles/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/recipes/recipes_list_reponse.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

class ApiRepositoryImpl extends BaseApiRepository implements ApiRepository {
  final AdminApiService _adminApiService;
  final StirredApiService _stirredApiService;

  ApiRepositoryImpl(this._adminApiService, this._stirredApiService);

  @override
  Future<DataState<LoginResponse>> getTokens({
    required LoginRequest request
  }) {
    return getState0f<LoginResponse>(request: () => _adminApiService.getTokens(
        {"username" : request.username!, "password" : request.password!}),
    );
  }

  @override
  Future<DataState<AllChoicesResponse>> getAllChoices() {
    return getState0f<AllChoicesResponse>(request: () => _stirredApiService.getAllChoices());
  }

  /// Profiles
  @override
  Future<DataState<ProfileListResponse>> getProfileList({
    required ProfileListRequest request
  }) {
    return getState0f<ProfileListResponse>(request: () => _stirredApiService.getProfileList(),
    );
  }

  /// Glasses
  @override
  Future<DataState<GlassesListResponse>> getGlassesList({
    required GlassesListRequest request
  }) {
    return getState0f<GlassesListResponse>(request: () => _stirredApiService.getGlassesList(),
    );
  }

  @override
  Future<DataState<GlassesCreateResponse>> createGlass({
    required GlassesCreateRequest request
  }) {
    return getState0f<GlassesCreateResponse>(request: () => _stirredApiService.createGlass(
      request.name!,
        request.description!,
        request.picture!),
    );
  }

  @override
  Future<void> deleteGlass({
    required GlassDeleteRequest request
  }) {
    return _stirredApiService.deleteGlass(
        request.id!
    );
  }

  @override
  Future<DataState<GlassPatchResponse>> patchGlass({
    required GlassPatchRequest request
  }) {
    return getState0f<GlassPatchResponse>(request: () {
      return _stirredApiService.patchGlass(request.id,
        name: request.body["name"],
        description: request.body["description"],
        picture: request.body["picture"],
      );
    });
  }

  /// Ingredients
  @override
  Future<DataState<IngredientsListResponse>> getIngredientsList({
    required IngredientsListRequest request
  }) {
    return getState0f<IngredientsListResponse>(request: () => _stirredApiService.getIngredientsList(),
    );
  }

  @override
  Future<DataState<IngredientsListResponse>> searchIngredients({
    required IngredientsSearchRequest request
  }) {
    return getState0f<IngredientsListResponse>(request: () => _stirredApiService.searchIngredients(query: request.query),
    );
  }

  @override
  Future<DataState<IngredientCreateResponse>> createIngredient({
    required IngredientCreateRequest request
  }) {
    return getState0f<IngredientCreateResponse>(request: () => _stirredApiService.createIngredient(
      request.name!,
      request.description!,
      request.picture!,
      request.categories!,
      request.matches!,
    ),
    );
  }

  @override
  Future<void> deleteIngredient({
    required IngredientDeleteRequest request
  }) {
    return _stirredApiService.deleteIngredient(
        request.id
    );
  }

  @override
  Future<DataState<IngredientPatchResponse>> patchIngredient({
    required IngredientPatchRequest request
  }) {
    return getState0f<IngredientPatchResponse>(request: () {
      return _stirredApiService.patchIngredient(request.id,
        name: request.body["name"],
        description: request.body["description"],
        picture: request.body["picture"],
        categories: request.body["categories"],
        matches: request.body["matches"],
      );
    });
  }

  /// Recipes
  @override
  Future<DataState<RecipesListResponse>> getRecipesList({
    required RecipesListRequest request
  }) {
    return getState0f<RecipesListResponse>(request: () => _stirredApiService.getRecipesList(),
    );
  }

  @override
  Future<void> deleteRecipe({
    required RecipeDeleteRequest request
  }) {
    return _stirredApiService.deleteRecipe(
        request.id
    );
  }

  /// Drinks
  @override
  Future<DataState<DrinksListResponse>> getDrinksList({
    required DrinksListRequest request
  }) {
    return getState0f<DrinksListResponse>(request: () => _stirredApiService.getDrinksList(),
    );
  }
}