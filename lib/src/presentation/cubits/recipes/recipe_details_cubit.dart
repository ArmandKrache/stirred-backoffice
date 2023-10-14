import 'dart:developer';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/presentation/data/search_functions.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'recipe_details_state.dart';

class RecipeDetailsCubit extends BaseCubit<RecipeDetailsState, Recipe> {
  final ApiRepository _apiRepository;

  RecipeDetailsCubit(this._apiRepository) : super(const RecipeDetailsLoading(), Recipe.empty());

  Future<void> setRecipe({Recipe? recipe, String? id}) async {
    if (recipe == null) {
      if (id == null) {
        emit(const RecipeDetailsFailedInit());
        return;
      }
      List<Recipe> recipes = await searchRecipes(id);
      if (recipes.isEmpty) {
        emit(const RecipeDetailsFailedInit());
        return;
      }
      data = recipes.first;
    } else {
      data = recipe;
    }
    emit(RecipeDetailsSuccess(recipe: data));
    return;
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