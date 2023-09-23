part of 'recipe_create_cubit.dart';

abstract class RecipeCreateState extends Equatable {
  final http.MultipartFile? selectedImage;

  const RecipeCreateState({
    this.selectedImage,
  });

  @override
  List<Object?> get props => [selectedImage];
}

class RecipeCreateLoading extends RecipeCreateState {
  const RecipeCreateLoading();
}

class RecipeCreateSuccess extends RecipeCreateState {
  const RecipeCreateSuccess();
}

class RecipeCreateImageSelectLoading extends RecipeCreateState {
  const RecipeCreateImageSelectLoading();
}

class RecipeCreateImageSelectSuccess extends RecipeCreateState {
  const RecipeCreateImageSelectSuccess({super.selectedImage});
}

class RecipeCreateFailed extends RecipeCreateState {
  const RecipeCreateFailed({super.selectedImage});
}