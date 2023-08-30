import 'package:equatable/equatable.dart';

class Glass extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? picture;

  const Glass({
    this.id,
    this.name,
    this.description,
    this.picture,
  });

  factory Glass.fromMap(Map<String, dynamic> map) {
    return Glass(
      id: map['id'] ?? "",
      name : map['name'] ?? "",
      description: map['description'] ?? "",
      picture: map['picture'] ?? "",
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, description];

}