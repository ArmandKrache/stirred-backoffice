part of 'recipe_details_cubit.dart';

abstract class RecipeDetailsState extends Equatable {
  final Recipe? recipe;
  final DioException? exception;

  const RecipeDetailsState({
    this.recipe,
    this.exception,
  });

  @override
  List<Object?> get props => [recipe, exception];
}

class RecipeDetailsLoading extends RecipeDetailsState {
  const RecipeDetailsLoading();
}

class RecipeDetailsSuccess extends RecipeDetailsState {
  const RecipeDetailsSuccess({super.recipe,});
}

class RecipeDetailsFailed extends RecipeDetailsState {
  const RecipeDetailsFailed({super.recipe,});
}

class RecipeDeleteSuccess extends RecipeDetailsState {
  const RecipeDeleteSuccess({super.recipe,});
}

class RecipeDeleteFailed extends RecipeDetailsState {
  const RecipeDeleteFailed({super.recipe,});
}

class RecipePatchSuccess extends RecipeDetailsState {
  const RecipePatchSuccess({super.recipe,});
}

class RecipePatchFailed extends RecipeDetailsState {
  const RecipePatchFailed({super.recipe,});
}