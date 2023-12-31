import 'dart:developer';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_list_reponse.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'recipes_state.dart';

class RecipesCubit extends BaseCubit<RecipesState, List<Recipe>> {
  final ApiRepository _apiRepository;

  RecipesCubit(this._apiRepository) : super(const RecipesLoading(), []);

  Future<void> fetchList({String query = ""}) async {
    if (isBusy) return;

     await run(() async {
        emit(RecipesLoading(recipes: data));
        late DataState<RecipesListResponse> response;
        if (query == "") {
          response = await _apiRepository.getRecipesList(request: RecipesListRequest());
        } else {
          response = await _apiRepository.searchRecipes(request: RecipesSearchRequest(query: query));
        }

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

  Future<List<Ingredient>> searchIngredients(String query) async {
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