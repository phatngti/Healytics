part of 'form_field_builders.dart';

class _AppTextField extends StatelessWidget {
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

  final String fieldKey;
  final String label;

  final Widget? suffixIcon;
  final Widget? prefixIcon; // Add prefixIcon field
  final Widget? suffix;
  final String? Function(dynamic)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final bool readOnly; // Add readOnly
  final VoidCallback? onTap; // Add onTap
  final String? initialValue;
  final TextStyle? labelStyle;
  final OutlineInputBorder? border;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? disabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? hoverBorder;
  final String? hintText;
  final double? width;
  final double? height;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRequired;
  final bool uppercaseLabel;

  @override
  Widget build(BuildContext context) {
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = enabled && formEnabled;

    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField(
        key: key,
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
