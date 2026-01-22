import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Account Security form section of Partner Registration.
///
/// Contains:
/// - Password field with toggle visibility
/// - Confirm Password field with toggle visibility
/// - Password requirements hint text
class AccountSecuritySection extends HookWidget {
  const AccountSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Visibility toggle states
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row: Password & Confirm Password
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldBuilders.buildTextField(
                          context,
                          fieldKey: 'password',
                          label: 'Create Password',
                          hintText: '••••••••',
                          isRequired: true,
                          obscureText: !showPassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              showPassword.value = !showPassword.value;
                            },
                          ),
                          validator: _validatePassword,
                        ),
                        AppDimens.verticalExtraSmall,
                        Text(
                          'At least 8 characters, 1 uppercase, 1 number',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'confirm_password',
                      label: 'Confirm Password',
                      hintText: '••••••••',
                      isRequired: true,
                      obscureText: !showConfirmPassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          showConfirmPassword.value =
                              !showConfirmPassword.value;
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'password',
                  label: 'Create Password',
                  hintText: '••••••••',
                  isRequired: true,
                  obscureText: !showPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      showPassword.value = !showPassword.value;
                    },
                  ),
                  validator: _validatePassword,
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'At least 8 characters, 1 uppercase, 1 number',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'confirm_password',
                  label: 'Confirm Password',
                  hintText: '••••••••',
                  isRequired: true,
                  obscureText: !showConfirmPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      showConfirmPassword.value = !showConfirmPassword.value;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Validates password meets requirements:
  /// - At least 8 characters
  /// - At least 1 uppercase letter
  /// - At least 1 number
  String? _validatePassword(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Password is required';
    }

    final password = value.toString();

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 number';
    }

    return null;
  }
}
