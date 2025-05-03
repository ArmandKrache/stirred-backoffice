import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/drink_details/drink_details_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/difficulty_selector_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/ingredients_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/number_picker_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/form_fields.dart' as custom;
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinkModal extends ConsumerStatefulWidget {
  const DrinkModal({
    super.key,
    required this.mode,
    this.entity,
    this.onSave,
    this.onDelete,
  });

  final EntityModalMode mode;
  final Drink? entity;
  final Function(dynamic)? onSave;
  final VoidCallback? onDelete;

  @override
  DrinkModalState createState() => DrinkModalState();
}

class DrinkModalState extends ConsumerState<DrinkModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _preparationTimeController;
  MultipartFile? _selectedImage;
  Difficulty _difficulty = Difficulty.beginner;
  final List<RecipeIngredient> _ingredients = [];
  late EntityModalMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _preparationTimeController = TextEditingController(text: widget.entity?.recipe?.preparationTime.toStringAsFixed(0));
    _instructionsController = TextEditingController(
      text: widget.entity?.recipe?.instructions.join('\n'),
    );
    _difficulty = widget.entity?.recipe?.difficulty ?? Difficulty.beginner;
    _ingredients.addAll(widget.entity?.recipe?.ingredients ?? []);

    if (widget.entity != null) {
      ref.read(drinkDetailsNotifierProvider(widget.entity!.id).notifier).refreshDrink();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StatefulBuilder(
        builder: (context, setState) => Container(
          width: 600,
          padding: const EdgeInsets.all(StirSpacings.medium24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StirText.titleLarge(_currentMode.title),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Gap(StirSpacings.medium24),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildContent(context),
                      ),
                    ),
                    const Gap(StirSpacings.small16),
                    _buildActions(context, setState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.entity == null) {
      return _buildForm();
    }

    return ref.watch(drinkDetailsNotifierProvider(widget.entity!.id)).when(
      data: (data) {
        final drink = data.drink ?? widget.entity!;
        _updateControllers(drink);
        return _buildForm();
      },
      error: (error, stackTrace) => ErrorPlaceholder(
        message: error.toString(),
        stackTrace: stackTrace,
      ),
      loading: () => const LoadingPlaceholder(),
    );
  }

  void _updateControllers(Drink drink) {
    _nameController.text = drink.name;
    _descriptionController.text = drink.description ?? '';
    _preparationTimeController.text = drink.recipe?.preparationTime.toStringAsFixed(0) ?? '';
    _instructionsController.text = drink.recipe?.instructions.join('\n') ?? '';
    _difficulty = drink.recipe?.difficulty ?? Difficulty.beginner;
    _ingredients.clear();
    _ingredients.addAll(drink.recipe?.ingredients ?? []);
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        custom.ImageFormField(
          currentImageUrl: widget.entity?.picture,
          onImageChanged: (image) => _selectedImage = image,
          enabled: _currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.medium24),
        custom.TextFormField(
          label: 'Name',
          controller: _nameController,
          enabled: _currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Description',
          controller: _descriptionController,
          enabled: _currentMode != EntityModalMode.view,
          minLines: 3,
        ),
        const Divider(
          height: StirSpacings.small16,
        ),
        StirText.titleMedium('Recipe'),
        const Gap(StirSpacings.small4),
        NumberPickerFormField(
          label: 'Preparation Time (minutes)',
          controller: _preparationTimeController,
          enabled: _currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        DifficultySelectorFormField(
          label: 'Difficulty',
          value: _difficulty,
          onChanged: (value) => setState(() => _difficulty = value),
          enabled: _currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        custom.TextFormField(
          label: 'Instructions (separated by new lines)',
          controller: _instructionsController,
          enabled: _currentMode != EntityModalMode.view,
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
          enabled: _currentMode != EntityModalMode.view,
        ),
        const Divider(
          height: StirSpacings.small16,
        ),
        StirText.titleMedium('Informations'),
        const Gap(StirSpacings.small4),
        /// TODO: Add glass type selector field
        /// TODO: Add categories field
      ],
    );
  }

  Widget _buildActions(BuildContext context, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_currentMode == EntityModalMode.view) ...[
          TextButton(
            onPressed: () {
              setState(() {
                _currentMode = EntityModalMode.edit;
              });
            },
            child: const Text('Edit'),
          ),
          const Gap(StirSpacings.small16),
          if (widget.onDelete != null)
            FilledButton(
              onPressed: widget.onDelete,
              child: const Text('Delete'),
            ),
        ] else ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const Gap(StirSpacings.small16),
          FilledButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ],
    );
  }

  void _handleSave() {
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

      if (_currentMode == EntityModalMode.create) {
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is required')),
          );
          return;
        }

        final request = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'picture': _selectedImage!,
          'recipe': {
            'ingredients': _ingredients,
            'instructions': instructions,
            'preparationTime': int.parse(_preparationTimeController.text),
            'difficulty': _difficulty,
          },
        };

        widget.onSave!(request);
      } /*else if (_currentMode == EntityModalMode.edit) {
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