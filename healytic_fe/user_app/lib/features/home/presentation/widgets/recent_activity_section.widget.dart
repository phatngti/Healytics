import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';

/// Theme-aware pastel card colours derived from the current
/// [ColorScheme] containers, avoiding hardcoded hex values.
List<Color> _cardColors(ColorScheme cs) => [
  cs.primaryContainer.withValues(alpha: 0.4),
  cs.primaryContainer.withValues(alpha: 0.6),
  cs.secondaryContainer.withValues(alpha: 0.4),
  cs.secondaryContainer.withValues(alpha: 0.6),
  cs.tertiaryContainer.withValues(alpha: 0.4),
  cs.tertiaryContainer.withValues(alpha: 0.6),
];

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColors>()!;
    final titleGap = AppDimens.titleGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: titleGap),
        Column(
          children: [
            _ActivityCard(
              index: 0,
              icon: Symbols.schedule,
              iconColor: semanticColors.info!,
              iconBgColor: semanticColors.info!.withValues(alpha: 0.1),
              title: 'Aromatherapy',
              time: 'Yesterday at 3:00 PM',
              status: 'Completed',
              statusColor: semanticColors.success!,
              statusBgColor: semanticColors.success!.withValues(alpha: 0.1),
            ),
            SizedBox(height: AppDimens.spaceMd),
            _ActivityCard(
              index: 1,
              icon: Symbols.check_circle,
              iconColor: semanticColors.success!,
              iconBgColor: semanticColors.success!.withValues(alpha: 0.1),
              title: 'Wellness Consult',
              time: 'Tomorrow at 10:00 AM',
              status: 'Scheduled',
              statusColor: semanticColors.info!,
              statusBgColor: semanticColors.info!.withValues(alpha: 0.1),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusBgColor;

  const _ActivityCard({
    required this.index,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentPad = AppDimens.contentPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final colors = _cardColors(theme.colorScheme);
    final cardColor = colors[index % colors.length];

    return Container(
      padding: EdgeInsets.all(contentPad),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardRad),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: AppDimens.avatarMd,
            width: AppDimens.avatarMd,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXxs),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.spaceSm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceXs,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: AppDimens.radiusPill,
            ),
            child: Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
