import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

class StirPillButton extends ConsumerWidget {
  const StirPillButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.onColor,
    this.selected = false,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool selected;
  final bool enabled;
  final Color? color;
  final Color? onColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;

    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: selected 
            ? color ?? colors.primary
            : colors.surface,
        foregroundColor: selected
            ? onColor ?? colors.onPrimary
            : colors.onSurface,
        disabledBackgroundColor: selected ? colors.disabled : colors.disabled.withValues(alpha: 0.5),
        disabledForegroundColor: selected ? colors.onDisabled : colors.onDisabled.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StirSpacings.small16),
        ),
      ),
      child: child,
    );
  }
} 