import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/material.dart';

class DescriptionAttributeWidget extends StatelessWidget {
  final String text;

  const DescriptionAttributeWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 128, maxWidth: 512),
        child: Text(
          "Description : \n$text",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}