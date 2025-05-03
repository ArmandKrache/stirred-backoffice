import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

/// A form field for managing ingredients with quantity and unit selection
class IngredientsFormField extends StatefulWidget {
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
  State<IngredientsFormField> createState() => _IngredientsFormFieldState();
}

class _IngredientsFormFieldState extends State<IngredientsFormField> {
  final List<RecipeIngredient> _ingredients = [];
  final List<String> _availableUnits = ['ml', 'cl', 'l', 'g', 'kg', 'oz', 'tsp', 'tbsp', 'piece'];

  @override
  void initState() {
    super.initState();
    _ingredients.addAll(widget.ingredients);
  }

  void _showAddIngredientDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddIngredientDialog(
        onAdd: (ingredient) {
          setState(() {
            _ingredients.add(ingredient);
            widget.onChanged(_ingredients);
          });
        },
        availableUnits: _availableUnits,
      ),
    );
  }

  void _removeIngredient(RecipeIngredient ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
      widget.onChanged(_ingredients);
    });
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
                label: const Text('Add Ingredient'),
              ),
          ],
        ),
        const Gap(StirSpacings.small8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              if (_ingredients.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No ingredients added yet'),
                  ),
                )
              else
                ..._ingredients.map((ingredient) => ListTile(
                  title: Text(ingredient.ingredientName),
                  subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
                  trailing: widget.enabled
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeIngredient(ingredient),
                        )
                      : null,
                )),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddIngredientDialog extends StatefulWidget {
  const _AddIngredientDialog({
    required this.onAdd,
    required this.availableUnits,
  });

  final Function(RecipeIngredient) onAdd;
  final List<String> availableUnits;

  @override
  State<_AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<_AddIngredientDialog> {
  final _quantityController = TextEditingController();
  String _selectedUnit = 'ml';
  String _selectedIngredient = '';

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StirText.titleMedium('Add Ingredient'),
            const Gap(StirSpacings.medium24),
            // TODO: Replace with actual ingredient selection from API
            DropdownButtonFormField<String>(
              value: _selectedIngredient.isEmpty ? null : _selectedIngredient,
              decoration: const InputDecoration(
                labelText: 'Ingredient',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Vodka', child: Text('Vodka')),
                DropdownMenuItem(value: 'Gin', child: Text('Gin')),
                DropdownMenuItem(value: 'Rum', child: Text('Rum')),
                DropdownMenuItem(value: 'Tequila', child: Text('Tequila')),
                DropdownMenuItem(value: 'Whiskey', child: Text('Whiskey')),
              ],
              onChanged: (value) => setState(() => _selectedIngredient = value ?? ''),
            ),
            const Gap(StirSpacings.small16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Gap(StirSpacings.small16),
                DropdownButton<String>(
                  value: _selectedUnit,
                  items: widget.availableUnits
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedUnit = value ?? 'ml'),
                ),
              ],
            ),
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
                    final quantity = double.tryParse(_quantityController.text);
                    if (quantity == null || _selectedIngredient.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    widget.onAdd(RecipeIngredient(
                      ingredientId: 'ID', // TODO: Get actual ID from selected ingredient
                      quantity: quantity,
                      unit: _selectedUnit,
                      ingredientName: _selectedIngredient,
                    ));
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 