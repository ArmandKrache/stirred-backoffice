import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/utils/constants/global_data.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:cocktail_app/src/utils/resources/utils_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initialChoicesDataRetrieve() async {
  final ApiRepository apiRepository = locator<ApiRepository>();
  final response = await apiRepository.getAllChoices();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (response is DataSuccess) {
    final data = response.data!;
    allPossibleCategories = Categories(
      seasons: data.seasons,
      diets: data.diets,
      strengths: data.strengths,
      eras: data.eras,
      colors: data.colors,
      origins: data.origins,
      keywords: const [],
    );
    allPossibleUnits = data.ingredientUnits;
    data.ingredientUnits.sort(alphabeticalStringSort);
    allPossibleDifficulties = data.difficulties;
    prefs.setStringList("seasons_choices", data.seasons);
    prefs.setStringList("diets_choices", data.diets);
    prefs.setStringList("strengths_choices", data.strengths);
    prefs.setStringList("eras_choices", data.eras);
    prefs.setStringList("colors_choices", data.colors);
    prefs.setStringList("origins_choices", data.origins);
    prefs.setStringList("difficulties_choices", data.difficulties);
    prefs.setStringList("ingredient_units_choices", data.ingredientUnits);
  } else if (response is DataFailed) {
    allPossibleCategories = Categories(
      seasons: prefs.getStringList("seasons_choices") ?? [],
      diets: prefs.getStringList("diets_choices") ?? [],
      strengths: prefs.getStringList("strengths_choices") ?? [],
      eras: prefs.getStringList("eras_choices") ?? [],
      colors: prefs.getStringList("colors_choices") ?? [],
      origins: prefs.getStringList("origins_choices") ?? [],
      keywords: const [],
    );
    allPossibleUnits = [];
    allPossibleDifficulties = [];
  }
}