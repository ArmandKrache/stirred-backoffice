
import 'dart:developer';

import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'recipe_details_state.dart';

class RecipeDetailsCubit extends BaseCubit<RecipeDetailsState, Recipe> {
  final ApiRepository _apiRepository;

  RecipeDetailsCubit(this._apiRepository) : super(const RecipeDetailsLoading(), Recipe.empty());

  Future<void> setRecipe(Recipe recipe) async {
    data = recipe;
    emit(RecipeDetailsSuccess(recipe: data));
  }


  Future<void> deleteRecipe(String id) async {
    if (isBusy) return;
    try {
      await _apiRepository.deleteRecipe(
          request: RecipeDeleteRequest(id: id,)
      );
      emit(RecipeDeleteSuccess(recipe: state.recipe,));
      appRouter.pop();
    } catch (e) {
      emit(RecipeDeleteFailed(recipe: state.recipe));
    }
  }

  Future<Recipe> patchRecipe(String id, Map<String, dynamic> data) async {
    final response = await _apiRepository.patchRecipe(
        request: RecipePatchRequest(
            id: id,
            body: data
        ));

    logger.d(response.data!.recipe);
    emit(const RecipeDetailsLoading());
    emit(RecipePatchSuccess(recipe: response.data!.recipe,));
    appRouter.pop();
    return response.data!.recipe;
  }

}