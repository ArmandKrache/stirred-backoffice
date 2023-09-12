import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:dio/dio.dart';

class IngredientsListRequest {
  IngredientsListRequest();
}

class IngredientCreateRequest {
  final String? name;
  final String? description;
  final MultipartFile? picture;
  final Categories? categories;
  final List<Ingredient>? matches;

  IngredientCreateRequest({
    this.name,
    this.description,
    this.picture,
    this.categories,
    this.matches,
  });
}