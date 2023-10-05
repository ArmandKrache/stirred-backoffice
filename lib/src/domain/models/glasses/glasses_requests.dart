import 'package:dio/dio.dart';

class GlassesListRequest {
  GlassesListRequest();
}

class GlassesCreateRequest {
  final String? name;
  final String? description;
  final MultipartFile? picture;

  GlassesCreateRequest({
    this.name,
    this.description,
    this.picture
  });
}

class GlassPatchRequest {
  final String id;
  final Map<String, dynamic> body;

  GlassPatchRequest({required this.id, required this.body});
}

class GlassesSearchRequest {
  final String query;

  GlassesSearchRequest({this.query = ""});
}

class GlassDeleteRequest {
  final String? id;

  GlassDeleteRequest({this.id});
}