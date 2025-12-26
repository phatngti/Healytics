import 'package:admin_panel/features/common/widgets/input/auto_generate_text_field.dart';
import 'package:admin_panel/features/common/widgets/input/date_pick_field.dart';
import 'package:admin_panel/features/common/widgets/input/multi_select_chip_field.dart';
import 'package:admin_panel/features/common/widgets/input/selection_field.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:flutter/material.dart';

/// Utility class containing reusable form field builders.
/// These methods can be used across multiple widgets to build consistent form fields.
class FormFieldBuilders {
  FormFieldBuilders._();

  /// Builds a text field with an auto-generate button.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [onGenerate] - Callback triggered when the auto-generate button is pressed.
  /// [controller] - Optional text controller for the field.
  /// [buttonText] - Text displayed on the auto-generate button.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  /// [isRequired] - Whether the field is required.
  static Widget buildAutoGenerateTextField(
    BuildContext context, {
    required String label,
    required VoidCallback onGenerate,
    TextEditingController? controller,
    String buttonText = 'Auto-Generate',
    String? fieldKey,
    bool isRequired = false,
    bool enabled = false,
  }) {
    return AppAutoGenerateTextField(
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      onGenerate: onGenerate,
      controller: controller,
      buttonText: buttonText,
      isRequired: isRequired,
      enabled: enabled,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

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
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
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
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
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
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      initialValue: items.first,
      onChanged: onChanged ?? (value) {},
    );
  }

  /// Builds a multi-select chip field with search functionality.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [availableOptions] - List of available options for selection.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  /// [initialValue] - Initial selected values.
  /// [searchHint] - Placeholder text for the search input.
  /// [helperText] - Helper text shown below the field.
  /// [allowCreate] - Whether to allow creating new options by typing.
  /// [onChanged] - Callback when selection changes.
  static Widget buildMultiSelectChipField(
    BuildContext context, {
    required String label,
    required List<String> availableOptions,
    String? fieldKey,
    List<String>? initialValue,
    String searchHint = 'Search...',
    String? helperText,
    bool allowCreate = true,
    String? Function(List<String>?)? validator,
    ValueChanged<List<String>>? onChanged,
    Color? chipBackgroundColor,
    Color? chipBorderColor,
    Color? chipTextColor,
  }) {
    return AppMultiSelectChipField(
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      availableOptions: availableOptions,
      initialValue: initialValue,
      searchHint: searchHint,
      helperText: helperText,
      allowCreate: allowCreate,
      validator: validator,
      onChanged: onChanged,
      chipBackgroundColor: chipBackgroundColor,
      chipBorderColor: chipBorderColor,
      chipTextColor: chipTextColor,
    );
  }

  /// Builds a chip selector field with a label and a container displaying chips.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text displayed above the field.
  /// [chips] - A list of widgets (typically chips) to display inside the container.
  /// [onTap] - Optional callback when the field is tapped.
  /// [trailing] - Optional trailing widget (defaults to expand_more icon).
  /// [emptyPlaceholder] - Placeholder text when no chips are selected.
  static Widget buildChipSelectorField(
    BuildContext context, {
    required String label,
    required List<Widget> chips,
    VoidCallback? onTap,
    Widget? trailing,
    String emptyPlaceholder = 'Select...',
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(3), blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: chips.isEmpty
                      ? Text(
                          emptyPlaceholder,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        )
                      : Wrap(spacing: 8, runSpacing: 8, children: chips),
                ),
                trailing ??
                    Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
