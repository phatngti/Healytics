import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Rounded hero banner image for the service manual
/// screen with gradient overlay, loading indicator,
/// and graceful error fallback.
class ServiceManualHeroImage extends StatelessWidget {
  const ServiceManualHeroImage({super.key, required this.imageUrl});

  /// URL of the hero banner to display.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppDimens.radiusMedium,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              semanticLabel: 'Service hero image',
              loadingBuilder: _loadingBuilder,
              errorBuilder: (_, __, ___) => Container(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: AppDimens.avatarMd,
                    color: colors.outline,
                  ),
                ),
              ),
            ),
          ),
          // Gradient overlay for depth
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colors.shadow.withValues(alpha: 0.2),
                    colors.shadow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a centered loading indicator while the
  /// image is being fetched from the network.
  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) {
    if (progress == null) return child;

    final colors = Theme.of(context).colorScheme;
    final total = progress.expectedTotalBytes;
    final loaded = progress.cumulativeBytesLoaded;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        color: colors.surfaceContainerHighest,
        child: Center(
          child: CircularProgressIndicator(
            value: total != null ? loaded / total : null,
            strokeWidth: AppDimens.borderWidthThick,
          ),
        ),
      ),
    );
  }
}
