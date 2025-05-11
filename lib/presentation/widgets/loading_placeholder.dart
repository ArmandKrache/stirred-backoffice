import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_loader.dart';

/// A Widget displaying a [FastLoader]. This widget is useful for displaying a
/// placeholder while a view is loading, to inform the user that a loading is
/// in progress.
class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({
    super.key,
  });
  static const spinnerSize = 64.0;


  @override
  Widget build(BuildContext context) {

    return const Padding(
      padding: EdgeInsets.all(StirSpacings.small16),
      child: Center(
        child: StirLoader(
          width: spinnerSize,
          height: spinnerSize,
        ),
      ),
    );
  }
}
