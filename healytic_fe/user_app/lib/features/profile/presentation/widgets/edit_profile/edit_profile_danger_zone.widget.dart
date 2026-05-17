import 'package:flutter/material.dart';

class EditProfileDangerZone extends StatelessWidget {
  const EditProfileDangerZone({
    super.key,
    this.onDeleteAccount,
    this.isBusy = false,
  });

  final VoidCallback? onDeleteAccount;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        TextButton(
          onPressed: isBusy ? null : onDeleteAccount,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.error,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: isBusy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.error,
                  ),
                )
              : Text(
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
