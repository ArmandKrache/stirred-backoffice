import 'dart:developer';
import 'package:cocktail_app/src/domain/models/glasses/glasses_requests.dart';
import 'package:cocktail_app/src/domain/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'glass_create_state.dart';



class GlassCreateCubit extends BaseCubit<GlassCreateState, dynamic> {

  final ApiRepository _apiRepository;

  GlassCreateCubit(this._apiRepository) : super(const GlassCreateLoading(), null);

  Future<void> setSelectedImage(http.MultipartFile image) async {
    await run(() async {
      emit(const GlassCreateImageSelectLoading());
      emit(GlassCreateImageSelectSuccess(selectedImage: image));
    });
  }

  Future<void> createGlass(Map<String, dynamic> data) async {
    final String? name = data["name"];
    final String? description = data["description"];
    final MultipartFile? picture = data["picture"];

    log("$name | $description | $picture");

    if (picture == null || name == "" || description == "") {
      emit(const GlassCreateFailed());
      return ;
    }

    await run(() async {
      final response = await _apiRepository.createGlass(
          request: GlassesCreateRequest(
            name: name,
            description: description,
            picture: picture,
          ));
      emit(const GlassCreateSuccess());
    });
  }

  void reset() {
    emit(const GlassCreateLoading());
  }
}