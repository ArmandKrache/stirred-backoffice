part of 'drinks_cubit.dart';


abstract class DrinksState extends Equatable {
  final List<Drink> drinks;
  final bool noMoreData;
  final DioException? exception;

  const DrinksState({
    this.drinks = const [],
    this.noMoreData = true,
    this.exception,
  });

  @override
  List<Object?> get props => [drinks, noMoreData, exception];
}

class DrinksLoading extends DrinksState {
  const DrinksLoading({super.drinks, super.noMoreData});
}

class DrinksSuccess extends DrinksState {
  const DrinksSuccess({super.drinks, super.noMoreData});
}

class DrinksFailed extends DrinksState {
  const DrinksFailed({super.exception});
}