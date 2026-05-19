import 'package:flutter/material.dart';

import '../../domain/entities/booking.entity.dart';
import 'booking_card/booking_card.widget.dart';

/// Uniform inter-card gap on both axes (Req 4.7).
const double kBookingsGridGap = 16.0;

/// Returns the column count for the given [width] in dp.
///
/// Mapping per the responsive grid strategy:
/// - `width < 400` → 1 column (smallMobile + mobile)
/// - `400 ≤ width < 600` → 2 columns (largeMobile)
/// - `600 ≤ width ≤ 1200` → 3 columns (tablet)
/// - `width > 1200` → 4 columns (desktop)
///
/// _(Req 1.1, 4.1–4.4; Property 1)_
int columnsFor(double width) {
  if (width < 400) return 1;
  if (width < 600) return 2;
  if (width <= 1200) return 3;
  return 4;
}

/// Returns the horizontal padding for the given [width] in dp.
///
/// Follows the project's `getHorizontalPadding` convention:
/// - `width < 360` → 16 dp
/// - `360 ≤ width < 400` → 20 dp
/// - `width ≥ 400` → 24 dp
///
/// _(Req 4.6; Property 2)_
double getHorizontalPadding(double width) {
  if (width < 360) return 16.0;
  if (width < 400) return 20.0;
  return 24.0;
}

/// Responsive grid that adapts column count and padding to the
/// parent layout width on the first frame (no flicker).
///
/// Uses [LayoutBuilder] + [GridView.builder] with
/// [SliverGridDelegateWithFixedCrossAxisCount] to lazily
/// materialise [BookingCard] widgets. Column count, horizontal
/// padding, and inter-card gap are derived from the parent
/// layout width per the breakpoint mapping.
///
/// _(Req 1.1, 4.1–4.4, 4.6, 4.7, 4.9,
/// Property 1, Property 2, Property 3)_
class ResponsiveBookingsGrid extends StatelessWidget {
  /// Creates a responsive bookings grid.
  const ResponsiveBookingsGrid({required this.bookings, super.key});

  /// The list of bookings to render as cards.
  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = columnsFor(width);
        final padding = getHorizontalPadding(width);

        return GridView.builder(
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
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index]);
          },
        );
      },
    );
  }

  /// Computes a child aspect ratio that keeps cards compact
  /// without clipping content.
  ///
  /// Targets a card height of ~320 dp for comfortable content
  /// display; clamps the ratio to avoid extreme shapes.
  double _aspectRatio(double parentWidth, int columns, double padding) {
    final totalGap = (columns - 1) * kBookingsGridGap;
    final available = parentWidth - 2 * padding - totalGap;
    final cardWidth = available / columns;
    final ratio = cardWidth / 320;
    return ratio.clamp(0.5, 1.2);
  }
}
