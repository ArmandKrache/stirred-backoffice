
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/login_request.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:cocktail_app/src/utils/resources/tokens_management.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends BaseCubit<LoginState, Map<String, dynamic>> {
  final ApiRepository _apiRepository;

  LoginCubit(this._apiRepository) : super(const LoginSuccess(), {});

  Future<void> logIn({LoginRequest? request}) async {
    if (isBusy) return;
    if (request == null) return;

      await run(() async {
        final response =
          await _apiRepository.getTokens(request: request);

        if (response is DataSuccess) {
          final access = response.data!.access;
          final refresh = response.data!.refresh;

          await storeAccessToken(access);
          await storeRefreshToken(refresh);

          appRouter.push(const RootRoute());

          emit(const LoginSuccess());
        } else if (response is DataFailed) {
          emit(const LoginLoading());
          emit(LoginFailed(exception: response.exception));
        }
      });
  }

  Future<void> isAlreadyLoggedIn() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    logger.d("Access : $access | Refresh : $refresh");

    if (access == null || refresh == null)
      return ;

    appRouter.push(const RootRoute());
    emit(const LoginSuccess());
  }
}
