import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/login_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'admin_api_service.g.dart';


@RestApi(baseUrl: baseStirredAdminUrl, parser: Parser.MapSerializable)
abstract class AdminApiService {
  factory AdminApiService(Dio dio, {String baseUrl}) = _AdminApiService;

  @POST('/auth/token/login/')
  Future<HttpResponse<LoginResponse>> getTokens(@Body() Map<String, dynamic> credentials);

}
