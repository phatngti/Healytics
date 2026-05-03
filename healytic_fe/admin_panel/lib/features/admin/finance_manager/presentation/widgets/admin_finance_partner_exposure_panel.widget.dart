import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Ranks partners by financial risk exposure.
class AdminFinancePartnerExposurePanel
    extends StatelessWidget {
  const AdminFinancePartnerExposurePanel({
    super.key,
    required this.exposures,
  });

  final List<AdminFinancePartnerExposure> exposures;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (exposures.isEmpty) {
      return Center(
        child: Padding(
          padding: AppDimens.paddingAllLarge,
          child: Text(
            'No partner exposure data matches '
            'the selected filters.',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

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
              'Partner Exposure',
              style: tt.titleMedium?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.verticalSmall,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: AppDimens.spaceLg,
                headingRowHeight: 36,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 36,
                columns: const [
                  DataColumn(label: Text('Partner')),
                  DataColumn(
                    label: Text('Volume'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Pending'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Refunds'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Failed'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Held'),
                    numeric: true,
                  ),
                  DataColumn(label: Text('Risk')),
                ],
                rows: exposures
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              e.partnerName,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                e.totalVolume,
                                e.currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                e.pendingPayouts,
                                e.currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                e.refundExposure,
                                e.currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                e.failedPayments,
                                e.currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                e.heldFunds,
                                e.currency,
                              ),
                            ),
                          ),
                          DataCell(
                            AdminFinanceRiskDot(
                              tone: e.riskTone,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
