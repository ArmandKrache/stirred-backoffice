import 'package:cocktail_app/src/domain/models/generic_data_model.dart';

class GenericPreviewDataModel implements GenericDataModel {
  final String? id;
  final String? name;
  final String? description;
  final String? picture;

  const GenericPreviewDataModel({
    this.id,
    this.name,
    this.description,
    this.picture,
  });


  factory GenericPreviewDataModel.fromMap(Map<String, dynamic> map) {
    return GenericPreviewDataModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
    );
  }

  factory GenericPreviewDataModel.empty() {
    return const GenericPreviewDataModel(
        id: "",
        name: "",
        description: "",
        picture: ""
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}