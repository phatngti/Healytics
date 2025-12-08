import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.controller,
    this.onEditingComplete,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
    this.labelStyle,
    this.border,
  });

  final String fieldKey;
  final String label;
  final Widget? suffixIcon;
  final String? Function(dynamic)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? initialValue;
  final TextStyle? labelStyle;
  final OutlineInputBorder? border;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      key: key,
      validator: validator,
      name: fieldKey,
      initialValue: controller != null ? controller!.text : initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      builder: (FormFieldState<dynamic> field) {
        return TextFormField(
          key: key,
          initialValue: controller != null ? null : field.value?.toString(),
          obscureText: obscureText,
          controller: controller,
          onEditingComplete: onEditingComplete,

          // --- FIX 1: Logic Enable/Disable ---
          enabled: enabled, // Chặn tương tác người dùng
          decoration: InputDecoration(
            // --- FIX 2: Visual Feedback (Đổi màu nền khi disable) ---
            filled: true, // Bắt buộc phải có để hiển thị fillColor
            fillColor: enabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.12,
                  ), // Màu xám nhẹ khi disable

            label: Text(
              label,
              style: enabled
                  ? labelStyle ?? Theme.of(context).textTheme.bodyLarge
                  : labelStyle?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 1),
                        ) ??
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 1),
                        ),
            ),
            errorText: field.errorText,
            border:
                border ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface.withAlpha(10),
                  ),
                ),

            // Style cho border khi disable (Tuỳ chọn, mặc định Flutter tự xử lý)
            disabledBorder:
                border?.copyWith(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                  ),
                ) ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                  ),
                ),

            suffixIcon: suffixIcon,
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
            if (enabled) {
              field.validate();
              FocusScope.of(context).unfocus();
            }
          },
        );
      },
    );
  }
}
