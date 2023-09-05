import 'dart:io' show HttpStatus;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:retrofit/retrofit.dart';



abstract class BaseApiRepository {
  // This method is responsible of handling the given request, in which /// it returns generic based Datastate
  // Returns DataSuccess that holds the generic data 'T if the response
  // is successfully recieved.
  // Returns DataFailed that holds a 'DioError' instance if any error occurs
  // while sending the request or recieving the response.

  @protected
  Future<DataState<T>> getState0f<T>({
  required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();
      if (
        httpResponse.response.statusCode == HttpStatus.ok ||
        httpResponse.response.statusCode == HttpStatus.created ||
        httpResponse.response.statusCode == HttpStatus.accepted
      ) {
        return DataSuccess(httpResponse.data);
      } else {
        throw DioException(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
        );
      }
    } on DioException catch (error) {
      return DataFailed(error);
    }
  }
}
