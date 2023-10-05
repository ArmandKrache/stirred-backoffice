class RecipesListRequest {
  RecipesListRequest();
}

class RecipesSearchRequest {
  final String query;
  RecipesSearchRequest({this.query = ""});
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

class RecipePatchRequest {
  final String id;
  final Map<String, dynamic> body;

  RecipePatchRequest({
    required this.id,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
    };
  }
}

class RecipeDeleteRequest {
  final String id;

  RecipeDeleteRequest({required this.id});
}