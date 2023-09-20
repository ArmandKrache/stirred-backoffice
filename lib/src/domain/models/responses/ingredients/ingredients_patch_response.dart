
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:equatable/equatable.dart';

class IngredientPatchResponse extends Equatable {
  final Ingredient ingredient;


  const IngredientPatchResponse({
    required this.ingredient,
  });


  factory IngredientPatchResponse.fromMap(Map<String, dynamic> map) {
    return IngredientPatchResponse(
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