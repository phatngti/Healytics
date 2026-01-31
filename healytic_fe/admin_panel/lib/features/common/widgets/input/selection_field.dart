part of 'form_field_builders.dart';

class _AppSelectionField<T> extends StatelessWidget {
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

  final String fieldKey;
  final String? label;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final T? initialValue;
  final TextStyle? labelStyle;
  final OutlineInputBorder? border;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? disabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final String? hintText;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final Widget? icon;
  final bool isRequired;
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
                value: items.any((e) => e.value == field.value)
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
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                  enabledBorder:
                      enabledBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                  focusedBorder:
                      focusedBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                  disabledBorder:
                      disabledBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withAlpha(100),
                        ),
                      ),
                  contentPadding:
                      contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
