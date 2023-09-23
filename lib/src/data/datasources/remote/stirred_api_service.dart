import 'dart:convert';
import 'package:cocktail_app/src/domain/models/responses/all_choices_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_patch_response.dart';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profiles/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/recipes/recipes_list_reponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'stirred_api_service.g.dart';


@RestApi(baseUrl: baseStirredApiUrl, parser: Parser.MapSerializable)
abstract class StirredApiService {
  factory StirredApiService(Dio dio, {String baseUrl}) = _StirredApiService;

  @GET('/all-choices/')
  Future<HttpResponse<AllChoicesResponse>> getAllChoices();

  /// Profiles
  @GET('/profile/')
  Future<HttpResponse<ProfileListResponse>> getProfileList();

  /// Glasses
  @GET('/glasses/')
  Future<HttpResponse<GlassesListResponse>> getGlassesList();

  @POST('/glasses/create/')
  @MultiPart()
  Future<HttpResponse<GlassesCreateResponse>> createGlass(
      @Part() String name,
      @Part() String description,
      @Part() MultipartFile picture
      );

  @PATCH("/glasses/{id}/")
  @MultiPart()
  Future<HttpResponse<GlassPatchResponse>> patchGlass(
      @Path() String id,
      {
        @Part() String? name,
        @Part() String? description,
        @Part() MultipartFile? picture
      }
      );

  @DELETE("/glasses/{id}/")
  Future<void> deleteGlass(@Path() String id);

  /// Ingredients
  @GET('/ingredients/')
  Future<HttpResponse<IngredientsListResponse>> getIngredientsList();

  @GET('/ingredients/search/')
  Future<HttpResponse<IngredientsListResponse>> searchIngredients({
    @Query("query") String? query,
  });

  @POST('/ingredients/create/')
  @MultiPart()
  Future<HttpResponse<IngredientCreateResponse>> createIngredient(
      @Part() String name,
      @Part() String description,
      @Part() MultipartFile picture,
      @Part() Map<String, dynamic> categories,
      @Part() List<String> matches,
      );

  @PATCH("/ingredients/{id}/")
  @MultiPart()
  Future<HttpResponse<IngredientPatchResponse>> patchIngredient(
      @Path() String id,
      {
        @Part() String? name,
        @Part() String? description,
        @Part() MultipartFile? picture,
        @Part() Map<String, dynamic>? categories,
        @Part() List<String>? matches,
      }
      );

  @DELETE("/ingredients/{id}/")
  Future<void> deleteIngredient(@Path() String id);

  ///Recipes
  @GET('/recipes/')
  Future<HttpResponse<RecipesListResponse>> getRecipesList();

/// @retrofit.Headers({"Content-Type" : "application/json",})

}
