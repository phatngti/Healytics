import 'package:flutter/material.dart';

import '../../../domain/entities/booking_slot.entity.dart';
import '../../providers/booking_filter_predicates.dart';

/// Displays the booking time slot as a full date plus `"HH:mm - HH:mm"`.
///
/// Uses [formatSlot] from the pure helpers to produce the
/// formatted string. When [slot] is `null`, renders an
/// em-dash ("—") placeholder per Requirement 2.8.
///
/// All text uses `maxLines: 1` with `TextOverflow.ellipsis`
/// per Requirement 2.9. Colours are resolved from the
/// current theme — no `Color` literals.
///
/// _(Req 2.4, 2.8, 2.9, Property 14)_
class TimeRow extends StatelessWidget {
  /// Creates a [TimeRow] widget.
  const TimeRow({required this.slot, super.key});

  /// The booking slot to display, or `null` for a
  /// placeholder.
  final BookingSlot? slot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final displayText = slot != null ? formatFullSlot(slot!) : '—';

    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
