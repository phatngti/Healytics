import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Account Information form section (Section 1) of Partner Registration.
///
/// Contains:
/// - Username text field
/// - Email Address text field
/// - Password field with visibility toggle
/// - Confirm Password field with visibility toggle
class AccountInformationSection extends HookWidget {
  const AccountInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Visibility toggle states
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Username & Email
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'username',
                      label: 'Username',
                      hintText: 'Enter username',
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'email',
                      label: 'Email Address',
                      hintText: 'email@domain.com',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'username',
                  label: 'Username',
                  hintText: 'Enter username',
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'email',
                  label: 'Email Address',
                  hintText: 'email@domain.com',
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Password & Confirm Password
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'password',
                      label: 'Password',
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
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'password',
                  label: 'Password',
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

  /// Validates email format.
  String? _validateEmail(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Email is required';
    }

    final email = value.toString();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
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
