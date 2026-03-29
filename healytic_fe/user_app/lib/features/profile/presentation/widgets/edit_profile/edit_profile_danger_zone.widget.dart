import 'package:flutter/material.dart';

class EditProfileDangerZone extends StatelessWidget {
  const EditProfileDangerZone({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        TextButton(
          onPressed: () {
            // TODO: Delete account flow
          },
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.error,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            'Delete Account',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Once deleted, your wellness data and progress cannot be recovered.',
          textAlign: TextAlign.center,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
