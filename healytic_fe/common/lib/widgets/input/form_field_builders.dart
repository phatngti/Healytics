import 'package:common/widgets/button/button.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:convert';
import 'package:common/widgets/quill.dart';

part 'auto_generate_text_field.dart';
part 'date_pick_field.dart';
part 'multi_select_chip_field.dart';
part 'selection_field.dart';
part 'text_field.dart';
part 'multi_select_popover_field.dart';
part 'quill_editor_field.dart';

/// Factory class providing consistent, styled form fields for use across
/// the application.
///
/// All methods are static builders that return widget instances of internal
/// `part` classes. Each method accepts a [BuildContext] (for theme access)
/// plus named parameters for customization.
///
/// Available builders:
/// - [buildTextField] — Standard text input
/// - [buildAutoGenerateTextField] — Text input with auto-generate button
/// - [buildDateField] — Date picker
/// - [buildDropdownField] — String dropdown
/// - [buildCustomDropdownField] — Generic typed dropdown
/// - [buildMultiSelectChipField] — Multi-select with inline chips & search
/// - [buildChipSelectorField] — Chip container with tap handler
/// - [buildMultiSelectPopoverField] — Multi-select dialog picker
/// - [buildQuillEditor] — Rich-text editor
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
    TextStyle? labelStyle,
    String? hintText,
    double? width,
    double? height,
    bool uppercaseLabel = true,
    String? initialValue,
    String? Function(dynamic)? validator,
    Key? widgetKey,
  }) {
    return _AppAutoGenerateTextField(
      key: widgetKey,
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      onGenerate: onGenerate,
      controller: controller,
      buttonText: buttonText,
      isRequired: isRequired,
      enabled: enabled,
      labelStyle:
          labelStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
      hintText: hintText,
      width: width,
      height: height,
      uppercaseLabel: uppercaseLabel,
      initialValue: initialValue,
      validator: validator,
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
    String? hintText,
    bool? isRequired,
    IconData? prefixIcon,
    String? fieldKey,
    Widget? suffixIcon,
    Widget? suffix,
    String? Function(dynamic)? validator,
    bool obscureText = false,
    TextEditingController? controller,
    VoidCallback? onEditingComplete,
    ValueChanged<dynamic>? onChanged,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    String? initialValue,
    TextStyle? labelStyle,
    OutlineInputBorder? border,
    OutlineInputBorder? enabledBorder,
    OutlineInputBorder? disabledBorder,
    OutlineInputBorder? focusedBorder,
    OutlineInputBorder? errorBorder,
    OutlineInputBorder? hoverBorder,
    TextInputType? keyboardType,
    int? maxLines,
    TextStyle? style,
    EdgeInsetsGeometry? contentPadding,
    bool uppercaseLabel = true,
    double? width,
    double? height,
    Key? widgetKey,
  }) {
    // Handle empty label for fieldKey generation
    final generatedFieldKey =
        fieldKey ??
        (label.isNotEmpty
            ? label.toLowerCase().replaceAll(' ', '_')
            : 'field_${(hintText ?? '').toLowerCase().replaceAll(' ', '_')}');

    return _AppTextField(
      key: widgetKey,
      fieldKey: generatedFieldKey,
      label: label,
      labelStyle:
          labelStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
      hintText: hintText,
      isRequired: isRequired,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
      suffixIcon: suffixIcon,
      suffix: suffix,
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      initialValue: initialValue,
      border: border,
      enabledBorder: enabledBorder,
      disabledBorder: disabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      hoverBorder: hoverBorder,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: style,
      contentPadding: contentPadding,
      uppercaseLabel: uppercaseLabel,
      width: width,
      height: height,
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
    bool enabled = true,
    bool isRequired = false,
    String? Function(dynamic)? validator,
    Key? widgetKey,
  }) {
    return _AppDatePickField(
      key: widgetKey,
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      enabled: enabled,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      isRequired: isRequired,
      validator: validator,
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
    String? Function(String?)? validator,
    bool enabled = true,
    String? initialValue,
    TextStyle? labelStyle,
    OutlineInputBorder? border,
    OutlineInputBorder? enabledBorder,
    OutlineInputBorder? disabledBorder,
    OutlineInputBorder? focusedBorder,
    OutlineInputBorder? errorBorder,
    String? hintText,
    double? width,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? style,
    Widget? icon,
    bool isRequired = false,
    bool uppercaseLabel = true,
    Key? widgetKey,
  }) {
    return _AppSelectionField<String>(
      key: widgetKey,
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      labelStyle:
          labelStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
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
      initialValue: initialValue,
      onChanged: onChanged ?? (value) {},
      validator: validator,
      enabled: enabled,
      border: border,
      enabledBorder: enabledBorder,
      disabledBorder: disabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      hintText: hintText,
      width: width,
      height: height,
      contentPadding: contentPadding,
      style: style,
      icon: icon,
      isRequired: isRequired,
      uppercaseLabel: uppercaseLabel,
    );
  }

  /// Builds a dropdown selection field with custom items.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [items] - The list of dropdown items to display.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  /// [onChanged] - Optional callback when selection changes.
  static Widget buildCustomDropdownField<T>(
    BuildContext context, {
    required String label,
    required List<DropdownMenuItem<T>> items,
    String? fieldKey,
    ValueChanged<T?>? onChanged,
    String? Function(T?)? validator,
    bool enabled = true,
    T? initialValue,
    TextStyle? labelStyle,
    OutlineInputBorder? border,
    OutlineInputBorder? enabledBorder,
    OutlineInputBorder? disabledBorder,
    OutlineInputBorder? focusedBorder,
    OutlineInputBorder? errorBorder,
    String? hintText,
    double? width,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? style,
    Widget? icon,
    bool isRequired = false,
    bool uppercaseLabel = true,
    Key? widgetKey,
  }) {
    return _AppSelectionField<T>(
      key: widgetKey,
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      labelStyle:
          labelStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
      items: items,
      initialValue: initialValue,
      onChanged: onChanged ?? (value) {},
      validator: validator,
      enabled: enabled,
      border: border,
      enabledBorder: enabledBorder,
      disabledBorder: disabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      hintText: hintText,
      width: width,
      height: height,
      contentPadding: contentPadding,
      style: style,
      icon: icon,
      isRequired: isRequired,
      uppercaseLabel: uppercaseLabel,
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
    required Map<String, String> availableOptions,
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
    double? width,
    double? height,
    bool isRequired = false,
    TextStyle? labelStyle,
    bool enabled = true,
    Key? widgetKey,
  }) {
    return _AppMultiSelectChipField<String>(
      key: widgetKey,
      fieldKey: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label,
      labelStyle:
          labelStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
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
      width: width,
      height: height,
      isRequired: isRequired,
      enabled: enabled,
    );
  }

  /// Builds a chip selector field with a label and a container displaying chips.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text displayed above the field.
  /// [chips] - A list of widgets (typically chips) to display inside the container.
  /// [fieldKey] - Optional custom field key for FormBuilder registration.
  /// [onTap] - Optional callback when the field is tapped.
  /// [trailing] - Optional trailing widget (defaults to expand_more icon).
  /// [emptyPlaceholder] - Placeholder text when no chips are selected.
  /// [labelStyle] - Optional custom label style.
  /// [isRequired] - Whether the field is required (shows asterisk).
  /// [uppercaseLabel] - Whether to uppercase the label.
  static Widget buildChipSelectorField(
    BuildContext context, {
    required String label,
    required List<Widget> chips,
    String? fieldKey,
    VoidCallback? onTap,
    Widget? trailing,
    String emptyPlaceholder = 'Select...',
    bool enabled = true,
    TextStyle? labelStyle,
    bool isRequired = false,
    bool uppercaseLabel = true,
    Key? widgetKey,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: uppercaseLabel ? label.toUpperCase() : label,
                    style:
                        labelStyle ??
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppDimens.radiusSmall,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.paddingVerticalSmall.top * 1.5,
              horizontal: AppDimens.paddingHorizontalSmall.left,
            ),
            decoration: BoxDecoration(
              color: enabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              borderRadius: AppDimens.radiusSmall,
              border: Border.all(
                color: enabled
                    ? colorScheme.outline
                    : colorScheme.outline.withAlpha(100),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: chips.isEmpty
                      ? Text(
                          emptyPlaceholder,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                        )
                      : Wrap(
                          spacing: AppDimens.paddingAllSmall.left,
                          runSpacing: AppDimens.paddingAllSmall.left,
                          children: chips,
                        ),
                ),
                trailing ??
                    Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                      size: AppDimens.responsiveIconSize(context),
                    ),
              ],
            ),
          ),
        ),
      ],
    );

    if (widgetKey != null) {
      return KeyedSubtree(key: widgetKey, child: child);
    }
    return child;
  }

  /// Builds a multi-select popover field.
  ///
  /// [context] - The build context.
  /// [label] - The label text.
  /// [items] - The items to select from (map of value to display string).
  /// [fieldKey] - The form field key.
  /// [initialValue] - Initial selected values.
  /// [width] - Width of the field.
  /// [height] - Height of the field.
  static Widget buildMultiSelectPopoverField<T>(
    BuildContext context, {
    required String label,
    required Map<T, String> items,
    String? fieldKey,
    List<T>? initialValue,
    ValueChanged<List<T>>? onChanged,
    String? Function(List<T>?)? validator,
    String searchHint = 'Search...',
    String? helperText,
    bool isRequired = false,
    double? width,
    double? height,
    bool enabled = true,
    Key? widgetKey,
  }) {
    return MultiSelectPickerField<T>(
      key: widgetKey,
      label: label,
      items: items,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      searchHint: searchHint,
      helperText: helperText,
      isRequired: isRequired,
      width: width,
      height: height,
      enabled: enabled,
    );
  }

  /// Builds a rich-text editor form field using Flutter Quill.
  ///
  /// [context] - The build context for accessing theme data.
  /// [label] - The label text for the field.
  /// [fieldKey] - Optional custom field key. If not provided, it will be generated from label.
  /// [initialValue] - Initial JSON-encoded Delta content.
  /// [readOnly] - Whether the editor is read-only.
  /// [height] - Height of the editor container.
  /// [labelStyle] - Optional custom label style.
  /// [enabled] - Whether the field is enabled.
  /// [isRequired] - Whether the field is required.
  static Widget buildQuillEditor(
    BuildContext context, {
    required String label,
    String? fieldKey,
    String? initialValue,
    bool readOnly = false,
    double height = 250,
    TextStyle? labelStyle,
    bool enabled = true,
    bool isRequired = false,
    Key? widgetKey,
  }) {
    final widget = _AppQuillEditorField(
      name: fieldKey ?? label.toLowerCase().replaceAll(' ', '_'),
      label: label.toUpperCase(),
      initialValue: initialValue,
      readOnly: readOnly,
      height: height,
      labelStyle: labelStyle,
      enabled: enabled,
      isRequired: isRequired,
    );

    if (widgetKey != null) {
      return KeyedSubtree(key: widgetKey, child: widget);
    }
    return widget;
  }
}
