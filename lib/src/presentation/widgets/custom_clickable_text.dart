
import 'package:flutter/material.dart';

class CustomClickableText extends StatelessWidget {
  final Text text;
  final Function() onTap;

  const CustomClickableText({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: text,
      ),
    );
  }
}