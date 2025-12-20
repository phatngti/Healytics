import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppDatePickField extends StatelessWidget {
  const AppDatePickField({
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
  });

  final String fieldKey;
  final String label;
  final TextEditingController? controller;
  final String? Function(dynamic)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<dynamic>? onChanged;
  final bool isRequired;
  final bool uppercaseLabel;
  final String? hintText;
  final TextStyle? style;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    // Define the label color matching HTML #618961
    const labelColor = Color(0xFF618961);

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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
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
