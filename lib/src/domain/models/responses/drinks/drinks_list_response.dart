
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:cocktail_app/src/domain/models/recipe.dart';
import 'package:equatable/equatable.dart';

class DrinksListResponse extends Equatable {
  final List<Drink> drinks;


  const DrinksListResponse({
    required this.drinks,
  });


  factory DrinksListResponse.fromMap(Map<String, dynamic> map) {
    return DrinksListResponse(
      drinks: List<Drink>.from((map['results'] ?? []).map<dynamic>((element) {
        return Drink(
          id: element['id'] ?? "",
          name : element['name'] ?? "",
          description: element['description'] ?? "",
          picture: element['picture'] ?? "",
          author: element['author'] ?? Profile.empty(),
          glass: element['glass'] ?? Glass.empty(),
          recipe: element['recipe'] ?? Recipe.empty(),
          categories: element['categories'] ?? Categories.empty(),
          averageRating: element['average_rating'] ?? -1.0,
        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [drinks];

}