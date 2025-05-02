import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
    this.title = 'Filters',
    this.children = const [],
  });

  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClearFilters;
  final String title;
  final List<Widget> children;

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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: StirSpacings.small16),
          ...children,
          const SizedBox(height: StirSpacings.small16),
          FilledButton(
            onPressed: () => onApplyFilters({}),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
} 