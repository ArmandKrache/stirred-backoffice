import 'dart:developer';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
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

    /// TODO: Handle creation flow
    /*final String? name = data["name"];
    final String? description = data["description"];
    final MultipartFile? picture = data["picture"];

    log("$name | $description | $picture");

    if (picture == null || name == "" || description == "") {
      emit(const RecipeCreateFailed());
      return ;
    }

    await run(() async {
      final response = await _apiRepository.createRecipe(
          request: RecipesCreateRequest(
            name: name,
            description: description,
            picture: picture,
          ));
      emit(const RecipeCreateSuccess());
    });*/
  }

  void reset() {
    emit(const RecipeCreateLoading());
  }
}