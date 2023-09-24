
import 'dart:developer';

import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/requests/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'drink_details_state.dart';

class DrinkDetailsCubit extends BaseCubit<DrinkDetailsState, Drink> {
  final ApiRepository _apiRepository;

  DrinkDetailsCubit(this._apiRepository) : super(const DrinkDetailsLoading(), Drink.empty());

  Future<void> setDrink(Drink drink) async {
    data = drink;
    emit(DrinkDetailsSuccess(drink: data));
  }


  Future<void> deleteDrink(String id) async {
    if (isBusy) return;
    /// TODO : Implement delete
    /*
    try {
      await _apiRepository.deleteDrink(
          request: DrinkDeleteRequest(id: id,)
      );
      emit(DrinkDeleteSuccess(drink: state.drink,));
      appRouter.pop();
    } catch (e) {
      emit(DrinkDeleteFailed(drink: state.drink));
    }*/
  }

  Future<Drink> patchDrink(String id, Map<String, dynamic> data) async {
    /// TODO : Implement patch
    /*
    final response = await _apiRepository.patchDrink(
        request: DrinkPatchRequest(
            id: id,
            body: data
        ));
    log(response.toString());
    log(response.data.toString());
    log(response.data!.drink.toString());

    emit(DrinkPatchSuccess(drink: response.data!.drink,));
    appRouter.pop();
    return response.data!.drink;
    */
    return Drink.empty();
  }

}