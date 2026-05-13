import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

const _exposureRowsPerPage = 10;
const _exposureTableHeight = 520.0;

/// Ranks partners by financial risk exposure.
class AdminFinancePartnerExposurePanel extends StatelessWidget {
  const AdminFinancePartnerExposurePanel({super.key, required this.exposures});

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
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    final rowsPerPage = exposures.length < _exposureRowsPerPage
        ? exposures.length
        : _exposureRowsPerPage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Exposure',
          style: tt.titleMedium?.copyWith(fontWeight: AppDimens.fontWeightBold),
        ),
        AppDimens.verticalSmall,
        SizedBox(
          height: _exposureTableHeight,
          child: AppTable(
            key: ValueKey(
              'admin-finance-partner-exposure-${exposures.length}'
              '-${exposures.first.partnerId.value}'
              '-${exposures.last.partnerId.value}',
            ),
            columns: const TableColumns(
              columns: [
                TableColumnData(label: 'Partner', size: ColumnSize.L),
                TableColumnData(label: 'Volume', size: ColumnSize.S),
                TableColumnData(label: 'Pending', size: ColumnSize.S),
                TableColumnData(label: 'Refunds', size: ColumnSize.S),
                TableColumnData(label: 'Failed', size: ColumnSize.S),
                TableColumnData(label: 'Held', size: ColumnSize.S),
                TableColumnData(label: 'Risk', size: ColumnSize.S),
              ],
            ).dataColumns(context),
            getTotalRows: () async => exposures.length,
            getData: (_, startingAt, count) async {
              if (startingAt >= exposures.length) {
                return [];
              }

              final end = (startingAt + count).clamp(0, exposures.length);
              return exposures
                  .sublist(startingAt, end)
                  .map(
                    (exposure) => DataRow(
                      key: ValueKey(
                        'partner-exposure-${exposure.partnerId.value}',
                      ),
                      cells: [
                        DataCell(
                          Text(
                            exposure.partnerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              exposure.totalVolume,
                              exposure.currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              exposure.pendingPayouts,
                              exposure.currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              exposure.refundExposure,
                              exposure.currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              exposure.failedPayments,
                              exposure.currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              exposure.heldFunds,
                              exposure.currency,
                            ),
                          ),
                        ),
                        DataCell(AdminFinanceRiskDot(tone: exposure.riskTone)),
                      ],
                    ),
                  )
                  .toList();
            },
            defaultRowsPerPage: rowsPerPage,
          ),
        ),
      ],
    );
  }
}
