import 'package:cocktail_app/src/domain/models/generic_data_model.dart';
import 'package:cocktail_app/src/domain/models/generic_preview_data_model.dart';
import 'package:cocktail_app/src/presentation/widgets/edit_field_widgets/generic_object_picker_modal.dart';
import 'package:equatable/equatable.dart';

class Glass extends Equatable implements GenericDataModel {
  final String id;
  final String name;
  final String description;
  final String picture;

  const Glass({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
  });

  factory Glass.fromMap(Map<String, dynamic> map) {
    return Glass(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
    );
  }

  factory Glass.empty() {
    return const Glass(
      id: "",
      name : "",
      description: "",
      picture: "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}