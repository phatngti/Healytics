import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';

/// Friendly green/mint/teal pastel colors for card backgrounds.
const _friendlyCardColors = [
  Color(0xFFE8F5E9), // Light green 50
  Color(0xFFC8E6C9), // Light green 100
  Color(0xFFE0F2F1), // Teal 50
  Color(0xFFB2DFDB), // Teal 100
  Color(0xFFE0F7FA), // Cyan 50
  Color(0xFFB2EBF2), // Cyan 100
  Color(0xFFF1F8E9), // Lime 50
  Color(0xFFDCEDC8), // Lime 100
  Color(0xFFE8F8F5), // Mint pastel
  Color(0xFFD5F5E3), // Soft mint
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
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusBgColor;

  const _ActivityCard({
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
    final cardColor =
        _friendlyCardColors[Random().nextInt(_friendlyCardColors.length)];

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
          // Wrap text column in Expanded to prevent overflow.
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
