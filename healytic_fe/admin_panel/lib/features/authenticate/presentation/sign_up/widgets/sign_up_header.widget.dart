import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sticky header component for the signup flow.
///
/// Displays:
/// - App logo and branding
/// - Support link (desktop only)
/// - Login button
class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Logo
          const AdminLogo(),

          // Right side - Actions
          Row(
            children: [
              // Support link - only on larger screens
              if (MediaQuery.of(context).size.width > 600)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to support
                  },
                  child: Text(
                    'Support',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              // Login button
              FilledButton.tonal(
                onPressed: () => context.go(const SignInRoute().location),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'Log In',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
