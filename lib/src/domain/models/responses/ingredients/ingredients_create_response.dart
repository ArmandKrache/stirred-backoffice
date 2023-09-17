import 'dart:developer';

import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class IngredientCreateResponse extends Equatable {
  final Ingredient ingredient;


  const IngredientCreateResponse({
    required this.ingredient,
  });


  factory IngredientCreateResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return IngredientCreateResponse(
      ingredient: Ingredient(
        id: data["id"] ?? "",
        name: data["attributes"]["name"] ?? "",
        description: data["attributes"]["description"] ?? "",
        picture: data["attributes"]["picture"] ?? "",
        matches: List<IngredientMatch>.from((data["attributes"]["matches"] ?? []).map(
                (element) => IngredientMatch.fromMap(element))
        ),
        categories: Categories.fromMap(data["attributes"]["categories"]),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [ingredient];

}