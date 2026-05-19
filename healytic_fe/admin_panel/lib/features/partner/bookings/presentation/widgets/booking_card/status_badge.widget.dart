import 'package:flutter/material.dart';

import '../../../domain/entities/booking_status.dart';
import '../booking_status_colors.theme.dart';

/// A colour-coded badge that displays the [BookingStatus] label.
///
/// Resolves both background and foreground colours from the
/// [BookingStatusColors] theme extension — no `Color` literals
/// anywhere in the render tree.
///
/// Mapping:
/// - [BookingStatus.finished]  → success (bg + fg)
/// - [BookingStatus.canceled]  → error (bg + fg)
/// - [BookingStatus.onProcess] → info (bg + fg)
/// - [BookingStatus.waiting]   → warning (bg + fg)
///
/// Ensures a minimum 48 × 48 dp hit area per Req 7.4.
///
/// _(Req 3.1, 3.2, 3.3, 3.4, 7.3, 7.4, Property 4, 5, 6)_
class StatusBadge extends StatelessWidget {
  /// Creates a status badge for the given [status].
  const StatusBadge({required this.status, super.key});

  /// The booking status to display.
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BookingStatusColors>()!;
    final (bg, fg) = _resolveColors(colors);
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            labelFor(status),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Maps [status] to the corresponding (background, foreground)
  /// colour pair from the theme extension.
  (Color, Color) _resolveColors(BookingStatusColors colors) {
    return switch (status) {
      BookingStatus.finished => (colors.successBg, colors.successFg),
      BookingStatus.canceled => (colors.errorBg, colors.errorFg),
      BookingStatus.onProcess => (colors.infoBg, colors.infoFg),
      BookingStatus.waiting => (colors.warningBg, colors.warningFg),
    };
  }
}
