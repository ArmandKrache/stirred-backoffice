import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/difficulty.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_pill_button.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

/// A form field for selecting difficulty level
class DifficultySelectorFormField extends ConsumerWidget {
  const DifficultySelectorFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final Difficulty value;
  final ValueChanged<Difficulty> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StirText.bodyMedium(label),
        const Gap(StirSpacings.small8),
        Wrap(
          spacing: StirSpacings.small4,
          children: Difficulty.values.map((difficulty) => StirPillButton(
                onPressed: () => onChanged(difficulty),
                selected: difficulty == value,
                enabled: enabled,
                color: difficulty.color(colors),
                child: Text(difficulty.label),
              ),
            )
            .toList(),
        ),
      ],
    );
  }
} 