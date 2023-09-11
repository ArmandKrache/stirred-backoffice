import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/material.dart';

class PreferencesAttributeWidget extends StatelessWidget {
  final Preferences preferences;

  const PreferencesAttributeWidget({
    super.key,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGenericAttributeWidget(
      title: "Preferences",
      child: Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 128, maxWidth: 448),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Favorites : ${preferences.favorites}"),
              Text("Likes : ${preferences.likes}"),
              Text("Dislikes : ${preferences.dislikes}"),
              Text("Allergies : ${preferences.allergies}"),
              Text("Diets : ${preferences.diets}"),
            ],
          ),
        ),
      ),
    );
  }
}