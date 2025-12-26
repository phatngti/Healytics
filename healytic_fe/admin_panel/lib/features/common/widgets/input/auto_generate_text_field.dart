import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A text field widget with an auto-generate button.
/// Used for fields like Employee ID that can be auto-generated.
class AppAutoGenerateTextField extends StatelessWidget {
  const AppAutoGenerateTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.onGenerate,
    this.controller,
    this.enabled = false,
    this.buttonText = 'Auto-Generate',
    this.labelStyle,
    this.hintText,
    this.width,
    this.height,
    this.isRequired = false,
    this.uppercaseLabel = true,
    this.initialValue,
    this.validator,
  });

  final String fieldKey;
  final String label;
  final VoidCallback onGenerate;
  final TextEditingController? controller;
  final bool enabled;
  final String buttonText;
  final TextStyle? labelStyle;
  final String? hintText;
  final double? width;
  final double? height;
  final bool isRequired;
  final bool uppercaseLabel;
  final String? initialValue;
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField<String>(
        key: key,
        validator: validator,
        name: fieldKey,
        initialValue: controller?.text ?? initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String> field) {
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
              TextFormField(
                controller: controller,
                enabled: enabled,
                initialValue: controller != null ? null : field.value,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: enabled
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest,
                  errorText: field.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: AppButton(
                      onPressed: () {
                        onGenerate();
                        // Update the form field value after generation
                        if (controller != null) {
                          field.didChange(controller!.text);
                        }
                      },
                      buttonType: ButtonType.text,
                      customStyle: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        backgroundColor: colorScheme.surfaceContainerHighest
                            .withAlpha(50),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  field.didChange(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
