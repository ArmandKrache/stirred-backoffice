part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  final List<Profile> profiles;
  final bool noMoreData;
  final DioException? exception;

  const ProfilesState({
    this.profiles = const [],
    this.noMoreData = true,
    this.exception
  });

  @override
  List<Object?> get props => [profiles, noMoreData, exception];
}

class ProfilesLoading extends ProfilesState {
  const ProfilesLoading({super.profiles, super.noMoreData});
}

class ProfilesSuccess extends ProfilesState {
  const ProfilesSuccess({super.profiles, super.noMoreData});
}

class ProfilesFailed extends ProfilesState {
  const ProfilesFailed({super.exception});
}