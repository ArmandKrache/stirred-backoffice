part of 'drink_details_cubit.dart';

abstract class DrinkDetailsState extends Equatable {
  final Drink? drink;
  final DioException? exception;

  const DrinkDetailsState({
    this.drink,
    this.exception,
  });

  @override
  List<Object?> get props => [drink, exception];
}

class DrinkDetailsLoading extends DrinkDetailsState {
  const DrinkDetailsLoading();
}

class DrinkDetailsSuccess extends DrinkDetailsState {
  const DrinkDetailsSuccess({super.drink,});
}

class DrinkDetailsFailed extends DrinkDetailsState {
  const DrinkDetailsFailed({super.drink,});
}

class DrinkDeleteSuccess extends DrinkDetailsState {
  const DrinkDeleteSuccess({super.drink,});
}

class DrinkDeleteFailed extends DrinkDetailsState {
  const DrinkDeleteFailed({super.drink,});
}

class DrinkPatchSuccess extends DrinkDetailsState {
  const DrinkPatchSuccess({super.drink,});
}

class DrinkPatchFailed extends DrinkDetailsState {
  const DrinkPatchFailed({super.drink,});
}