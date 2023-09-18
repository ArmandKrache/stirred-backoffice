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
      seasons: List<String>.from(map['seasons'] ?? []),
      origins: List<String>.from(map['origins'] ?? []),
      strengths: List<String>.from(map['strengths'] ?? []),
      eras: List<String>.from(map['eras'] ?? []),
      diets: List<String>.from(map['diets'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      ingredientUnits: List<String>.from(map['ingredient_units'] ?? []),
      difficulties: List<String>.from(map['difficulties'] ?? []),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [origins, seasons, strengths, eras, diets, colors, ingredientUnits, difficulties];

}