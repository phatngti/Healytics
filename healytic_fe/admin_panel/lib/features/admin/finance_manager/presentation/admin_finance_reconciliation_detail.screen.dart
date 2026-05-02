import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance.provider.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_audit_timeline.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_notes_panel.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminFinanceReconciliationDetailScreen
    extends ConsumerWidget {
  const AdminFinanceReconciliationDetailScreen({
    super.key,
    required this.exceptionId,
  });

  final String exceptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = AdminFinanceReconciliationId(exceptionId);
    final async = ref.watch(
      adminFinanceReconciliationDetailProvider(id),
    );
    final body = async.when(
      data: (d) => _Body(detail: d),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
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
  final AdminFinanceReconciliationDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = detail.exception;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    Navigator.of(context).pop(),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: Text(
                  'Exception ${e.id.value}',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: AppDimens.fontWeightBold,
                  ),
                ),
              ),
              AdminFinanceStatusChip(
                label: e.status.label,
              ),
            ]),
            AppDimens.verticalLarge,
            _info(context, 'Exception Summary', {
              'Type': e.type.label,
              'Provider': e.provider.label,
              'Event ID': e.providerEventId,
              'Related Txn':
                  e.relatedTransactionId?.value ?? '—',
              'Expected': formatAdminCurrency(
                e.expectedAmount, e.currency,
              ),
              'Provider Amt': formatAdminCurrency(
                e.providerAmount, e.currency,
              ),
              'Difference': formatAdminCurrency(
                e.difference, e.currency,
              ),
              'Owner': e.owner,
              'Detected': formatAdminDateTime(
                e.detectedAt,
              ),
            }),
            AppDimens.verticalMedium,
            _info(context, 'Provider Event Context', {
              'Detail': detail.providerEventContext,
            }),
            AppDimens.verticalMedium,
            _info(context, 'Ledger Context', {
              'Detail': detail.ledgerContext,
            }),
            if (detail.resolutionNotes.isNotEmpty) ...[
              AppDimens.verticalMedium,
              _info(context, 'Resolution', {
                'Notes': detail.resolutionNotes,
              }),
            ],
            AppDimens.verticalMedium,
            AdminFinanceAuditTimeline(
              events: detail.auditTrail,
            ),
            AppDimens.verticalMedium,
            AdminFinanceNotesPanel(
              notes: detail.notes,
              onAddNote: () => ref
                  .read(adminFinanceWorkspaceProvider
                      .notifier)
                  .bumpReload(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(
    BuildContext ctx,
    String title,
    Map<String, String> rows,
  ) {
    final cs = Theme.of(ctx).colorScheme;
    final tt = Theme.of(ctx).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMd,
        side: BorderSide(
          color: cs.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(title,
                style: tt.titleMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                )),
            AppDimens.verticalSmall,
            ...rows.entries.map((e) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.spaceXs,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(e.key,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        )),
                  ),
                  Expanded(
                    child: Text(e.value,
                        style: tt.bodyMedium,
                        maxLines: 3,
                        overflow:
                            TextOverflow.ellipsis),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
