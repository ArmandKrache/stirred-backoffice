import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrinksView extends ConsumerWidget {
  const DrinksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(drinksNotifierProvider);
    final drinksNotifier = ref.read(drinksNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
        child: notifier.when(
          data: (data) {
            return Column(
              children: [
                const Gap(StirSpacings.small16),
                DrinksHeader(
                  onSearch: (query) => drinksNotifier.searchDrinks(query),
                  onFilterPressed: () => _showFilterBottomSheet(context, drinksNotifier),
                ),
                const SizedBox(height: StirSpacings.small16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: StirSpacings.small16,
                      mainAxisSpacing: StirSpacings.small16,
                    ),
                    itemCount: data.drinks.length,
                    itemBuilder: (context, index) {
                      return DrinkCardItem(drink: data.drinks[index]);
                    },
                  ),
                ),
              ],
            );
          },
          error: (error, stacktrace) => ErrorPlaceholder(
            message: error.toString(),
            stackTrace: stacktrace,
          ),
          loading: () {
            return const LoadingPlaceholder();
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, DrinksNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        onApplyFilters: (filters) {
          notifier.applyFilters(filters);
          Navigator.pop(context);
        },
        onClearFilters: () {
          notifier.clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DrinksHeader extends ConsumerWidget {
  const DrinksHeader({
    super.key,
    required this.onSearch,
    required this.onFilterPressed,
  });

  final Function(String) onSearch;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list, size: 32),
          onPressed: onFilterPressed,
        ),
        const SizedBox(width: 8),
        const StirText.titleLarge('Trending'),
        const SizedBox(width: 24),
        Expanded(
          child: StirTextField(
            hint: 'Search',
            onChanged: onSearch,
            leadingIconData: Icons.search,
            showLabel: false,
          ),
        ),
      ],
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StirSpacings.small16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StirText.titleLarge('Filters'),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: StirSpacings.small16),
          // TODO: Add filter options here
          const SizedBox(height: StirSpacings.small16),
          ElevatedButton(
            onPressed: () => onApplyFilters({}),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

class DrinkCardItem extends StatelessWidget {
  const DrinkCardItem({super.key, required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => router.push(
          DrinkDetailsRoute.route(drink.id),
          extra: drink,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'drink_image_${drink.id}',
                child: CachedNetworkImage(
                  imageUrl: drink.picture,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StirText.bodyLarge(
                    drink.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      StirText.bodySmall(
                        drink.averageRating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
