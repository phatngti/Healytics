import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Builds event markers below calendar day numbers.
///
/// Three visual tiers based on appointment count:
/// - **1**: Single 20×20 circular thumbnail.
/// - **2**: Two 16×16 overlapping thumbnails.
/// - **≥3**: Two thumbnails + "+N" counter badge.
class CalendarMarkerBuilder {
  const CalendarMarkerBuilder._();

  /// Returns the appropriate marker widget for
  /// the given day's [events].
  static Widget build(
    BuildContext context,
    DateTime day,
    List<AppointmentEntity> events,
  ) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }
    if (events.length == 1) {
      return _SingleThumbnail(imageUrl: events.first.imageUrl);
    }
    return _OverlappingThumbnails(events: events, overflow: events.length - 2);
  }
}

// ─── Single thumbnail ──────────────────────────────

class _SingleThumbnail extends StatelessWidget {
  const _SingleThumbnail({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.surfaceContainerHighest),
      ),
      child: ClipOval(
        child: NetworkImageAuto(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_) => ColoredBox(color: colors.surfaceContainerLow),
          errorWidget: (_) => ColoredBox(
            color: colors.surfaceContainerLow,
            child: Icon(Icons.spa, size: 10, color: colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

// ─── Overlapping thumbnails ────────────────────────

class _OverlappingThumbnails extends StatelessWidget {
  const _OverlappingThumbnails({required this.events, required this.overflow});

  final List<AppointmentEntity> events;
  final int overflow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Show at most 2 thumbnails + overflow badge
    final shown = events.take(2).toList();

    // Calculate total width:
    // first thumbnail 16 + overlap offset 8 per
    // additional item
    final itemCount = shown.length + (overflow > 0 ? 1 : 0);
    final totalWidth = 16.0 + (itemCount - 1) * 10.0;

    return SizedBox(
      width: totalWidth,
      height: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 10.0,
              child: _MiniThumbnail(
                imageUrl: shown[i].imageUrl,
                colors: colors,
              ),
            ),
          if (overflow > 0)
            Positioned(
              left: shown.length * 10.0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$overflow',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Mini thumbnail (16×16) ────────────────────────

class _MiniThumbnail extends StatelessWidget {
  const _MiniThumbnail({required this.imageUrl, required this.colors});

  final String imageUrl;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.surface),
      ),
      child: ClipOval(
        child: NetworkImageAuto(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_) => ColoredBox(color: colors.surfaceContainerLow),
          errorWidget: (_) => ColoredBox(color: colors.surfaceContainerLow),
        ),
      ),
    );
  }
}
