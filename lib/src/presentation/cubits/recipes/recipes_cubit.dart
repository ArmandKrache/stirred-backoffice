import 'dart:developer';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

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