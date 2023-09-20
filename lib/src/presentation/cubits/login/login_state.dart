part of 'login_cubit.dart';

abstract class LoginState extends Equatable {

  final DioException? exception;

  const LoginState({this.exception});

  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginFailed extends LoginState {
  const LoginFailed({super.exception});
}