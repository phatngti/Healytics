import 'package:flutter/material.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/widgets/survey_text_styles.dart';

/// A survey dropdown field that delegates to
/// [FormFieldBuilders.buildCustomDropdownField] for consistent
/// styling across the application.
class SurveyField extends StatelessWidget {
  const SurveyField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.options,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
  });

  /// Form field key used by [FormBuilder].
  final String fieldKey;

  /// Label displayed above the dropdown.
  final String label;

  /// Available options as `[{value: ..., text: ...}]`.
  final List<Map<String, dynamic>> options;

  final String? Function(dynamic)? validator;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final optionTextStyle = SurveyTextStyles.optionText(context);

    return FormFieldBuilders.buildCustomDropdownField(
      context,
      label: label,
      labelStyle: SurveyTextStyles.questionLabel(context),
      fieldKey: fieldKey,
      initialValue: initialValue,
      hintText: 'Select an option',
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option['value'],
              child: Text(option['text'] as String, style: optionTextStyle),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      style: optionTextStyle,
      uppercaseLabel: false,
    );
  }
}
