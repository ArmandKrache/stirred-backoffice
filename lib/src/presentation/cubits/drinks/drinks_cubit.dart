import 'dart:developer';
import 'package:stirred_backoffice/src/presentation/cubits/base/base_cubit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drinks_state.dart';

class DrinksCubit extends BaseCubit<DrinksState, List<Drink>> {
  final ApiRepository _apiRepository;

  DrinksCubit(this._apiRepository) : super(const DrinksLoading(), []);

  Future<void> fetchList({String query = ""}) async {
    if (isBusy) return;

     await run(() async {
        emit(DrinksLoading(drinks: data));
        late DataState<DrinksListResponse> response;
        if (query == "") {
          response = await _apiRepository.getDrinksList(request: DrinksListRequest());
        } else {
          response = await _apiRepository.searchDrinks(request: DrinksSearchRequest(query: query));
        }

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