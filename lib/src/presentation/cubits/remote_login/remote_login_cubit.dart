import 'dart:developer';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/requests/filtered_cocktails_request.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/domain/models/requests/searched_cocktails_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:cocktail_app/src/utils/resources/tokens_management.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'remote_login_state.dart';

class RemoteLoginCubit extends BaseCubit<RemoteLoginState, Map<String, dynamic>> {
  final ApiRepository _apiRepository;

  RemoteLoginCubit(this._apiRepository) : super(const RemoteLoginSuccess(), {});

  Future<void> handleEvent({dynamic event}) async {
    if (isBusy) return;
    if (event == null) return;

    if (event is LoginEvent) {
      await run(() async {
        final response =
          await _apiRepository.getTokens(request: event.request!);

        if (response is DataSuccess) {
          log(response.data.toString());
          final access = response.data!.access;
          final refresh = response.data!.refresh;

          storeAccessToken(access);
          storeRefreshToken(refresh);

          String? test = await getAccessToken();

          emit(const RemoteLoginSuccess());
        } else if (response is DataFailed) {
          emit(const RemoteLoginLoading());
          log(response.exception.toString());
          log(response.exception!.response.toString());
          emit(RemoteLoginFailed(exception: response.exception));
        }
      });
    }
  }
}

class LoginEvent {
  final LoginRequest? request;

  LoginEvent({this.request});
}
