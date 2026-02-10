import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A simplified text input field with a label and [FormBuilderTextField].
///
/// Provides a widget-based API (as opposed to the static method in
/// [FormFieldBuilders]) for use in standalone forms or the user app.
///
/// ```dart
/// AppTextField(
///   fieldKey: 'email',
///   label: 'Email Address',
///   hintText: 'Enter your email',
///   validator: (v) => v == null || v.isEmpty ? 'Required' : null,
/// )
/// ```
///
/// See also: `FormFieldBuilders.buildTextField` for the richer variant.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  ///
  /// - [fieldKey] — Unique form field key for [FormBuilder] value retrieval.
  /// - [label] — Text displayed above the field.
  /// - [hintText] — Placeholder text inside the field.
  /// - [obscureText] — Masks input for passwords (defaults to `false`).
  /// - [controller] — Optional external [TextEditingController].
  /// - [maxLines] — Number of visible text lines (defaults to 1).
  const AppTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.initialValue,
  });

  /// Unique form field key used by [FormBuilder] to identify this field.
  final String fieldKey;

  /// Label text displayed above the input field.
  final String label;

  /// Optional external text editing controller.
  final TextEditingController? controller;

  /// Optional suffix icon widget (e.g. visibility toggle for passwords).
  final Widget? suffixIcon;

  /// Optional prefix icon widget.
  final Widget? prefixIcon;

  /// Validator function called during form validation.
  final String? Function(String?)? validator;

  /// Whether to obscure the input text (for passwords).
  final bool obscureText;

  /// Whether the field is enabled. Disabled fields are styled differently.
  final bool enabled;

  /// Whether the field is read-only (prevents edits but allows focus).
  final bool readOnly;

  /// Placeholder text shown inside the field when empty.
  final String? hintText;

  /// Callback invoked whenever the field value changes.
  final ValueChanged<String?>? onChanged;

  /// The type of keyboard to display (e.g. email, number).
  final TextInputType? keyboardType;

  /// Number of visible text lines.
  final int maxLines;

  /// Initial value to pre-populate the field with.
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        FormBuilderTextField(
          name: fieldKey,
          controller: controller,
          initialValue: initialValue,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withAlpha(100)),
            ),
          ),
        ),
      ],
    );
  }
}

/// A simplified date picker field with a label and [FormBuilderDateTimePicker].
///
/// Provides a widget-based API for date selection in standalone forms.
///
/// ```dart
/// AppDatePickField(
///   fieldKey: 'dob',
///   label: 'Date of Birth',
///   lastDate: DateTime.now(),
/// )
/// ```
class AppDatePickField extends StatelessWidget {
  /// Creates an [AppDatePickField].
  ///
  /// - [fieldKey] — Unique form field key.
  /// - [label] — Text displayed above the date picker.
  /// - [firstDate] / [lastDate] — Date range constraints.
  const AppDatePickField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.hintText,
  });

  /// Unique form field key used by [FormBuilder].
  final String fieldKey;

  /// Label text displayed above the date picker.
  final String label;

  /// Initial date value.
  final DateTime? initialValue;

  /// Earliest selectable date (defaults to 1900).
  final DateTime? firstDate;

  /// Latest selectable date (defaults to 2100).
  final DateTime? lastDate;

  /// Validator function called during form validation.
  final String? Function(DateTime?)? validator;

  /// Callback invoked when the selected date changes.
  final ValueChanged<DateTime?>? onChanged;

  /// Whether the field is enabled.
  final bool enabled;

  /// Placeholder text shown when no date is selected.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        FormBuilderDateTimePicker(
          name: fieldKey,
          initialValue: initialValue,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          inputType: InputType.date,
          enabled: enabled,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText ?? 'Select date',
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: enabled
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
