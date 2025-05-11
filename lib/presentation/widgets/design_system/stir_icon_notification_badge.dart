import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';

/// A widget to display an icon with a badge.
class StirIconNotificationBadge extends ConsumerWidget {
  const StirIconNotificationBadge({
    super.key,
    required this.iconData,
    this.showNotificationBadge = false,
    this.color,
  });

  /// The icon to display.
  final IconData iconData;

  /// If true shows a notification badge above the icon.
  final bool showNotificationBadge;

  /// The color of the icon.
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Badge(
        backgroundColor: ref.colors.error,
        smallSize: StirSpacings.small8,
        isLabelVisible: showNotificationBadge,
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(StirSpacings.small8),
          child: StirIcon.standard(
            iconData: iconData,
            color: color,
          ),
        ),
      ),
    );
  }
}
