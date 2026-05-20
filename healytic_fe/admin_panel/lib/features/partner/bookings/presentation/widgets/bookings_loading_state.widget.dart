import 'package:flutter/material.dart';

import 'responsive_bookings_grid.widget.dart';

/// Skeleton loading state for the bookings dashboard.
///
/// Renders 6–24 skeleton placeholders shaped like
/// [BookingCard] in the active grid layout. The count is
/// always a multiple of the active column count so the
/// grid appears visually balanced.
///
/// Uses the same horizontal padding and 16 dp gaps as the
/// real [ResponsiveBookingsGrid].
///
/// _(Req 1.4, 6.1)_
class BookingsLoadingState extends StatelessWidget {
  /// Creates the bookings loading state.
  const BookingsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = columnsFor(width);
        final padding = getHorizontalPadding(width);
        final count = _skeletonCount(columns);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: kBookingsGridGap,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: kBookingsGridGap,
            mainAxisSpacing: kBookingsGridGap,
            childAspectRatio: _aspectRatio(width, columns, padding),
          ),
          itemCount: count,
          itemBuilder: (context, index) {
            return const _SkeletonCard();
          },
        );
      },
    );
  }

  /// Computes a skeleton count in [6, 24] that is a
  /// multiple of [columns].
  int _skeletonCount(int columns) {
    // Target ~12 items, rounded to nearest multiple of
    // columns, clamped to [6, 24].
    final target = (12 / columns).round() * columns;
    return target.clamp(6, 24);
  }

  /// Mirrors the aspect ratio logic from
  /// [ResponsiveBookingsGrid].
  double _aspectRatio(double parentWidth, int columns, double padding) {
    final totalGap = (columns - 1) * kBookingsGridGap;
    final available = parentWidth - 2 * padding - totalGap;
    final cardWidth = available / columns;
    final ratio = cardWidth / 320;
    return ratio.clamp(0.5, 1.2);
  }
}

/// A single skeleton placeholder card that mimics the
/// shape of a [BookingCard].
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shimmerBase = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.4,
    );
    final shimmerHighlight = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.7,
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge placeholder
          _ShimmerBox(
            width: 80,
            height: 24,
            baseColor: shimmerBase,
            highlightColor: shimmerHighlight,
          ),
          const SizedBox(height: 16),
          // Avatar + name row
          Row(
            children: [
              _ShimmerCircle(
                size: 36,
                baseColor: shimmerBase,
                highlightColor: shimmerHighlight,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(
                      width: double.infinity,
                      height: 14,
                      baseColor: shimmerBase,
                      highlightColor: shimmerHighlight,
                    ),
                    const SizedBox(height: 6),
                    _ShimmerBox(
                      width: 60,
                      height: 12,
                      baseColor: shimmerBase,
                      highlightColor: shimmerHighlight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Second avatar + name row
          Row(
            children: [
              _ShimmerCircle(
                size: 36,
                baseColor: shimmerBase,
                highlightColor: shimmerHighlight,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(
                      width: double.infinity,
                      height: 14,
                      baseColor: shimmerBase,
                      highlightColor: shimmerHighlight,
                    ),
                    const SizedBox(height: 6),
                    _ShimmerBox(
                      width: 80,
                      height: 12,
                      baseColor: shimmerBase,
                      highlightColor: shimmerHighlight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Service row placeholder
          _ShimmerBox(
            width: double.infinity,
            height: 14,
            baseColor: shimmerBase,
            highlightColor: shimmerHighlight,
          ),
          const SizedBox(height: 12),
          // Time row placeholder
          _ShimmerBox(
            width: 120,
            height: 14,
            baseColor: shimmerBase,
            highlightColor: shimmerHighlight,
          ),
        ],
      ),
    );
  }
}

/// Rectangular shimmer placeholder.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.baseColor,
    required this.highlightColor,
  });

  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Circular shimmer placeholder for avatars.
class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle({
    required this.size,
    required this.baseColor,
    required this.highlightColor,
  });

  final double size;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}
