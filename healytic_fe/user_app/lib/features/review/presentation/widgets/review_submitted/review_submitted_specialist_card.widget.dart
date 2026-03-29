import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

/// Confirmation card shown after a specialist review
/// is submitted.
///
/// Displays the specialist avatar with a check badge,
/// a summary line, star rating, and a "Submitted"
/// chip.
class ReviewSubmittedSpecialistCard
    extends StatelessWidget {
  /// Display name of the specialist.
  final String specialistName;

  /// Network URL for the specialist's avatar.
  final String? specialistAvatarUrl;

  /// Star rating the user submitted (1–5).
  final int rating;

  const ReviewSubmittedSpecialistCard({
    super.key,
    required this.specialistName,
    this.specialistAvatarUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppDimens.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface
                .withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(colors),
          AppDimens.horizontalLarge,
          Expanded(
            child: _buildInfo(textTheme, colors),
          ),
        ],
      ),
    );
  }

  /// Avatar with check badge overlay.
  Widget _buildAvatar(ColorScheme colors) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          AvatarImage(
            name: specialistName,
            imageUrl: specialistAvatarUrl,
            radius: 32,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      colors.surfaceContainerLowest,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 10,
                color: colors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Summary text, stars, and submitted badge.
  Widget _buildInfo(
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'You shared your thoughts on '
          '$specialistName.',
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalSmall,
        Row(
          children: [
            _buildStars(colors),
            AppDimens.horizontalMedium,
            _buildSubmittedBadge(
              textTheme,
              colors,
            ),
          ],
        ),
      ],
    );
  }

  /// Row of filled star icons based on rating.
  Widget _buildStars(ColorScheme colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating
              ? Icons.star_rounded
              : Icons.star_outline_rounded,
          size: 16,
          color: colors.primary,
        ),
      ),
    );
  }

  /// Small "Submitted" chip badge.
  Widget _buildSubmittedBadge(
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        'SUBMITTED',
        style: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
          fontSize: 9,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
