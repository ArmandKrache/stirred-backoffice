import 'package:equatable/equatable.dart';

class AllChoicesResponse extends Equatable {
  final List<String> seasons;
  final List<String> origins;
  final List<String> strengths;
  final List<String> eras;
  final List<String> diets;
  final List<String> colors;
  final List<String> ingredientUnits;
  final List<String> difficulties;

  const AllChoicesResponse({
    required this.seasons,
    required this.origins,
    required this.strengths,
    required this.eras,
    required this.diets,
    required this.colors,
    required this.ingredientUnits,
    required this.difficulties,
  });


  factory AllChoicesResponse.fromMap(Map<String, dynamic> map) {
    final data = map["data"];
    return AllChoicesResponse(
      seasons: data['seasons'] ?? [],
      origins: data['origins'] ?? [],
      strengths: data['strengths'] ?? [],
      eras: data['eras'] ?? [],
      diets: data['diets'] ?? [],
      colors: data['colors'] ?? [],
      ingredientUnits: data['ingredient_units'] ?? [],
      difficulties: data['difficulties'] ?? [],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];

}