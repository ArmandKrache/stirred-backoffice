part of 'drink_create_cubit.dart';

abstract class DrinkCreateState extends Equatable {
  final http.MultipartFile? selectedImage;

  const DrinkCreateState({
    this.selectedImage,
  });

  @override
  List<Object?> get props => [selectedImage];
}

class DrinkCreateLoading extends DrinkCreateState {
  const DrinkCreateLoading();
}

class DrinkCreateSuccess extends DrinkCreateState {
  const DrinkCreateSuccess();
}

class DrinkCreateImageSelectLoading extends DrinkCreateState {
  const DrinkCreateImageSelectLoading();
}

class DrinkCreateImageSelectSuccess extends DrinkCreateState {
  const DrinkCreateImageSelectSuccess({super.selectedImage});
}

class DrinkCreateFailed extends DrinkCreateState {
  const DrinkCreateFailed({super.selectedImage});
}