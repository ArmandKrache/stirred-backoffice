import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:flutter/material.dart';

class CategoriesAttributeWidget extends StatelessWidget {
  final Categories categories;

  const CategoriesAttributeWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 128, maxWidth: 448),
            child: CustomGenericAttributeWidget(
              title: "Categories",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Keywords : ${categories.keywords}"),
                  Text("Origins : ${categories.origins}"),
                  Text("Eras : ${categories.eras}"),
                  Text("Colors : ${categories.colors}"),
                  Text("Seasons : ${categories.seasons}"),
                  Text("Diets : ${categories.diets}"),
                  Text("Strengths : ${categories.strengths}"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}