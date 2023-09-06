import 'dart:developer';

import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:equatable/equatable.dart';

class GlassDeleteResponse extends Equatable {
  final bool success;

  const GlassDeleteResponse({
    required this.success,
  });


  factory GlassDeleteResponse.fromMap(Map<String, dynamic> map) {
    log("Delete Response : $map");
    return const GlassDeleteResponse(
        success: true
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success];

}