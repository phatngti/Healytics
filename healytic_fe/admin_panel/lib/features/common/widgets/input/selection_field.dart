import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppSelectionField<T> extends StatelessWidget {
  const AppSelectionField({
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
        enabled: enabled,
        builder: (FormFieldState<T> field) {
          // Define the label color matching HTML #618961
          const labelColor = Color(0xFF618961);

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
                                color: labelColor,
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
              InputDecorator(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      contentPadding ??
                      EdgeInsets.symmetric(
                        vertical: AppDimens.paddingVerticalSmall.top * 1.5,
                        horizontal: AppDimens.paddingHorizontalSmall.left,
                      ),
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: enabled
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  errorText: field.errorText,
                  border:
                      border ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                  enabledBorder:
                      enabledBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                  focusedBorder:
                      focusedBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  disabledBorder:
                      disabledBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withAlpha(100),
                        ),
                      ),
                  hoverColor: Theme.of(context).colorScheme.surface,
                ),
                isEmpty:
                    field.value == null ||
                    !items.any((e) => e.value == field.value),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: items.any((e) => e.value == field.value)
                        ? field.value
                        : null,
                    items: items,
                    onChanged: enabled
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
