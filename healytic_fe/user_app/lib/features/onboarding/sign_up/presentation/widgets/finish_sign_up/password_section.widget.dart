import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';

/// Form section for setting and confirming the user's
/// password during sign-up.
///
/// Requires [formKey] so the confirm-password validator
/// can cross-reference the password field's current value.
class PasswordSection extends StatelessWidget {
  /// Creates a [PasswordSection].
  const PasswordSection({
    super.key,
    required this.formKey,
  });

  /// Key of the parent [FormBuilder] for cross-field
  /// validation between password and confirm password.
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(
          color: Theme.of(context)
              .textTheme
              .titleMedium
              ?.color
              ?.withAlpha(700),
          fontWeight: FontWeight.bold,
        );

    final captionStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(
          color: Theme.of(context)
              .textTheme
              .bodySmall
              ?.color
              ?.withAlpha(700),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1.0,
      children: [
        Text('Password', style: titleStyle),
        AppDimens.verticalSmall,
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: 'password',
          label: 'Password',
          uppercaseLabel: false,
          obscureText: true,
          validator: FormValidators.password,
        ),
        AppDimens.verticalSmall,
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: 'confirm_password',
          label: 'Confirm Password',
          uppercaseLabel: false,
          obscureText: true,
          validator: (value) =>
              FormValidators.confirmPassword(
            value,
            password: formKey.currentState
                    ?.fields['password']
                    ?.value
                    ?.toString() ??
                '',
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Make sure your password is at least '
          '8 characters long.',
          style: captionStyle,
        ),
      ],
    );
  }
}
