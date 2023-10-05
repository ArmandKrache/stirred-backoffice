import 'package:dio/dio.dart';

class DrinksListRequest {
  DrinksListRequest();
}

class DrinkCreateRequest {
  final String name;
  final String description;
  final MultipartFile picture;
  final String recipe;
  final String glass;
  final String author;
  final Map<String, List<String>> categories;

  DrinkCreateRequest({
    required this.name,
    required this.description,
    required this.picture,
    required this.recipe,
    required this.glass,
    required this.author,
    required this.categories,
  });
}

class DrinkPatchRequest {
  final String id;
  final String? name;
  final String? description;
  final MultipartFile? picture;
  final String? recipe;
  final String? glass;
  final String? author;
  final Map<String, List<String>>? categories;

  DrinkPatchRequest({
    required this.id,
    this.name,
    this.description,
    this.picture,
    this.recipe,
    this.glass,
    this.author,
    this.categories,
  });
}

class DrinkDeleteRequest {
  final String id;

  DrinkDeleteRequest({required this.id});
}