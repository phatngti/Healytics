part of 'form_field_builders.dart';

/// Internal text-field widget with an integrated auto-generate button.
///
/// Used by [FormFieldBuilders.buildAutoGenerateTextField] for fields like
/// Employee ID or SKU codes that can be populated via a generation callback.
///
/// The generate button appears as a suffix inside the input and triggers
/// [onGenerate] when tapped.
class _AppAutoGenerateTextField extends StatelessWidget {
  /// Creates an [_AppAutoGenerateTextField].
  const _AppAutoGenerateTextField({
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

  /// Form field key used by [FormBuilder].
  final String fieldKey;

  /// Label text displayed above the input.
  final String label;

  /// Callback invoked when the auto-generate button is pressed.
  final VoidCallback onGenerate;

  /// Optional external controller for reading/writing the field value.
  final TextEditingController? controller;

  /// Whether the field accepts user input (defaults to `false`).
  final bool enabled;

  /// Text displayed on the auto-generate button (defaults to 'Auto-Generate').
  final String buttonText;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  /// Hint text shown when the field is empty.
  final String? hintText;

  /// Container width constraint.
  final double? width;

  /// Container height constraint.
  final double? height;

  /// Whether the field is required (shows red asterisk).
  final bool isRequired;

  /// Whether to uppercase the label text.
  final bool uppercaseLabel;

  /// Pre-populated value (used when no [controller] is set).
  final String? initialValue;

  /// Validator function for form validation.
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = enabled && formEnabled;

    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField<String>(
        key: key,
        validator: validator,
        name: fieldKey,
        initialValue: controller?.text ?? initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: isEnabled,
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
                enabled: isEnabled,
                initialValue: controller != null ? null : field.value,
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
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withAlpha(100),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingHorizontalSmall.left,
                    vertical: AppDimens.paddingVerticalSmall.top * 1.5,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: AppButton(
                      onPressed: isEnabled
                          ? () {
                              onGenerate();
                              // Update the form field value after generation
                              if (controller != null) {
                                field.didChange(controller!.text);
                              }
                            }
                          : null,
                      buttonType: ButtonType.text,
                      customStyle: TextButton.styleFrom(
                        foregroundColor: isEnabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                        backgroundColor: isEnabled
                            ? colorScheme.surfaceContainerHighest.withAlpha(50)
                            : colorScheme.surfaceContainerHighest.withAlpha(20),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingHorizontalMedium.left,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimens.radiusExtraSmall,
                          side: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: AppDimens.fontSizeSmall,
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
