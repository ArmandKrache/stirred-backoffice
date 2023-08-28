import 'dart:developer';

import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class ProfileListResponse extends Equatable {
  final List<Profile> profiles;


  const ProfileListResponse({
    required this.profiles,
  });


  factory ProfileListResponse.fromMap(Map<String, dynamic> map) {
    return ProfileListResponse(
      profiles: List<Profile>.from((map['data'] ?? []).map<dynamic>((element) {
        return Profile(
          id: element["id"] ?? "",
          email: element["attributes"]["user"]["email"] ?? "",
          name: element["attributes"]["name"] ?? "",
          description: element["attributes"]["description"] ?? "",
          picture: element["attributes"]["picture"] ?? "",
          dateOfBirth: element["attributes"]["date_of_birth"] ?? "",
          preferences: Preferences.fromMap(element["attributes"]["preferences"] ?? {}), /// TODO: Replace with correct format
        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [profiles];

}