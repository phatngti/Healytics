import 'package:flutter/material.dart';

import '../../../domain/entities/specialist.entity.dart';
import 'avatar_with_initials.widget.dart';

/// Em-dash placeholder for null or empty displayable fields.
const _emDash = '—';

/// Maximum character length for the specialist name display.
const _maxNameLength = 40;

/// Maximum character length for the role label display.
const _maxRoleLabelLength = 50;

/// Booking card sub-section that displays specialist info
/// under a "Specialist" role heading.
///
/// Shows the specialist avatar (with initials fallback),
/// full name (truncated at 40 chars), and role label
/// (truncated at 50 chars). Renders an em-dash placeholder
/// for any null or empty displayable field and continues
/// rendering remaining fields.
///
/// All text uses `maxLines: 1` + `TextOverflow.ellipsis`.
///
/// _(Req 2.2, 2.6, 2.8, 2.9, Property 14)_
class SpecialistSection extends StatelessWidget {
  /// Creates a specialist section widget.
  const SpecialistSection({required this.specialist, super.key});

  /// The specialist entity to display. May have null fields
  /// for avatar; name and role are required by the entity
  /// but the widget handles display gracefully.
  final Specialist? specialist;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final name = specialist?.fullName;
    final roleLabel = specialist?.roleLabel;
    final avatarUrl = specialist?.avatarUrl;

    final displayName = _truncateOrPlaceholder(name, _maxNameLength);
    final displayRole = _truncateOrPlaceholder(roleLabel, _maxRoleLabelLength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Specialist',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AvatarWithInitials(
              name: name ?? '',
              imageUrl: avatarUrl,
              radius: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayRole,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns a truncated version of [value] capped at
  /// [maxLength], or an em-dash if [value] is null or empty.
  String _truncateOrPlaceholder(String? value, int maxLength) {
    if (value == null || value.isEmpty) return _emDash;
    if (value.length <= maxLength) return value;
    return value.substring(0, maxLength);
  }
}
