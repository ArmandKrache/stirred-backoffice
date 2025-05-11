import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

/// A widget displaying a divider.
class StirDivider extends ConsumerWidget {
  const StirDivider({
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
  });

  /// The height of the line.
  final double height;

  /// The thickness of the line.
  final double thickness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Divider(
      height: height,
      thickness: thickness,
      color: ref.colors.onSurfaceVariantLowEmphasis,
    );
  }
}
