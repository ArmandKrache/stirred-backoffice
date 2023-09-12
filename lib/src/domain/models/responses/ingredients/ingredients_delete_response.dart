import 'package:equatable/equatable.dart';

class IngredientDeleteResponse extends Equatable {
  final bool success;

  const IngredientDeleteResponse({
    required this.success,
  });


  factory IngredientDeleteResponse.fromMap(Map<String, dynamic> map) {
    return const IngredientDeleteResponse(
        success: true
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [success];

}