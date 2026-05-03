import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Paginated data table for admin ledger transactions.
class AdminFinanceTransactionTable extends StatelessWidget {
  const AdminFinanceTransactionTable({
    super.key,
    required this.records,
    required this.totalRows,
    required this.onRowTap,
    this.emptyMessage =
        'No transactions match the selected filters.',
  });

  final List<AdminFinanceTransactionRecord> records;
  final int totalRows;
  final ValueChanged<AdminFinanceTransactionId> onRowTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimens.spaceMd,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Reference')),
          DataColumn(label: Text('Partner')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Source')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Gross'), numeric: true),
          DataColumn(label: Text('Fee'), numeric: true),
          DataColumn(label: Text('Net'), numeric: true),
          DataColumn(label: Text('Currency')),
          DataColumn(label: Text('Payment')),
          DataColumn(label: Text('Settlement')),
          DataColumn(label: Text('Payout')),
          DataColumn(label: Text('Provider')),
          DataColumn(label: Text('Flag')),
        ],
        rows: records
            .map(
              (r) => DataRow(
                onSelectChanged: (_) => onRowTap(r.id),
                cells: [
                  DataCell(
                    Text(formatAdminDateTime(r.createdAt)),
                  ),
                  DataCell(
                    Text(
                      r.id.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.reference)),
                  DataCell(
                    Text(
                      r.partnerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.sourceType.label)),
                  DataCell(Text(r.type.label)),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.grossAmount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.feeAmount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.netAmount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(Text(r.currency)),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.transactionStatus.label,
                    ),
                  ),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.settlementStatus.label,
                    ),
                  ),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.payoutStatus.label,
                    ),
                  ),
                  DataCell(Text(r.provider.label)),
                  DataCell(
                    r.isFlagged
                        ? Icon(
                            Icons.flag_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .error,
                            size: 18,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Paginated data table for admin payouts.
class AdminFinancePayoutTable extends StatelessWidget {
  const AdminFinancePayoutTable({
    super.key,
    required this.records,
    required this.totalRows,
    required this.onRowTap,
    this.emptyMessage =
        'No payout batches match the selected filters.',
  });

  final List<AdminFinancePayoutRecord> records;
  final int totalRows;
  final ValueChanged<AdminFinancePayoutId> onRowTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimens.spaceMd,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Scheduled')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Partner')),
          DataColumn(label: Text('Period')),
          DataColumn(
            label: Text('Volume'),
            numeric: true,
          ),
          DataColumn(
            label: Text('Fees'),
            numeric: true,
          ),
          DataColumn(
            label: Text('Net'),
            numeric: true,
          ),
          DataColumn(label: Text('Currency')),
          DataColumn(label: Text('Method')),
          DataColumn(label: Text('Status')),
          DataColumn(
            label: Text('Attempts'),
            numeric: true,
          ),
          DataColumn(label: Text('Failure')),
          DataColumn(label: Text('Hold')),
        ],
        rows: records
            .map(
              (r) => DataRow(
                onSelectChanged: (_) => onRowTap(r.id),
                cells: [
                  DataCell(
                    Text(
                      formatAdminDate(r.scheduledDate),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.id.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.partnerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.periodLabel)),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.includedVolume,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.feesAndAdjustments,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.netPayout,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(Text(r.currency)),
                  DataCell(Text(r.method)),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.status.label,
                    ),
                  ),
                  DataCell(
                    Text(r.attemptCount.toString()),
                  ),
                  DataCell(
                    Text(
                      r.failureReason ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.holdReason ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Paginated data table for refund cases.
class AdminFinanceRefundCaseTable extends StatelessWidget {
  const AdminFinanceRefundCaseTable({
    super.key,
    required this.records,
    required this.totalRows,
    required this.onRowTap,
    this.emptyMessage =
        'No refund or dispute cases match '
        'the selected filters.',
  });

  final List<AdminFinanceRefundCaseRecord> records;
  final int totalRows;
  final ValueChanged<AdminFinanceRefundCaseId> onRowTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimens.spaceMd,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Requested')),
          DataColumn(label: Text('Case ID')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Txn ID')),
          DataColumn(label: Text('Partner')),
          DataColumn(label: Text('Customer')),
          DataColumn(
            label: Text('Amount'),
            numeric: true,
          ),
          DataColumn(label: Text('Currency')),
          DataColumn(label: Text('Reason')),
          DataColumn(label: Text('Owner')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('SLA')),
          DataColumn(label: Text('Risk')),
        ],
        rows: records
            .map(
              (r) => DataRow(
                onSelectChanged: (_) => onRowTap(r.id),
                cells: [
                  DataCell(
                    Text(
                      formatAdminDate(r.requestedAt),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.id.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.caseType.label)),
                  DataCell(
                    Text(
                      r.transactionId.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.partnerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.amount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(Text(r.currency)),
                  DataCell(
                    Text(
                      r.reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.owner)),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.status.label,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${r.slaHours}h${r.slaBreached ? ' ⚠' : ''}',
                    ),
                  ),
                  DataCell(
                    AdminFinanceRiskDot(
                      tone: r.riskTone,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Data table for reconciliation exceptions.
class AdminFinanceReconciliationTable
    extends StatelessWidget {
  const AdminFinanceReconciliationTable({
    super.key,
    required this.records,
    required this.totalRows,
    required this.onRowTap,
    this.emptyMessage =
        'No reconciliation exceptions match '
        'the selected filters.',
  });

  final List<AdminFinanceReconciliationException> records;
  final int totalRows;
  final ValueChanged<AdminFinanceReconciliationId>
      onRowTap;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimens.spaceMd,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Detected')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Provider')),
          DataColumn(label: Text('Event ID')),
          DataColumn(label: Text('Related Txn')),
          DataColumn(
            label: Text('Expected'),
            numeric: true,
          ),
          DataColumn(
            label: Text('Provider Amt'),
            numeric: true,
          ),
          DataColumn(
            label: Text('Diff'),
            numeric: true,
          ),
          DataColumn(label: Text('Currency')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Owner')),
        ],
        rows: records
            .map(
              (r) => DataRow(
                onSelectChanged: (_) => onRowTap(r.id),
                cells: [
                  DataCell(
                    Text(
                      formatAdminDate(r.detectedAt),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.id.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(r.provider.label)),
                  DataCell(
                    Text(
                      r.providerEventId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      r.relatedTransactionId?.value ??
                          '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.expectedAmount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.providerAmount,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatAdminCurrency(
                        r.difference,
                        r.currency,
                      ),
                    ),
                  ),
                  DataCell(Text(r.currency)),
                  DataCell(Text(r.type.label)),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.status.label,
                    ),
                  ),
                  DataCell(Text(r.owner)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Data table for export jobs.
class AdminFinanceExportTable extends StatelessWidget {
  const AdminFinanceExportTable({
    super.key,
    required this.records,
    this.emptyMessage =
        'No finance exports have been created yet.',
  });

  final List<AdminFinanceExportJob> records;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimens.spaceMd,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 44,
        columns: const [
          DataColumn(label: Text('Created')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Requested By')),
          DataColumn(label: Text('Status')),
          DataColumn(
            label: Text('Rows'),
            numeric: true,
          ),
          DataColumn(label: Text('Download')),
          DataColumn(label: Text('Expires')),
        ],
        rows: records
            .map(
              (r) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      formatAdminDateTime(r.createdAt),
                    ),
                  ),
                  DataCell(Text(r.id.value)),
                  DataCell(Text(r.type.label)),
                  DataCell(Text(r.requestedBy)),
                  DataCell(
                    AdminFinanceStatusChip(
                      label: r.status.label,
                    ),
                  ),
                  DataCell(
                    Text(r.rowCount.toString()),
                  ),
                  DataCell(
                    r.downloadUrl != null
                        ? Icon(
                            Icons.download_rounded,
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          )
                        : const Text('—'),
                  ),
                  DataCell(
                    Text(
                      r.expiresAt != null
                          ? formatAdminDate(
                              r.expiresAt!,
                            )
                          : '—',
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Empty state placeholder.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 48,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
            AppDimens.verticalSmall,
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
