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
  final String recipeId;
  final Categories categories;
  final double averageRating;

  const Drink({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.author,
    required this.glass,
    required this.recipeId,
    required this.categories,
    required this.averageRating,
  });

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
      recipeId: map['recipe'] ?? "",
      author: map['author'] != null ? Profile.fromMap(map['author']) : Profile.empty(),
      glass: map['glass'] != null ? Glass.fromMap(map['glass']) :  Glass.empty(),
      categories: map['categories'] != null ? Categories.fromMap(map['categories']) : Categories.empty(),
      averageRating: map['average_rating'] ?? 0.0,
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
      recipeId: "",
      categories: Categories.empty(),
      averageRating: -1.0,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}