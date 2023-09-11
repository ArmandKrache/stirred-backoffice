
import 'dart:developer';
import 'dart:io';

import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'ingredients_state.dart';

class IngredientsCubit extends BaseCubit<IngredientsState, List<Ingredient>> {
  final ApiRepository _apiRepository;

  IngredientsCubit(this._apiRepository) : super(const IngredientsLoading(), []);

  Future<void> fetchList({IngredientsListRequest? request}) async {
    if (isBusy || request == null) return;

    await run(() async {
      emit(const IngredientsLoading());
      final response = await _apiRepository.getIngredientsList(request: request);

      if (response is DataSuccess) {
        final ingredients = response.data!.ingredients;
        final noMoreData = ingredients.isEmpty;

        data.clear();
        data.addAll(ingredients);

        emit(IngredientsSuccess(ingredients: data, noMoreData: noMoreData));
      } else if (response is DataFailed) {
        log(response.exception.toString());
      }
    });
  }


}
