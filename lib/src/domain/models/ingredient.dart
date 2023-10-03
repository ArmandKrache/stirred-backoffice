import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/generic_data_model.dart';
import 'package:equatable/equatable.dart';

class Ingredient extends Equatable implements GenericDataModel {
  final String id;
  final String name;
  final String description;
  final String picture;
  final List<IngredientMatch> matches;
  final Categories categories;

  const Ingredient({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.matches,
    required this.categories,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
      matches: List<IngredientMatch>.from((map['matches'] ?? []).map(
        (element) => IngredientMatch.fromMap(element))
      ),
      categories: map['categories'] != null ?  Categories.fromMap(map['categories']) : Categories.empty(),
    );
  }

  factory Ingredient.empty() {
    return Ingredient(
      id: "",
      name : "",
      description: "",
      picture: "",
      matches: const [],
      categories: Categories.empty(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}

class IngredientMatch extends Equatable {
  final String id;
  final String name;

  const IngredientMatch({
    required this.id,
    required this.name,
  });

  factory IngredientMatch.fromMap(Map<String, dynamic> map) {
    return IngredientMatch(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
    );
  }

  factory IngredientMatch.empty() {
    return const IngredientMatch(
      id: "",
      name : "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];

}
