import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

class FastFullScreenDialog extends ConsumerWidget {
  const FastFullScreenDialog({
    super.key,
    required this.child,
  });

  final Widget child;

  static Future<T?> show<T>(BuildContext context, Widget child, {bool? isBarrierDismissible}) {
    return showDialog<T>(
      context: context,
      useSafeArea: false,
      builder: (_) => child,
      barrierDismissible: isBarrierDismissible ?? true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog.fullscreen(
      backgroundColor: ref.colors.surface,
      child: child,
    );
  }
}
