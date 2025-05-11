import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/views/ingredients/ingredients_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

/// A form field for managing ingredients with quantity and unit selection
class IngredientsFormField extends ConsumerStatefulWidget {
  const IngredientsFormField({
    super.key,
    required this.label,
    required this.ingredients,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final List<RecipeIngredient> ingredients;
  final ValueChanged<List<RecipeIngredient>> onChanged;
  final bool enabled;

  @override
  ConsumerState<IngredientsFormField> createState() => _IngredientsFormFieldState();
}

class _IngredientsFormFieldState extends ConsumerState<IngredientsFormField> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // TODO: Add search query

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddIngredientDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddIngredientDialog(
        onIngredientSelected: (ingredient, quantity, unit) {
          setState(() {
            final updatedIngredients = List<RecipeIngredient>.from(widget.ingredients)
              ..add(
                RecipeIngredient(
                  ingredientId: ingredient.id,
                  ingredientName: ingredient.name,
                  quantity: quantity,
                  unit: unit,
                ),
              );
            widget.onChanged(updatedIngredients);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StirText.bodyMedium(widget.label),
            if (widget.enabled)
              TextButton.icon(
                onPressed: _showAddIngredientDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
          ],
        ),
        const Gap(StirSpacings.small16),
        if (widget.ingredients.isEmpty)
          const Center(
            child: Text('No ingredients added yet'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredients[index];
              return ListTile(
                title: Text(ingredient.ingredientName),
                subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
                trailing: widget.enabled
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            final updatedIngredients = List<RecipeIngredient>.from(widget.ingredients)
                              ..removeAt(index);
                            widget.onChanged(updatedIngredients);
                          });
                        },
                      )
                    : null,
              );
            },
          ),
      ],
    );
  }
}

class _AddIngredientDialog extends ConsumerStatefulWidget {
  const _AddIngredientDialog({
    required this.onIngredientSelected,
  });

  final Function(Ingredient ingredient, double quantity, String unit) onIngredientSelected;

  @override
  ConsumerState<_AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends ConsumerState<_AddIngredientDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _searchQuery = '';
  String? _selectedUnit;
  Ingredient? _selectedIngredient;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        _searchQuery = _searchController.text;
        ref.read(ingredientsNotifierProvider.notifier).search(_searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final availableUnits = ref.allChoices?.ingredientUnits ?? [];

    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(StirSpacings.medium24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StirText.titleLarge('Add Ingredient'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Gap(StirSpacings.medium24),
            StirTextField(
              controller: _searchController,
              hint: 'Search ingredients...',
              leadingIconData: Icons.search,
            ),
            const Gap(StirSpacings.medium24),
            Expanded(
              child: ref.watch(ingredientsNotifierProvider).when(
                loading: () => const LoadingPlaceholder(),
                error: (error, stackTrace) => ErrorPlaceholder(
                  message: error.toString(),
                  stackTrace: stackTrace,
                ),
                data: (state) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final ingredient = state.items[index];
                      return ListTile(
                        title: Text(ingredient.name),
                        selected: _selectedIngredient == ingredient,
                        onTap: () => setState(() => _selectedIngredient = ingredient),
                      );
                    },
                  );
                },
              ),
            ),
            const Gap(StirSpacings.medium24),
            if (_selectedIngredient != null) ...[
              Row(
                children: [
                  Expanded(
                    child: StirTextField(
                      controller: _quantityController,
                      hint: 'Quantity',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Gap(StirSpacings.small16),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    hint: const Text('Unit'),
                    items: availableUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedUnit = value),
                  ),
                ],
              ),
              const Gap(StirSpacings.medium24),
              FilledButton(
                onPressed: () {
                  if (_selectedIngredient != null &&
                      _quantityController.text.isNotEmpty &&
                      _selectedUnit != null) {
                    widget.onIngredientSelected(
                      _selectedIngredient!,
                      double.parse(_quantityController.text),
                      _selectedUnit!,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 