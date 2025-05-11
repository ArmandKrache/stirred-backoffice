import 'package:stirred_common_domain/stirred_common_domain.dart';

String formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

String formatDateTimeDeltaFromNow(DateTime dateTime) {
  final now = DateTime.now();
  final timeDifference = now.difference(dateTime);

  if (timeDifference.inDays < 4) {
    if (timeDifference.inHours < 24) {
      final hours = timeDifference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = timeDifference.inDays;
      if (days == 1) {
        return "Yesterday";
      }
      return '$days days ago';
    }
  } else {
    return formatDateTime(dateTime);
  }
}

String formatDouble(double value) {
  if (value == value.toInt()) {
    // It's a whole number, so format without decimal
    return value.toInt().toString();
  } else {
    // It has a decimal part, so format with one decimal place
    return value.toStringAsFixed(1);
  }
}

String formatRecipeIngredient(RecipeIngredient ingredient) {
  switch (ingredient.unit) {
    case "fill":
      return "Fill with ${ingredient.ingredientName}";
    case "none":
      return ingredient.ingredientName;
    case "liking":
      return "Add ${ingredient.ingredientName} to your liking";
    case "unit":
      return "${formatDouble(ingredient.quantity)} ${ingredient.ingredientName}";
    default:
      return "${formatDouble(ingredient.quantity)} ${ingredient.unit} of ${ingredient.ingredientName}";
  }
}

String formatDifficulty(String difficulty) {
  switch (difficulty) {
    case "beginner":
      return "Beginner";
    case "intermediate":
      return "Intermediate";
    case "advanced":
      return "Advanced";
    case "expert":
      return "Expert";
    case "master":
    return "Master";
    default:
      return "";
  }
}