import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Audit trail timeline widget for detail screens.
class AdminFinanceAuditTimeline extends StatelessWidget {
  const AdminFinanceAuditTimeline({
    super.key,
    required this.events,
  });

  final List<AdminFinanceAuditEvent> events;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMd,
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audit Trail',
              style: tt.titleMedium?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.verticalSmall,
            if (events.isEmpty)
              Text(
                'No audit events recorded.',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              )
            else
              ...events.map(
                (e) => _AuditRow(event: e),
              ),
          ],
        ),
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.event});

  final AdminFinanceAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceSmMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            event.isError
                ? Icons.error_outline
                : Icons.check_circle_outline,
            size: 16,
            color: event.isError
                ? cs.error
                : cs.primary,
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${event.detail} — ${event.performedBy}',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            formatAdminDateTime(event.occurredAt),
            style: tt.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
