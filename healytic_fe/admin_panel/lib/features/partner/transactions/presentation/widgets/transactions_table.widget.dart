import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
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
import 'package:go_router/go_router.dart';

import 'package:admin_panel/router/partner_routes.dart';

enum _TransactionRowAction { details, settle, review }

class TransactionsTable extends ConsumerWidget {
  const TransactionsTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reloadToken = ref.watch(financeReloadTokenProvider);
    final filterHash = ref.watch(financeFilterProvider).hashCode;
    final notifier = ref.read(transactionsManagerProvider.notifier);

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(reloadToken, filterHash),
        columns: TableColumns(
          columns: [
            TableColumnData(label: 'ID', size: ColumnSize.S),
            TableColumnData(label: 'Created At', size: ColumnSize.M),
            TableColumnData(label: 'Type', size: ColumnSize.S),
            TableColumnData(label: 'Source', size: ColumnSize.S),
            TableColumnData(label: 'Reference', size: ColumnSize.M),
            TableColumnData(label: 'Customer', size: ColumnSize.M),
            TableColumnData(label: 'Gross', size: ColumnSize.S),
            TableColumnData(label: 'Fee', size: ColumnSize.S),
            TableColumnData(label: 'Net', size: ColumnSize.S),
            TableColumnData(label: 'Status', size: ColumnSize.M),
            TableColumnData(label: 'Settlement', size: ColumnSize.M),
            TableColumnData(label: 'Actions', size: ColumnSize.S),
          ],
        ).dataColumns(context),
        getTotalRows: notifier.getTransactionsTotalRows,
        getData: (setRowSelection, startingAt, count) async {
          final records = await notifier.getTransactions(
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
                DataCell(Text(formatFinanceDateTime(record.createdAt))),
                DataCell(Text(record.type.label)),
                DataCell(Text(record.sourceType.label)),
                DataCell(Text(record.reference)),
                DataCell(Text(record.customerName)),
                DataCell(
                  Text(
                    formatFinanceCurrency(record.grossAmount, record.currency),
                  ),
                ),
                DataCell(
                  Text(
                    formatFinanceCurrency(record.feeAmount, record.currency),
                  ),
                ),
                DataCell(
                  Text(
                    formatFinanceCurrency(record.netAmount, record.currency),
                  ),
                ),
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
                  FinanceStatusBadge(
                    label: record.settlementStatus.label,
                    backgroundColor: financeStatusBackground(
                      context,
                      record.settlementStatus.label,
                    ),
                    foregroundColor: financeStatusForeground(
                      context,
                      record.settlementStatus.label,
                    ),
                  ),
                ),
                DataCell(
                  PopupMenuButton<_TransactionRowAction>(
                    tooltip: 'Transaction actions',
                    onSelected: (action) {
                      switch (action) {
                        case _TransactionRowAction.details:
                          context.goNamed(
                            TransactionDetailsRoute.name,
                            pathParameters: {'id': record.id.value},
                          );
                          break;
                        case _TransactionRowAction.settle:
                          notifier.markTransactionSettled(record.id);
                          break;
                        case _TransactionRowAction.review:
                          notifier.flagTransactionForReview(record.id);
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _TransactionRowAction.details,
                        child: Text('View details'),
                      ),
                      PopupMenuItem(
                        value: _TransactionRowAction.settle,
                        child: Text('Mark settled'),
                      ),
                      PopupMenuItem(
                        value: _TransactionRowAction.review,
                        child: Text('Flag review'),
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
              final csv = await notifier.buildTransactionsCsv();
              await Clipboard.setData(ClipboardData(text: csv));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction CSV copied to clipboard.'),
                  ),
                );
              }
            },
            child: const Row(
              children: [
                Icon(Icons.download_outlined),
                SizedBox(width: 8),
                Text('Export CSV'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
