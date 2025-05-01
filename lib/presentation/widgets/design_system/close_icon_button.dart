import 'package:flutter/material.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_button.dart';

/// {@template close_icon_button}
/// A button with an X mark icon, used to go back to the previous navigation
/// view using `context.router.pop`.
/// {@endtemplate}
class CloseIconButton extends StatelessWidget {
  const CloseIconButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.alignment,
    this.isSmallIcon = false,
    this.popResult,
  });

  /// The padding around the icon button. Defaults to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// The alignment of the button in the layout.
  final Alignment? alignment;

  /// Indicates if the inner [FastIconButton] button size should be small or
  /// large.
  ///
  /// Defaults to `false`.
  final bool isSmallIcon;

  /// The `Object` to return within `context.router.pop`.
  final Object? popResult;

  @override
  Widget build(BuildContext context) {
    final safeAlignment = alignment;

    final button = StirIconButton.standard(
      iconData: Icons.close,
      onPressed: () {
        if (router.canPop()) {
          router.pop(popResult);
        }
      },
      size: isSmallIcon ? StirIconButtonSize.small : StirIconButtonSize.large,
    );

    final child = safeAlignment != null
        ? Align(
            alignment: safeAlignment,
            child: button,
          )
        : button;

    return Padding(
      padding: padding,
      child: child,
    );
  }
}
