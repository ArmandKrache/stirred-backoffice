
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glasses/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:equatable/equatable.dart';

class DrinksListResponse extends Equatable {
  final List<Drink> drinks;


  const DrinksListResponse({
    required this.drinks,
  });


  factory DrinksListResponse.fromMap(Map<String, dynamic> map) {
    return DrinksListResponse(
      drinks: List<Drink>.from((map['results'] ?? []).map<dynamic>((element) {
        return Drink.fromMap(element);
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [drinks];

}