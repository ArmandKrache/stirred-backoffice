import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/drink_details/drink_details_notifier.dart';
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
  String? _recipeId;
  MultipartFile? _selectedImage;
  Difficulty _difficulty = Difficulty.beginner;
  final List<RecipeIngredient> _ingredients = [];
  Glass? _selectedGlass;
  Map<String, List<String>> _selectedCategories = {};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _recipeId = widget.entity?.recipe?.id;
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _preparationTimeController = TextEditingController(
      text: widget.entity?.recipe?.preparationTime.toStringAsFixed(0) ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.entity?.recipe?.instructions.join('\n') ?? '',
    );
    _difficulty = widget.entity?.recipe?.difficulty ?? Difficulty.beginner;
    _ingredients.clear();
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
            // Only update controllers if the drink ID has changed
            if (!_initialized) {
              _initializeControllers(drink);
              _initialized = true;
            }
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

  void _initializeControllers(Drink drink) {
    _recipeId = drink.recipe?.id;
    _nameController.text = drink.name;
    _descriptionController.text = drink.description ?? '';
    _preparationTimeController.text = drink.recipe?.preparationTime.toStringAsFixed(0) ?? '';
    _instructionsController.text = drink.recipe?.instructions.join('\n') ?? '';
    _difficulty = drink.recipe?.difficulty ?? Difficulty.beginner;
    _ingredients.clear();
    _ingredients.addAll(drink.recipe?.ingredients ?? []);
    _selectedGlass = drink.glass;
    _selectedCategories = {
      'seasons': List<String>.from(drink.categories?.seasons ?? []),
      'origins': List<String>.from(drink.categories?.origins ?? []),
      'strengths': List<String>.from(drink.categories?.strengths ?? []),
      'eras': List<String>.from(drink.categories?.eras ?? []),
      'diets': List<String>.from(drink.categories?.diets ?? []),
      'colors': List<String>.from(drink.categories?.colors ?? []),
      'keywords': List<String>.from(drink.categories?.keywords ?? []),
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

      final request = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'recipe': {
          'id': _recipeId,
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

      if (currentMode == EntityModalMode.create) {
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is required')),
          );
          return;
        }
        request['picture'] = _selectedImage!;
      } else if (_selectedImage != null) {
        request['picture'] = _selectedImage!;
      }

      widget.onSave!(request);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}