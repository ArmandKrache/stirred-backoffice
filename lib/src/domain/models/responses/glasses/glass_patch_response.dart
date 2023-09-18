import 'dart:developer';

import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class GlassPatchResponse extends Equatable {
  final Glass glass;

  const GlassPatchResponse({
    required this.glass,
  });


  factory GlassPatchResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return GlassPatchResponse(
        glass: Glass(
          id: map["id"] ?? "",
          name: map["name"] ?? "",
          description: map["description"] ?? "",
          picture: map["picture"] ?? "",
        )
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [glass];

}