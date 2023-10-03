import 'package:cocktail_app/src/domain/models/generic_data_model.dart';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable implements GenericDataModel {
  final String id;
  final String name;
  final String description;
  final int preparationTime;
  final String difficulty;
  final String instructions;
  final List<RecipeIngredient> ingredients;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      preparationTime: map['preparation_time'] ?? 0,
      difficulty: map['difficulty'] ?? "",
      instructions: map['instructions'] ?? "",
      ingredients: List<RecipeIngredient>.from((map['ingredients'] ?? []).map(
              (element) => RecipeIngredient.fromMap(element))
      ),
    );
  }

  factory Recipe.empty() {
    return const Recipe(
      id: "",
      name : "",
      description: "",
      preparationTime: 0,
      difficulty: "",
      instructions: "",
      ingredients: [],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}

// ignore: must_be_immutable
class RecipeIngredient extends Equatable {
  String ingredientId;
  String ingredientName;
  double quantity;
  String unit;

  RecipeIngredient({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      ingredientId: map['ingredient_id'] ?? "",
      ingredientName : map['ingredient_name'] ?? "",
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? "",
    );
  }

  factory RecipeIngredient.empty() {
    return RecipeIngredient(
      ingredientId: "",
      ingredientName : "",
      quantity: 0,
      unit: "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [ingredientId, ingredientName, quantity, unit];

}