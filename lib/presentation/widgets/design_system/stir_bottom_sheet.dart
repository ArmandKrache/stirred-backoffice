import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

/// A widget used to display a bottom sheet.
class StirBottomSheet<T> extends ConsumerWidget {
  const StirBottomSheet({
    super.key,
    this.bottomWidget,
    this.content,
  });

  /// The widget to display at the bottom of the bottom sheet (usually a button).
  final Widget? bottomWidget;

  /// The content of the bottom sheet.
  final Widget? content;

  /// A method to show the bottom sheet.
  ///
  /// In the code, call `showMe()` instead.
  static Future<T?> show<T>(BuildContext context, Widget child) {
    final maxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 100.0;

    return showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(StirSpacings.small8),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(maxHeight: maxHeight),
      builder: (_) => child,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;
    final localBottomWidget = bottomWidget;
    final localContent = content;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ColoredBox(
        color: colors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: StirSpacings.small16,
              ),
              child: _BottomSheetHandle(),
            ),
            if (localContent != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StirSpacings.medium24,
                  ),
                  child: SingleChildScrollView(child: localContent),
                ),
              ),
            if (localBottomWidget != null)
              ColoredBox(
                color: colors.surface,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: StirSpacings.medium24,
                    left: StirSpacings.medium24,
                    right: StirSpacings.medium24,
                  ),
                  child: localBottomWidget,
                ),
              ),
            Gap(MediaQuery.of(context).padding.bottom + StirSpacings.medium24),
          ],
        ),
      ),
    );
  }
}

/// The bottom sheet handle.
class _BottomSheetHandle extends ConsumerWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const handleSize = Size(64.0, 4.0);

    return SizedBox.fromSize(
      size: handleSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ref.colors.onSurfaceVariantLowEmphasis,
          borderRadius: BorderRadius.circular(StirSpacings.small4),
        ),
      ),
    );
  }
}
