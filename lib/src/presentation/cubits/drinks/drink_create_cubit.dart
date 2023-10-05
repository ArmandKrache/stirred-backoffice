import 'dart:developer';
import 'package:cocktail_app/src/domain/models/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'drink_create_state.dart';



class DrinkCreateCubit extends BaseCubit<DrinkCreateState, dynamic> {

  final ApiRepository _apiRepository;

  DrinkCreateCubit(this._apiRepository) : super(const DrinkCreateLoading(), null);

  Future<void> setSelectedImage(http.MultipartFile image) async {
    await run(() async {
      emit(const DrinkCreateImageSelectLoading());
      emit(DrinkCreateImageSelectSuccess(selectedImage: image));
    });
  }

  Future<void> createDrink(Map<String, dynamic> data) async {
    final String? name = data["name"];
    final String? description = data["description"];
    final String? recipe = data["recipe"];
    final String? author = data["author"];
    final String? glass = data["glass"];
    final MultipartFile? picture = data["picture"];
    final Map<String, List<String>> categories = data["categories"];

    if (picture == null || name == null ||
        description == null || recipe == null ||
        author == null || glass == null) {
      emit(const DrinkCreateFailed());
      return ;
    }

    await run(() async {
      final response = await _apiRepository.createDrink(
          request: DrinkCreateRequest(
            name: name,
            description: description,
            picture: picture,
            recipe: recipe,
            author: author,
            glass: glass,
            categories: categories
          ));
      emit(const DrinkCreateSuccess());
    });
  }

  void reset() {
    emit(const DrinkCreateLoading());
  }
}