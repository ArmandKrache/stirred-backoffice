import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:equatable/equatable.dart';

class SearchedCocktailsResponse extends Equatable {
  final List<Drink> drinks;

  const SearchedCocktailsResponse({
    required this.drinks,
  });


  factory SearchedCocktailsResponse.fromMap(Map<String, dynamic> map) {
    return SearchedCocktailsResponse(
      drinks: List<Drink>.from(
        (map['drinks'] ?? []).map<Drink>(
              (x) => Drink.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [drinks];

}