import 'package:admin_panel/features/common/widgets/input/date_pick_field.dart';
import 'package:admin_panel/features/common/widgets/input/selection_field.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:flutter/material.dart';

/// Utility class containing reusable form field builders.
/// These methods can be used across multiple widgets to build consistent form fields.
class FormFieldBuilders {
  FormFieldBuilders._();

  /// Builds a text field with consistent styling.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [placeholder] - The hint/placeholder text.
  /// [isRequired] - Whether the field is required.
  /// [prefixIcon] - Optional icon to display at the start of the field.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label or placeholder.
  static Widget buildTextField(
    BuildContext context, {
    required String label,
    required String placeholder,
    bool isRequired = false,
    IconData? prefixIcon,
    String? fieldKey,
  }) {
    // Handle empty label for fieldKey generation
    final generatedFieldKey =
        fieldKey ??
        (label.isNotEmpty
            ? label.toLowerCase().replaceAll(' ', '_')
            : 'field_${placeholder.toLowerCase().replaceAll(' ', '_')}');

    return AppTextField(
      fieldKey: generatedFieldKey,
      label: label,
      hintText: placeholder,
      isRequired: isRequired,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
    );
  }

  /// Builds a date picker field with consistent styling.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [hintText] - Optional hint/placeholder text.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  static Widget buildDateField(
    BuildContext context, {
    required String label,
    String? hintText,
    String? fieldKey,
  }) {
    return AppDatePickField(
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Builds a dropdown selection field with consistent styling.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [items] - The list of string items to display in the dropdown.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  /// [onChanged] - Optional callback when selection changes.
  static Widget buildDropdownField(
    BuildContext context, {
    required String label,
    required List<String> items,
    String? fieldKey,
    ValueChanged<String?>? onChanged,
  }) {
    return AppSelectionField<String>(
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      initialValue: items.first,
      onChanged: onChanged ?? (value) {},
    );
  }
}
