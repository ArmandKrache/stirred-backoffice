import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// A Widget displaying an error state. This widget is useful for displaying a
/// placeholder while a view is in error, to inform the user that an error
/// occured.
class ErrorPlaceholder extends ConsumerStatefulWidget {
  const ErrorPlaceholder({
    super.key,
    this.title,
    this.subtitle,
    this.message,
    this.iconData,
    this.action,
    this.actionLabel,
    this.isConnected = true,
    this.error,
    this.stackTrace,
  });

  /// An optional title to display.
  ///
  /// If null, the defaults title is `localizations.unexpectedErrorTitle`.
  final String? title;

  /// An optional subtitle to display.
  ///
  /// If null, the subtitle defaults to `localizations.unexpectedErrorBody`.
  final String? subtitle;

  /// An optional error message to display to the user.
  ///
  /// If null, the message will not appear.
  final String? message;

  /// An optional icon to display.
  ///
  /// If null, the default icon is `FontAwesomeIcons.lightCircleExclamation`.
  final IconData? iconData;

  /// An optional callback to call.
  ///
  /// If null, the action button will not appear.
  final VoidCallback? action;

  /// An optional label to display on the action button.
  ///
  /// If `action` is null, the action button will not appear, therefore setting
  /// this attribute is useless.
  ///
  /// If `action` is not null but `actionLabel` is, the action label defaults to
  /// `localizations.unexpectedErrorActionRetry`.
  final String? actionLabel;

  /// True if the device is connected to the internet, false otherwise.
  final bool isConnected;

  /// An optional error object to display (only in preprod and dev environments).
  final Object? error;

  /// An optional stack trace to display (only in preprod and dev environments).
  final StackTrace? stackTrace;

  @override
  ConsumerState<ErrorPlaceholder> createState() => _ErrorPlaceholderState();
}

class _ErrorPlaceholderState extends ConsumerState<ErrorPlaceholder> {
  bool isDetailsDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final colors = ref.colors;
    final errorText = widget.message;

    return Padding(
      padding: const EdgeInsets.all(StirSpacings.medium24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StirIcon.xxl(
                iconData: widget.iconData ?? Icons.wrong_location_outlined,
            ),
            const Gap(StirSpacings.medium32),
            StirText.headlineMedium(
              widget.title ?? 'Error',
            ),
            const Gap(StirSpacings.small16),
            StirText.bodyLarge(
              widget.subtitle ?? 'An error occurred',
              textAlign: TextAlign.center,
            ),
            const Gap(StirSpacings.small8),
            if (errorText != null && errorText.isNotEmpty && errorText != 'null')
              StirText.bodyMedium(
                errorText,
                color: colors.onSurfaceVariantLowEmphasis,
              ),
            if (widget.action != null) ...[
              const Gap(StirSpacings.medium32),
              StirButton.primary(
                label: widget.actionLabel ?? 'Retry',
                onPressed: widget.action,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
