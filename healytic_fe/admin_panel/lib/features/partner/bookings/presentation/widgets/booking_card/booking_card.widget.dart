import 'package:flutter/material.dart';

import '../../../domain/entities/booking.entity.dart';
import '../../../domain/entities/booking_status.dart';
import '../../providers/booking_filter_predicates.dart';
import 'booking_card_header.widget.dart';
import 'customer_section.widget.dart';
import 'service_row.widget.dart';
import 'specialist_section.widget.dart';
import 'time_row.widget.dart';

/// Placeholder phrase used in the semantics label when a
/// field is null or empty.
const _unavailable = 'unavailable';

/// Parent widget that composes all booking card sub-sections
/// into a single visually compact card.
///
/// Composes:
/// - [BookingCardHeader] (slot tag + [StatusBadge])
/// - [CustomerSection]
/// - [SpecialistSection]
/// - [ServiceRow]
/// - [TimeRow]
///
/// Wraps the card in a single [Semantics] node whose label
/// concatenates Customer name, Specialist name, Service name,
/// formatted slot start, and status label, separated by
/// `", "`, substituting `"unavailable"` for any null/empty
/// field rather than omitting it.
///
/// Em-dash placeholders are rendered for any visible null
/// displayable field. All text uses `maxLines: 1` +
/// `TextOverflow.ellipsis`. Intrinsic minimum width ≤ 280 dp;
/// no horizontal overflow at any width in [280, 1500] dp.
///
/// _(Req 2.1–2.9, 4.8, 7.1, 7.4, Property 3, Property 14)_
class BookingCard extends StatelessWidget {
  /// Creates a booking card widget.
  const BookingCard({required this.booking, super.key});

  /// The booking entity to render.
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isProcessing =
        booking.status == BookingStatus.onProcess;

    return Semantics(
      label: _buildSemanticsLabel(),
      child: Card(
        elevation: 1,
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isProcessing
              ? BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                )
              : BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 0.5,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BookingCardHeader(
                service: booking.service,
                status: booking.status,
              ),
              const SizedBox(height: 12),
              CustomerSection(customer: booking.customer),
              const SizedBox(height: 12),
              SpecialistSection(specialist: booking.specialist),
              const SizedBox(height: 12),
              ServiceRow(service: booking.service),
              const SizedBox(height: 8),
              TimeRow(slot: booking.slot),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the accessibility label by concatenating key
  /// fields separated by `", "`. Substitutes
  /// [_unavailable] for any null or empty field.
  String _buildSemanticsLabel() {
    final parts = <String>[
      _fieldOrUnavailable(booking.customer.fullName),
      _fieldOrUnavailable(booking.specialist.fullName),
      _fieldOrUnavailable(booking.service.name),
      _slotStartOrUnavailable(),
      labelFor(booking.status),
    ];
    return parts.join(', ');
  }

  /// Returns [value] if non-null and non-empty, otherwise
  /// returns [_unavailable].
  String _fieldOrUnavailable(String? value) {
    if (value == null || value.isEmpty) return _unavailable;
    return value;
  }

  /// Returns the formatted slot start time or
  /// [_unavailable] when the slot is null.
  String _slotStartOrUnavailable() {
    final slot = booking.slot;
    return formatSlot(slot);
  }
}
