import 'dart:io';

import 'package:dio/dio.dart';

class GlassesCreateRequest {
  final String? name;
  final String? description;
  final File? picture;

  GlassesCreateRequest({
    this.name,
    this.description,
    this.picture
  });
}