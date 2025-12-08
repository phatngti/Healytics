import 'package:admin_panel/utils/demensions.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FormBuilderField(
        key: key,
        validator: validator,
        name: fieldKey,
        initialValue: controller != null ? controller!.text : initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        builder: (FormFieldState<dynamic> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    labelStyle?.copyWith(fontWeight: FontWeight.w600) ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              2.verticalSpace,
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

                // --- FIX 1: Logic Enable/Disable ---
                enabled: enabled, // Chặn tương tác người dùng
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
                  fillColor: enabled
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.12,
                        ), // Màu xám nhẹ khi disable

                  errorText: field.errorText,
                  border:
                      border ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceBright.withAlpha(100),
                        ),
                      ),
                  enabledBorder:
                      enabledBorder ??
                      OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withAlpha(100),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
