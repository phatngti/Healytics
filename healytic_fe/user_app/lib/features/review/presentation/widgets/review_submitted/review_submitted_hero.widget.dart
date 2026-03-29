import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Hero section for the review-submitted screen.
///
/// Displays an animated verified-user icon inside a
/// pulsing container, a "Thank you" headline, and a
/// descriptive subtitle mentioning the specialist.
class ReviewSubmittedHero extends StatefulWidget {
  /// Display name of the reviewed specialist.
  final String specialistName;

  const ReviewSubmittedHero({
    super.key,
    required this.specialistName,
  });

  @override
  State<ReviewSubmittedHero> createState() =>
      _ReviewSubmittedHeroState();
}

class _ReviewSubmittedHeroState
    extends State<ReviewSubmittedHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(colors),
        AppDimens.verticalExtraLarge,
        _buildHeadline(textTheme, colors),
        AppDimens.verticalMedium,
        _buildSubtitle(textTheme, colors),
      ],
    );
  }

  /// Animated pulsing icon with verified badge.
  Widget _buildIcon(ColorScheme colors) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing background circle
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer
                      .withValues(
                    alpha: _pulseAnimation.value * 0.3,
                  ),
                ),
              );
            },
          ),
          // Static inner circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primaryContainer
                  .withValues(alpha: 0.3),
            ),
          ),
          // Icon
          Icon(
            Icons.verified_user,
            size: 48,
            color: colors.primary,
          ),
        ],
      ),
    );
  }

  /// "Thank you for your review!" heading.
  Widget _buildHeadline(
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Text(
      'Thank you for your review!',
      style: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: colors.onSurface,
        letterSpacing: -0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Descriptive subtitle with specialist name.
  Widget _buildSubtitle(
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.bodyLarge?.copyWith(
          color: colors.onSurfaceVariant,
          height: 1.5,
        ),
        children: [
          const TextSpan(
            text: 'Your feedback for ',
          ),
          TextSpan(
            text: widget.specialistName,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const TextSpan(
            text: "'s specialist care has been "
                "submitted.",
          ),
        ],
      ),
    );
  }
}
