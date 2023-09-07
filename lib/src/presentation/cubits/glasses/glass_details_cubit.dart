
import 'dart:developer';
import 'dart:io';

import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glass_patch_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_delete_request.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'glass_details_state.dart';

class GlassDetailsCubit extends BaseCubit<GlassDetailsState, Glass> {
  final ApiRepository _apiRepository;

  GlassDetailsCubit(this._apiRepository) : super(const GlassDetailsLoading(), Glass.empty());

  Future<void> handleEvent({dynamic event}) async {
    if (isBusy) return;
    if (event == null) return;

    if (event is GlassDetailsSetGlassEvent) {
      data = event.glass;
      log(data.toString());
      emit(GlassDetailsSuccess(glass: data));
    }
    if (event is GlassDeleteEvent) {
      try {
        await _apiRepository.deleteGlass(
            request: GlassDeleteRequest(
              id: state.glass!.id,
            ));
        emit(GlassDeleteSuccess(glass: state.glass,));
        appRouter.pop();
      } catch (e) {
        emit(GlassDeleteFailed(glass: state.glass));
      }
    }
  }

  Future<void> patchGlass(String id, Map<String, dynamic> data) async {
    await _apiRepository.patchGlass(
        request: GlassPatchRequest(
          id: id,
          body: data
        ));

    emit(GlassPatchSuccess(glass: state.glass,));
    appRouter.pop();
  }

}

class GlassDetailsSetGlassEvent {
  final Glass glass;

  GlassDetailsSetGlassEvent({required this.glass});
}

class GlassDeleteEvent {
  final GlassDeleteRequest? request;

  GlassDeleteEvent({this.request});
}