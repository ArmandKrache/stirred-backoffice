import 'dart:developer';

import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/ingredient.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class IngredientsListResponse extends Equatable {
  final List<Ingredient> ingredients;


  const IngredientsListResponse({
    required this.ingredients,
  });


  factory IngredientsListResponse.fromMap(Map<String, dynamic> map) {
    return IngredientsListResponse(
      ingredients: List<Ingredient>.from((map['data'] ?? []).map<dynamic>((element) {
        return Ingredient(
          id: element["id"] ?? "",
          name: element["attributes"]["name"] ?? "",
          description: element["attributes"]["description"] ?? "",
          picture: element["attributes"]["picture"] ?? "",
          matches: List<String>.from((element["attributes"]["matches"] ?? [])),
          categories: Categories.fromMap(element["attributes"]["categories"]),
        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [ingredients];

}