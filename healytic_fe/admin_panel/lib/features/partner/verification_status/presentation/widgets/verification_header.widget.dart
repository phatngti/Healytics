import 'package:flutter/material.dart';

/// Custom AppBar for the verification status screen.
///
/// Displays the platform logo, title, application ID, and help button.
class VerificationHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a new [VerificationHeader].
  const VerificationHeader({
    required this.applicationId,
    required this.onHelpPressed,
    super.key,
  });

  /// The application ID to display (e.g., "#SP-8821").
  final String applicationId;

  /// Callback when the help button is pressed.
  final VoidCallback onHelpPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Row(
        children: [
          // Logo
          SizedBox(
            width: 32,
            height: 32,
            child: Icon(Icons.spa, color: colorScheme.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Text(
            'Spa Platform Admin',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: [
        // Application ID badge
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Application ID: $applicationId',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Help button
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton(
            onPressed: onHelpPressed,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Help Center'),
          ),
        ),
      ],
    );
  }
}
