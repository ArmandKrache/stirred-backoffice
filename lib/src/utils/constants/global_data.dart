import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/utils/constants/colors.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:cocktail_app/src/utils/resources/utils_data_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Categories _allPossibleCategories;

Categories get allPossibleCategories => _allPossibleCategories;

set allPossibleCategories(Categories categories) {
  _allPossibleCategories = categories;
}

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


/// Difficulties

late List<String> _allPossibleDifficulties;

List<String> get allPossibleDifficulties => _allPossibleDifficulties;

set allPossibleDifficulties(List<String> difficulties) {
  _allPossibleDifficulties = difficulties;
}

String getDifficultyTitle(String key) {
  if (allPossibleDifficulties.contains(key)) {
    switch (key) {
      case "beginner" : return "Beginner";
      case "intermediate" : return "Intermediate";
      case "advanced" : return "Advanced";
      case "expert" : return "Expert";
      case "master" : return "Master";
      default : "Unknown";
    }
  }
  return "Unknown";
}

Color getDifficultyColor(String key) {
  if (allPossibleDifficulties.contains(key)) {
    switch (key) {
      case "beginner" : return commonColor;
      case "intermediate" : return unusualColor;
      case "advanced" : return rareColor;
      case "expert" : return epicColor;
      case "master" : return legendaryColor;
      default : commonColor;
    }
  }
  return commonColor;
}

/// Units

late List<String> _allPossibleUnits;

List<String> get allPossibleUnits => _allPossibleUnits;

set allPossibleUnits(List<String> units) {
  _allPossibleUnits = units;
}

String getUnitTitle(String key) {
  if (allPossibleUnits.contains(key)) {
    switch (key) {
      case "cup" : return "Cup";
      case "teaspoon" : return "Teaspoon";
      case "tablespoon" : return "TableSpoon";
      case "gram" : return "Gram";
      case "milliliter" : return "Milliliter";
      case "slice" : return "Slice";
      case "pinch" : return "Pinch";
      default : "Unknown";
    }
  }
  return "Unknown";
}