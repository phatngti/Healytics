import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_impl.repository.dart';
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

class AdminFinanceRefundCaseDetailScreen extends ConsumerWidget {
  const AdminFinanceRefundCaseDetailScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = AdminFinanceRefundCaseId(caseId);
    final async = ref.watch(adminFinanceRefundCaseDetailProvider(id));
    final body = async.when(
      data: (d) => _Body(detail: d),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
    return ResponsiveWrapper(
      useLayout: true,
      desktop: body,
      tablet: body,
      mobile: body,
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});
  final AdminFinanceRefundCaseDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = detail.record;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppDimens.horizontalSmall,
                Expanded(
                  child: Text(
                    '${r.caseType.label} ${r.id.value}',
                    style: tt.titleLarge?.copyWith(
                      fontWeight: AppDimens.fontWeightBold,
                    ),
                  ),
                ),
                AdminFinanceStatusChip(label: r.status.label),
              ],
            ),
            AppDimens.verticalMedium,
            Wrap(
              spacing: AppDimens.spaceSm,
              runSpacing: AppDimens.spaceSm,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Approve'),
                  onPressed: () async {
                    final note = await showAdminFinanceActionDialog(
                      context,
                      title: 'Approve Case',
                      description: 'Approve this refund or dispute case.',
                      confirmLabel: 'Approve',
                    );
                    if (note != null && context.mounted) {
                      await ref
                          .read(adminFinanceRepositoryProvider)
                          .approveRefundCase(
                            r.id,
                            note: note.isEmpty ? null : note,
                          );
                      ref
                          .read(adminFinanceWorkspaceProvider.notifier)
                          .bumpReload();
                    }
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Reject'),
                  onPressed: () async {
                    final note = await showAdminFinanceActionDialog(
                      context,
                      title: 'Reject Case',
                      description: 'Reject this refund or dispute case.',
                      confirmLabel: 'Reject',
                      requireNote: true,
                      isDestructive: true,
                    );
                    if (note != null && context.mounted) {
                      await ref
                          .read(adminFinanceRepositoryProvider)
                          .rejectRefundCase(r.id, note: note);
                      ref
                          .read(adminFinanceWorkspaceProvider.notifier)
                          .bumpReload();
                    }
                  },
                ),
              ],
            ),
            AppDimens.verticalLarge,
            _info(context, 'Summary', {
              'Transaction': r.transactionId.value,
              'Partner': r.partnerName,
              'Customer': r.customerName,
              'Amount': formatAdminCurrency(r.amount, r.currency),
              'Reason': r.reason,
              'Owner': r.owner,
              'SLA':
                  '${r.slaHours}h'
                  '${r.slaBreached ? " ⚠" : ""}',
            }),
            AppDimens.verticalMedium,
            _info(context, 'Customer Request', {
              'Message': detail.customerRequest,
            }),
            AppDimens.verticalMedium,
            _info(context, 'Partner Response', {
              'Response': detail.partnerResponse,
            }),
            if (detail.decisionNote.isNotEmpty) ...[
              AppDimens.verticalMedium,
              _info(context, 'Decision', {'Note': detail.decisionNote}),
            ],
            AppDimens.verticalMedium,
            AdminFinanceAuditTimeline(events: detail.auditTrail),
            AppDimens.verticalMedium,
            AdminFinanceNotesPanel(
              notes: detail.notes,
              onAddNote: () async {
                final note = await showAdminFinanceAddNoteDialog(context);
                if (note != null && context.mounted) {
                  await ref
                      .read(adminFinanceRepositoryProvider)
                      .addNote(
                        entityType: 'refundCase',
                        entityId: r.id.value,
                        content: note,
                      );
                  ref.read(adminFinanceWorkspaceProvider.notifier).bumpReload();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(BuildContext ctx, String title, Map<String, String> rows) {
    final cs = Theme.of(ctx).colorScheme;
    final tt = Theme.of(ctx).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMd,
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
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
            ...rows.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        e.key,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.value,
                        style: tt.bodyMedium,
                        maxLines: 3,
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
