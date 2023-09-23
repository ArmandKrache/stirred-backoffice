
import 'package:cocktail_app/src/domain/models/Recipe.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:equatable/equatable.dart';

class RecipesListResponse extends Equatable {
  final List<Recipe> recipes;


  const RecipesListResponse({
    required this.recipes,
  });


  factory RecipesListResponse.fromMap(Map<String, dynamic> map) {
    return RecipesListResponse(
      recipes: List<Recipe>.from((map['results'] ?? []).map<dynamic>((element) {
        return Recipe(
          id: element["id"] ?? "",
          name: element["name"] ?? "",
          description: element["description"] ?? "",
          preparationTime: element["preparation_time"] ?? 0,
          difficulty: element["difficulty"] ?? "",
          instructions: element["instructions"] ?? "",

        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [recipes];

}