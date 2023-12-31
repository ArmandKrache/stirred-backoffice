
import 'dart:developer';

import 'package:cocktail_app/src/domain/models/glasses/glass.dart';
import 'package:cocktail_app/src/domain/models/glasses/glasses_list_response.dart';
import 'package:cocktail_app/src/domain/models/glasses/glasses_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'glasses_state.dart';

class GlassesCubit extends BaseCubit<GlassesState, List<Glass>> {
  final ApiRepository _apiRepository;

  GlassesCubit(this._apiRepository) : super(const GlassesLoading(), []);

  Future<void> fetchList({String query = ""}) async {
    if (isBusy) return;


    await run(() async {
      emit(GlassesLoading(glasses: data));
      late DataState<GlassesListResponse> response;
      if (query == "") {
        response = await _apiRepository.getGlassesList(request: GlassesListRequest());
      } else {
        response = await _apiRepository.searchGlasses(request: GlassesSearchRequest(query: query));
      }

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

class GlassesListEvent {
  final GlassesListRequest? request;

  GlassesListEvent({this.request});
}