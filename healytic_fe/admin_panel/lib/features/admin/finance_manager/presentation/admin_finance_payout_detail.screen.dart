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

/// Payout detail screen.
class AdminFinancePayoutDetailScreen
    extends ConsumerWidget {
  const AdminFinancePayoutDetailScreen({
    super.key,
    required this.payoutId,
  });

  final String payoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = AdminFinancePayoutId(payoutId);
    final detailAsync = ref.watch(
      adminFinancePayoutDetailProvider(id),
    );

    return ResponsiveWrapper(
      useLayout: true,
      desktop: detailAsync.when(
        data: (d) => _PayoutDetailDesktop(detail: d),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
      tablet: detailAsync.when(
        data: (d) => _PayoutDetailDesktop(detail: d),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
      mobile: detailAsync.when(
        data: (d) => _PayoutDetailDesktop(detail: d),
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

class _PayoutDetailDesktop extends ConsumerWidget {
  const _PayoutDetailDesktop({required this.detail});

  final AdminFinancePayoutDetail detail;

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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.of(context).pop(),
                ),
                AppDimens.horizontalSmall,
                Expanded(
                  child: Text(
                    'Payout ${r.id.value}',
                    style: tt.titleLarge?.copyWith(
                      fontWeight:
                          AppDimens.fontWeightBold,
                    ),
                  ),
                ),
                AdminFinanceStatusChip(
                  label: r.status.label,
                ),
              ],
            ),
            AppDimens.verticalLarge,
            Card(
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
                    Text(
                      'Payout Summary',
                      style: tt.titleMedium?.copyWith(
                        fontWeight:
                            AppDimens.fontWeightBold,
                      ),
                    ),
                    AppDimens.verticalSmall,
                    _row(tt, cs, 'Partner',
                        r.partnerName),
                    _row(tt, cs, 'Period',
                        r.periodLabel),
                    _row(tt, cs, 'Method', r.method),
                    _row(
                      tt,
                      cs,
                      'Destination',
                      detail.maskedDestination,
                    ),
                    _row(
                      tt,
                      cs,
                      'Net Payout',
                      formatAdminCurrency(
                        r.netPayout,
                        r.currency,
                      ),
                    ),
                    _row(
                      tt,
                      cs,
                      'Scheduled',
                      formatAdminDate(r.scheduledDate),
                    ),
                    if (r.failureReason != null)
                      _row(tt, cs, 'Failure',
                          r.failureReason!),
                    if (r.holdReason != null)
                      _row(tt, cs, 'Hold Reason',
                          r.holdReason!),
                  ],
                ),
              ),
            ),
            AppDimens.verticalMedium,

            // Attempts
            if (detail.attempts.isNotEmpty)
              Card(
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
                      Text(
                        'Payout Attempts',
                        style: tt.titleMedium?.copyWith(
                          fontWeight:
                              AppDimens.fontWeightBold,
                        ),
                      ),
                      AppDimens.verticalSmall,
                      ...detail.attempts.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimens.spaceXs,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '#${a.attemptNumber}',
                                style: tt.labelMedium,
                              ),
                              AppDimens.horizontalSmall,
                              AdminFinanceStatusChip(
                                label: a.status,
                              ),
                              AppDimens.horizontalSmall,
                              Text(
                                formatAdminDateTime(
                                  a.attemptedAt,
                                ),
                                style: tt.bodySmall,
                              ),
                              if (a.failureReason !=
                                  null) ...[
                                AppDimens.horizontalSmall,
                                Flexible(
                                  child: Text(
                                    a.failureReason!,
                                    style: tt.bodySmall
                                        ?.copyWith(
                                      color: cs.error,
                                    ),
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            AppDimens.verticalMedium,
            AdminFinanceAuditTimeline(
              events: detail.auditTrail,
            ),
            AppDimens.verticalMedium,
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

  Widget _row(
    TextTheme tt,
    ColorScheme cs,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
