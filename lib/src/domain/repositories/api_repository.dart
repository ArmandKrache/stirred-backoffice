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
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/lookup_details_response.dart';
import 'package:cocktail_app/src/domain/models/responses/popular_cocktails_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/searched_cocktails_response.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

abstract class ApiRepository {
  Future<DataState<LoginResponse>> getTokens({
    required LoginRequest request,
  });

  /// Profiles
  Future<DataState<ProfileListResponse>> getProfileList({
    required ProfileListRequest request,
  });

  /// Glasses
  Future<DataState<GlassesListResponse>> getGlassesList({
    required GlassesListRequest request,
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

  Future<void> deleteIngredient({
    required IngredientDeleteRequest request,
  });

  /// -------- Deprecated below ----------- ///
  Future<DataState<PopularCocktailsResponse>> getPopularCocktails({
    required PopularCocktailsRequest request,
  });

  Future<DataState<FilteredCocktailsResponse>> getFilteredCocktails({
    required FilteredCocktailsRequest request,
  });

  Future<DataState<SearchedCocktailsResponse>> getSearchedCocktails({
    required SearchedCocktailsRequest request,
  });

  Future<DataState<LookupDetailsResponse>> lookupDetails({
    required LookupDetailsRequest request
  });
}