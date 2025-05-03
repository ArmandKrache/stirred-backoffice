import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_backoffice/core/theme/shadow.dart';
import 'package:stirred_backoffice/presentation/providers/choices_notifier.dart';
import 'package:stirred_backoffice/presentation/providers/current_theme.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

extension WidgetRefExtensions on WidgetRef {
  StirColorTheme get colors => watch(colorsProvider);
  
  StirShadowTheme get shadows => watch(shadowProvider);

  AllChoicesResponse? get allChoices => watch(choicesNotifierProvider).whenOrNull(
        data: (data) => data,
      );

  /// Get the current locale of the app. If the locale notifier is in error or
  /// loading, the default locale of the device is used instead.
  ///
  /// `listen` defaults to `true` to watch the provider, and should
  /// only be used in Widget build() methods. If you need to access this provider
  /// elsewhere, use `listen = false` to `read` the provider instead.
  
  /* Locale getCurrentLocale({bool listen = false}) {
    final reader = listen ? watch : read;

    return reader(currentLocaleNotifierProvider).maybeWhen(
      data: (locale) => locale,
      orElse: () => WidgetsBinding.instance.platformDispatcher.locale,
    );
  } */
}
