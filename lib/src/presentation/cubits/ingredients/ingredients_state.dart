part of 'ingredients_cubit.dart';

abstract class IngredientsState extends Equatable {
  final List<Ingredient> ingredients;
  final bool noMoreData;
  final DioException? exception;

  const IngredientsState({
    this.ingredients = const [],
    this.noMoreData = true,
    this.exception,
  });

  @override
  List<Object?> get props => [ingredients, noMoreData, exception];
}

class IngredientsLoading extends IngredientsState {
  const IngredientsLoading();
}

class IngredientsSuccess extends IngredientsState {
  const IngredientsSuccess({super.ingredients, super.noMoreData});
}

class IngredientsFailed extends IngredientsState {
  const IngredientsFailed({super.exception});
}

class IngredientCreateSuccess extends IngredientsState {
  const IngredientCreateSuccess({super.ingredients, super.noMoreData});
}

class IngredientCreateFailed extends IngredientsState {
  const IngredientCreateFailed({super.exception});
}