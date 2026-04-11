import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_filter_panel.widget.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _PayoutRowAction { breakdown, retry, export }

class PayoutsTable extends ConsumerWidget {
  const PayoutsTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reloadToken = ref.watch(financeReloadTokenProvider);
    final filterHash = ref.watch(financeFilterProvider).hashCode;
    final notifier = ref.read(transactionsManagerProvider.notifier);

    return SizedBox(
      height: height,
      child: AppTable(
        key: ValueKey('payouts-$reloadToken-$filterHash'),
        columns: TableColumns(
          columns: [
            TableColumnData(label: 'Payout ID', size: ColumnSize.S),
            TableColumnData(label: 'Period', size: ColumnSize.M),
            TableColumnData(label: 'Included Volume', size: ColumnSize.S),
            TableColumnData(label: 'Fees/Adjustments', size: ColumnSize.S),
            TableColumnData(label: 'Net Payout', size: ColumnSize.S),
            TableColumnData(label: 'Scheduled Date', size: ColumnSize.M),
            TableColumnData(label: 'Method', size: ColumnSize.M),
            TableColumnData(label: 'Status', size: ColumnSize.M),
            TableColumnData(label: 'Actions', size: ColumnSize.S),
          ],
        ).dataColumns(context),
        getTotalRows: notifier.getPayoutsTotalRows,
        getData: (setRowSelection, startingAt, count) async {
          final records = await notifier.getPayouts(
            startingAt: startingAt,
            count: count,
          );
          return records.map((record) {
            return DataRow(
              key: ValueKey(record.id.value),
              onSelectChanged: (selected) {
                if (selected != null) {
                  setRowSelection(ValueKey(record.id.value), selected);
                }
              },
              cells: [
                DataCell(Text(record.id.value)),
                DataCell(Text(record.periodLabel)),
                DataCell(
                  Text(
                    formatFinanceCurrency(
                      record.includedVolume,
                      record.currency,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    formatFinanceCurrency(
                      record.feesAdjustments,
                      record.currency,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    formatFinanceCurrency(record.netPayout, record.currency),
                  ),
                ),
                DataCell(Text(formatFinanceDateTime(record.scheduledDate))),
                DataCell(Text(record.method)),
                DataCell(
                  FinanceStatusBadge(
                    label: record.status.label,
                    backgroundColor: financeStatusBackground(
                      context,
                      record.status.label,
                    ),
                    foregroundColor: financeStatusForeground(
                      context,
                      record.status.label,
                    ),
                  ),
                ),
                DataCell(
                  PopupMenuButton<_PayoutRowAction>(
                    tooltip: 'Payout actions',
                    onSelected: (action) async {
                      switch (action) {
                        case _PayoutRowAction.breakdown:
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Payout ${record.id.value}'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Period: ${record.periodLabel}'),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Net payout: ${formatFinanceCurrency(record.netPayout, record.currency)}',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Transactions: ${record.includedTransactionIds.length}',
                                  ),
                                ],
                              ),
                            ),
                          );
                          break;
                        case _PayoutRowAction.retry:
                          if (record.status == PayoutStatus.failed) {
                            await notifier.retryPayout(record.id.value);
                          }
                          break;
                        case _PayoutRowAction.export:
                          final text = [
                            'Payout ${record.id.value}',
                            'Period: ${record.periodLabel}',
                            'Net: ${formatFinanceCurrency(record.netPayout, record.currency)}',
                            'Method: ${record.method}',
                          ].join('\n');
                          await Clipboard.setData(ClipboardData(text: text));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Payout statement copied to clipboard.',
                                ),
                              ),
                            );
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _PayoutRowAction.breakdown,
                        child: Text('View breakdown'),
                      ),
                      PopupMenuItem(
                        value: _PayoutRowAction.retry,
                        child: Text('Retry payout'),
                      ),
                      PopupMenuItem(
                        value: _PayoutRowAction.export,
                        child: Text('Export statement'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList();
        },
        defaultRowsPerPage: 10,
        onSearchChanged: notifier.setSearchQuery,
        functionButtons: const [
          TableFunctionButtonWidget(
            label: 'Filters',
            prefixIcon: Icons.filter_alt_outlined,
            child: FinanceFilterPanel(),
          ),
        ],
        buttons: [
          AppButton(
            buttonType: ButtonType.elevated,
            onPressed: () async {
              final csv = await notifier.buildPayoutsCsv();
              await Clipboard.setData(ClipboardData(text: csv));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payout CSV copied to clipboard.'),
                  ),
                );
              }
            },
            child: const Row(
              children: [
                Icon(Icons.download_outlined),
                SizedBox(width: 8),
                Text('Export Statement'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
