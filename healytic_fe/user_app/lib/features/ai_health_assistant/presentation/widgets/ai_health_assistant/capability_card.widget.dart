import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Single capability card showing an AI feature with
/// an icon, title and description.
class CapabilityCard extends StatelessWidget {
  const CapabilityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);
    final cardRad = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(cardRad),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.ctaButtonMd,
            height: AppDimens.ctaButtonMd,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppDimens.radiusSmall,
            ),
            child: Icon(
              icon,
              color: color,
              size: AppDimens.iconLg,
            ),
          ),
          SizedBox(height: AppDimens.spaceMd),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.spaceXs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
