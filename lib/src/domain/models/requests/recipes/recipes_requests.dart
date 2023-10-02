class RecipesListRequest {
  RecipesListRequest();
}

class RecipeCreateRequest {
  final String name;
  final String description;
  final String instructions;
  final String difficulty;
  final int preparationTime;
  final List<Map<String, dynamic>> ingredients;

  RecipeCreateRequest({
    required this.name,
    required this.description,
    required this.instructions,
    required this.difficulty,
    required this.preparationTime,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'instructions': instructions,
      'difficulty': difficulty,
      'preparation_time': preparationTime,
      'ingredients': ingredients,
    };
  }
}

class RecipeDeleteRequest {
  final String id;

  RecipeDeleteRequest({required this.id});
}