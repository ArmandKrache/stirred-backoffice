// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

class RecipesView extends ConsumerWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(StirSpacings.medium24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wine_bar_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: StirSpacings.medium24),
                const StirText.headlineMedium(
                  'Recipes Feature',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: StirSpacings.small8),
                const StirText.bodyLarge(
                  'Manage the recipes.\nComing soon!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
