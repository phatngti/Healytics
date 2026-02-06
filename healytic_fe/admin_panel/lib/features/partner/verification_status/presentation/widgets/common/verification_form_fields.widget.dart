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
class VerificationTextField extends StatefulWidget {
  const VerificationTextField({
    required this.label,
    required this.field,
    this.fieldId,
    this.isDropdown = false,
    this.dropdownItems,
    this.onDropdownChanged,
    this.onEditStateChanged,
    super.key,
  });

  /// The label text displayed above the field.
  final String label;

  /// Optional unique identifier for the field (defaults to label-derived key).
  final String? fieldId;

  /// The verification field containing value, update status, and feedback.
  final VerifiedField field;

  /// Whether to show a dropdown instead of a text field when editable.
  final bool isDropdown;

  /// List of items to show in the dropdown (required when [isDropdown] is true).
  final List<dynamic>? dropdownItems;

  /// Callback when dropdown value changes. Returns the selected CustomDropdownItem.
  final ValueChanged<CustomDropdownItem>? onDropdownChanged;

  /// Callback when the edit state changes (edited vs not edited).
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<VerificationTextField> createState() => _VerificationTextFieldState();
}

class _VerificationTextFieldState extends State<VerificationTextField> {
  bool _isEdited = false;

  String get _fieldKey => widget.fieldId ?? widget.field.fieldKey;

  /// Gets the display value from the field value.
  String get _displayValue {
    final value = widget.field.value;
    if (value is String) return value;
    if (value is Map) return value['name']?.toString() ?? value.toString();
    if (value is List) return value.join(', ');
    return value.toString();
  }

  /// Whether the field requires an update (not verified).
  bool get _requiresUpdate => !widget.field.isVerified;

  void _handleEditStateChanged(bool isEdited) {
    if (_isEdited != isEdited) {
      setState(() => _isEdited = isEdited);
      widget.onEditStateChanged?.call(isEdited);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return VerifiableField(
      fieldId: _fieldKey,
      title: widget.label,
      requiresUpdate: _requiresUpdate,
      isEdited: _isEdited,
      adminFeedback: widget.field.feedback,
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
    if (isEditable) {
      if (widget.isDropdown && widget.dropdownItems != null) {
        final dynamic validItem = widget.dropdownItems!.firstWhere(
          (item) => item.label == _displayValue,
          orElse: () => CustomDropdownItem(value: '', label: ''),
        );

        return _EditableDropdownField(
          fieldKey: _fieldKey,
          initialValue: validItem,
          items: widget.dropdownItems as List<CustomDropdownItem>,
          hintText: widget.label,
          onChanged: widget.onDropdownChanged,
          onEditStateChanged: _handleEditStateChanged,
        );
      }
      return _EditableTextField(
        fieldKey: _fieldKey,
        initialValue: _displayValue,
        hintText: widget.label,
        onEditStateChanged: _handleEditStateChanged,
      );
    }

    // Read-only display
    return _ReadOnlyField(
      value: _displayValue,
      showDropdownIcon: widget.isDropdown,
      applyOpacity: true,
    );
  }
}

/// Private reusable editable text field with verification styling.
///
/// Automatically tracks edit state by comparing current value against initial.
class _EditableTextField extends StatefulWidget {
  const _EditableTextField({
    required this.fieldKey,
    required this.initialValue,
    this.hintText,
    this.onChanged,
    this.onEditStateChanged,
  });

  final String fieldKey;
  final String initialValue;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  /// Callback when the edit state changes (edited vs not edited).
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<_EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<_EditableTextField> {
  bool _isEdited = false;

  void _handleValueChanged(dynamic newValue) {
    final value = (newValue as String?) ?? '';

    // Determine if value differs from initial
    final wasEdited = _isEdited;
    final isNowEdited = value != widget.initialValue;

    if (wasEdited != isNowEdited) {
      setState(() => _isEdited = isNowEdited);
      widget.onEditStateChanged?.call(isNowEdited);
    }

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final borderColor = _isEdited ? colorScheme.primary : colorScheme.error;

    return FormFieldBuilders.buildTextField(
      context,
      label: '',
      fieldKey: widget.fieldKey,
      initialValue: widget.initialValue,
      onChanged: _handleValueChanged,
      hintText: widget.hintText,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    );
  }
}

class CustomDropdownItem {
  final String value;
  final String label;

  CustomDropdownItem({required this.value, required this.label});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomDropdownItem && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'CustomDropdownItem(value: $value, label: $label)';
  }
}

/// Private reusable editable dropdown field with verification styling.
///
/// Automatically tracks edit state by comparing current value against initial.
class _EditableDropdownField extends StatefulWidget {
  const _EditableDropdownField({
    required this.fieldKey,
    required this.items,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.onEditStateChanged,
  });

  final String fieldKey;
  final List<CustomDropdownItem> items;
  final CustomDropdownItem? initialValue;
  final String? hintText;
  final ValueChanged<CustomDropdownItem>? onChanged;

  /// Callback when the edit state changes (edited vs not edited).
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<_EditableDropdownField> createState() => _EditableDropdownFieldState();
}

class _EditableDropdownFieldState extends State<_EditableDropdownField> {
  bool _isEdited = false;

  void _handleValueChanged(CustomDropdownItem? newValue) {
    if (newValue == null) return;

    // Determine if value differs from initial
    final wasEdited = _isEdited;
    final isNowEdited = newValue != widget.initialValue;

    if (wasEdited != isNowEdited) {
      setState(() => _isEdited = isNowEdited);
      widget.onEditStateChanged?.call(isNowEdited);
    }

    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = _isEdited ? colorScheme.primary : colorScheme.error;

    return FormFieldBuilders.buildCustomDropdownField<CustomDropdownItem>(
      context,
      label: '',
      fieldKey: widget.fieldKey,
      items: widget.items
          .map(
            (item) => DropdownMenuItem<CustomDropdownItem>(
              value: item,
              child: Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      initialValue: widget.initialValue,
      onChanged: _handleValueChanged,
      hintText: widget.hintText,
      enabled: true,
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
    );
  }
}

/// Private reusable read-only field container.
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.value,
    this.showDropdownIcon = false,
    this.applyOpacity = false,
  });

  final String value;
  final bool showDropdownIcon;
  final bool applyOpacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final container = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (showDropdownIcon)
            Icon(
              Icons.expand_more,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
        ],
      ),
    );

    if (applyOpacity) {
      return Opacity(opacity: 0.6, child: container);
    }
    return container;
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
/// Automatically tracks edit state internally.
class VerificationEditableField extends StatefulWidget {
  const VerificationEditableField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onChanged,
    this.onEditStateChanged,
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

  /// Callback when the edit state changes (edited vs not edited).
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<VerificationEditableField> createState() =>
      _VerificationEditableFieldState();
}

class _VerificationEditableFieldState extends State<VerificationEditableField> {
  bool _isEdited = false;

  String get _fieldKey =>
      widget.fieldId ?? widget.label.toLowerCase().replaceAll(' ', '_');

  String get _displayValue {
    final value = widget.field.value;
    if (value is String) return value;
    return value.toString();
  }

  bool get _requiresUpdate => !widget.field.isVerified;

  void _handleEditStateChanged(bool isEdited) {
    if (_isEdited != isEdited) {
      setState(() => _isEdited = isEdited);
      widget.onEditStateChanged?.call(isEdited);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VerifiableField(
      fieldId: _fieldKey,
      title: widget.label,
      requiresUpdate: _requiresUpdate,
      isEdited: _isEdited,
      adminFeedback: widget.field.feedback,
      child: _requiresUpdate
          ? _EditableTextField(
              fieldKey: _fieldKey,
              initialValue: _displayValue,
              hintText: widget.field.feedback,
              onChanged: widget.onChanged,
              onEditStateChanged: _handleEditStateChanged,
            )
          : _ReadOnlyField(value: _displayValue),
    );
  }
}

/// Dropdown-styled field that can be editable based on verification status.
///
/// Uses [VerifiableField] wrapper for consistent status display.
/// Automatically tracks edit state internally.
class VerificationDropdownField extends StatefulWidget {
  const VerificationDropdownField({
    required this.label,
    required this.field,
    this.fieldId,
    this.onChanged,
    this.onEditStateChanged,
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

  /// Callback when the edit state changes (edited vs not edited).
  final ValueChanged<bool>? onEditStateChanged;

  @override
  State<VerificationDropdownField> createState() =>
      _VerificationDropdownFieldState();
}

class _VerificationDropdownFieldState extends State<VerificationDropdownField> {
  bool _isEdited = false;

  String get _fieldKey =>
      widget.fieldId ?? widget.label.toLowerCase().replaceAll(' ', '_');

  String get _displayValue {
    final value = widget.field.value;
    if (value is String) return value;
    return value.toString();
  }

  bool get _requiresUpdate => !widget.field.isVerified;

  void _handleEditStateChanged(bool isEdited) {
    if (_isEdited != isEdited) {
      setState(() => _isEdited = isEdited);
      widget.onEditStateChanged?.call(isEdited);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VerifiableField(
      fieldId: _fieldKey,
      title: widget.label,
      requiresUpdate: _requiresUpdate,
      isEdited: _isEdited,
      adminFeedback: widget.field.feedback,
      child: _requiresUpdate
          ? _EditableTextField(
              fieldKey: _fieldKey,
              initialValue: _displayValue,
              hintText: widget.field.feedback,
              onChanged: widget.onChanged,
              onEditStateChanged: _handleEditStateChanged,
            )
          : _ReadOnlyField(value: _displayValue, showDropdownIcon: true),
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
