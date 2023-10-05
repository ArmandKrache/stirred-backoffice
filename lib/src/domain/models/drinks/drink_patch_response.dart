import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:equatable/equatable.dart';

class DrinkPatchResponse extends Equatable {
  final Drink drink;


  const DrinkPatchResponse({
    required this.drink,
  });


  factory DrinkPatchResponse.fromMap(Map<String, dynamic> map) {
    logger.d(map);
    return DrinkPatchResponse(
        drink: Drink.fromMap(map)
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [drink];

}