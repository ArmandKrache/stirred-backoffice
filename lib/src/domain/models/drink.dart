import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/generic_id_with_name.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:equatable/equatable.dart';

class Drink extends Equatable {
  final String id;
  final String name;
  final String description;
  final String picture;
  final GenericPreviewModel author;
  final Glass glass;
  final GenericPreviewModel recipe;
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
      recipe: map['recipe'] != null ? GenericPreviewModel.fromMap(map['recipe']) : GenericPreviewModel.empty(),
      author: map['author'] != null ? GenericPreviewModel.fromMap(map['author']) : GenericPreviewModel.empty(),
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
      author: GenericPreviewModel.empty(),
      glass: Glass.empty(),
      recipe: GenericPreviewModel.empty(),
      categories: Categories.empty(),
      averageRating: 0.0,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}