import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

const _defaultSpinnerSize = 45.0;

class StirLoader extends ConsumerWidget {
  const StirLoader({
    super.key,
    this.backgroundColor,
    this.color,
    this.width = _defaultSpinnerSize,
    this.height = _defaultSpinnerSize,
  });

  final Color? backgroundColor;
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        backgroundColor: backgroundColor,
        color: color ?? ref.colors.primary,
      ),
    );
  }
}
