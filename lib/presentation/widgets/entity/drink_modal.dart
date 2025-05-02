import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/entity/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/entity/form_fields.dart' as custom;
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinkModal extends BaseEntityModal<Drink> {
  const DrinkModal({
    super.key,
    required super.mode,
    super.entity,
    super.onSave,
    super.onDelete,
  });

  @override
  DrinkModalState createState() => DrinkModalState();
}

class DrinkModalState extends BaseEntityModalState<Drink> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _preparationTimeController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _ingredientsController;
  MultipartFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _preparationTimeController = TextEditingController(text: widget.entity?.recipe?.preparationTime.toString());
    _instructionsController = TextEditingController(
      text: widget.entity?.recipe?.instructions.join('\n'),
    );
    _ingredientsController = TextEditingController(
      text: widget.entity?.recipe?.ingredients
          .map((i) => '${i.quantity} ${i.unit} ${i.ingredientName}')
          .join('\n'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _preparationTimeController.dispose();
    _instructionsController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        custom.ImageFormField(
          currentImageUrl: widget.entity?.picture,
          onImageChanged: (image) => _selectedImage = image,
          enabled: currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.medium24),
        custom.TextFormField(
          label: 'Name',
          controller: _nameController,
          enabled: currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Description',
          controller: _descriptionController,
          enabled: currentMode != EntityModalMode.view,
          minLines: 3,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Preparation Time (minutes)',
          controller: _preparationTimeController,
          enabled: currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Instructions (one per line)',
          controller: _instructionsController,
          enabled: currentMode != EntityModalMode.view,
          minLines: 3,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Ingredients (format: quantity unit name, one per line)',
          controller: _ingredientsController,
          enabled: currentMode != EntityModalMode.view,
          minLines: 3,
        ),
      ],
    );
  }

  List<RecipeIngredient> _parseIngredients() {
    final ingredients = <RecipeIngredient>[];
    final lines = _ingredientsController.text.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      final parts = line.trim().split(' ');
      if (parts.length < 3) {
        throw Exception('Invalid ingredient format: $line');
      }
      
      final quantity = double.tryParse(parts[0]);
      if (quantity == null) {
        throw Exception('Invalid quantity in ingredient: $line');
      }
      
      final unit = parts[1];
      final name = parts.sublist(2).join(' ');
      
      ingredients.add(RecipeIngredient(
        ingredientId: 'ID',
        quantity: quantity,
        unit: unit,
        ingredientName: name,
      ));
    }
    
    return ingredients;
  }

  @override
  void handleSave() {
    if (widget.onSave == null) return;

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    try {
      final ingredients = _parseIngredients();
      final instructions = _instructionsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      final preparationTime = int.tryParse(_preparationTimeController.text);
      /*
      if (currentMode == EntityModalMode.create) {
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is required')),
          );
          return;
        }

        final request = DrinksCreateRequest(
          name: _nameController.text,
          description: _descriptionController.text,
          picture: _selectedImage!,
          recipe: RecipeCreateRequest(
            ingredients: ingredients,
            instructions: instructions,
            preparationTime: preparationTime,
          ),
        );

        widget.onSave!(request);
      } else if (currentMode == EntityModalMode.edit) {
        final request = DrinkPatchRequest(
          id: widget.entity!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          picture: _selectedImage,
          recipe: RecipePatchRequest(
            ingredients: ingredients,
            instructions: instructions,
            preparationTime: preparationTime,
          ),
        );

        widget.onSave!(request);
      }*/
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}