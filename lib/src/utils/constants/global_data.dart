import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/utils/constants/colors.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:cocktail_app/src/utils/resources/utils_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Categories _allPossibleCategories;

Categories get allPossibleCategories => _allPossibleCategories;

set allPossibleCategories(Categories categories) {
  _allPossibleCategories = categories;
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