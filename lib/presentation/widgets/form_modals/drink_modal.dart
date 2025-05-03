import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/drink_details/drink_details_notifier.dart';
import 'package:stirred_backoffice/presentation/views/drinks/drinks_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/categories_selector_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/difficulty_selector_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/glass_selector_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/ingredients_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/number_picker_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/form_fields.dart' as custom;
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinkModal extends BaseEntityModal<Drink> {
  const DrinkModal({
    super.key,
    required super.mode,
    required super.entity,
    required super.onSave,
    super.onDelete,
  });

  @override
  BaseEntityModalState<Drink> createState() => DrinkModalState();
}

class DrinkModalState extends BaseEntityModalState<Drink> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _preparationTimeController;
  MultipartFile? _selectedImage;
  Difficulty _difficulty = Difficulty.beginner;
  final List<RecipeIngredient> _ingredients = [];
  Glass? _selectedGlass;
  Map<String, List<String>> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _preparationTimeController = TextEditingController(text: widget.entity?.recipe?.preparationTime.toStringAsFixed(0));
    _instructionsController = TextEditingController(
      text: widget.entity?.recipe?.instructions.join('\n'),
    );
    _difficulty = widget.entity?.recipe?.difficulty ?? Difficulty.beginner;
    _ingredients.addAll(widget.entity?.recipe?.ingredients ?? []);
    _selectedGlass = widget.entity?.glass;
    _selectedCategories = {
      'seasons': widget.entity?.categories?.seasons ?? [],
      'origins': widget.entity?.categories?.origins ?? [],
      'strengths': widget.entity?.categories?.strengths ?? [],
      'eras': widget.entity?.categories?.eras ?? [],
      'diets': widget.entity?.categories?.diets ?? [],
      'colors': widget.entity?.categories?.colors ?? [],
      'keywords': widget.entity?.categories?.keywords ?? [],
    };

    if (widget.entity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProviderScope.containerOf(context).read(drinkDetailsNotifierProvider(widget.entity!.id).notifier).refreshDrink();
      });
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
  Widget buildContent(BuildContext context) {
    if (widget.entity == null) {
      return _buildForm();
    }

    return Consumer(
      builder: (context, ref, child) {
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
      },
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
    _selectedGlass = drink.glass;
    _selectedCategories = {
      'seasons': drink.categories?.seasons ?? [],
      'origins': drink.categories?.origins ?? [],
      'strengths': drink.categories?.strengths ?? [],
      'eras': drink.categories?.eras ?? [],
      'diets': drink.categories?.diets ?? [],
      'colors': drink.categories?.colors ?? [],
      'keywords': drink.categories?.keywords ?? [],
    };
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const Divider(
          height: StirSpacings.small16,
        ),
        StirText.titleMedium('Recipe'),
        const Gap(StirSpacings.small4),
        NumberPickerFormField(
          label: 'Preparation Time (minutes)',
          controller: _preparationTimeController,
          enabled: currentMode != EntityModalMode.view,
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
        const Divider(
          height: StirSpacings.small16,
        ),
        StirText.titleMedium('Informations'),
        const Gap(StirSpacings.small4),
        GlassSelectorFormField(
          label: 'Glass',
          value: _selectedGlass,
          onChanged: (glass) => setState(() => _selectedGlass = glass),
          enabled: currentMode != EntityModalMode.view,
        ),
        const Gap(StirSpacings.small16),
        CategoriesSelectorFormField(
          label: 'Categories',
          value: _selectedCategories,
          onChanged: (categories) => setState(() => _selectedCategories = categories),
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

      if (currentMode == EntityModalMode.create) {
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
            'ingredients': _ingredients.map((ingredient) => {
              'ingredient': ingredient.ingredientId,
              'quantity': ingredient.quantity,
              'unit': ingredient.unit,
            }).toList(),
            'instructions': instructions,
            'preparation_time': int.parse(_preparationTimeController.text),
            'difficulty': _difficulty.value,
          },
          'glass': _selectedGlass?.id,
          'categories': {
            'seasons': List<String>.from(_selectedCategories['seasons'] ?? []),
            'origins': List<String>.from(_selectedCategories['origins'] ?? []),
            'strengths': List<String>.from(_selectedCategories['strengths'] ?? []),
            'eras': List<String>.from(_selectedCategories['eras'] ?? []),
            'diets': List<String>.from(_selectedCategories['diets'] ?? []),
            'colors': List<String>.from(_selectedCategories['colors'] ?? []),
            'keywords': List<String>.from(_selectedCategories['keywords'] ?? []),
          },
        };

        widget.onSave!(request);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _handleDelete() async {
    if (widget.entity == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drink'),
        content: const Text('Are you sure you want to delete this drink? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ProviderScope.containerOf(context).read(drinksNotifierProvider.notifier).deleteDrink(widget.entity!.id);
      
      if (success) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete drink')),
          );
        }
      }
    }
  }
}