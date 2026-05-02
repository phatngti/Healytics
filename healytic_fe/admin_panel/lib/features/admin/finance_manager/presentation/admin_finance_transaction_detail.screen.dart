import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance.provider.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_action_dialogs.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_audit_timeline.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_notes_panel.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transaction detail screen.
class AdminFinanceTransactionDetailScreen
    extends ConsumerWidget {
  const AdminFinanceTransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = AdminFinanceTransactionId(transactionId);
    final detailAsync = ref.watch(
      adminFinanceTransactionDetailProvider(id),
    );

    return ResponsiveWrapper(
      useLayout: true,
      desktop: detailAsync.when(
        data: (detail) =>
            _TransactionDetailDesktop(detail: detail),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
      tablet: detailAsync.when(
        data: (detail) =>
            _TransactionDetailDesktop(detail: detail),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
      mobile: detailAsync.when(
        data: (detail) =>
            _TransactionDetailDesktop(detail: detail),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
    );
  }
}

class _TransactionDetailDesktop extends ConsumerWidget {
  const _TransactionDetailDesktop({
    required this.detail,
  });

  final AdminFinanceTransactionDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = detail.record;
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button + title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.of(context).pop(),
                ),
                AppDimens.horizontalSmall,
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ${r.id.value}',
                        style: tt.titleLarge?.copyWith(
                          fontWeight:
                              AppDimens.fontWeightBold,
                        ),
                      ),
                      Text(
                        r.reference,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminFinanceStatusChip(
                  label: r.transactionStatus.label,
                ),
              ],
            ),
            AppDimens.verticalLarge,

            // Summary
            _InfoCard(
              title: 'Transaction Summary',
              rows: [
                _InfoRow('Type', r.type.label),
                _InfoRow('Source', r.sourceType.label),
                _InfoRow(
                  'Gross',
                  formatAdminCurrency(
                    r.grossAmount,
                    r.currency,
                  ),
                ),
                _InfoRow(
                  'Fee',
                  formatAdminCurrency(
                    r.feeAmount,
                    r.currency,
                  ),
                ),
                _InfoRow(
                  'Net',
                  formatAdminCurrency(
                    r.netAmount,
                    r.currency,
                  ),
                ),
                _InfoRow('Currency', r.currency),
                _InfoRow('Provider', r.provider.label),
                _InfoRow(
                  'Settlement',
                  r.settlementStatus.label,
                ),
                _InfoRow(
                  'Payout Status',
                  r.payoutStatus.label,
                ),
                _InfoRow(
                  'Created',
                  formatAdminDateTime(r.createdAt),
                ),
              ],
            ),
            AppDimens.verticalMedium,

            // Partner & Customer
            _InfoCard(
              title: 'Participants',
              rows: [
                _InfoRow('Partner', r.partnerName),
                _InfoRow('Customer', r.customerName),
              ],
            ),
            AppDimens.verticalMedium,

            // Provider Events
            if (detail.providerEvents.isNotEmpty) ...[
              _InfoCard(
                title: 'Provider Events',
                rows: detail.providerEvents
                    .map(
                      (e) => _InfoRow(
                        e.eventType,
                        '${e.detail} '
                        '(${formatAdminDateTime(e.occurredAt)})',
                      ),
                    )
                    .toList(),
              ),
              AppDimens.verticalMedium,
            ],

            // Related Refund Cases
            if (detail.relatedRefundCases.isNotEmpty) ...[
              _InfoCard(
                title: 'Related Refund Cases',
                rows: detail.relatedRefundCases
                    .map(
                      (rc) => _InfoRow(
                        rc.id.value,
                        '${rc.status.label} — '
                        '${formatAdminCurrency(rc.amount, rc.currency)}',
                      ),
                    )
                    .toList(),
              ),
              AppDimens.verticalMedium,
            ],

            // Audit Trail
            AdminFinanceAuditTimeline(
              events: detail.auditTrail,
            ),
            AppDimens.verticalMedium,

            // Notes
            AdminFinanceNotesPanel(
              notes: detail.notes,
              onAddNote: () async {
                final note =
                    await showAdminFinanceAddNoteDialog(
                  context,
                );
                if (note != null && context.mounted) {
                  ref
                      .read(
                        adminFinanceWorkspaceProvider
                            .notifier,
                      )
                      .bumpReload();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared detail helpers ───────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
              title,
              style: tt.titleMedium?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.verticalSmall,
            ...rows.map(
              (r) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppDimens.spaceXs,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        r.label,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r.value,
                        style: tt.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;
}
