part of 'ingredient_details_cubit.dart';

abstract class IngredientDetailsState extends Equatable {
  final Ingredient? ingredient;
  final DioException? exception;

  const IngredientDetailsState({
    this.ingredient,
    this.exception,
  });

  @override
  List<Object?> get props => [ingredient, exception];
}

class IngredientDetailsLoading extends IngredientDetailsState {
  const IngredientDetailsLoading();
}

class IngredientDetailsSuccess extends IngredientDetailsState {
  const IngredientDetailsSuccess({super.ingredient,});
}

class IngredientDetailsFailed extends IngredientDetailsState {
  const IngredientDetailsFailed({super.ingredient,});
}

class IngredientDetailsFailedInit extends IngredientDetailsState {
  const IngredientDetailsFailedInit({super.ingredient,});
}

class IngredientDeleteSuccess extends IngredientDetailsState {
  const IngredientDeleteSuccess({super.ingredient,});
}

class IngredientDeleteFailed extends IngredientDetailsState {
  const IngredientDeleteFailed({super.ingredient,});
}

class IngredientPatchSuccess extends IngredientDetailsState {
  const IngredientPatchSuccess({super.ingredient,});
}

class IngredientPatchFailed extends IngredientDetailsState {
  const IngredientPatchFailed({super.ingredient,});
}