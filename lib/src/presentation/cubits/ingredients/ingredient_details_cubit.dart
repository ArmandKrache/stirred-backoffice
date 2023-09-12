
import 'dart:developer';
import 'dart:io';

import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
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

part 'ingredient_details_state.dart';

class IngredientDetailsCubit extends BaseCubit<IngredientDetailsState, Ingredient> {
  final ApiRepository _apiRepository;

  IngredientDetailsCubit(this._apiRepository) : super(const IngredientDetailsLoading(), Ingredient.empty());

  Future<void> setIngredient(Ingredient ingredient) async {
    data = ingredient;
    emit(IngredientDetailsSuccess(ingredient: data));
  }


  Future<void> deleteIngredient(String id) async {
    if (isBusy) return;
    /* try {
      await _apiRepository.deleteIngredient(
          request: IngredientDeleteRequest(
            id: id,
          ));
      emit(IngredientDeleteSuccess(ingredient: state.ingredient,));
      appRouter.pop();
    } catch (e) {
      emit(IngredientDeleteFailed(ingredient: state.ingredient));
    } */
  }

  /* Future<Ingredient> patchIngredient(String id, Map<String, dynamic> data) async {
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
  } */

}