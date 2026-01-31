import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Common verification form field widgets for the verification status feature.
///
/// Provides reusable field components with verification status indicators
/// that show which fields need updates and display admin feedback.

/// Text field with verification status indicator.
///
/// Displays a label with a required indicator (*) and status badge.
/// When [field.requiresUpdate] is true, shows an editable text field or
/// dropdown (if [isDropdown] is true) with error border.
/// Otherwise, shows a read-only container with the value.
class VerificationTextField extends StatelessWidget {
  const VerificationTextField({
    required this.label,
    required this.field,
    this.hintText,
    this.onChanged,
    this.isDropdown = false,
    this.dropdownItems,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The verification field containing value, update status, and feedback.
  final VerificationStringField field;

  /// Hint text shown when the field is editable.
  final String? hintText;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Whether to show a dropdown instead of a text field when editable.
  final bool isDropdown;

  /// List of items to show in the dropdown (required when [isDropdown] is true).
  final List<String>? dropdownItems;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    final isEditable = field.requiresUpdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with status indicator
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
            ),
            const Spacer(),
            if (field.requiresUpdate)
              VerificationStatusBadge(
                label: 'UPDATE NEEDED',
                color: colorScheme.error,
              )
            else
              Icon(Icons.check_circle, size: 16, color: successColor),
          ],
        ),
        const SizedBox(height: 8),

        // Text field or Dropdown
        if (isEditable)
          if (isDropdown && dropdownItems != null)
            FormFieldBuilders.buildDropdownField(
              context,
              label: '',
              fieldKey: label.toLowerCase().replaceAll(' ', '_'),
              items: dropdownItems!,
              initialValue: dropdownItems!.contains(field.displayValue)
                  ? field.displayValue
                  : null,
              onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
              hintText: hintText ?? field.adminFeedback,
              enabled: isEditable,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            )
          else
            FormFieldBuilders.buildTextField(
              context,
              label: '',
              fieldKey: label.toLowerCase().replaceAll(' ', '_'),
              initialValue: field.displayValue,
              onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
              hintText: hintText ?? field.adminFeedback,
              enabled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            )
        else
          Opacity(
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
                      field.displayValue,
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
          ),

        // Admin feedback
        if (field.adminFeedback != null && field.adminFeedback!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: colorScheme.error),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  field.adminFeedback!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
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
      ],
    );
  }
}

/// Editable or read-only field based on [VerificationStringField.requiresUpdate].
///
/// Displays action required badge when update is needed and success
/// checkmark when verified.
class VerificationEditableField extends StatelessWidget {
  const VerificationEditableField({
    required this.label,
    required this.field,
    this.onChanged,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The verification field containing value and update status.
  final VerificationStringField field;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresAction = field.requiresUpdate;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with action badge
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (requiresAction)
              VerificationActionRequiredBadge(color: colorScheme.error)
            else
              Icon(Icons.check_circle, size: 16, color: successColor),
          ],
        ),
        const SizedBox(height: 6),
        // Field container - editable when requires action
        if (requiresAction)
          FormFieldBuilders.buildTextField(
            context,
            label: '',
            fieldKey: label.toLowerCase().replaceAll(' ', '_'),
            initialValue: field.value,
            onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
            hintText: field.adminFeedback,
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
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
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
              field.value,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

/// Dropdown-styled field that can be editable based on verification status.
///
/// Shows a dropdown chevron icon and supports editing when update is required.
class VerificationDropdownField extends StatelessWidget {
  const VerificationDropdownField({
    required this.label,
    required this.field,
    this.onChanged,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The verification field containing value and update status.
  final VerificationStringField field;

  /// Callback when the field value changes.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresAction = field.requiresUpdate;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with action badge
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (requiresAction)
              VerificationActionRequiredBadge(color: colorScheme.error)
            else
              Icon(Icons.check_circle, size: 16, color: successColor),
          ],
        ),
        const SizedBox(height: 8),
        // Field container - editable when requires action
        if (requiresAction)
          FormFieldBuilders.buildTextField(
            context,
            label: '',
            fieldKey: label.toLowerCase().replaceAll(' ', '_'),
            initialValue: field.value,
            onChanged: onChanged != null ? (v) => onChanged!(v ?? '') : null,
            hintText: field.adminFeedback,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: Icon(
              Icons.expand_more,
              color: colorScheme.error,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          )
        else
          Container(
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
                    field.value,
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
      ],
    );
  }
}

/// Read-only field displaying a label and value.
class VerificationReadOnlyField extends StatelessWidget {
  const VerificationReadOnlyField({
    required this.label,
    required this.value,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// The value to display.
  final String value;

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
      ],
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
