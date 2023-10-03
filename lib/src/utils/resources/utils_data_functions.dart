import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:cocktail_app/src/domain/models/requests/glasses/glasses_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/requests/profile_list_request.dart';
import 'package:cocktail_app/src/domain/models/requests/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

int alphabeticalStringSort(String a, String b) {
  return a.toLowerCase().compareTo(b.toLowerCase());
}

Future<List<Ingredient>> searchIngredients(String query) async {
  ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.searchIngredients(
      request: IngredientsSearchRequest(query: query,));
  if (response is DataSuccess) {
    return response.data!.ingredients;
  } else if (response is DataFailed) {
    logger.d(response.exception.toString());
  }
  return [];
}


Future<List<Glass>> searchGlasses(String query) async {
  ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.searchGlasses(
      request: GlassesSearchRequest(query: query,));
  if (response is DataSuccess) {
    return response.data!.glasses;
  } else if (response is DataFailed) {
    logger.d(response.exception.toString());
  }
  return [];
}

Future<List<Recipe>> searchRecipes(String query) async {
  ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.searchRecipes(
      request: RecipesSearchRequest(query: query,));
  if (response is DataSuccess) {
    return response.data!.recipes;
  } else if (response is DataFailed) {
    logger.d(response.exception.toString());
  }
  return [];
}

Future<List<Profile>> searchProfiles(String query) async {
  ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.searchProfiles(
      request: ProfilesSearchRequest(query: query,));
  if (response is DataSuccess) {
    return response.data!.profiles;
  } else if (response is DataFailed) {
    logger.d(response.exception.toString());
  }
  return [];
}