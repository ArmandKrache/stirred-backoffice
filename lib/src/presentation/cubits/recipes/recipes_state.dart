part of 'recipes_cubit.dart';


abstract class RecipesState extends Equatable {
  final List<Recipe> recipes;
  final bool noMoreData;
  final DioException? exception;

  const RecipesState({
    this.recipes = const [],
    this.noMoreData = true,
    this.exception,
  });

  @override
  List<Object?> get props => [recipes, noMoreData, exception];
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesSuccess extends RecipesState {
  const RecipesSuccess({super.recipes, super.noMoreData});
}

class RecipesFailed extends RecipesState {
  const RecipesFailed({super.exception});
}