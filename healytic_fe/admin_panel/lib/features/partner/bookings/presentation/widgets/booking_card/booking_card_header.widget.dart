import 'package:flutter/material.dart';

import '../../../domain/entities/booking_status.dart';
import '../../../domain/entities/service.entity.dart';
import 'status_badge.widget.dart';

/// Em-dash placeholder for null text display.
const _emDash = '—';

/// Thin layout-only wrapper that places service name/category and
/// [StatusBadge] in a compact block at the top of a [BookingCard].
///
/// Not one of the five named sub-sections from Requirement 9
/// — it exists purely to share a consistent header layout
/// regardless of card width.
class BookingCardHeader extends StatelessWidget {
  /// Creates a booking card header.
  const BookingCardHeader({
    required this.service,
    required this.status,
    super.key,
  });

  /// The service displayed as the booking's primary card heading.
  final Service? service;

  /// The booking status for the badge.
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _serviceName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        StatusBadge(status: status),
      ],
    );
  }

  String get _serviceName {
    final name = service?.name.trim();
    return name == null || name.isEmpty ? _emDash : name;
  }

  String get _categoryName {
    final category = service?.categoryName.trim();
    return category == null || category.isEmpty ? _emDash : category;
  }
}
