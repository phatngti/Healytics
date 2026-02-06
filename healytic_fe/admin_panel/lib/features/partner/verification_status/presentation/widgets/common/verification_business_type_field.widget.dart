import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verifiable_field.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Available business type options matching the API enum values.
const _availableBusinessTypes = <String>[
  'MASSAGE_THERAPY',
  'MASSAGE_REHABILITATION',
  'SPA_BEAUTY',
  'FITNESS',
  'PHARMACY',
  'DENTAL',
  'TRADITIONAL_MEDICINE',
  'PSYCHOLOGY',
  'DERMATOLOGY',
  'NUTRITION',
  'PSYCHIATRY',
];

/// Maps API enum values to human-readable display labels.
String _businessTypeLabel(String type) {
  switch (type) {
    case 'MASSAGE_THERAPY':
      return 'Massage Therapy';
    case 'MASSAGE_REHABILITATION':
      return 'Massage Rehabilitation';
    case 'SPA_BEAUTY':
      return 'Spa & Beauty';
    case 'FITNESS':
      return 'Fitness';
    case 'PHARMACY':
      return 'Pharmacy';
    case 'DENTAL':
      return 'Dental';
    case 'TRADITIONAL_MEDICINE':
      return 'Traditional Medicine';
    case 'PSYCHOLOGY':
      return 'Psychology';
    case 'DERMATOLOGY':
      return 'Dermatology';
    case 'NUTRITION':
      return 'Nutrition';
    case 'PSYCHIATRY':
      return 'Psychiatry';
    default:
      return type;
  }
}

/// A field widget for selecting business types as chips/tags.
///
/// When the field is not verified (requires update), shows selectable chips
/// for all available business types. When verified, shows read-only chips
/// matching the style in [BusinessOverviewSection].
class VerificationBusinessTypeField extends StatefulWidget {
  const VerificationBusinessTypeField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onEditStateChanged,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// Optional unique identifier for the field.
  final String? fieldId;

  /// The verification field containing value, status, and feedback.
  final VerifiedField field;

  /// Callback when the edit state changes.
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<VerificationBusinessTypeField> createState() =>
      _VerificationBusinessTypeFieldState();
}

class _VerificationBusinessTypeFieldState
    extends State<VerificationBusinessTypeField> {
  bool _isEdited = false;

  String get _fieldKey => widget.fieldId ?? widget.field.fieldKey;

  /// Gets the current business types from the field value.
  List<String> get _currentTypes {
    final value = widget.field.value;
    if (value is List) return value.cast<String>();
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }

  /// Whether the field requires an update (not verified).
  bool get _requiresUpdate => !widget.field.isVerified;

  @override
  Widget build(BuildContext context) {
    return VerifiableField(
      fieldId: _fieldKey,
      title: widget.label,
      requiresUpdate: _requiresUpdate,
      isEdited: _isEdited,
      adminFeedback: widget.field.feedback,
      child: _requiresUpdate
          ? _buildEditableChips(context)
          : _buildReadOnlyChips(context),
    );
  }

  /// Builds editable chip selection using FormBuilderField.
  Widget _buildEditableChips(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilderField<List<String>>(
      name: _fieldKey,
      initialValue: _currentTypes,
      builder: (FormFieldState<List<String>> fieldState) {
        final selectedTypes = fieldState.value ?? [];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: _isEdited
                  ? colorScheme.primary
                  : colorScheme.error.withValues(alpha: 0.5),
              width: _isEdited ? 2 : 1,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableBusinessTypes.map((type) {
              final isSelected = selectedTypes.contains(type);
              return FilterChip(
                label: Text(_businessTypeLabel(type)),
                selected: isSelected,
                onSelected: (selected) {
                  final updatedTypes = List<String>.from(selectedTypes);
                  if (selected) {
                    updatedTypes.add(type);
                  } else {
                    updatedTypes.remove(type);
                  }
                  fieldState.didChange(updatedTypes);

                  // Track edit state
                  final wasEdited = _isEdited;
                  final initialTypes = _currentTypes;
                  final isNowEdited = !_listEquals(updatedTypes, initialTypes);

                  if (wasEdited != isNowEdited) {
                    setState(() => _isEdited = isNowEdited);
                    widget.onEditStateChanged?.call(isNowEdited);
                  }
                },
                selectedColor: colorScheme.primaryContainer,
                checkmarkColor: colorScheme.onPrimaryContainer,
                labelStyle: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimens.radiusSmall,
                  side: BorderSide(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Builds read-only chip display (matching business_overview_section style).
  Widget _buildReadOnlyChips(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final types = _currentTypes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: types.isEmpty
          ? Text(
              'No business types selected',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: types.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimens.radiusSmall,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    _businessTypeLabel(tag),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  /// Compares two lists for equality regardless of order.
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}
