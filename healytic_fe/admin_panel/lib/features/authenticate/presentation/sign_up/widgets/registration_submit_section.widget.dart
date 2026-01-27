import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Submit section for the Partner Registration form.
///
/// Contains the submit button and login link for the registration page.
class RegistrationSubmitSection extends StatelessWidget {
  /// Callback invoked when the submit button is pressed.
  final VoidCallback onSubmit;

  /// Whether the form is currently loading/submitting.
  final bool isLoading;

  const RegistrationSubmitSection({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Submit button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: AppButton(
            onPressed: onSubmit,
            buttonType: ButtonType.elevated,
            isLoading: isLoading,
            child: Text(
              'Complete Registration',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        AppDimens.verticalMedium,

        // Login link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: () => context.go(const SignInRoute().location),
              child: Text(
                'Log In',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
