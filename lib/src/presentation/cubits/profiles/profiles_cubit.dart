
import 'dart:developer';

import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile_list_response.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'profiles_state.dart';

class ProfilesCubit extends BaseCubit<ProfilesState, List<Profile>> {
  final ApiRepository _apiRepository;

  ProfilesCubit(this._apiRepository) : super(const ProfilesLoading(), []);

  Future<void> fetchList({String query = ""}) async {
    if (isBusy) return;

    await run(() async {
      emit(ProfilesLoading(profiles: data));
      late DataState<ProfileListResponse> response;
      if (query == "") {
        response = await _apiRepository.getProfileList(request: ProfileListRequest());
      } else {
        response = await _apiRepository.searchProfiles(request: ProfilesSearchRequest(query: query));
      }

      if (response is DataSuccess) {
        final profiles = response.data!.profiles;
        final noMoreData = profiles.isEmpty;

        data.clear();
        data.addAll(profiles);

        emit(ProfilesSuccess(profiles: data, noMoreData: noMoreData));
      } else if (response is DataFailed) {
        log(response.exception.toString());
      }
    });
  }
}