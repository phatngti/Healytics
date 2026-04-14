import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays the partner verification status
/// as a coloured chip badge.
class VerificationBadgeWidget extends StatelessWidget {
  const VerificationBadgeWidget({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final (color, icon) = _statusStyle(cs);

    return Card(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Status',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimens.verticalMediumSmall,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppDimens.radiusSmall,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: AppDimens.iconSmMd),
                  AppDimens.horizontalSmall,
                  Text(
                    _formatStatus(status),
                    style: tt.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, IconData) _statusStyle(ColorScheme cs) {
    return switch (status) {
      'APPROVED' => (cs.primary, Icons.verified_rounded),
      'PENDING' => (cs.tertiary, Icons.hourglass_top_rounded),
      'REJECTED' => (cs.error, Icons.cancel_rounded),
      'REQUIRED_RESUBMIT' => (cs.error, Icons.error_outline_rounded),
      _ => (cs.outline, Icons.info_outline_rounded),
    };
  }

  String _formatStatus(String raw) {
    return raw
        .split('_')
        .where((p) => p.isNotEmpty)
        .map(
          (p) =>
              '${p[0].toUpperCase()}'
              '${p.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
