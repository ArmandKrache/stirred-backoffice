
import 'dart:developer';

import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_list_response.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'ingredients_state.dart';

class IngredientsCubit extends BaseCubit<IngredientsState, List<Ingredient>> {
  final ApiRepository _apiRepository;

  IngredientsCubit(this._apiRepository) : super(const IngredientsLoading(), []);

  Future<void> fetchList({String query = ""}) async {
    if (isBusy) return;

    await run(() async {
      emit(IngredientsLoading(ingredients: data));
      late DataState<IngredientsListResponse> response;
      if (query == "") {
        response = await _apiRepository.getIngredientsList(request: IngredientsListRequest());
      } else {
        response = await _apiRepository.searchIngredients(request: IngredientsSearchRequest(query: query));
      }

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

  Future<void> createIngredient(Map<String, dynamic> map, Function onSuccess) async {
    if (isBusy) return;
    final String name = map["name"];
    final String description = map["description"];
    final MultipartFile? picture = map["picture"];
    final List<String> matches = map["matches"];
    final Map<String, List<String>> categories = map["categories"] as Map<String, List<String>>;

    await run(() async {
      emit(const IngredientsLoading());
      final response = await _apiRepository.createIngredient(
          request: IngredientCreateRequest(
            name: name,
            description: description,
            picture: picture,
            matches: matches,
            categories: categories,
          ));
      if (response is DataSuccess) {
        log("Success");
        emit(IngredientCreateSuccess(ingredients: data));
        onSuccess.call();
      } else if (response is DataFailed) {
        log(response.exception.toString());
        emit(const IngredientCreateFailed());
      }
    });
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

  Future<void> setLoading() async {
    emit(const IngredientsLoading());
  }

}
