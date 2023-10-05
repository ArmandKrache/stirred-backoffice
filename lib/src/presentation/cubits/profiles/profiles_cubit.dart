
import 'dart:developer';

import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
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

  Future<void> handleEvent({dynamic event}) async {
    if (isBusy) return;
    if (event == null) return;


    if (event is ProfileListEvent) {
      await run(() async {
        final response = await _apiRepository.getProfileList(request: event.request!);

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
    } /*else if (event is SearchDrinksEvent) {
      await run(() async {
        emit(ProfilesLoading());
        final response = await _apiRepository.getSearchedCocktails(request: event.request!);

        if (response is DataSuccess) {
          final drinks = response.data!.drinks;
          final noMoreData = drinks.isEmpty;

          data.clear();
          data.addAll(drinks);

          emit(ProfilesSuccess(drinks: data, noMoreData: noMoreData));
        } else if (response is DataFailed) {
          // log(response.exception.toString());
        }
      });
    }*/
  }
}

/*
class SearchDrinksEvent {
  final SearchedCocktailsRequest? request;

  SearchDrinksEvent({this.request});
}*/

class ProfileListEvent {
  final ProfileListRequest? request;

  ProfileListEvent({this.request});
}