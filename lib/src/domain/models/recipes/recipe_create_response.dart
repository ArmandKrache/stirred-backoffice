
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:equatable/equatable.dart';

class RecipeCreateResponse extends Equatable {
  final Recipe recipe;


  const RecipeCreateResponse({
    required this.recipe,
  });


  factory RecipeCreateResponse.fromMap(Map<String, dynamic> map) {
    return RecipeCreateResponse(
      recipe: Recipe.fromMap(map)
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [recipe];

}