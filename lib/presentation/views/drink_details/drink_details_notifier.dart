import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'drink_details_notifier.freezed.dart';
part 'drink_details_notifier.g.dart';

@riverpod
class DrinkDetailsNotifier extends _$DrinkDetailsNotifier {
  @override
  Future<DrinkDetailsNotifierState> build(String drinkId) async {
    final controller = await _load(drinkId);

    state = AsyncData(controller);

    return controller;
  }

  Future<DrinkDetailsNotifierState> _load(String drinkId) async {
    final result = await ref.read(drinksRepositoryProvider).retrieveDrink(drinkId);

    logger.d('result: $result');

    final drink = result.when(
      success: (response) => response,
      failure: (_) => null,
    );

    return DrinkDetailsNotifierState(
      drink: drink,
    );
  }

  Future<void> refreshDrink() async {
    state = const AsyncLoading();
    try {
      final controller = await _load(drinkId);
      state = AsyncData(controller);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

@freezed
class DrinkDetailsNotifierState with _$DrinkDetailsNotifierState {
  const factory DrinkDetailsNotifierState({
    Drink? drink,
  }) = _DrinkDetailsNotifierStateData;
} 