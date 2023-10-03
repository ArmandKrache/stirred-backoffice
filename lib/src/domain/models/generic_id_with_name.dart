import 'package:equatable/equatable.dart';

class GenericPreviewModel extends Equatable {
  final String? id;
  final String? name;
  final String? picture;

  const GenericPreviewModel({
    this.id,
    this.name,
    this.picture,
  });


  factory GenericPreviewModel.fromMap(Map<String, dynamic> map) {
    return GenericPreviewModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      picture: map['picture'] ?? "",
    );
  }

  factory GenericPreviewModel.empty() {
    return const GenericPreviewModel(id: "", name: "", picture: "");
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}