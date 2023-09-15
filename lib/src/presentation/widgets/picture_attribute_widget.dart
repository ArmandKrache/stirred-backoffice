import 'package:cocktail_app/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class PictureAttributeWidget extends StatelessWidget {
  final String src;

  const PictureAttributeWidget({
    super.key,
    required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return src == "" ?
      Image.asset(glassPlaceholderAsset, width: 160, height: 160, fit: BoxFit.cover,) :
      Image.network(src, width: 160, height: 160, fit: BoxFit.cover,);
  }
}