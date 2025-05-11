import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

typedef ColorBuilder = Color Function(WidgetRef);

mixin ShowableFastSnackbar on Widget {
  /// A method used to easily show a snackbar to the user.
  ///
  /// Set `clearPreviousSnackbars` to true if you wish to remove all the
  /// displayed snackbars on the screen before showing the new snackbar.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMe(
    BuildContext context, {
    bool clearPreviousSnackbars = true,
  }) {
    return FastSnackbar.show(
      context: context,
      content: this,
      clearPreviousSnackbars: clearPreviousSnackbars,
    );
  }
}

/// A widget used to display a snackbar.
class FastSnackbar extends ConsumerWidget with ShowableFastSnackbar {
  FastSnackbar.primary({
    super.key,
    required this.title,
    this.subtitle,
    this.iconData,
    this.onTap,
  })  : foregroundColor = ((ref) => ref.colors.surface),
        backgroundColor = ((ref) => ref.colors.onSurface);

  FastSnackbar.error({
    super.key,
    required this.title,
    this.subtitle,
    this.iconData,
    this.onTap,
  })  : foregroundColor = ((ref) => ref.colors.onError),
        backgroundColor = ((ref) => ref.colors.error);

  /// The title of the snackbar.
  final String title;

  /// The subtitle of the snackbar.
  final String? subtitle;

  /// The foreground color of the snackbar, i.e. the text/icon color.
  final ColorBuilder foregroundColor;

  /// The background color of the snackbar.
  final ColorBuilder backgroundColor;

  /// The icon displayed in the snackbar.
  final IconData? iconData;

  /// A callback to call when the snackbar gets tapped.
  final VoidCallback? onTap;

  /// A method to show the snackbar.
  ///
  /// In the code, call `showMe()` instead.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required Widget content,
    bool clearPreviousSnackbars = false,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (clearPreviousSnackbars) {
      scaffoldMessenger.clearSnackBars();
    }

    return scaffoldMessenger.showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(StirSpacings.small8),
        margin: EdgeInsets.zero,
        elevation: 0,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final computedForegroundColor = foregroundColor(ref);
    final safeSubtitle = subtitle;
    final safeIconData = iconData;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(StirSpacings.small8),
          color: backgroundColor(ref),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: StirSpacings.small16,
            vertical: safeSubtitle != null ? StirSpacings.small8 : StirSpacings.small16,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StirText.lsdHeadlineSmall(
                      title,
                      color: computedForegroundColor,
                    ),
                    if (safeSubtitle != null) ...[
                      const Gap(StirSpacings.small8),
                      StirText.titleSmall(
                        safeSubtitle,
                        color: computedForegroundColor,
                      ),
                    ],
                  ],
                ),
              ),
              if (safeIconData != null) ...[
                const Gap(StirSpacings.medium24),
                StirIcon.large(
                  iconData: safeIconData,
                  color: computedForegroundColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
