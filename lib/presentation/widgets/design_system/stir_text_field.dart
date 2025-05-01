import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/theme/text.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// Widget used to display a form's text field.
class StirTextField extends ConsumerWidget {
  const StirTextField({
    super.key,
    this.label = '',
    this.showLabel = true,
    this.hint,
    this.supportingText,
    this.isRequired = false,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.leadingIconData,
    this.trailingIconData,
    this.onTrailingIconPressed,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.style,
    this.suffix,
    this.autofillHints,
    this.padding,
    this.minLines,
    this.hintStyle,
    this.borderWidth,
    this.border,
    this.fillColor,
    this.focusedBorder,
    this.enabledBorder,
    this.onTap,
    this.onFieldSubmitted,
  });

  /// The label of the text field.
  final String label;

  /// Boolean to show the label or not (true by default).
  final bool showLabel;

  /// The placeholder of the field.
  final String? hint;

  /// The helper text to display under the field.
  final String? supportingText;

  /// Make the field required to fill or not (false by default).
  final bool isRequired;

  /// The controller to edit the text field.
  final TextEditingController? controller;

  /// The initial value to display inside the field.
  final String? initialValue;

  /// Boolean to obsucre the text (useful for password).
  final bool obscureText;

  /// The icon to put at the leading of the field.
  final IconData? leadingIconData;

  /// The icon to put at the trailing of the field.
  final IconData? trailingIconData;

  /// Callback executed when the trailing icon is pressed.
  final VoidCallback? onTrailingIconPressed;

  /// The function to display an error message.
  ///
  /// If [isRequired] is true the validator will trigger when the field is empty.
  final String Function(String?)? validator;

  /// Callback to execute when the value changed.
  final Function(String)? onChanged;

  /// Focus on the field when arriving on the page (false by default).
  final bool autofocus;

  /// Boolean to make the text field editable or not (false by default).
  final bool readOnly;

  /// Display the cursor on the text field.
  final bool? showCursor;

  /// The focus node to call when the field is focus.
  final FocusNode? focusNode;

  /// The decoration of the field.
  final InputDecoration? decoration;

  /// The alignment of the text inside the field.
  final TextAlign textAlign;

  /// The style text style of the field.
  final TextStyle? style;

  /// The suffix widget to display on the field.
  ///
  /// Use [leadingIconData] if you want to display an icon.
  final Widget? suffix;

  /// The padding of the text inside the field.
  final EdgeInsets? padding;

  /// The fill method for hints.
  final Iterable<String>? autofillHints;

  /// The system keyboard type to show when editing the field.
  final TextInputType? keyboardType;

  /// The input formatters to apply to the field.
  final List<TextInputFormatter>? inputFormatters;

  /// The minimum lines to display for the field.
  final int? minLines;

  /// The text style of the hint.
  final TextStyle? hintStyle;

  /// The width of the borders
  final double? borderWidth;

  /// The shape of the border to draw around the decoration's container.
  final InputBorder? border;

  /// The base fill color of the decoration's container color.
  final Color? fillColor;

  /// The border to display when the [InputDecorator] has the focus and is not showing an error.
  final InputBorder? focusedBorder;

  /// The border to display when the [InputDecorator] is enabled and is not showing an error.
  final InputBorder? enabledBorder;

  /// Callback executed when the field is tapped.
  final void Function()? onTap;

  /// Callback executed when the field is submitted.
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;
    final localLeadingIconData = leadingIconData;
    final localTrailingIconData = trailingIconData;
    const iconContainerSize = 40.0;
    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: colors.error,
        width: borderWidth ?? 2,
      ),
    );
    final defaultFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: colors.secondary,
        width: borderWidth ?? 2,
      ),
    );
    final defaultEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: colors.disabled,
        width: borderWidth ?? 1,
      ),
    );
    String? emptyFieldValidator(String? text) {
      if (text == null || text.isEmpty) {
        return 'Field is required';
      }

      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            children: [
              StirText.labelLarge(label),
              if (isRequired) ...[
                const Gap(StirSpacings.small8),
                const StirIcon.xs(
                  iconData: Icons.star, // TODO: Use the correct icon
                ),
              ],
            ],
          ),
          const Gap(StirSpacings.small4),
        ],
        TextFormField(
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          maxLines: minLines != null ? null : 1,
          minLines: minLines,
          obscureText: obscureText,
          autocorrect: false,
          obscuringCharacter: '*',
          validator: validator ?? (isRequired ? emptyFieldValidator : null),
          initialValue: initialValue,
          readOnly: readOnly,
          showCursor: showCursor,
          onFieldSubmitted: onFieldSubmitted,
          onTapOutside: (_) {
            if (context.mounted) {
              // Allows to unfocus the TextField if tapping outside of it.
              FocusScope.of(context).unfocus();
            }
          },
          onChanged: onChanged,
          autofocus: autofocus,
          onTap: onTap,
          cursorColor: colors.onSurfaceVariantLowEmphasis,
          decoration: decoration ??
              InputDecoration(
                hintText: hint,
                hintMaxLines: minLines,
                border: border,
                filled: true,
                fillColor: fillColor ?? colors.surface,
                helperText: supportingText,
                helperStyle: StirTextTheme.bodySmall.copyWith(
                  color: colors.onSurfaceVariantLowEmphasis,
                ),
                helperMaxLines: 3,
                errorStyle: StirTextTheme.bodySmall.copyWith(
                  color: colors.error,
                ),
                // Used to add a small padding when there is no leadingIcon.
                // We cannot use the `contentPadding` property because it applies
                // a padding to the supporting/error text as well.
                prefix: localLeadingIconData == null ? const SizedBox(width: StirSpacings.small8) : null,
                prefixIconConstraints: const BoxConstraints(
                  minWidth: iconContainerSize,
                  minHeight: iconContainerSize,
                ),
                prefixIcon: localLeadingIconData != null
                    ? SizedBox.square(
                        dimension: iconContainerSize,
                        child: Center(
                          child: StirIcon.standard(
                            iconData: localLeadingIconData,
                            color: colors.onSurfaceVariantLowEmphasis,
                          ),
                        ),
                      )
                    : null,
                // Used to add a small padding when there is no leadingIcon.
                // We cannot use the `contentPadding` property because it applies
                // a padding to the supporting/error text as well.
                suffix: suffix ?? (localTrailingIconData == null ? const SizedBox(width: StirSpacings.small8) : null),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: iconContainerSize + StirSpacings.small8,
                  minHeight: iconContainerSize,
                ),
                suffixIcon: localTrailingIconData != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: StirSpacings.small8),
                        child: SizedBox.square(
                          dimension: iconContainerSize,
                          child: StirIconButton.standard(
                            iconData: localTrailingIconData,
                            onPressed: onTrailingIconPressed,
                          ),
                        ),
                      )
                    : null,
                errorBorder: errorBorder,
                focusedErrorBorder: errorBorder,
                focusedBorder: focusedBorder ?? defaultFocusedBorder,
                enabledBorder: enabledBorder ?? defaultEnabledBorder,
                labelStyle: StirTextTheme.bodyLarge.copyWith(
                  color: colors.onSurface,
                ),
                floatingLabelStyle: StirTextTheme.bodyLarge.copyWith(
                  color: colors.onSurface,
                ),
                hintStyle: (hintStyle ?? StirTextTheme.bodyLarge).copyWith(
                  color: colors.onSurfaceVariantLowEmphasis,
                ),
                contentPadding: padding ??
                    const EdgeInsets.only(
                      top: StirSpacings.small8,
                      right: StirSpacings.small8,
                      bottom: StirSpacings.small8,
                    ),
              ),
          style: style,
          textAlign: textAlign,
        ),
      ],
    );
  }
}
