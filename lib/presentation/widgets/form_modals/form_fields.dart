import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_picker/image_picker.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

/// A form field for displaying and editing text
class TextFormField extends StatelessWidget {
  const TextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.minLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StirText.bodyMedium(label),
        const Gap(StirSpacings.small8),
        TextField(
          controller: controller,
          enabled: enabled,
          minLines: minLines,
          maxLines: minLines > 1 ? null : 1,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

/// A form field for displaying and editing images
class ImageFormField extends StatefulWidget {
  const ImageFormField({
    super.key,
    this.currentImageUrl,
    required this.onImageChanged,
    this.enabled = true,
  });

  final String? currentImageUrl;
  final Function(MultipartFile?) onImageChanged;
  final bool enabled;

  @override
  State<ImageFormField> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  String? _previewUrl;
  MultipartFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    _previewUrl = widget.currentImageUrl;
  }

  Future<void> _pickImage() async {
    if (!widget.enabled) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final blob = html.Blob([bytes], 'image/jpeg');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      setState(() {
        _previewUrl = url;
        _selectedFile = MultipartFile.fromBytes(
          'picture',
          bytes,
          filename: image.name,
          contentType: MediaType('image', 'jpeg'),
        );
      });

      widget.onImageChanged(_selectedFile);
    }
  }

  void _removeImage() {
    if (_previewUrl != null) {
      html.Url.revokeObjectUrl(_previewUrl!);
    }
    setState(() {
      _previewUrl = null;
      _selectedFile = null;
    });
    widget.onImageChanged(null);
  }

  @override
  void dispose() {
    if (_previewUrl != null) {
      html.Url.revokeObjectUrl(_previewUrl!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StirText.bodyMedium('Image'),
        const Gap(StirSpacings.small8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: _previewUrl != null
              ? Stack(
                  children: [
                    Center(
                      child: Image.network(
                        _previewUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error_outline),
                          );
                        },
                      ),
                    ),
                    if (widget.enabled)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _pickImage,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _removeImage,
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              : widget.enabled
                  ? Center(
                      child: TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add Image'),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
        ),
      ],
    );
  }
}

/// A form field for displaying and editing numbers
class NumberFormField extends StatelessWidget {
  const NumberFormField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StirText.bodyMedium(label),
        const Gap(StirSpacings.small8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
} 