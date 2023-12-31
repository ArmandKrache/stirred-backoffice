import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/models/glasses/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile_requests.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:cocktail_app/src/domain/models/glasses/glasses_requests.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredients_requests.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';

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

Future<List<Drink>> searchDrinks(String query) async {
  ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.searchDrinks(
      request: DrinksSearchRequest(query: query,));
  if (response is DataSuccess) {
    return response.data!.drinks;
  } else if (response is DataFailed) {
    logger.d(response.exception.toString());
  }
  return [];
}