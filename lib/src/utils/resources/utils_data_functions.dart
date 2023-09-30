import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/requests/ingredients/ingredients_requests.dart';
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