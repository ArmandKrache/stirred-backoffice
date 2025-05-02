import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/form_fields.dart' as custom;
import 'package:stirred_backoffice/presentation/widgets/form_modals/complex_form_fields.dart';
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
  late final TextEditingController _instructionsController;
  MultipartFile? _selectedImage;
  double _preparationTime = 0;
  int _difficulty = 1;
  final List<RecipeIngredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _instructionsController = TextEditingController(
      text: widget.entity?.recipe?.instructions.join('\n'),
    );
    _preparationTime = widget.entity?.recipe?.preparationTime.toDouble() ?? 0;
    _difficulty = widget.entity?.recipe?.difficulty.hashCode ?? 1;
    _ingredients.addAll(widget.entity?.recipe?.ingredients ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
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
        NumberPickerFormField(
          label: 'Preparation Time (minutes)',
          value: _preparationTime,
          onChanged: (value) => setState(() => _preparationTime = value),
          enabled: currentMode != EntityModalMode.view,
          min: 0,
          max: 120,
          step: 1,
        ),
        const Gap(StirSpacings.small16),
        DifficultySelectorFormField(
          label: 'Difficulty',
          value: _difficulty,
          onChanged: (value) => setState(() => _difficulty = value),
          enabled: currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Instructions (separated by new lines)',
          controller: _instructionsController,
          enabled: currentMode != EntityModalMode.view,
          minLines: 3,
        ),
        const Gap(StirSpacings.small16),
        IngredientsFormField(
          label: 'Ingredients',
          ingredients: _ingredients,
          onChanged: (ingredients) => setState(() {
            _ingredients.clear();
            _ingredients.addAll(ingredients);
          }),
          enabled: currentMode != EntityModalMode.view,
        ),
      ],
    );
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
      final instructions = _instructionsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      /*if (currentMode == EntityModalMode.create) {
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
            ingredients: _ingredients,
            instructions: instructions,
            preparationTime: _preparationTime.toInt(),
            difficulty: _difficulty,
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
            ingredients: _ingredients,
            instructions: instructions,
            preparationTime: _preparationTime.toInt(),
            difficulty: _difficulty,
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