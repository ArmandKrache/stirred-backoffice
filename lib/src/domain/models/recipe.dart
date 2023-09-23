import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String description;
  final int preparationTime;
  final String difficulty;
  final String instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.instructions,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      preparationTime: map['preparation_time'] ?? 0,
      difficulty: map['difficulty'] ?? "",
      instructions: map['instructions'] ?? "",
    );
  }

  factory Recipe.empty() {
    return const Recipe(
      id: "",
      name : "",
      description: "",
      preparationTime: 0,
      difficulty: "",
      instructions: "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}