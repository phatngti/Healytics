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
  });

  final String fieldKey;
  final String label;
  final TextEditingController? controller;
  final String? Function(dynamic)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      key: key,
      name: fieldKey,
      controller: controller,
      inputType: InputType.date,
      initialValue: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: onChanged,
      initialDatePickerMode: DatePickerMode.day,
      format: DateFormat('dd-MM-yyyy'),
      valueTransformer: (value) {
        return value != null ? DateFormat('yyyy-MM-dd').format(value) : null;
      },

      onSaved: (newValue) => {
        if (onChanged != null) {onChanged!(newValue)},
      },
      onEditingComplete: () => {FocusScope.of(context).unfocus()},
    );
  }
}
