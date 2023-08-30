import 'dart:developer';

import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class GlassesCreateResponse extends Equatable {
  final List<Glass> glasses;


  const GlassesCreateResponse({
    required this.glasses,
  });


  factory GlassesCreateResponse.fromMap(Map<String, dynamic> map) {
    log("Glass Create REponse Map : $map");
    return GlassesCreateResponse(
      glasses: List<Glass>.from((map['data'] ?? []).map<dynamic>((element) {
        return Glass(
          id: element["id"] ?? "",
          name: element["attributes"]["name"] ?? "",
          description: element["attributes"]["description"] ?? "",
          picture: element["attributes"]["picture"] ?? "",
        );
      })),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [glasses];

}