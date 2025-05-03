import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

part 'choices_notifier.g.dart';

@riverpod
class ChoicesNotifier extends _$ChoicesNotifier {
  @override
  Future<AllChoicesResponse> build() async {
    final result = await ref.read(drinksRepositoryProvider).getAllChoices();
    return result.when(
      success: (response) => response,
      failure: (error) => throw error,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final result = await ref.read(drinksRepositoryProvider).getAllChoices();
      state = result.when(
        success: (response) => AsyncData(response),
        failure: (error) => AsyncError(error, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
} 