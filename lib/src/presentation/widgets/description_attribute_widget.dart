import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:flutter/material.dart';

class DescriptionAttributeWidget extends StatelessWidget {
  final String text;
  final String title;

  const DescriptionAttributeWidget({
    super.key,
    required this.text,
    this.title = "Description",
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 128, maxWidth: 512),
          child: CustomGenericAttributeWidget(
            title : title,
            child: Text(
                text,
                style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}