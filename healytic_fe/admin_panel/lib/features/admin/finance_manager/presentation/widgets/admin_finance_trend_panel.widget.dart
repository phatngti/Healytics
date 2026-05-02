import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays a simple trend summary table.
///
/// A full chart (e.g. fl_chart) can replace this
/// once fl_chart is added as a dependency.
class AdminFinanceTrendPanel extends StatelessWidget {
  const AdminFinanceTrendPanel({
    super.key,
    required this.data,
    required this.currency,
  });

  final List<AdminFinanceTrendPoint> data;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show last 7 data points as a summary strip.
    final sample = data.length > 7
        ? data.sublist(data.length - 7)
        : data;

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
              'Revenue Trend',
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
                  DataColumn(label: Text('Date')),
                  DataColumn(
                    label: Text('Gross'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Net'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Refunds'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Payouts'),
                    numeric: true,
                  ),
                ],
                rows: sample
                    .map(
                      (p) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              formatAdminDate(p.date),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                p.grossAmount,
                                currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                p.netAmount,
                                currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                p.refundAmount,
                                currency,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              formatAdminCurrencyCompact(
                                p.payoutAmount,
                                currency,
                              ),
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
