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
    log(map.toString());
    return GlassPatchResponse(
        glass: Glass(
          id: data["id"] ?? "",
          name: data["attributes"]["name"] ?? "",
          description: data["attributes"]["description"] ?? "",
          picture: data["attributes"]["picture"] ?? "",
        )
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [glass];

}