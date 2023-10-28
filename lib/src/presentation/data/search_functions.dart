import 'package:stirred_common_domain/stirred_common_domain.dart';

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