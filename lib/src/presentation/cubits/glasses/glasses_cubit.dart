
import 'dart:developer';

import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_list_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'glasses_state.dart';

class GlassesCubit extends BaseCubit<GlassesState, List<Glass>> {
  final ApiRepository _apiRepository;

  GlassesCubit(this._apiRepository) : super(const GlassesLoading(), []);

  Future<void> handleEvent({dynamic event}) async {
    if (isBusy) return;
    if (event == null) return;


    if (event is GlassesListEvent) {
      await run(() async {
        emit(const GlassesLoading());
        final response = await _apiRepository.getGlassesList(request: event.request!);

        if (response is DataSuccess) {
          final glasses = response.data!.glasses;
          final noMoreData = glasses.isEmpty;

          data.clear();
          data.addAll(glasses);

          emit(GlassesSuccess(glasses: data, noMoreData: noMoreData));
        } else if (response is DataFailed) {
          log(response.exception.toString());
        }
      });
    }
  }

}

class GlassesListEvent {
  final GlassesListRequest? request;

  GlassesListEvent({this.request});
}