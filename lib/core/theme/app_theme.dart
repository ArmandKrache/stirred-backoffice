import 'package:flutter/material.dart';

/// An enum representing a selected theme in the app.
enum AppTheme {
  light,
  dark,
  system;

  /// Creates an [AppTheme] from a `string`.
  factory AppTheme.fromString(String string) {
    return AppTheme.values.firstWhere((e) => e.name == string);
  }
}

extension AppThemeExtensions on AppTheme {
  /// Gets the `themeIndex` associated with an `AppTheme`.
  int get themeIndex {
    switch (this) {
      case AppTheme.dark:
        return 1;
      case AppTheme.system:
        final theme = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return theme == Brightness.light ? 0 : 1;
      case AppTheme.light:
        return 0;
    }
  }
}
