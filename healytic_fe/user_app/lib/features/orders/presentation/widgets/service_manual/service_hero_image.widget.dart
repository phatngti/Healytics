import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Full-width hero image for the service manual screen.
///
/// Displays the service image with rounded corners, a
/// subtle gradient overlay, and a soft shadow — matching
/// the spa-style design template.
class ServiceHeroImage extends StatelessWidget {
  const ServiceHeroImage({
    super.key,
    required this.imageUrl,
  });

  /// Network URL of the service image.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = AppDimens.cardRadius(context);

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.06),
              blurRadius: AppDimens.spaceXl,
              offset: const Offset(0, AppDimens.spaceXs),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _image(colors),
              _gradientOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  /// The network image with an error fallback.
  Widget _image(ColorScheme colors) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: colors.onSurfaceVariant,
            size: AppDimens.iconXxl,
          ),
        ),
      ),
    );
  }

  /// Subtle bottom-to-top gradient for depth.
  Widget _gradientOverlay() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0.20),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
