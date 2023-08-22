part of 'remote_login_cubit.dart';

abstract class RemoteLoginState extends Equatable {

  final DioException? exception;

  const RemoteLoginState({this.exception});

  @override
  List<Object?> get props => [];
}

class RemoteLoginLoading extends RemoteLoginState {
  const RemoteLoginLoading();
}

class RemoteLoginSuccess extends RemoteLoginState {
  const RemoteLoginSuccess();
}

class RemoteLoginFailed extends RemoteLoginState {
  const RemoteLoginFailed({super.exception});
}