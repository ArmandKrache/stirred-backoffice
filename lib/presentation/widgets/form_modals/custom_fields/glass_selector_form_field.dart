import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/views/glasses/glasses_notifier.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';
import 'package:stirred_backoffice/presentation/widgets/loading_placeholder.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class GlassSelectorFormField extends ConsumerStatefulWidget {
  const GlassSelectorFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final Glass? value;
  final ValueChanged<Glass?> onChanged;
  final bool enabled;

  @override
  ConsumerState<GlassSelectorFormField> createState() => _GlassSelectorFormFieldState();
}

class _GlassSelectorFormFieldState extends ConsumerState<GlassSelectorFormField> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        _searchQuery = _searchController.text;
        ref.read(glassesNotifierProvider.notifier).search(_searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showGlassSelectorDialog() {
    showDialog(
      context: context,
      builder: (context) => _GlassSelectorDialog(
        selectedGlass: widget.value,
        onGlassSelected: (glass) {
          widget.onChanged(glass);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StirText.bodyMedium(widget.label),
            if (widget.enabled)
              TextButton.icon(
                onPressed: _showGlassSelectorDialog,
                icon: const Icon(Icons.search),
                label: const Text('Select'),
              ),
          ],
        ),
        const Gap(StirSpacings.small16),
        if (widget.value == null)
          const Center(
            child: Text('No glass selected'),
          )
        else
          ListTile(
            title: Text(widget.value!.name),
            trailing: widget.enabled
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => widget.onChanged(null),
                  )
                : null,
          ),
      ],
    );
  }
}

class _GlassSelectorDialog extends ConsumerStatefulWidget {
  const _GlassSelectorDialog({
    required this.selectedGlass,
    required this.onGlassSelected,
  });

  final Glass? selectedGlass;
  final ValueChanged<Glass> onGlassSelected;

  @override
  ConsumerState<_GlassSelectorDialog> createState() => _GlassSelectorDialogState();
}

class _GlassSelectorDialogState extends ConsumerState<_GlassSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Glass? _selectedGlass;

  @override
  void initState() {
    super.initState();
    _selectedGlass = widget.selectedGlass;
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        _searchQuery = _searchController.text;
        ref.read(glassesNotifierProvider.notifier).search(_searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(StirSpacings.medium24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StirText.titleLarge('Select Glass'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Gap(StirSpacings.medium24),
            StirTextField(
              controller: _searchController,
              hint: 'Search glasses...',
              leadingIconData: Icons.search,
            ),
            const Gap(StirSpacings.medium24),
            Expanded(
              child: ref.watch(glassesNotifierProvider).when(
                loading: () => const LoadingPlaceholder(),
                error: (error, stackTrace) => ErrorPlaceholder(
                  message: error.toString(),
                  stackTrace: stackTrace,
                ),
                data: (state) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final glass = state.items[index];
                      return ListTile(
                        title: Text(glass.name),
                        selected: _selectedGlass == glass,
                        onTap: () => setState(() => _selectedGlass = glass),
                      );
                    },
                  );
                },
              ),
            ),
            const Gap(StirSpacings.medium24),
            FilledButton(
              onPressed: _selectedGlass != null
                  ? () => widget.onGlassSelected(_selectedGlass!)
                  : null,
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }
} 