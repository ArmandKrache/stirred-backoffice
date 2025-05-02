import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// Base modal for entity operations (view, edit, create)
abstract class BaseEntityModal<T> extends StatefulWidget {
  const BaseEntityModal({
    super.key,
    required this.mode,
    this.entity,
    this.onSave,
    this.onDelete,
  });

  /// The mode of the modal (view, edit, or create)
  final EntityModalMode mode;

  /// The entity to display/edit (null for create mode)
  final T? entity;

  /// Callback when the save button is pressed
  final Function(dynamic)? onSave;

  /// Callback when the delete button is pressed
  final VoidCallback? onDelete;

  @override
  State<BaseEntityModal<T>> createState() => BaseEntityModalState<T>();
}

/// Base state class for entity modals
class BaseEntityModalState<T> extends State<BaseEntityModal<T>> {
  /// The current mode of the modal
  EntityModalMode get currentMode => _currentMode;
  late EntityModalMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
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
              buildContent(context),
              const Gap(StirSpacings.medium24),
              buildActions(context, setState),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the content of the modal
  Widget buildContent(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// Build the action buttons
  Widget buildActions(BuildContext context, StateSetter setState) {
    return Row(
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
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ] else if (_currentMode == EntityModalMode.edit || _currentMode == EntityModalMode.create) ...[
          TextButton(
            onPressed: () {
              if (_currentMode == EntityModalMode.edit) {
                setState(() {
                  _currentMode = EntityModalMode.view;
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
          ),
          const Gap(StirSpacings.small16),
          FilledButton(
            onPressed: handleSave,
            child: const Text('Save'),
          ),
        ],
      ],
    );
  }

  void handleSave() {
    if (widget.onSave == null) return;
    if (_currentMode == EntityModalMode.create) {
      widget.onSave!(null);
    } else if (_currentMode == EntityModalMode.edit && widget.entity != null) {
      widget.onSave!(widget.entity!);
    }
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