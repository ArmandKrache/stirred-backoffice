
import 'dart:developer';

import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drink_details_state.dart';

class DrinkDetailsCubit extends BaseCubit<DrinkDetailsState, Drink> {
  final ApiRepository _apiRepository;

  DrinkDetailsCubit(this._apiRepository) : super(const DrinkDetailsLoading(), Drink.empty());

  Future<void> retrieveDrink({required String id}) async {
    if (isBusy) return;

    await run(() async {
      emit(const DrinkDetailsLoading());
      late DataState<Drink> response;
      response = await _apiRepository.retrieveDrink(request: DrinkRetrieveRequest(id: id));

      if (response is DataSuccess) {
        final drink = response.data!;

        data = drink;

        emit(DrinkDetailsSuccess(drink: data));
      } else if (response is DataFailed) {
        log(response.exception.toString());
        emit(DrinkDetailsFailed(exception: response.exception));
      }
    });
  }


  Future<void> deleteDrink(String id) async {
    if (isBusy) return;
    try {
      await _apiRepository.deleteDrink(
          request: DrinkDeleteRequest(id: id,)
      );
      emit(DrinkDeleteSuccess(drink: state.drink,));
      appRouter.pop();
    } catch (e) {
      emit(DrinkDeleteFailed(drink: state.drink));
    }
  }

  Future<Drink?> patchDrink(String id, Map<String, dynamic> data) async {
    final String? name = data["name"];
    final String? description = data["description"];
    final String? recipe = data["recipe"];
    final String? author = data["author"];
    final String? glass = data["glass"];
    final MultipartFile? picture = data["picture"];
    final Map<String, List<String>> categories = data["categories"];

    final response = await _apiRepository.patchDrink(
        request: DrinkPatchRequest(
          id: id,
          name: name,
          description: description,
          recipe: recipe,
          author: author,
          glass: glass,
          picture: picture,
          categories: categories
        ));
    log(response.toString());
    log(response.data.toString());
    log(response.data!.drink.toString());

    emit(DrinkPatchSuccess(drink: response.data!.drink,));
    appRouter.pop();
    return response.data!.drink;
  }

}