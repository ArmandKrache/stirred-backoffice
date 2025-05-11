import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_backoffice/presentation/views/drink_details/drink_details_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinkDetailsView extends ConsumerWidget {
  const DrinkDetailsView({
    super.key, 
    required this.drinkId,
    required this.initialDrink,
  });

  final String drinkId;
  final Drink initialDrink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(drinkDetailsNotifierProvider(drinkId));
    final colors = ref.colors;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.35;

    return Scaffold(
      backgroundColor: colors.surface,
      body: notifier.when(
        data: (data) {
          final drink = data.drink ?? initialDrink;
          return Column(
            children: [
              _DrinkHeader(
                drink: drink,
                imageHeight: imageHeight,
                colors: colors,
              ),
              Expanded(
                child: _DrinkContentTabs(drink: drink, colors: colors),
              ),
            ],
          );
        },
        error: (error, stackTrace) => ErrorPlaceholder(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
        loading: () {
          return Column(
            children: [
              _DrinkHeader(
                drink: initialDrink,
                imageHeight: imageHeight,
                colors: colors,
              ),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DrinkHeader extends StatelessWidget {
  const _DrinkHeader({
    required this.drink,
    required this.imageHeight,
    required this.colors,
  });

  final Drink drink;
  final double imageHeight;
  final StirColorTheme colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Drink Image
        Container(
          height: imageHeight,
          width: double.infinity,
          color: colors.secondary.withValues(alpha: 0.5),
          child: Hero(
            tag: 'drink_image_${drink.id}',
            child: CachedNetworkImage(
              imageUrl: drink.picture,
              fit: BoxFit.contain,
              errorWidget: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        // Drink Info Overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: StirSpacings.small16,
              vertical: StirSpacings.small8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: _DrinkInfoHeader(drink: drink),
          ),
        ),
        // Back Button
        const Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: _BackButton(),
          ),
        ),
      ],
    );
  }
}

class _DrinkInfoHeader extends StatelessWidget {
  const _DrinkInfoHeader({required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StirText.titleLarge(
            drink.name,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            const SizedBox(width: 4),
            StirText.bodyLarge(
              drink.averageRating.toStringAsFixed(1),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(StirSpacings.small16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }
}

class _DrinkContentTabs extends StatelessWidget {
  const _DrinkContentTabs({
    required this.drink,
    required this.colors,
  });

  final Drink drink;
  final StirColorTheme colors;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            height: 48,
            color: colors.surface,
            child: TabBar(
              tabs: const [
                Tab(text: 'Ingredients'),
                Tab(text: 'Instructions'),
                Tab(text: 'Nutrition'),
              ],
              labelColor: colors.primary,
              unselectedLabelColor: colors.onSurface,
              indicatorColor: colors.primary,
              tabAlignment: TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _IngredientsTab(drink: drink),
                _InstructionsTab(drink: drink),
                const _NutritionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientsTab extends StatelessWidget {
  const _IngredientsTab({required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(StirSpacings.small16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (drink.description != null) ...[
            ExpandablePanel(
              header: const StirText.bodyLarge(
                'Description',
                fontWeight: FontWeight.bold,
              ),
              collapsed: StirText.bodyLarge(
                drink.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              expanded: StirText.bodyLarge(
                drink.description!,
              ),
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToExpand: true,
                tapBodyToCollapse: true,
                hasIcon: true,
              ),
            ),
            const SizedBox(height: StirSpacings.small16),
          ],
          if (drink.recipe?.ingredients != null) ...[
            const StirText.bodyLarge(
              'Ingredients',
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: StirSpacings.small16),
            ...drink.recipe!.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: StirSpacings.small8),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8),
                  const SizedBox(width: StirSpacings.small8),
                  Expanded(
                    child: StirText.bodyLarge(
                      '${ingredient.quantity} ${ingredient.unit} ${ingredient.ingredientName}',
                    ),
                  ),
                ],
              ),
            )),
          ],
          if (drink.glass != null) ...[
            const SizedBox(height: StirSpacings.small16),
            const StirText.bodyLarge(
              'Glass',
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: StirSpacings.small8),
            Row(
              children: [
                const Icon(Icons.wine_bar),
                const SizedBox(width: StirSpacings.small8),
                StirText.bodyLarge(
                  drink.glass!.name,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InstructionsTab extends StatelessWidget {
  const _InstructionsTab({required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(StirSpacings.small16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (drink.recipe?.instructions != null) ...[
            const StirText.bodyLarge(
              'Instructions',
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: StirSpacings.small16),
            ...drink.recipe!.instructions.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final instruction = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: StirSpacings.small8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StirText.bodyLarge(
                      '$index.',
                    ),
                    const SizedBox(width: StirSpacings.small8),
                    Expanded(
                      child: StirText.bodyLarge(
                        instruction,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _NutritionTab extends StatelessWidget {
  const _NutritionTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(StirSpacings.small16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StirText.bodyLarge(
            'Nutrition Information',
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: StirSpacings.small16),
          Center(
            child: StirText.bodyLarge(
              'Nutrition information coming soon',
            ),
          ),
        ],
      ),
    );
  }
}
