
import 'dart:developer';
import 'dart:io';

import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'glass_details_state.dart';

class GlassDetailsCubit extends BaseCubit<GlassDetailsState, Glass> {
  final ApiRepository _apiRepository;
  final Glass glass;

  GlassDetailsCubit(this._apiRepository, this.glass) : super(GlassDetailsSuccess(glass: glass), glass);

  Future<void> handleEvent({dynamic event}) async {
    if (isBusy) return;
    if (event == null) return;
    // TODO

  }

}

class GlassDeleteEvent {
  final GlassesListRequest? request; /// TODO: replace with GlassDeleteRequest

  GlassDeleteEvent({this.request});
}