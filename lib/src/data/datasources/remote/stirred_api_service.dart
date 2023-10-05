import 'dart:convert';
import 'package:cocktail_app/src/domain/models/drinks/drink_patch_response.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/models/all_choices_response.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink_create_response.dart';
import 'package:cocktail_app/src/domain/models/drinks/drinks_list_response.dart';
import 'package:cocktail_app/src/domain/models/glasses/glass_patch_response.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_create_response.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_patch_response.dart';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/glasses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe_create_response.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe_patch_response.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_list_reponse.dart';
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

  @GET('/profile/search/')
  Future<HttpResponse<ProfileListResponse>> searchProfiles({
    @Query("query") String? query,
  });

  /// Glasses
  @GET('/glasses/')
  Future<HttpResponse<GlassesListResponse>> getGlassesList();

  @GET('/glasses/search/')
  Future<HttpResponse<GlassesListResponse>> searchGlasses({
    @Query("query") String? query,
  });

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

  @GET('/recipes/search/')
  Future<HttpResponse<RecipesListResponse>> searchRecipes({
    @Query("query") String? query,
  });

  @POST('/recipes/create/')
  Future<HttpResponse<RecipeCreateResponse>> createRecipe(@Body() Map<String, dynamic> body);

  @PATCH('/recipes/{id}/')
  Future<HttpResponse<RecipePatchResponse>> patchRecipe(@Path() String id, @Body() Map<String, dynamic> body);

  @DELETE("/recipes/{id}/")
  Future<void> deleteRecipe(@Path() String id);


  /// Drinks
  @GET('/drinks/')
  Future<HttpResponse<DrinksListResponse>> getDrinksList();

  @POST('/drinks/create/')
  @MultiPart()
  Future<HttpResponse<DrinkCreateResponse>> createDrink({
    @Part() required String name,
    @Part() required String description,
    @Part() required MultipartFile picture,
    @Part() required Map<String, dynamic> categories,
    @Part() required String recipe,
    @Part() required String author,
    @Part() required String glass,
  });

  @PATCH("/drinks/{id}/")
  @MultiPart()
  Future<HttpResponse<DrinkPatchResponse>> patchDrink(
    @Path() String id,
    {
      @Part() String? name,
      @Part() String? description,
      @Part() MultipartFile? picture,
      @Part() Map<String, dynamic>? categories,
      @Part() String? recipe,
      @Part() String? author,
      @Part() String? glass,
    }
  );


  @DELETE("/drinks/{id}/")
  Future<void> deleteDrink(@Path() String id);

}
