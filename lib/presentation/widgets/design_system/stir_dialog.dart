import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/close_icon_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

class StirDialog<T> extends ConsumerWidget {
  const StirDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const <Widget>[],
    this.padding = const EdgeInsets.all(StirSpacings.small16),
    this.canDismiss = true,
    this.titleSpacing = StirSpacings.medium32,
  });

  final String? title;
  final Widget? content;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;
  final bool canDismiss;
  final double titleSpacing;

  static Future<T?> show<T>(BuildContext context, Widget child, {bool? isBarrierDismissible}) {
    return showDialog<T>(
      context: context,
      builder: (_) => child,
      barrierDismissible: isBarrierDismissible ?? true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: StirSpacings.medium24),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(StirSpacings.small16),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: [
                      Expanded(
                        child: StirText.lsdHeadlineSmall(title ?? ''),
                      ),
                      if (canDismiss) ...[
                        const CloseIconButton(isSmallIcon: true),
                      ],
                    ],
                  ),
                  Gap(titleSpacing),
                content ?? const SizedBox.shrink(),
                ...actions,
              ],
            ),
          ),
        ),
      );
  }
}
