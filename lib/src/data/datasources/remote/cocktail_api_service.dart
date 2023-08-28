import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/responses/filtered_cocktails_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/lookup_details_response.dart';
import 'package:cocktail_app/src/domain/models/responses/popular_cocktails_response.dart';
import 'package:cocktail_app/src/domain/models/responses/saerched_cocktails_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'cocktail_api_service.g.dart';


@RestApi(baseUrl: baseStirredAdminUrl, parser: Parser.MapSerializable)
abstract class CocktailApiService {
  factory CocktailApiService(Dio dio, {String baseUrl}) = _CocktailApiService;

  @POST('/auth/token/login/')
  Future<HttpResponse<LoginResponse>> getTokens(@Body() Map<String, dynamic> credentials);

  /// Deprecated below

  @GET('/popular.php')
  Future<HttpResponse<PopularCocktailsResponse>> getPopularCocktails();

  @GET('/filter.php')
  Future<HttpResponse<FilteredCocktailsResponse>> getFilteredCocktails({
    @Query("c") String? categorie,
    @Query("a") String? alcoholic,
    @Query("g") String? glass,
    @Query("i") String? ingredients,
    ///     @Header("Authorization") String? authorization
  });

  @GET('/search.php')
  Future<HttpResponse<SearchedCocktailsResponse>> getSearchedCocktails({
    @Query("s") String? name,
    @Query("f") String? firstLetter,
    @Query("i") String? ingredient,
  });

  @GET('/lookup.php')
  Future<HttpResponse<LookupDetailsResponse>> lookupDetails({
    @Query('i') String? drinkId,
    @Query('iid') String? ingredientId,
  });
}
