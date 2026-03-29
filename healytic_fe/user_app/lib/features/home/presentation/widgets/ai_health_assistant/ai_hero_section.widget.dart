import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Gradient hero section with animated AI bot icon
/// and descriptive title/subtitle.
class AiHeroSection extends StatelessWidget {
  const AiHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenW =
        MediaQuery.sizeOf(context).width;

    final heroHeight = AppDimens.adaptive(
      context,
      small: screenW * 0.55,
      medium: screenW * 0.50,
      large: screenW * 0.48,
    );

    return Container(
      width: double.infinity,
      height: heroHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimens.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary
                .withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withValues(alpha: 0.06),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // AI icon with glow
                Container(
                  width: AppDimens.adaptive(
                    context,
                    small: 64.0,
                    medium: 72.0,
                    large: 72.0,
                  ),
                  height: AppDimens.adaptive(
                    context,
                    small: 64.0,
                    medium: 72.0,
                    large: 72.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                        .withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white
                            .withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Symbols.smart_toy,
                    size: AppDimens.adaptive(
                      context,
                      small: 36.0,
                      medium: 42.0,
                      large: 42.0,
                    ),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppDimens.spaceLg),
                Text(
                  'AI Health Assistant',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: AppDimens.spaceSm),
                Text(
                  'Get instant health guidance '
                  'powered by AI',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    color: Colors.white
                        .withValues(alpha: 0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
