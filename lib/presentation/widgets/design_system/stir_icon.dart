import 'package:flutter/material.dart';

enum StirIconSize {
  xs(14.0),
  standard(18.0),
  medium(24.0),
  large(32.0),
  xl(48.0),
  xxl(64.0);

  const StirIconSize(this.size);

  final double size;
}

class StirIcon extends StatelessWidget {
  const StirIcon({
    super.key,
    required this.iconData,
    this.color,
    this.iconSize,
  });

  const StirIcon.xs({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.xs;

  const StirIcon.standard({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.standard;

  const StirIcon.medium({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.medium;

  const StirIcon.large({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.large;

  const StirIcon.xl({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.xl;

  const StirIcon.xxl({
    super.key,
    required this.iconData,
    this.color,
  }) : iconSize = StirIconSize.xxl;

  final IconData iconData;
  final StirIconSize? iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: iconSize?.size ?? StirIconSize.standard.size,
      color: color,
    );
  }
}
