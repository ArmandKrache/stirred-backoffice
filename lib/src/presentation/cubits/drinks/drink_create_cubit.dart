import 'dart:developer';
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

    /// TODO: Handle creation flow
    /*final String? name = data["name"];
    final String? description = data["description"];
    final MultipartFile? picture = data["picture"];

    log("$name | $description | $picture");

    if (picture == null || name == "" || description == "") {
      emit(const DrinkCreateFailed());
      return ;
    }

    await run(() async {
      final response = await _apiRepository.createDrink(
          request: DrinksCreateRequest(
            name: name,
            description: description,
            picture: picture,
          ));
      emit(const DrinkCreateSuccess());
    });*/
  }

  void reset() {
    emit(const DrinkCreateLoading());
  }
}