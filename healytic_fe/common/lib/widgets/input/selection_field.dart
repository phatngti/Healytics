part of 'form_field_builders.dart';

/// Internal dropdown selection field used by
/// [FormFieldBuilders.buildDropdownField] and
/// [FormFieldBuilders.buildCustomDropdownField].
///
/// Renders a labeled [DropdownButtonFormField] wrapped in a [FormBuilderField]
/// with customizable borders, styling, and enable/disable state.
class _AppSelectionField<T> extends StatelessWidget {
  /// Creates an [_AppSelectionField].
  const _AppSelectionField({
    super.key,
    required this.fieldKey,
    this.label,
    required this.items,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
    this.labelStyle,
    this.border,
    this.hintText,
    this.width,
    this.height,
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.contentPadding,
    this.style,
    this.icon,
    this.isRequired = false,
    this.uppercaseLabel = true,
  });

  /// Form field key used by [FormBuilder].
  final String fieldKey;

  /// Label text displayed above the dropdown.
  final String? label;

  /// List of [DropdownMenuItem] entries.
  final List<DropdownMenuItem<T>> items;

  /// Validator function for form validation.
  final String? Function(T?)? validator;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the dropdown accepts user interaction.
  final bool enabled;

  /// Pre-selected dropdown value.
  final T? initialValue;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  /// Default border for the input decoration.
  final OutlineInputBorder? border;

  /// Border used when enabled.
  final OutlineInputBorder? enabledBorder;

  /// Border used when disabled.
  final OutlineInputBorder? disabledBorder;

  /// Border used when focused.
  final OutlineInputBorder? focusedBorder;

  /// Border used on validation error.
  final OutlineInputBorder? errorBorder;

  /// Hint text shown when no item is selected.
  final String? hintText;

  /// Container width constraint.
  final double? width;

  /// Container height constraint.
  final double? height;

  /// Padding inside the input decoration.
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the selected item.
  final TextStyle? style;

  /// Custom dropdown arrow icon.
  final Widget? icon;

  /// Whether the field is required (shows red asterisk).
  final bool isRequired;

  /// Whether to uppercase the label text.
  final bool uppercaseLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = enabled && formEnabled;

    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField<T>(
        key: key,
        validator: validator,
        name: fieldKey,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        enabled: isEnabled,
        builder: (FormFieldState<T> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null && label!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: uppercaseLabel ? label!.toUpperCase() : label,
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
              DropdownButtonFormField<T>(
                key: ValueKey(field.value),
                initialValue:
                    (field.value != null &&
                        items.any((e) => e.value == field.value))
                    ? field.value
                    : ((initialValue != null &&
                              items.any((e) => e.value == initialValue))
                          ? initialValue
                          : null),
                items: items,
                onChanged: isEnabled
                    ? (value) {
                        field.didChange(value);
                        if (onChanged != null) {
                          onChanged!(value);
                        }
                      }
                    : null,
                style: style ?? Theme.of(context).textTheme.bodyMedium,
                icon: icon ?? const Icon(Icons.keyboard_arrow_down_rounded),
                isDense: true,
                isExpanded: true,
                alignment: AlignmentDirectional.centerStart,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: isEnabled
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest,
                  errorText: field.errorText,
                  border:
                      border ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                  enabledBorder:
                      enabledBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                  focusedBorder:
                      focusedBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                  disabledBorder:
                      disabledBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: colorScheme.outline.withAlpha(100),
                        ),
                      ),
                  contentPadding:
                      contentPadding ??
                      EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingHorizontalSmall.left,
                        vertical: AppDimens.paddingHorizontalSmall.left,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
