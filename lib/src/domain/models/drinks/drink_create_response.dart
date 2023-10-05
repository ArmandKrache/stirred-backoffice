
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/domain/models/drinks/drink.dart';
import 'package:cocktail_app/src/domain/models/ingredients/ingredient.dart';
import 'package:equatable/equatable.dart';

class DrinkCreateResponse extends Equatable {
  final Drink drink;


  const DrinkCreateResponse({
    required this.drink,
  });


  factory DrinkCreateResponse.fromMap(Map<String, dynamic> map) {
    logger.d(map);
    return DrinkCreateResponse(
      drink: Drink.fromMap(map),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [drink];

}