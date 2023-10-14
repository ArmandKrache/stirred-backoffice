import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:flutter/material.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class PreferencesAttributeWidget extends StatelessWidget {
  final Preferences preferences;

  const PreferencesAttributeWidget({
    super.key,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 128, maxWidth: 448),
            child:  CustomGenericAttributeWidget(
              title: "Preferences",
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
        ),
      ],
    );
  }
}