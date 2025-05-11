import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

class StirModal extends StatelessWidget {
  const StirModal({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.width = 600,
    this.height,
    this.onClose,
  });

  /// The title of the modal
  final String title;

  /// The content widget of the modal
  final Widget content;

  /// Optional list of action buttons
  final List<Widget>? actions;

  /// The width of the modal
  final double width;

  /// Optional height of the modal
  final double? height;

  /// Optional callback when the modal is closed
  final VoidCallback? onClose;

  /// Shows the modal
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    double width = 600,
    double? height,
    VoidCallback? onClose,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => StirModal(
        title: title,
        content: content,
        actions: actions,
        width: width,
        height: height,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(StirSpacings.small8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(StirSpacings.small16),
              child: Row(
                children: [
                  StirText.titleLarge(title),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onClose?.call();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(StirSpacings.small16),
                child: content,
              ),
            ),
            // Actions
            if (actions != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(StirSpacings.small16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (final action in actions!) ...[
                      action,
                      if (action != actions!.last) 
                        const Gap(StirSpacings.small8),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 