import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_header.widget.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Success Registration Screen.
///
/// Displays a success message after a partner completes registration.
/// Includes:
/// - Animated check icon with glow effect
/// - Success messaging with review timeline
/// - Button to navigate back to login
class SucessRegistrationScreen extends StatelessWidget {
  const SucessRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Reuse existing header component
          const SignUpHeader(),

          // Main content area
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 16,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: _SuccessCard(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    isDesktop: isDesktop,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Success card widget with all content elements.
class _SuccessCard extends StatelessWidget {
  const _SuccessCard({
    required this.colorScheme,
    required this.textTheme,
    required this.isDesktop,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppDimens.radiusLarge,
        child: Stack(
          children: [
            // Background glow effect
            Positioned(
              top: -80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.all(isDesktop ? 48 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success icon with glow
                  _SuccessIcon(colorScheme: colorScheme),
                  AppDimens.verticalLargeExtra,

                  // Title
                  Text(
                    'Registration Successful!',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppDimens.verticalLarge,

                  // Message section
                  _MessageSection(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  AppDimens.verticalLargeExtra,

                  // Back to Login button
                  _BackToLoginButton(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    isDesktop: isDesktop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Success icon with ambient glow effect.
class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow layer
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.25),
                colorScheme.primary.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        // Icon container with ring
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 80,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Message section with partner application status info.
class _MessageSection extends StatelessWidget {
  const _MessageSection({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Thank you for applying to become a partner.',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        AppDimens.verticalMedium,
        Text(
          'Your application has been received and is currently under review. '
          'Our team will verify your documents within ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '1-2 business days',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        AppDimens.verticalSmall,
        Text(
          'A confirmation email has been sent to your registered address.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Back to Login button with styling matching the design.
class _BackToLoginButton extends StatelessWidget {
  const _BackToLoginButton({
    required this.colorScheme,
    required this.textTheme,
    required this.isDesktop,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isDesktop ? 240 : double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: () => context.go(const SignInRoute().location),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: 12.circularRadius),
          elevation: 4,
          shadowColor: colorScheme.primary.withValues(alpha: 0.4),
        ),
        child: Text(
          'Back to Login',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
