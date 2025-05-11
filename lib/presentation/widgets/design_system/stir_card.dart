import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

// A widget displaying a card with a title and an icon.
class FastCard extends ConsumerWidget {
  const FastCard({
    super.key,
    required this.child,
    this.radius,
    this.padding,
    this.border,
    this.shadows,
    this.color,
    this.onTap,
  });

  /// The child to display inside the card.
  final Widget child;

  /// The padding of the card
  final EdgeInsets? padding;

  /// The border of the card
  final BoxBorder? border;

  /// The shadows of the card
  final List<BoxShadow>? shadows;

  /// The radius of the card
  final double? radius;

  /// The color of the card
  final Color? color;

  /// The function to call when the card is tapped
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: StirSpacings.small8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? StirSpacings.small12),
            ),
            color: color ?? ref.colors.surface,
            boxShadow: shadows ?? ref.shadows.cardDropShadow,
            border: border ?? Border.all(color: ref.shadows.cardDropShadow.first.color),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
