import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verifiable_field.widget.dart';
import 'package:flutter/material.dart';

/// Common verification form field widgets for the verification status feature.
///
/// Provides reusable field components with verification status indicators
/// that show which fields need updates and display admin feedback.

/// Text field with verification status indicator.
///
/// Uses [VerifiableField] wrapper to display label, status badge, and feedback.
/// When [field.isVerified] is false, shows an editable text field or
/// dropdown (if [isDropdown] is true) with error border.
/// Otherwise, shows a read-only container with the value.
class VerificationTextField extends StatelessWidget {
  const VerificationTextField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onChanged,
    this.isEdited = false,
    this.isDropdown = false,
    this.dropdownItems,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// Optional unique identifier for the field (defaults to label-derived key).
  final String? fieldId;

  /// The verification field containing value, update status, and feedback.
  final VerifiedField field;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Whether the user has edited this field's value.
  final bool isEdited;

  /// Whether to show a dropdown instead of a text field when editable.
  final bool isDropdown;

  /// List of items to show in the dropdown (required when [isDropdown] is true).
  final List<String>? dropdownItems;

  String get _fieldKey => fieldId ?? label.toLowerCase().replaceAll(' ', '_');

  /// Gets the display value from the field value.
  String get _displayValue {
    final value = field.value;
    if (value is String) return value;
    if (value is Map) return value['name']?.toString() ?? value.toString();
    if (value is List) return value.join(', ');
    return value.toString();
  }

  /// Whether the field requires an update (not verified).
  bool get _requiresUpdate => !field.isVerified;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return VerifiableField(
      fieldId: _fieldKey,
      title: label,
      requiresUpdate: _requiresUpdate,
      isEdited: isEdited,
      adminFeedback: field.feedback,
      child: _buildFieldContent(
        context,
        colorScheme: colorScheme,
        textTheme: textTheme,
        isEditable: _requiresUpdate,
      ),
    );
  }

  Widget _buildFieldContent(
    BuildContext context, {
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required bool isEditable,
  }) {
    // Determine border color based on edit state
    final borderColor = isEdited ? colorScheme.primary : colorScheme.error;

    if (isEditable) {
      if (isDropdown && dropdownItems != null) {
        return FormFieldBuilders.buildDropdownField(
          context,
          label: '',
          fieldKey: _fieldKey,
          items: dropdownItems!,
          initialValue: dropdownItems!.contains(_displayValue)
              ? _displayValue
              : null,
          onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
          hintText: field.feedback,
          enabled: isEditable,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        );
      }
      return FormFieldBuilders.buildTextField(
        context,
        label: '',
        fieldKey: _fieldKey,
        initialValue: _displayValue,
        onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
        hintText: field.feedback,
        enabled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      );
    }

    // Read-only display
    return Opacity(
      opacity: 0.6,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _displayValue,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (isDropdown)
              Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Read-only text field with optional edit indicator.
///
/// When [requiresUpdate] is true, displays an editable text field.
/// Otherwise, displays a read-only container with the value.
class VerificationReadOnlyTextField extends StatelessWidget {
  const VerificationReadOnlyTextField({
    required this.label,
    this.value,
    this.requiresUpdate = false,
    this.adminFeedback,
    this.onChanged,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The value to display.
  final String? value;

  /// Whether the field requires an update (makes it editable).
  final bool requiresUpdate;

  /// Admin feedback to show as hint when editable.
  final String? adminFeedback;

  /// Callback when the field value changes (when editable).
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: requiresUpdate
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (requiresUpdate) ...[
              const SizedBox(width: 6),
              Icon(Icons.edit_outlined, size: 14, color: colorScheme.error),
            ],
          ],
        ),
        const SizedBox(height: 6),
        if (requiresUpdate)
          FormFieldBuilders.buildTextField(
            context,
            label: '',
            fieldKey: label.toLowerCase().replaceAll(' ', '_'),
            initialValue: value,
            onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
            hintText: adminFeedback,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value ?? 'N/A',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        // Feedback message display
        if (adminFeedback != null && adminFeedback!.isNotEmpty)
          _FeedbackMessage(feedback: adminFeedback!),
      ],
    );
  }
}

/// Editable or read-only field based on [VerifiedField.isVerified].
///
/// Uses [VerifiableField] wrapper for consistent status display.
class VerificationEditableField extends StatelessWidget {
  const VerificationEditableField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onChanged,
    this.isEdited = false,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// Optional unique identifier for the field.
  final String? fieldId;

  /// The verification field containing value and update status.
  final VerifiedField field;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Whether the user has edited this field's value.
  final bool isEdited;

  String get _fieldKey => fieldId ?? label.toLowerCase().replaceAll(' ', '_');

  String get _displayValue {
    final value = field.value;
    if (value is String) return value;
    return value.toString();
  }

  bool get _requiresUpdate => !field.isVerified;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresAction = _requiresUpdate;
    final borderColor = isEdited ? colorScheme.primary : colorScheme.error;

    return VerifiableField(
      fieldId: _fieldKey,
      title: label,
      requiresUpdate: _requiresUpdate,
      isEdited: isEdited,
      adminFeedback: field.feedback,
      child: requiresAction
          ? FormFieldBuilders.buildTextField(
              context,
              label: '',
              fieldKey: _fieldKey,
              initialValue: _displayValue,
              onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
              hintText: field.feedback,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _displayValue,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }
}

/// Dropdown-styled field that can be editable based on verification status.
///
/// Uses [VerifiableField] wrapper for consistent status display.
class VerificationDropdownField extends StatelessWidget {
  const VerificationDropdownField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onChanged,
    this.isEdited = false,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// Optional unique identifier for the field.
  final String? fieldId;

  /// The verification field containing value and update status.
  final VerifiedField field;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Whether the user has edited this field's value.
  final bool isEdited;

  String get _fieldKey => fieldId ?? label.toLowerCase().replaceAll(' ', '_');

  String get _displayValue {
    final value = field.value;
    if (value is String) return value;
    return value.toString();
  }

  bool get _requiresUpdate => !field.isVerified;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresAction = _requiresUpdate;
    final borderColor = isEdited ? colorScheme.primary : colorScheme.error;

    return VerifiableField(
      fieldId: _fieldKey,
      title: label,
      requiresUpdate: _requiresUpdate,
      isEdited: isEdited,
      adminFeedback: field.feedback,
      child: requiresAction
          ? FormFieldBuilders.buildTextField(
              context,
              label: '',
              fieldKey: _fieldKey,
              initialValue: _displayValue,
              onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
              hintText: field.feedback,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: Icon(Icons.expand_more, color: borderColor, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _displayValue,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
    );
  }
}

/// Read-only field displaying a label and value with optional feedback.
class VerificationReadOnlyField extends StatelessWidget {
  const VerificationReadOnlyField({
    required this.label,
    required this.value,
    this.adminFeedback,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The value to display.
  final String value;

  /// Optional admin feedback message to display.
  final String? adminFeedback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // Feedback message display
        if (adminFeedback != null && adminFeedback!.isNotEmpty)
          _FeedbackMessage(feedback: adminFeedback!),
      ],
    );
  }
}

/// Reusable feedback message widget for displaying admin feedback.
class _FeedbackMessage extends StatelessWidget {
  const _FeedbackMessage({required this.feedback});

  final String feedback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: colorScheme.error, width: 3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: 16,
              color: colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                feedback,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small status badge showing verification status text.
class VerificationStatusBadge extends StatelessWidget {
  const VerificationStatusBadge({
    required this.label,
    required this.color,
    super.key,
  });

  /// The badge label text.
  final String label;

  /// The badge color.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Small action required badge with icon.
class VerificationActionRequiredBadge extends StatelessWidget {
  const VerificationActionRequiredBadge({required this.color, super.key});

  /// The badge color.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            'Action Required',
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
