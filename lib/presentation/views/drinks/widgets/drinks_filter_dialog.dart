import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

enum DrinksOrdering {
  trending('trending'),
  bestRated('best_rated'),
  newest('newest');

  const DrinksOrdering(this.value);

  final String value;

  static DrinksOrdering fromValue(String value) {
    return DrinksOrdering.values.firstWhere((ordering) => ordering.value == value);
  }

  String get label {
    switch (this) {
      case DrinksOrdering.trending:
        return 'Trending';
      case DrinksOrdering.bestRated:
        return 'Best Rated';
      case DrinksOrdering.newest:
        return 'Newest';
    }
  }
}

class DrinksFilterDialog extends StatefulWidget {
  const DrinksFilterDialog({
    super.key,
    required this.currentOrdering,
    required this.isFavoritesOnly,
    required this.onApply,
  });

  final DrinksOrdering currentOrdering;
  final bool isFavoritesOnly;
  final void Function(DrinksOrdering ordering, bool favoritesOnly) onApply;

  @override
  State<DrinksFilterDialog> createState() => _DrinksFilterDialogState();
}

class _DrinksFilterDialogState extends State<DrinksFilterDialog> {
  late DrinksOrdering _selectedOrdering;
  late bool _isFavoritesOnly;

  @override
  void initState() {
    super.initState();
    _selectedOrdering = widget.currentOrdering;
    _isFavoritesOnly = widget.isFavoritesOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(StirSpacings.medium24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StirText.titleLarge('Filter Drinks'),
            const Gap(StirSpacings.medium24),
            StirText.titleMedium('Order by'),
            const Gap(StirSpacings.small16),
            _buildOrderingSelector(),
            const Gap(StirSpacings.medium24),
            _buildFavoritesToggle(),
            const Gap(StirSpacings.medium24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Gap(StirSpacings.small16),
                FilledButton(
                  onPressed: () {
                    widget.onApply(_selectedOrdering, _isFavoritesOnly);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderingSelector() {
    return Column(
      children: DrinksOrdering.values.map((ordering) {
        return RadioListTile<DrinksOrdering>(
          title: Text(ordering.label),
          value: ordering,
          groupValue: _selectedOrdering,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedOrdering = value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildFavoritesToggle() {
    return SwitchListTile(
      title: const Text('Favorites only'),
      value: _isFavoritesOnly,
      onChanged: (value) {
        setState(() => _isFavoritesOnly = value);
      },
    );
  }
} 