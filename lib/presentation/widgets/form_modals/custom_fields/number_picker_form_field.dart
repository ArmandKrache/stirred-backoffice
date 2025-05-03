import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';

/// A form field for selecting a number with increment/decrement buttons
class NumberPickerFormField extends StatelessWidget {
  const NumberPickerFormField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return StirTextField(
      label: label,
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
} 