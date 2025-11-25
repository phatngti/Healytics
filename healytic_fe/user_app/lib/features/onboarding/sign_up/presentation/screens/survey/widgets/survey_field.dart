import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:user_app/utils/demensions.dart';

class SurveyField extends StatelessWidget {
  const SurveyField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.options, // Changed type below
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.controller,
    this.onEditingComplete,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
    this.valueTransformer,
  });

  final String fieldKey;
  final String label;
  // SỬA Ở ĐÂY: Nhận List Map thay vì List String
  final List<Map<String, dynamic>> options;

  final Widget? suffixIcon;
  final String? Function(dynamic)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? initialValue;
  final ValueTransformer<dynamic>? valueTransformer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        AppDimens.verticalSmall,
        FormBuilderDropdown(
          name: fieldKey,
          hint: const Text('Select an option'),
          // padding: EdgeInsets.zero, // Fix padding if needed
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            fillColor: enabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface.withAlpha(30),
            // Bạn nên thêm border styling ở đây nếu chưa có trong theme
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          initialValue: initialValue,
          valueTransformer: valueTransformer,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          // SỬA Ở ĐÂY: Map value vào value, text vào child
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value:
                      option['value'], // Giá trị gửi lên server (vd: "relax")
                  child: Text(
                    option['text'],
                  ), // Giá trị hiển thị (vd: "Relaxation...")
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
