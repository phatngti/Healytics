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
import 'package:go_router/go_router.dart';

import 'package:admin_panel/router/partner_routes.dart';

enum _RefundRowAction { approve, reject, open }

class RefundCasesTable extends ConsumerWidget {
  const RefundCasesTable({super.key, required this.height});

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
            TableColumnData(label: 'Case ID', size: ColumnSize.S),
            TableColumnData(label: 'Linked Transaction', size: ColumnSize.M),
            TableColumnData(label: 'Case Type', size: ColumnSize.S),
            TableColumnData(label: 'Requested At', size: ColumnSize.M),
            TableColumnData(label: 'Amount', size: ColumnSize.S),
            TableColumnData(label: 'Reason', size: ColumnSize.L),
            TableColumnData(label: 'Owner', size: ColumnSize.S),
            TableColumnData(label: 'Status', size: ColumnSize.M),
            TableColumnData(label: 'SLA', size: ColumnSize.S),
            TableColumnData(label: 'Actions', size: ColumnSize.S),
          ],
        ).dataColumns(context),
        getTotalRows: notifier.getRefundCasesTotalRows,
        getData: (setRowSelection, startingAt, count) async {
          final records = await notifier.getRefundCases(
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
                DataCell(Text(record.transactionId.value)),
                DataCell(Text(record.caseType.label)),
                DataCell(Text(formatFinanceDateTime(record.requestedAt))),
                DataCell(
                  Text(formatFinanceCurrency(record.amount, record.currency)),
                ),
                DataCell(
                  SizedBox(
                    width: 260,
                    child: Text(
                      record.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(record.owner)),
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
                DataCell(Text('${record.slaHours}h')),
                DataCell(
                  PopupMenuButton<_RefundRowAction>(
                    tooltip: 'Refund actions',
                    onSelected: (action) {
                      switch (action) {
                        case _RefundRowAction.approve:
                          if (record.status == RefundCaseStatus.pending ||
                              record.status == RefundCaseStatus.underReview) {
                            notifier.approveRefundCase(record.id.value);
                          }
                          break;
                        case _RefundRowAction.reject:
                          if (record.status == RefundCaseStatus.pending ||
                              record.status == RefundCaseStatus.underReview) {
                            notifier.rejectRefundCase(record.id.value);
                          }
                          break;
                        case _RefundRowAction.open:
                          context.goNamed(
                            TransactionDetailsRoute.name,
                            pathParameters: {'id': record.transactionId.value},
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _RefundRowAction.approve,
                        child: Text('Approve refund'),
                      ),
                      PopupMenuItem(
                        value: _RefundRowAction.reject,
                        child: Text('Reject refund'),
                      ),
                      PopupMenuItem(
                        value: _RefundRowAction.open,
                        child: Text('Open transaction'),
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
              final csv = await notifier.buildRefundCasesCsv();
              await Clipboard.setData(ClipboardData(text: csv));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Refund case CSV copied to clipboard.'),
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
