import 'dart:developer';

import 'package:cocktail_app/src/data/datasources/remote/base/base_api_repository.dart';
import 'package:cocktail_app/src/data/datasources/remote/cocktail_api_service.dart';
import 'package:cocktail_app/src/data/datasources/remote/stirred_api_service.dart';
import 'package:cocktail_app/src/domain/models/requests/filtered_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glass_patch_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_create_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/domain/models/requests/lookup_details_request.dart';
import 'package:cocktail_app/src/domain/models/requests/popular_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/searched_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/responses/filtered_cocktails_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_delete_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/lookup_details_response.dart';
import 'package:cocktail_app/src/domain/models/responses/popular_cocktails_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/saerched_cocktails_response.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

class ApiRepositoryImpl extends BaseApiRepository implements ApiRepository {
  final CocktailApiService _cocktailApiService;
  final StirredApiService _stirredApiService;

  ApiRepositoryImpl(this._cocktailApiService, this._stirredApiService);

  @override
  Future<DataState<PopularCocktailsResponse>> getPopularCocktails({
    required PopularCocktailsRequest request
  }) {
    return getState0f<PopularCocktailsResponse>(request: () => _cocktailApiService.getPopularCocktails());
  }

  @override
  Future<DataState<FilteredCocktailsResponse>> getFilteredCocktails({
    required FilteredCocktailsRequest request
  }) {
    return getState0f<FilteredCocktailsResponse>(request: () => _cocktailApiService.getFilteredCocktails(
      alcoholic: request.alcoholic,
      ingredients: request.ingredients,
      glass: request.glass,
      categorie: request.categorie
    ));
  }

  @override
  Future<DataState<SearchedCocktailsResponse>> getSearchedCocktails({
    required SearchedCocktailsRequest request
  }) {
    return getState0f<SearchedCocktailsResponse>(request: () => _cocktailApiService.getSearchedCocktails(
        name: request.name,
        ingredient: request.ingredient,
        firstLetter: request.firstLetter,
    ));
  }

  @override
  Future<DataState<LookupDetailsResponse>> lookupDetails({
    required LookupDetailsRequest request
  }) {
    return getState0f<LookupDetailsResponse>(request: () => _cocktailApiService.lookupDetails(
      drinkId: request.drinkId,
      ingredientId: request.ingredientId,
    ));
  }

  @override
  Future<DataState<LoginResponse>> getTokens({
    required LoginRequest request
  }) {
    return getState0f<LoginResponse>(request: () => _cocktailApiService.getTokens(
        {"username" : request.username!, "password" : request.password!}),
    );
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
}