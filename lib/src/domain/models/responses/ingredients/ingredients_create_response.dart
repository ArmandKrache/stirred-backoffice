
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:equatable/equatable.dart';

class IngredientCreateResponse extends Equatable {
  final Ingredient ingredient;


  const IngredientCreateResponse({
    required this.ingredient,
  });


  factory IngredientCreateResponse.fromMap(Map<String, dynamic> map) {
    return IngredientCreateResponse(
      ingredient: Ingredient(
        id: map["id"] ?? "",
        name: map["name"] ?? "",
        description: map["description"] ?? "",
        picture: map["picture"] ?? "",
        matches: List<IngredientMatch>.from((map["matches"] ?? []).map(
                (element) => IngredientMatch.fromMap(element))
        ),
        categories: Categories.fromMap(map["categories"]),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [ingredient];

}