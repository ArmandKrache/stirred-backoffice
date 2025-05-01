import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color.freezed.dart';

@freezed
class StirColorTheme with _$StirColorTheme {
  const factory StirColorTheme({
    required Brightness brightness,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariantLowEmphasis,
    required Gradient primaryGradient,
    required Color onPrimaryGradient,
    required Color primary,
    required Color onPrimary,
    required Color primaryVariant,
    required Color onPrimaryVariant,
    required Color secondary,
    required Color onSecondary,
    required Color secondaryVariant,
    required Color onSecondaryVariant,
    required Color tertiary,
    required Color onTertiary,
    required Color disabled,
    required Color onDisabled,
    required Color surfaceContainer,
    required Color error,
    required Color onError,
    required Color success,
    required Color onSuccess,
    required Color warning,
    required Color onWarning,
    required Color info,
    required Color onInfo,
    required Color common,
    required Color uncommon,
    required Color rare,
    required Color epic,
    required Color legendary,
  }) = _StirColorTheme;

  /// Returns the correct `FastColorTheme` from a `themeIndex`.
  factory StirColorTheme.fromThemeIndex(int themeIndex) {
    switch (themeIndex) {
      case 1:
        return _darkTheme;
      case 0:
      default:
        return _lightTheme;
    }
  }

  /// The light theme of the application.
  static const _lightTheme = StirColorTheme(
    brightness: Brightness.light,
    surface: Color(0xFFF9F9F9),
    surfaceContainer: Color(0xffe9e9e9),
    onSurface: Color(0xFF000000),
    onSurfaceVariantLowEmphasis: Color(0xFF6C777F),
    primaryGradient: LinearGradient(
      colors: [
        Color(0xffE25D5D),
        Color(0xffE98583),
        Color(0xffF6DA80),
        Color(0xffF3C494),
        Color(0xffEFADA8),
      ],
    ),
    onPrimaryGradient: Color(0xFFFFFFFF),
    primary: Color(0xffE25D5D),
    onPrimary: Color(0xffF6F6F6),
    primaryVariant: Color(0xffE98583),
    onPrimaryVariant: Color(0xff222222),
    secondary: Color(0xffF6DA80),
    onSecondary: Color(0xff222222),
    secondaryVariant: Color(0xffF3C494),
    onSecondaryVariant: Color(0xff222222),
    tertiary: Color(0xffEFADA8),
    onTertiary: Color(0xff222222),
    disabled: Color(0xFFC2B8B8),
    onDisabled: Color(0xFFFFFFFF),
    error: Color(0xffE25D5D),
    onError: Color(0xffF6F6F6),
    success: Color(0xff319236),
    onSuccess: Color(0xffF6F6F6),
    warning: Color(0xffF3C494),
    onWarning: Color(0xff222222),
    info: Color(0xff307FE2),
    onInfo: Color(0xffF6F6F6),
    common: Color(0xff319236),
    uncommon: Color(0xff4c51f7),
    rare: Color(0xff9d4dbb),
    epic: Color(0xfff3af19),
    legendary: Color(0xffff033e),
  );

  /// The dark theme of the application.
  static const _darkTheme = StirColorTheme(
    brightness: Brightness.dark,
    surface: Color(0xFF272727),
    surfaceContainer: Color(0xff272727),
    onSurface: Color(0xFFF0F0F0),
    onSurfaceVariantLowEmphasis: Color(0xFF6C777F),
    primaryGradient: LinearGradient(
      colors: [
        Color(0xffE25D5D),
        Color(0xffE98583),
        Color(0xffF6DA80),
        Color(0xffF3C494),
        Color(0xffEFADA8),
      ],
    ),
    onPrimaryGradient: Color(0xFFFFFFFF),
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    primaryVariant: Color(0xFF307FE2),
    onPrimaryVariant: Color(0xFFFFFFFF),
    secondary: Color(0xFF373BC1),
    onSecondary: Color(0xFFFFFFFF),
    secondaryVariant: Color(0xFF307FE2),
    onSecondaryVariant: Color(0xFFFFFFFF),
    tertiary: Color(0xFF00DDC0),
    onTertiary: Color(0xFFFFFFFF),
    disabled: Color(0xFFC2B8B8),
    onDisabled: Color(0xFFFFFFFF),

    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    success: Color(0xFF24A148),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFF1C21B),
    onWarning: Color(0xFFFFFFFF),
    info: Color(0xFF307FE2),
    onInfo: Color(0xFFFFFFFF),
    common: Color(0xff319236),
    uncommon: Color(0xff4c51f7),
    rare: Color(0xff9d4dbb),
    epic: Color(0xfff3af19),
    legendary: Color(0xffff033e),
  );
}

extension FastColorThemeExtensions on StirColorTheme {
  Color get transparent => const Color(0x00000000);

  ColorScheme get toColorScheme {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
      outline: disabled,
    );
  }
}
