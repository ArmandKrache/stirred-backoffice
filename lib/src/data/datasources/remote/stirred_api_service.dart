import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/ingredients/ingredients_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profile_list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/retrofit.dart' as retrofit;

part 'stirred_api_service.g.dart';


@RestApi(baseUrl: baseStirredApiUrl, parser: Parser.MapSerializable)
abstract class StirredApiService {
  factory StirredApiService(Dio dio, {String baseUrl}) = _StirredApiService;

  @POST('/auth/token/login/')
  Future<HttpResponse<LoginResponse>> getTokens(@Body() Map<String, dynamic> credentials);

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
      @Part() Categories categories,
      @Part() List<Ingredient> matches,
      );

  @DELETE("/ingredients/{id}/")
  Future<void> deleteIngredient(@Path() String id);

/// @retrofit.Headers({"Content-Type" : "application/json",})

}
