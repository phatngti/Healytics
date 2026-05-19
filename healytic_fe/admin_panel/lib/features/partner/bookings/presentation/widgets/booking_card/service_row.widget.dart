import 'package:flutter/material.dart';

import '../../../domain/entities/service.entity.dart';
import '../../providers/booking_filter_predicates.dart';

/// Em-dash placeholder for null or empty displayable fields.
const _emDash = '—';

/// Booking card sub-section that displays the locale-formatted price.
///
/// Uses [formatPrice] from the pure helpers to produce the
/// currency-formatted price string. When [service] is `null`, renders an
/// em-dash placeholder for price per Requirement 2.8.
///
/// All text uses `maxLines: 1` with `TextOverflow.ellipsis`
/// per Requirement 2.9. Colours are resolved from the
/// current theme — no `Color` literals.
///
/// _(Req 2.3, 2.8, 2.9, Property 14)_
class ServiceRow extends StatelessWidget {
  /// Creates a [ServiceRow] widget.
  const ServiceRow({required this.service, super.key});

  /// The service entity to display, or `null` for
  /// placeholders.
  final Service? service;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          Icons.payments_outlined,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _displayPrice,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the formatted price or an em-dash placeholder
  /// when the service is unavailable.
  String get _displayPrice {
    final s = service;
    if (s == null) return _emDash;
    return formatPrice(s.price, s.currencyCode);
  }
}
