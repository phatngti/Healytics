part of 'form_field_builders.dart';

/// Internal text-field widget used by [FormFieldBuilders.buildTextField].
///
/// Renders a labeled [TextFormField] wrapped in a [FormBuilderField] for
/// integration with [FormBuilder]. Supports custom borders, read-only mode,
/// validation, prefix/suffix icons, and adapts background color when disabled.
class _AppTextField extends StatelessWidget {
  /// Creates an [_AppTextField].
  const _AppTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.controller,
    this.onEditingComplete,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
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
    this.hoverBorder,
    this.keyboardType,
    this.maxLines,
    this.style,
    this.contentPadding,
    this.isRequired = false,
    this.uppercaseLabel = true,
    this.suffix,
  });

  /// Form field key used by [FormBuilder].
  final String fieldKey;

  /// Label text displayed above the input.
  final String label;

  /// Optional trailing icon widget.
  final Widget? suffixIcon;

  /// Optional leading icon widget.
  final Widget? prefixIcon;

  /// Optional trailing widget placed after the input text.
  final Widget? suffix;

  /// Validator function for form validation.
  final String? Function(dynamic)? validator;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Optional external controller for the text field.
  final TextEditingController? controller;

  /// Called when the user submits the text field.
  final VoidCallback? onEditingComplete;

  /// Called on every text change.
  final ValueChanged<dynamic>? onChanged;

  /// Whether the field accepts user input.
  final bool enabled;

  /// Whether the field is read-only (focusable but not editable).
  final bool readOnly;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Pre-populated value (used when no [controller] is set).
  final String? initialValue;

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

  /// Border used when there is a validation error.
  final OutlineInputBorder? errorBorder;

  /// Border used on hover.
  final OutlineInputBorder? hoverBorder;

  /// Hint text shown when the field is empty.
  final String? hintText;

  /// Container width constraint.
  final double? width;

  /// Container height constraint.
  final double? height;

  /// Keyboard type (e.g. number, email).
  final TextInputType? keyboardType;

  /// Number of visible lines.
  final int? maxLines;

  /// Text style applied to the input text.
  final TextStyle? style;

  /// Padding inside the input decoration.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the field is required (shows red asterisk).
  final bool isRequired;

  /// Whether to uppercase the label text.
  final bool uppercaseLabel;

  @override
  Widget build(BuildContext context) {
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = enabled && formEnabled;

    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField(
        validator: validator,
        name: fieldKey,
        initialValue: controller != null ? controller!.text : initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: isEnabled,
        onChanged: onChanged,
        builder: (FormFieldState<dynamic> field) {
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
                key: key,
                initialValue: controller != null
                    ? null
                    : field.value?.toString(),
                obscureText: obscureText,
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines ?? 1,
                onEditingComplete: onEditingComplete,
                style: style,
                readOnly: readOnly, // Pass readOnly
                onTap: onTap, // Pass onTap
                // --- FIX 1: Logic Enable/Disable ---
                enabled: isEnabled, // Chặn tương tác người dùng
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
                  // --- FIX 2: Visual Feedback (Đổi màu nền khi disable) ---
                  filled: true, // Bắt buộc phải có để hiển thị fillColor
                  fillColor: isEnabled
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

                  // Style cho border khi disable (Tuỳ chọn, mặc định Flutter tự xử lý)
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

                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  suffix: suffix,
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                    maxWidth: double.infinity,
                  ),
                ),
                onChanged: (value) {
                  // Cập nhật giá trị cho FormBuilder
                  field.didChange(value);

                  // Gọi callback bên ngoài (nếu có)
                  if (onChanged != null) {
                    onChanged!(value);
                  }
                },
                onTapOutside: (_) {
                  if (isEnabled) {
                    field.validate();
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
