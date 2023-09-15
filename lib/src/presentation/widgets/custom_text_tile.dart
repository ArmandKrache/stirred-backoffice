import 'dart:developer';

import 'package:cocktail_app/src/domain/models/categories.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextTileWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Icon icon;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Function? onTap;

  const CustomTextTileWidget({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(),
    this.icon = const Icon(Icons.close, size: 16,),
    this.backgroundColor = Colors.blueAccent,
    this.padding = const EdgeInsets.all(4),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
            style: textStyle,
          ),
          Visibility(
            visible: onTap != null,
            child: const SizedBox(width: 2,)
          ),
          Visibility(
            visible: onTap != null,
            child: GestureDetector(
              onTap: () {
                onTap!.call();
                },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}