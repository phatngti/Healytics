import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays the rating/reviews on the left and price on the right,
/// with a "Verified Treatment" label under the rating.
class RatingPriceRow extends StatelessWidget {
  const RatingPriceRow({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.priceSubtitle = 'per session',
    this.isVerified = false,
  });

  final double rating;
  final int reviewCount;
  final String price;
  final String priceSubtitle;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left – rating + verified label
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFBBF24), // amber-400
                  size: AppDimens.iconXs,
                ),
                AppDimens.horizontalExtraSmall,
                Text(
                  '${rating > 0 ? rating : 5.0}',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.horizontalExtraSmall,
                Text(
                  '($reviewCount  Reviews)',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (isVerified) ...[
              AppDimens.verticalExtraSmall,
              Text(
                'Verified Treatment',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        // Right – price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              priceSubtitle,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
