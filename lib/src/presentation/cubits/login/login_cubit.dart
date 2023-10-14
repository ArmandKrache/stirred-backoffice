import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';
import 'package:stirred_backoffice/src/presentation/cubits/base/base_cubit.dart';
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

    if (access == null || refresh == null) {
      return ;
    }

    appRouter.push(const RootRoute());
    emit(const LoginSuccess());
  }
}
