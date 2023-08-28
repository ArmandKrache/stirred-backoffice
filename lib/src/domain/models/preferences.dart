import 'package:equatable/equatable.dart';

class Preferences extends Equatable {
  final String? id;
  final List<String>? favorites;
  final List<String>? likes;
  final List<String>? dislikes;
  final List<String>? allergies;
  final List<String>? diets;

  const Preferences({
    this.id,
    this.favorites,
    this.likes,
    this.dislikes,
    this.allergies,
    this.diets,
  });

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      id: map['id'] ?? "",
      favorites: map['favorites'] ?? [],
      likes : map['likes'] ?? [],
      dislikes: map['dislikes'] ?? [],
      allergies: map['allergies'] ?? [],
      diets: map['diets'] ?? [],
    );
  }

  factory Preferences.empty() {
    return const Preferences(
      id: "-1",
      favorites: [],
      likes : [],
      dislikes: [],
      allergies: [],
      diets: [],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, favorites, likes, dislikes, allergies, diets];

}