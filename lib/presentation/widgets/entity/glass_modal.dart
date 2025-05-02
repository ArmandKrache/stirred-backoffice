import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/entity/base_entity_modal.dart';
import 'package:stirred_backoffice/presentation/widgets/entity/form_fields.dart' as custom;
import 'package:stirred_common_domain/stirred_common_domain.dart';

class GlassModal extends BaseEntityModal<Glass> {
  const GlassModal({
    super.key,
    required super.mode,
    required super.entity,
    required super.onSave,
    super.onDelete,
  });

  @override
  BaseEntityModalState<Glass> createState() => GlassModalState();
}

class GlassModalState extends BaseEntityModalState<Glass> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  MultipartFile? _selectedImage;

  MultipartFile? get selectedImage => _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity?.name ?? '');
    _descriptionController = TextEditingController(text: widget.entity?.description ?? '');
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

    if (currentMode == EntityModalMode.create) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image is required')),
        );
        return;
      }

      final request = GlassesCreateRequest(
        name: _nameController.text,
        description: _descriptionController.text,
        picture: _selectedImage!,
      );

      widget.onSave!(request);
    } else if (currentMode == EntityModalMode.edit) {
      final request = GlassPatchRequest(
        id: widget.entity!.id,
        name: _nameController.text,
        description: _descriptionController.text,
        picture: _selectedImage,
      );

      widget.onSave!(request);
    }
  }
} 