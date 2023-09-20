
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:equatable/equatable.dart';

class GlassPatchResponse extends Equatable {
  final Glass glass;

  const GlassPatchResponse({
    required this.glass,
  });


  factory GlassPatchResponse.fromMap(Map<String, dynamic> map) {
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