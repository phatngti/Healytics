import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

const _trendRowsPerPage = 7;
const _trendTableHeight = 420.0;

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

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show last 7 data points as a summary strip.
    final sample = data.length > 7 ? data.sublist(data.length - 7) : data;

    final rowsPerPage = sample.length < _trendRowsPerPage
        ? sample.length
        : _trendRowsPerPage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Trend',
          style: tt.titleMedium?.copyWith(fontWeight: AppDimens.fontWeightBold),
        ),
        AppDimens.verticalSmall,
        SizedBox(
          height: _trendTableHeight,
          child: AppTable(
            key: ValueKey(
              'admin-finance-trend-${sample.first.date.toIso8601String()}'
              '-${sample.last.date.toIso8601String()}',
            ),
            columns: const TableColumns(
              columns: [
                TableColumnData(label: 'Date', size: ColumnSize.M),
                TableColumnData(label: 'Gross', size: ColumnSize.S),
                TableColumnData(label: 'Net', size: ColumnSize.S),
                TableColumnData(label: 'Refunds', size: ColumnSize.S),
                TableColumnData(label: 'Payouts', size: ColumnSize.S),
              ],
            ).dataColumns(context),
            getTotalRows: () async => sample.length,
            getData: (_, startingAt, count) async {
              if (startingAt >= sample.length) {
                return [];
              }

              final end = (startingAt + count).clamp(0, sample.length);
              return sample
                  .sublist(startingAt, end)
                  .map(
                    (point) => DataRow(
                      cells: [
                        DataCell(Text(formatAdminDate(point.date))),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              point.grossAmount,
                              currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              point.netAmount,
                              currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              point.refundAmount,
                              currency,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            formatAdminCurrencyCompact(
                              point.payoutAmount,
                              currency,
                            ),
                          ),
                        ),
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
