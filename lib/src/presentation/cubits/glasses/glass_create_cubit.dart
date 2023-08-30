import 'dart:developer';
import 'dart:io';
import 'package:cocktail_app/src/domain/models/requests/glasses_create_request.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'glass_create_state.dart';


class GlassCreateCubit extends BaseCubit<GlassCreateState, dynamic> {

  final ApiRepository _apiRepository;

  GlassCreateCubit(this._apiRepository) : super(const GlassCreateLoading(), null);

  Future<void> setSelectedImage(File? image) async {
    await run(() async {
      emit(GlassCreateImageSelectSuccess(selectedImage: image));
    });
  }

  Future<void> createGlass(Map<String, dynamic> data) async {
    final String? name = data["name"];
    final String? description = data["description"];
    final File? picture = data["picture"];

    log(data.toString());

    if (picture == null || name == "" || description == "") {
      emit(GlassCreateFailed(selectedImage: picture));
      return ;
    }

    await run(() async {
      final response = await _apiRepository.createGlass(
          request: GlassesCreateRequest(
            name: name,
            description: description,
            picture: picture,
          ));
      log("Cubit response : ${response.data.toString()}");
      emit(const GlassCreateSuccess());
    });
  }

  void reset() {
    emit(const GlassCreateLoading());
  }
}