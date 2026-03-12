import 'package:flutter/material.dart';

/// Rounded hero banner image with network loading
/// and a graceful error fallback.
class HeroImage extends StatelessWidget {
  const HeroImage({super.key, required this.imageUrl});

  /// URL of the hero banner to display.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 224,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: colors.surfaceContainerHighest,
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 48),
            ),
          ),
        ),
      ),
    );
  }
}
