import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:equatable/equatable.dart';

class Drink extends Equatable {
  final String id;
  final String name;
  final String description;
  final String picture;
  final Profile author;
  final Glass glass;
  final Recipe recipe;
  final Categories categories;
  final double averageRating;

  const Drink({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.author,
    required this.glass,
    required this.recipe,
    required this.categories,
    required this.averageRating,
  });

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
      author: map['author'] ?? Profile.empty(),
      glass: map['glass'] ?? Glass.empty(),
      recipe: map['recipe'] ?? Recipe.empty(),
      categories: map['categories'] ?? Categories.empty(),
      averageRating: map['average_rating'] ?? -1.0,
    );
  }

  factory Drink.empty() {
    return Drink(
      id: "",
      name : "",
      description: "",
      picture: "",
      author: Profile.empty(),
      glass: Glass.empty(),
      recipe: Recipe.empty(),
      categories: Categories.empty(),
      averageRating: -1.0,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}