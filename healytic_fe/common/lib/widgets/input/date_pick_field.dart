part of 'form_field_builders.dart';

/// Internal date-picker field used by [FormFieldBuilders.buildDateField].
///
/// Renders a labeled [FormBuilderDateTimePicker] with formatted
/// date input (dd-MM-yyyy display, yyyy-MM-dd storage) and a
/// calendar icon suffix.
class _AppDatePickField extends StatelessWidget {
  /// Creates an [_AppDatePickField].
  const _AppDatePickField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.controller,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.isRequired = false,
    this.uppercaseLabel = true,
    this.hintText,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.enabled = true,
  });

  /// Form field key used by [FormBuilder].
  final String fieldKey;

  /// Label text displayed above the picker.
  final String label;

  /// Optional external controller.
  final TextEditingController? controller;

  /// Validator function for form validation.
  final String? Function(dynamic)? validator;

  /// Pre-selected date.
  final DateTime? initialDate;

  /// Earliest selectable date (defaults to 1900).
  final DateTime? firstDate;

  /// Latest selectable date (defaults to 2100).
  final DateTime? lastDate;

  /// Called when the date value changes.
  final ValueChanged<dynamic>? onChanged;

  /// Whether the field is required (shows red asterisk).
  final bool isRequired;

  /// Whether to uppercase the label text.
  final bool uppercaseLabel;

  /// Hint text shown when no date is selected.
  final String? hintText;

  /// Text style for the date value.
  final TextStyle? style;

  /// Text style for the hint text.
  final TextStyle? hintStyle;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  /// Whether the field is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Define the label color matching HTML #618961
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = enabled && formEnabled;

    return Column(
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
        FormBuilderDateTimePicker(
          key: key,
          name: fieldKey,
          controller: controller,
          inputType: InputType.date,
          initialValue: initialDate,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: style,
          enabled: isEnabled,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            border: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              size: AppDimens.responsiveIconSize(context),
            ),
            fillColor: isEnabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingHorizontalSmall.left,
              vertical: AppDimens.paddingVerticalSmall.top * 1.5,
            ),
          ),
          onChanged: onChanged,
          initialDatePickerMode: DatePickerMode.day,
          format: DateFormat('dd-MM-yyyy'),
          valueTransformer: (value) {
            return value != null
                ? DateFormat('yyyy-MM-dd').format(value)
                : null;
          },
          onSaved: (newValue) => {
            if (onChanged != null) {onChanged!(newValue)},
          },
          onEditingComplete: () => {FocusScope.of(context).unfocus()},
        ),
      ],
    );
  }
}
