import 'package:flutter/material.dart';

import '../../../domain/entities/customer.entity.dart';
import 'avatar_with_initials.widget.dart';

/// The em-dash placeholder used when a displayable field is
/// null or empty.
const _emDash = '—';

/// Maximum character length for the customer name display.
const _maxNameLength = 40;

/// Booking card sub-section that groups customer-facing fields
/// under a "Customer" role heading.
///
/// Displays:
/// - A "Customer" heading label.
/// - An [AvatarWithInitials] for the customer's avatar.
/// - The customer full name, truncated at [_maxNameLength]
///   characters with `maxLines: 1` and `TextOverflow.ellipsis`.
/// - The customer age as an integer.
///
/// When a displayable field is null or empty, an em-dash
/// placeholder is rendered in its position and all remaining
/// fields continue to render normally.
///
/// _(Req 2.1, 2.6, 2.7, 2.8, 2.9; Property 14)_
class CustomerSection extends StatelessWidget {
  /// Creates a customer section widget.
  const CustomerSection({required this.customer, super.key});

  /// The customer entity to display. May be `null` when the
  /// booking has missing customer data.
  final Customer? customer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Customer',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AvatarWithInitials(
              name: customer?.fullName ?? '',
              imageUrl: customer?.avatarUrl,
              radius: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayName,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _displayAge,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns the truncated customer name or an em-dash
  /// placeholder when the customer or name is unavailable.
  String get _displayName {
    final name = customer?.fullName;
    if (name == null || name.isEmpty) return _emDash;
    if (name.length > _maxNameLength) {
      return name.substring(0, _maxNameLength);
    }
    return name;
  }

  /// Returns the customer age as a string or an em-dash
  /// placeholder when the customer is unavailable.
  String get _displayAge {
    final c = customer;
    if (c == null) return _emDash;
    return '${c.age} years';
  }
}
