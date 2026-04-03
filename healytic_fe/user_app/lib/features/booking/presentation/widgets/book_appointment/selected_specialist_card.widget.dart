import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Compact card showing the selected specialist context
/// at the top of Screen 2 (Select Time).
///
/// Displays avatar, name, specialty, rating, and a
/// "Change" action button.
class SelectedSpecialistCard extends StatelessWidget {
  const SelectedSpecialistCard({
    super.key,
    required this.name,
    required this.specialty,
    this.rating = 4.9,
    this.reviewCount = 120,
    this.onChangePressed,
  });

  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final VoidCallback? onChangePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with online indicator
          _AvatarWithStatus(name: name),
          SizedBox(width: AppDimens.spaceLg),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXxs),
                Text(
                  specialty,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppDimens.spaceXs),
                _RatingRow(
                  rating: rating,
                  reviewCount: reviewCount,
                ),
              ],
            ),
          ),

          // Change button
          GestureDetector(
            onTap: onChangePressed,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceXs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer
                    .withValues(alpha: 0.5),
                borderRadius: AppDimens.radiusSmall,
              ),
              child: Text(
                'Change',
                style: theme.textTheme.labelSmall
                    ?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar with a green online status dot.
class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: AppDimens.avatarLg,
      height: AppDimens.avatarLg,
      child: Stack(
        children: [
          Container(
            width: AppDimens.avatarLg,
            height: AppDimens.avatarLg,
            decoration: BoxDecoration(
              color:
                  colorScheme.surfaceContainerHighest,
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(
              Symbols.person,
              size: AppDimens.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Positioned(
            bottom: -1,
            right: -1,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: AppDimens.spaceSm,
                height: AppDimens.spaceSm,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Star rating + review count row.
class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          Symbols.star,
          size: AppDimens.iconSm,
          color: colorScheme.tertiary,
          fill: 1,
        ),
        SizedBox(width: AppDimens.spaceXxs),
        Text(
          rating.toStringAsFixed(1),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(width: AppDimens.spaceXs),
        Text(
          '($reviewCount Reviews)',
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: colorScheme.onSurfaceVariant
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
