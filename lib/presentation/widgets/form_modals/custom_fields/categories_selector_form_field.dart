import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';

class CategoriesSelectorFormField extends ConsumerStatefulWidget {
  const CategoriesSelectorFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final Map<String, List<String>> value;
  final ValueChanged<Map<String, List<String>>> onChanged;
  final bool enabled;

  @override
  ConsumerState<CategoriesSelectorFormField> createState() => _CategoriesSelectorFormFieldState();
}

class _CategoriesSelectorFormFieldState extends ConsumerState<CategoriesSelectorFormField> {
  late Map<String, List<String>> _selectedCategories;
  final TextEditingController _keywordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategories = Map<String, List<String>>.from(widget.value);
    _keywordsController.text = _selectedCategories['keywords']?.join(', ') ?? '';
  }

  @override
  void dispose() {
    _keywordsController.dispose();
    super.dispose();
  }

  void _toggleCategory(String type, String category) {
    setState(() {
      final categories = _selectedCategories[type] ?? [];
      if (categories.contains(category)) {
        categories.remove(category);
      } else {
        categories.add(category);
      }
      _selectedCategories[type] = categories;
      widget.onChanged(_selectedCategories);
    });
  }

  void _clearAll(String type) {
    setState(() {
      _selectedCategories[type] = [];
      widget.onChanged(_selectedCategories);
    });
  }

  void _updateKeywords() {
    final keywords = _keywordsController.text
        .split(',')
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .toList();
    setState(() {
      _selectedCategories['keywords'] = keywords;
      widget.onChanged(_selectedCategories);
    });
  }

  Widget _buildCategorySection(String title, List<String> categories, String type) {
    final selectedCategories = _selectedCategories[type] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StirText.titleSmall(title),
            if (widget.enabled && selectedCategories.isNotEmpty)
              TextButton.icon(
                onPressed: () => _clearAll(type),
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear all'),
              ),
          ],
        ),
        const Gap(StirSpacings.small8),
        if (categories.isEmpty)
          const Center(
            child: Text('No categories available'),
          )
        else
          Wrap(
            spacing: StirSpacings.small8,
            runSpacing: StirSpacings.small8,
            children: categories.map((category) {
              final isSelected = selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: widget.enabled ? (selected) => _toggleCategory(type, category) : null,
              );
            }).toList(),
          ),
        const Gap(StirSpacings.medium24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final choices = ref.allChoices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StirText.bodyMedium(widget.label),
        const Gap(StirSpacings.small16),
        _buildCategorySection('Seasons', choices?.seasons ?? [], 'seasons'),
        _buildCategorySection('Origins', choices?.origins ?? [], 'origins'),
        _buildCategorySection('Strengths', choices?.strengths ?? [], 'strengths'),
        _buildCategorySection('Eras', choices?.eras ?? [], 'eras'),
        _buildCategorySection('Diets', choices?.diets ?? [], 'diets'),
        _buildCategorySection('Colors', choices?.colors ?? [], 'colors'),
        const Gap(StirSpacings.small16),
        StirText.titleSmall('Keywords'),
        const Gap(StirSpacings.small8),
        StirTextField(
          controller: _keywordsController,
          hint: 'Enter keywords separated by commas',
          enabled: widget.enabled,
          onChanged: (_) => _updateKeywords(),
        ),
      ],
    );
  }
} 