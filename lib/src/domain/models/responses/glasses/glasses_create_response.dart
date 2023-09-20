
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:equatable/equatable.dart';

class GlassesCreateResponse extends Equatable {
  final Glass glass;

  const GlassesCreateResponse({
    required this.glass,
  });


  factory GlassesCreateResponse.fromMap(Map<String, dynamic> map) {
    return GlassesCreateResponse(
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