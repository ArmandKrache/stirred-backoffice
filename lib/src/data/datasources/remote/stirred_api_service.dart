import 'dart:convert';
import 'dart:io';

import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses_create_response.dart';
import 'package:cocktail_app/src/domain/models/responses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/responses/login_response.dart';
import 'package:cocktail_app/src/domain/models/responses/profile_list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'stirred_api_service.g.dart';


@RestApi(baseUrl: baseStirredApiUrl, parser: Parser.MapSerializable)
abstract class StirredApiService {
  factory StirredApiService(Dio dio, {String baseUrl}) = _StirredApiService;

  @POST('/auth/token/login/')
  Future<HttpResponse<LoginResponse>> getTokens(@Body() Map<String, dynamic> credentials);

  @GET('/profile/')
  Future<HttpResponse<ProfileListResponse>> getProfileList();

  @GET('/glasses/')
  Future<HttpResponse<GlassesListResponse>> getGlassesList();

  @POST('/glasses/create/')
  @MultiPart()
  Future<HttpResponse<GlassesCreateResponse>> createGlass(@Part() Map<String, dynamic> body, @Part() File picture);

}
