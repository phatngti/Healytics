import 'dart:developer';

import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Form field keys for the add service tag dialog.
class _FieldKeys {
  static const name = 'tag_name';
  static const description = 'tag_description';
  static const sortOrder = 'tag_sort_order';
}

/// Dialog for creating a new service tag.
///
/// Displays a centered form with fields matching the
/// [CreateServiceTagDto] spec: name, description, colorValue,
/// isActive, and sortOrder.
class AddServiceTagDialog extends ConsumerStatefulWidget {
  const AddServiceTagDialog({super.key});

  @override
  ConsumerState<AddServiceTagDialog> createState() =>
      _AddServiceTagDialogState();
}

class _AddServiceTagDialogState extends ConsumerState<AddServiceTagDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;
  bool _isActive = true;
  Color _selectedColor = const Color(0xFF6366F1);

  /// Preset color palette for quick selection.
  static const _presetColors = <Color>[
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF59E0B), // Amber
    Color(0xFF3B82F6), // Blue
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Violet
    Color(0xFF10B981), // Emerald
    Color(0xFFF97316), // Orange
    Color(0xFF06B6D4), // Cyan
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppDimens.radiusMedium),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, minWidth: 360),
        child: Padding(
          padding: AppDimens.paddingAllLarge,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colorScheme, textTheme),
                AppDimens.verticalMedium,
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNameField(context),
                        AppDimens.verticalMedium,
                        _buildDescriptionField(context),
                        AppDimens.verticalMedium,
                        _buildColorField(colorScheme, textTheme),
                        AppDimens.verticalMedium,
                        _buildSortOrderField(context),
                        AppDimens.verticalMedium,
                        _buildActiveToggle(colorScheme, textTheme),
                      ],
                    ),
                  ),
                ),
                AppDimens.verticalLarge,
                _buildActions(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          padding: AppDimens.paddingAllSmall,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: AppDimens.radiusSmall,
          ),
          child: Icon(Icons.label, color: colorScheme.onPrimaryContainer),
        ),
        AppDimens.horizontalMedium,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Tag',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Add a tag for categorizing services',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return FormFieldBuilders.buildTextField(
      context,
      label: 'Name',
      fieldKey: _FieldKeys.name,
      hintText: 'e.g. Facial Treatment',
      isRequired: true,
      validator: (value) {
        if (value == null || value.toString().trim().isEmpty) {
          return 'Tag name is required';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return FormFieldBuilders.buildTextField(
      context,
      label: 'Description',
      fieldKey: _FieldKeys.description,
      hintText: 'A brief description of this tag...',
      maxLines: 3,
    );
  }

  Widget _buildColorField(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            'COLOR',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetColors.map((color) {
            final isSelected = _selectedColor.toARGB32() == color.toARGB32();
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: colorScheme.onSurface, width: 2.5)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withAlpha(100),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortOrderField(BuildContext context) {
    return FormFieldBuilders.buildTextField(
      context,
      label: 'Sort Order',
      fieldKey: _FieldKeys.sortOrder,
      hintText: '0',
      initialValue: '0',
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildActiveToggle(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACTIVE',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tag will be available for selection',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Switch.adaptive(
          value: _isActive,
          onChanged: (val) => setState(() => _isActive = val),
          activeTrackColor: colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildActions(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          buttonType: ButtonType.outline,
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppDimens.horizontalSmall,
        AppButton(
          buttonType: ButtonType.elevated,
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final values = _formKey.currentState!.value;

      final sortOrder =
          int.tryParse(values[_FieldKeys.sortOrder]?.toString() ?? '0') ?? 0;

      final request = CreateServiceTagRequest(
        name: values[_FieldKeys.name] as String,
        description: (values[_FieldKeys.description] as String?) ?? '',
        colorValue: _selectedColor.toARGB32(),
        isActive: _isActive,
        sortOrder: sortOrder,
      );

      await ref.read(serviceTagProvider.notifier).createServiceTag(request);

      if (!mounted) return;

      ToastContext.showToast(
        context,
        ToastType.success,
        'Tag "${request.name}" created successfully',
      );

      Navigator.of(context).pop(true);
    } catch (e, st) {
      log('Failed to create service tag', error: e, stackTrace: st);
      if (!mounted) return;

      ToastContext.showToast(
        context,
        ToastType.error,
        'Failed to create tag: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
