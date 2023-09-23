import 'dart:developer';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/domain/models/requests/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'recipes_state.dart';

class RecipesCubit extends BaseCubit<RecipesState, List<Recipe>> {
  final ApiRepository _apiRepository;

  RecipesCubit(this._apiRepository) : super(const RecipesLoading(), []);

  Future<void> fetchList({required RecipesListRequest request}) async {
    if (isBusy) return;

     await run(() async {
        emit(const RecipesLoading());
        final response = await _apiRepository.getRecipesList(request: request);

        if (response is DataSuccess) {
          final recipes = response.data!.recipes;
          final noMoreData = recipes.isEmpty;

          data.clear();
          data.addAll(recipes);

          emit(RecipesSuccess(recipes: data, noMoreData: noMoreData));
        } else if (response is DataFailed) {
          log(response.exception.toString());
        }
      });
  }

}