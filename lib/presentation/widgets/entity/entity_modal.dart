import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';

/// A generic modal dialog for displaying and editing entity information
class EntityModal<T> extends StatefulWidget {
  const EntityModal({
    super.key,
    required this.mode,
    this.entity,
    this.onSave,
    this.onDelete,
    this.specificFields = const [],
    this.name,
    this.description,
    this.picture,
    this.onModeChanged,
  });

  /// The mode of the modal (view, edit, or create)
  final EntityModalMode mode;

  /// The entity to display/edit (null for create mode)
  final T? entity;

  /// Callback when the save button is pressed
  final Function(T)? onSave;

  /// Callback when the delete button is pressed
  final VoidCallback? onDelete;

  /// Callback when the mode is changed
  final Function(EntityModalMode)? onModeChanged;

  /// Additional fields specific to the entity type
  final List<EntityField> specificFields;

  /// The name of the entity
  final String? name;

  /// The description of the entity
  final String? description;

  /// The picture of the entity
  final String? picture;

  @override
  State<EntityModal<T>> createState() => _EntityModalState<T>();
}

class _EntityModalState<T> extends State<EntityModal<T>> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late EntityModalMode _currentMode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _currentMode = widget.mode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
              if (widget.picture != null) ...[
                // Picture
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(widget.picture!),
                  ),
                ),
                const Gap(StirSpacings.medium24),
              ],
              // Common fields
              StirTextField(
                controller: _nameController,
                label: 'Name',
                enabled: _currentMode != EntityModalMode.view,
              ),
              const Gap(StirSpacings.small16),
              StirTextField(
                controller: _descriptionController,
                label: 'Description',
                enabled: _currentMode != EntityModalMode.view,
                minLines: 3,
              ),
              const Gap(StirSpacings.small16),
              // Specific fields
              ...widget.specificFields.map((field) => Column(
                children: [
                  field.builder(context, _currentMode, widget.entity),
                  const Gap(StirSpacings.small16),
                ],
              )),
              const Gap(StirSpacings.medium24),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentMode == EntityModalMode.view) ...[
                    if (widget.onDelete != null)
                      TextButton.icon(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    const Gap(StirSpacings.small16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentMode = EntityModalMode.edit;
                        });
                        widget.onModeChanged?.call(EntityModalMode.edit);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ] else if (_currentMode == EntityModalMode.edit) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentMode = EntityModalMode.view;
                        });
                        widget.onModeChanged?.call(EntityModalMode.view);
                      },
                      child: const Text('Cancel'),
                    ),
                    const Gap(StirSpacings.small16),
                    FilledButton(
                      onPressed: _handleSave,
                      child: const Text('Save'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (widget.onSave == null) return;
    // This is a placeholder - you'll need to implement the actual entity creation/update
    // widget.onSave!(entity);
  }
}

/// The mode of the entity modal
enum EntityModalMode {
  /// View mode - fields are not editable
  view,
  /// Edit mode - fields are editable
  edit,
  /// Create mode - fields are empty and editable
  create;

  String get title {
    switch (this) {
      case EntityModalMode.view:
        return 'View';
      case EntityModalMode.edit:
        return 'Edit';
      case EntityModalMode.create:
        return 'Create';
    }
  }
}

/// A field specific to an entity type
class EntityField {
  const EntityField({
    required this.id,
    required this.label,
    required this.builder,
  });

  /// The ID of the field (used to get/set the value)
  final String id;

  /// The label to display for the field
  final String label;

  /// Builder function that creates the field widget
  /// 
  /// Parameters:
  /// - context: The build context
  /// - mode: The current mode of the modal
  /// - entity: The current entity (null in create mode)
  final Widget Function(BuildContext context, EntityModalMode mode, dynamic entity) builder;
} 