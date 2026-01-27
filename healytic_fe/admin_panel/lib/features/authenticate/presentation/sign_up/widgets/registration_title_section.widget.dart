import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Title section for the Partner Registration form.
///
/// Displays the main heading and description text for the registration page.
class RegistrationTitleSection extends StatelessWidget {
  const RegistrationTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Registration',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Register your spa business to join our B2B partner network. '
          'Please fill out the information accurately.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
