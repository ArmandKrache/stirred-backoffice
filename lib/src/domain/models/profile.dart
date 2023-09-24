import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String name;
  final String description;
  final String picture;
  final String dateOfBirth;
  final Preferences preferences;

  const Profile({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.picture,
    required this.dateOfBirth,
    required this.preferences,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] ?? "",
      email: map['email'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
      dateOfBirth: map['date_of_birth'] ?? "",
      preferences: map['preferences'] ?? Preferences.empty(),
    );
  }

  factory Profile.empty() {
    return Profile(
      id: "",
      email: "",
      name : "",
      description: "",
      picture: "",
      dateOfBirth: "",
      preferences: Preferences.empty(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, email];

}