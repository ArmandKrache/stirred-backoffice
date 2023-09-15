
import 'dart:developer';
import 'dart:io';

import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
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

  Future<void> createIngredient(Map<String, dynamic> data) async {
    if (isBusy) return;
    final String name = data["name"];
    final String description = data["description"];
    final MultipartFile? picture = data["picture"];
    final List<String> matches = data["matches"];
    final Map<String, List<String>> categories = data["categories"] as Map<String, List<String>>;

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
        emit(const IngredientCreateSuccess());
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

}
