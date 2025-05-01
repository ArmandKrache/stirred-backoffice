import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/theme/text.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// Widget used to display a drop down menu for a form's field.
class StirDropDownField extends ConsumerWidget {
  const StirDropDownField({
    super.key,
    required this.label,
    required this.items,
    this.hint,
    this.supportingText,
    this.initialValue,
    this.isRequired = false,
    this.leadingIconData,
    this.trailingIconData,
    this.onTrailingIconPressed,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.decoration,
    this.style,
    this.suffix,
  });

  /// The items to display in the drop down menu.
  final List<DropdownMenuItem<String>>? items;

  /// The label to display above the field.
  final String label;

  /// The placeholder of the field.
  final String? hint;

  /// The helper text to display under the field.
  final String? supportingText;

  /// The value to display initially in the dropdown.
  final String? initialValue;

  /// Make the field required to fill or not (false by default).
  final bool isRequired;

  /// The icon to put at the leading of the field.
  final IconData? leadingIconData;

  /// The icon to put at the trailing of the field.
  final IconData? trailingIconData;

  /// Callback executed when the trailing icon is pressed.
  final VoidCallback? onTrailingIconPressed;

  /// The function to display an error message.
  ///
  /// If [isRequired] is true the validator will trigger when the field is empty.
  final String? Function(String?)? validator;

  /// Callback to execute when the value changed.
  final Function(String?)? onChanged;

  /// Focus on the field when arriving on the page (false by default).
  final bool autofocus;

  /// The focus node to call when the field is focus.
  final FocusNode? focusNode;

  /// The decoration of the field.
  final InputDecoration? decoration;

  /// The style text style of the field.
  final TextStyle? style;

  /// The suffix widget to display on the field.
  ///
  /// Use [leadingIconData] if you want to display an icon.
  final Widget? suffix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;
    final localLeadingIconData = leadingIconData;
    final localTrailingIconData = trailingIconData;
    const iconContainerSize = 40.0;
    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: colors.error,
        width: 2,
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
        DropdownButtonFormField(
          items: items,
          focusNode: focusNode,
          value: initialValue,
          isExpanded: true,
          validator: validator ?? (isRequired ? emptyFieldValidator : null),
          hint: StirText.bodyLarge(
            hint ?? '',
            color: colors.onSurfaceVariantLowEmphasis,
          ),
          onChanged: onChanged,
          autofocus: autofocus,
          decoration: decoration ??
              InputDecoration(
                filled: true,
                fillColor: colors.surface,
                helperText: supportingText,
                helperStyle: StirTextTheme.bodySmall.copyWith(
                  color: colors.onSurfaceVariantLowEmphasis,
                ),
                helperMaxLines: 3,
                errorStyle: StirTextTheme.bodySmall.copyWith(
                  color: colors.error,
                ),
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
                suffix: suffix ??
                    (localTrailingIconData == null
                        ? const SizedBox(width: StirSpacings.small8)
                        : null),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: iconContainerSize + StirSpacings.small8,
                  minHeight: iconContainerSize,
                ),
                suffixIcon: localTrailingIconData != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(right: StirSpacings.small8),
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.secondary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.onSurfaceVariantLowEmphasis,
                  ),
                ),
                labelStyle: StirTextTheme.bodyLarge.copyWith(
                  color: colors.onSurface,
                ),
                floatingLabelStyle: StirTextTheme.bodyLarge.copyWith(
                  color: colors.onSurface,
                ),
                hintStyle: StirTextTheme.bodyLarge.copyWith(
                  color: colors.onSurfaceVariantLowEmphasis,
                ),
              ),
          style: style,
        ),
      ],
    );
  }
}
