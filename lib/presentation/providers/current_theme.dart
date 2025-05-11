import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stirred_backoffice/core/theme/app_theme.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_backoffice/core/theme/shadow.dart';

part 'current_theme.g.dart';

// A notifier that holds the current theme selected by the user.
@riverpod
class CurrentThemeNotifier extends _$CurrentThemeNotifier {
  /// At the app launch, the notifier loads the theme saved in the cache
  /// (if any) and provides it to the app. If no theme is found, the default
  /// theme used is [AppTheme.system] (i.e. the theme selected on the physical
  /// device).
  @override
  Future<AppTheme> build() async {
    // Indicates that the state should be preserved even if the provider is not
    // listened anymore.
    ref.keepAlive();

    // TODO: Get the current theme from the current data
    final currentTheme = AppTheme.light; 

    return currentTheme;
  }

  /// Allows to set the current theme of the app and saves it in the cache.
  Future<void> setCurrentTheme(AppTheme theme) async {
    // await ref.read(currentUserRepositoryProvider).saveCurrentTheme(theme);

    state = AsyncValue.data(theme);
  }
}

/// The provider providing the color theme on the app, depending on
/// [CurrentThemeNotifier].
final colorsProvider = Provider.autoDispose<StirColorTheme>((ref) {
  final themeNotifier = ref.watch(currentThemeNotifierProvider);

  final theme = themeNotifier.maybeWhen(
    data: (data) => data.themeIndex,
    orElse: () => 0,
  );

  return StirColorTheme.fromThemeIndex(theme);
});

/// The provider providing the shadow theme on the app, depending on
/// [CurrentThemeNotifier].
final shadowProvider = Provider.autoDispose<StirShadowTheme>((ref) {
  final themeNotifier = ref.watch(currentThemeNotifierProvider);

  final themeIndex = themeNotifier.maybeWhen(
    data: (data) => data.themeIndex,
    orElse: () => 0,
  );

  return StirShadowTheme.fromThemeIndex(themeIndex);
});
