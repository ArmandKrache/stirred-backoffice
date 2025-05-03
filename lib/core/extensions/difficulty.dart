import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

extension DifficultyExtension on Difficulty {
  Color color(StirColorTheme colors) {
    switch (this) {
      case Difficulty.beginner:
        return colors.common;
      case Difficulty.intermediate:
        return colors.uncommon;
      case Difficulty.advanced:
        return colors.rare;
      case Difficulty.expert:
        return colors.epic;
      case Difficulty.master:
        return colors.legendary;
    }
  }

  String get label {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
      case Difficulty.expert:
        return 'Expert';
      case Difficulty.master:
        return 'Master';
    }
  }
}