
import 'dart:developer';
import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/base/base_cubit.dart';
import 'package:stirred_backoffice/src/presentation/data/search_functions.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'ingredient_details_state.dart';

class IngredientDetailsCubit extends BaseCubit<IngredientDetailsState, Ingredient> {
  final ApiRepository _apiRepository;

  IngredientDetailsCubit(this._apiRepository) : super(const IngredientDetailsLoading(), Ingredient.empty());

  Future<void> setIngredient({Ingredient? ingredient, String? id}) async {
    if (ingredient == null) {
      if (id == null) {
        emit(const IngredientDetailsFailedInit());
        return;
      }
      List<Ingredient> ingredients = await searchIngredients(id);
      if (ingredients.isEmpty) {
        emit(const IngredientDetailsFailedInit());
        return;
      }
      data = ingredients.first;
    } else {
      data = ingredient;
    }
    emit(IngredientDetailsSuccess(ingredient: data));
    return;
  }


  Future<void> deleteIngredient(String id) async {
    if (isBusy) return;
    try {
      await _apiRepository.deleteIngredient(
          request: IngredientDeleteRequest(id: id,)
      );
      emit(IngredientDeleteSuccess(ingredient: state.ingredient,));
      appRouter.pop();
    } catch (e) {
      emit(IngredientDeleteFailed(ingredient: state.ingredient));
    }
  }

  Future<Ingredient> patchIngredient(String id, Map<String, dynamic> data) async {
    final response = await _apiRepository.patchIngredient(
        request: IngredientPatchRequest(
            id: id,
            body: data
        ));
    log(response.toString());
    log(response.data.toString());
    log(response.data!.ingredient.toString());

    emit(IngredientPatchSuccess(ingredient: response.data!.ingredient,));
    appRouter.pop();
    return response.data!.ingredient;
  }

  Future<List<Ingredient>> searchMatches(String query) async {
    final response = await _apiRepository.searchIngredients(
        request: IngredientsSearchRequest(query: query,));
    if (response is DataSuccess) {
      return response.data!.ingredients;
    } else if (response is DataFailed) {
      log(response.exception.toString());
    }
    return [];
  }

}