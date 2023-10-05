
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:equatable/equatable.dart';

class IngredientsListResponse extends Equatable {
  final List<Ingredient> ingredients;


  const IngredientsListResponse({
    required this.ingredients,
  });


  factory IngredientsListResponse.fromMap(Map<String, dynamic> map) {
    return IngredientsListResponse(
      ingredients: List<Ingredient>.from((map['results'] ?? []).map<dynamic>((element) {
        return Ingredient(
          id: element["id"] ?? "",
          name: element["name"] ?? "",
          description: element["description"] ?? "",
          picture: element["picture"] ?? "",
          matches: List<IngredientMatch>.from((element["matches"] ?? []).map(
                  (element) => IngredientMatch.fromMap(element))),
          categories: Categories.fromMap(element["categories"]),
        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [ingredients];

}