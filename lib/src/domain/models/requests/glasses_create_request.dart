import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

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