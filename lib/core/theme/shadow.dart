import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shadow.freezed.dart';

@freezed
class StirShadowTheme with _$StirShadowTheme {
  const factory StirShadowTheme({
    required List<BoxShadow> cardDropShadow,
    required List<BoxShadow> noShadow,
  }) = _StirShadowTheme;

  factory StirShadowTheme.fromThemeIndex(
    int themeIndex
  ) {
    switch (themeIndex) {
      case 1:
        return StirShadowTheme.darkTheme();
      case 0:
      default:
        return StirShadowTheme.lightTheme();
    }
  }

  factory StirShadowTheme.lightTheme() {
    return StirShadowTheme(
      cardDropShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 1,
          blurStyle: BlurStyle.inner,
        ),
      ],
      noShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 1,
          blurStyle: BlurStyle.inner,
        ),
      ],
    );
  }

  factory StirShadowTheme.darkTheme() {
    return StirShadowTheme(
      cardDropShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 1,
          blurStyle: BlurStyle.inner,
        ),
      ],
      noShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 1,
          blurStyle: BlurStyle.inner,
        ),
      ],
    );
  }
}
