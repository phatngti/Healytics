import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Reusable action tile for the review-submitted
/// screen.
///
/// Displays a circular icon, title, subtitle, and a
/// trailing chevron. Includes hover/press effects.
class ReviewSubmittedActionTile extends StatelessWidget {
  /// Icon to display in the circular container.
  final IconData icon;

  /// Primary action title.
  final String title;

  /// Secondary description text.
  final String subtitle;

  /// Callback when the tile is tapped.
  final VoidCallback onTap;

  const ReviewSubmittedActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: AppDimens.radiusMedium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusMedium,
        child: Padding(
          padding: const EdgeInsets.all(
            AppDimens.spaceLg,
          ),
          child: Row(
            children: [
              _buildIconCircle(colors),
              AppDimens.horizontalLarge,
              Expanded(
                child: _buildText(
                  textTheme,
                  colors,
                ),
              ),
              AppDimens.horizontalSmall,
              Icon(
                Icons.chevron_right,
                color: colors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Circular icon container.
  Widget _buildIconCircle(ColorScheme colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceContainerLowest,
      ),
      child: Icon(
        icon,
        size: AppDimens.iconMd,
        color: colors.primary,
      ),
    );
  }

  /// Title and subtitle column.
  Widget _buildText(
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
