import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/categories_selector_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/custom_fields/ingredients_form_field.dart';
import 'package:stirred_backoffice/presentation/widgets/form_modals/form_fields.dart' as custom;
import 'package:stirred_common_domain/stirred_common_domain.dart';

class IngredientModal extends BaseEntityModal<Ingredient> {
  const IngredientModal({
    super.key,
    required super.mode,
    required super.entity,
    required super.onSave,
    super.onDelete,
  });

  @override
  BaseEntityModalState<Ingredient> createState() => IngredientModalState();
}

class IngredientModalState extends BaseEntityModalState<Ingredient> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  MultipartFile? _selectedImage;
  final List<IngredientMatch> _matches = [];
  Map<String, List<String>> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity?.name);
    _descriptionController = TextEditingController(text: widget.entity?.description);
    _matches.clear();
    _matches.addAll(widget.entity?.matches ?? []);
    _selectedCategories = {
      'seasons': List<String>.from(widget.entity?.categories.seasons ?? []),
      'origins': List<String>.from(widget.entity?.categories.origins ?? []),
      'strengths': List<String>.from(widget.entity?.categories.strengths ?? []),
      'eras': List<String>.from(widget.entity?.categories.eras ?? []),
      'diets': List<String>.from(widget.entity?.categories.diets ?? []),
      'colors': List<String>.from(widget.entity?.categories.colors ?? []),
      'keywords': List<String>.from(widget.entity?.categories.keywords ?? []),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
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
        const Gap(StirSpacings.small16),
        IngredientsFormField(
          label: 'Matches',
          ingredients: _matches.map((match) => RecipeIngredient(
            ingredientId: match.id,
            ingredientName: match.name,
            quantity: 0,
            unit: '',
          )).toList(),
          onChanged: (matches) => setState(() {
            _matches.clear();
            _matches.addAll(matches.map((match) => IngredientMatch(
              id: match.ingredientId,
              name: match.ingredientName,
            )));
          }),
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
      final request = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'matches': _matches.map((match) => match.id).toList(),
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