import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/recipes/recipe.dart';
import 'package:equatable/equatable.dart';

class RecipePatchResponse extends Equatable {
  final Recipe recipe;


  const RecipePatchResponse({
    required this.recipe,
  });


  factory RecipePatchResponse.fromMap(Map<String, dynamic> map) {
    logger.d(map);
    return RecipePatchResponse(
        recipe: Recipe.fromMap(map)
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [recipe];

}