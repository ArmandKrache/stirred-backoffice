import 'package:cocktail_app/src/domain/models/requests/glasses/glass_patch_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_create_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/responses/all_choices_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profiles/profile_list_response.dart';
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

  Future<DataState<IngredientPatchResponse>> patchIngredient({
    required IngredientPatchRequest request,
  });

  Future<void> deleteIngredient({
    required IngredientDeleteRequest request,
  });

  Future<DataState<IngredientsListResponse>> searchIngredients({
    required IngredientsSearchRequest request,
  });


}