import 'dart:developer';
import 'package:cocktail_app/src/domain/models/recipes/recipes_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'recipe_create_state.dart';



class RecipeCreateCubit extends BaseCubit<RecipeCreateState, dynamic> {

  final ApiRepository _apiRepository;

  RecipeCreateCubit(this._apiRepository) : super(const RecipeCreateLoading(), null);

  Future<void> setSelectedImage(http.MultipartFile image) async {
    await run(() async {
      emit(const RecipeCreateImageSelectLoading());
      emit(RecipeCreateImageSelectSuccess(selectedImage: image));
    });
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {

    await run(() async {
      final response = await _apiRepository.createRecipe(
          request: RecipeCreateRequest(
            name: data["name"],
            description: data["description"],
            instructions: data["instructions"],
            difficulty: data["difficulty"],
            preparationTime: data["preparation_time"],
            ingredients: data["ingredients"],
          ));
      emit(const RecipeCreateSuccess());
    });
  }

  void reset() {
    emit(const RecipeCreateLoading());
  }
}