import 'package:equatable/equatable.dart';

class Categories extends Equatable {
  final List<String> origins;
  final List<String> strengths;
  final List<String> eras;
  final List<String> diets;
  final List<String> seasons;
  final List<String> colors;
  final List<String> keywords;

  const Categories({
    required this.origins,
    required this.strengths,
    required this.eras,
    required this.diets,
    required this.seasons,
    required this.colors,
    required this.keywords,
  });

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      origins: List<String>.from((map['origin'] ?? [])),
      strengths: List<String>.from((map['strengths'] ?? [])),
      eras: List<String>.from((map['eras'] ?? [])),
      diets: List<String>.from((map['diets'] ?? [])),
      seasons: List<String>.from((map['seasons'] ?? [])),
      colors: List<String>.from((map['colors'] ?? [])),
      keywords: List<String>.from((map['keywords'] ?? [])),
    );
  }

  factory Categories.empty() {
    return const Categories(
      origins: [],
      strengths : [],
      eras: [],
      diets: [],
      seasons: [],
      colors: [],
      keywords: [],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [origins, strengths, eras, diets, seasons, colors, keywords];

}