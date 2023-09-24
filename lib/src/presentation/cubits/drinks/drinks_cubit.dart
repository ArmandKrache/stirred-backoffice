import 'dart:developer';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/domain/models/requests/drinks/drinks_requests.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/presentation/cubits/base/base_cubit.dart';
import 'package:cocktail_app/src/utils/resources/data_state.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'drinks_state.dart';

class DrinksCubit extends BaseCubit<DrinksState, List<Drink>> {
  final ApiRepository _apiRepository;

  DrinksCubit(this._apiRepository) : super(const DrinksLoading(), []);

  Future<void> fetchList({required DrinksListRequest request}) async {
    if (isBusy) return;

     await run(() async {
        emit(const DrinksLoading());
        final response = await _apiRepository.getDrinksList(request: request);

        if (response is DataSuccess) {
          final drinks = response.data!.drinks;
          final noMoreData = drinks.isEmpty;

          data.clear();
          data.addAll(drinks);

          emit(DrinksSuccess(drinks: data, noMoreData: noMoreData));
        } else if (response is DataFailed) {
          log(response.exception.toString());
        }
      });
  }

}