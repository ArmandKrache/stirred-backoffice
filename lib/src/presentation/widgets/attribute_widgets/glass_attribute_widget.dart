/*
CustomGenericAttributeWidget(
                        title: "Glass",
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(drink.glass.picture, height: 96,),
                            const SizedBox(width: 8,),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320, minHeight: 96),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomClickableText(
                                    text: Text(drink.glass.name,
                                      style: const TextStyle(color: Colors.deepPurple,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onTap: () {
                                      /// TODO: Go to Glass Details Page
                                    },
                                  ),
                                  Text(drink.glass.description + " iazbefba zieubf iazeb fuabzei fbizue fba izeubf iuabiu baiz be fauz ebfa bzfi uabz eiufab zu"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
 */

import 'package:cocktail_app/src/domain/models/glasses/glass.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_clickable_text.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class GlassAttributeWidget extends StatelessWidget {
  final Glass glass;

  const GlassAttributeWidget({
    super.key,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGenericAttributeWidget(
      title: "Glass",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(glass.picture, height: 96,),
          const SizedBox(width: 8,),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, minHeight: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomClickableText(
                  text: Text(glass.name,
                    style: const TextStyle(color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onTap: () {
                    /// TODO: Go to Glass Details Page
                  },
                ),
                Text(glass.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}