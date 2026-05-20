import 'dart:math' as math;

import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_impl.repository.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _defaultRowsPerPage = 10;
const _tableChromeWidth = 136.0;

const _transactionColumns = [
  _FinanceTableColumn('Date', 152),
  _FinanceTableColumn('ID', 116),
  _FinanceTableColumn('Reference', 148),
  _FinanceTableColumn('Partner', 156),
  _FinanceTableColumn('Customer', 156),
  _FinanceTableColumn('Source', 136),
  _FinanceTableColumn('Type', 104),
  _FinanceTableColumn('Gross', 132),
  _FinanceTableColumn('Fee', 124),
  _FinanceTableColumn('Net', 132),
  _FinanceTableColumn('Currency', 96),
  _FinanceTableColumn('Payment', 132),
  _FinanceTableColumn('Settlement', 154),
  _FinanceTableColumn('Payout', 154),
  _FinanceTableColumn('Provider', 108),
  _FinanceTableColumn('Flag', 72),
];

const _payoutColumns = [
  _FinanceTableColumn('Scheduled', 128),
  _FinanceTableColumn('ID', 116),
  _FinanceTableColumn('Partner', 168),
  _FinanceTableColumn('Period', 144),
  _FinanceTableColumn('Volume', 132),
  _FinanceTableColumn('Fees', 132),
  _FinanceTableColumn('Net', 132),
  _FinanceTableColumn('Currency', 96),
  _FinanceTableColumn('Method', 132),
  _FinanceTableColumn('Status', 136),
  _FinanceTableColumn('Attempts', 96),
  _FinanceTableColumn('Failure', 220),
  _FinanceTableColumn('Hold', 220),
];

const _refundColumns = [
  _FinanceTableColumn('Requested', 128),
  _FinanceTableColumn('Case ID', 116),
  _FinanceTableColumn('Type', 124),
  _FinanceTableColumn('Txn ID', 116),
  _FinanceTableColumn('Partner', 160),
  _FinanceTableColumn('Customer', 160),
  _FinanceTableColumn('Amount', 132),
  _FinanceTableColumn('Currency', 96),
  _FinanceTableColumn('Reason', 240),
  _FinanceTableColumn('Owner', 132),
  _FinanceTableColumn('Status', 144),
  _FinanceTableColumn('SLA', 80),
  _FinanceTableColumn('Risk', 72),
];

const _reconciliationColumns = [
  _FinanceTableColumn('Detected', 128),
  _FinanceTableColumn('ID', 116),
  _FinanceTableColumn('Provider', 112),
  _FinanceTableColumn('Event ID', 164),
  _FinanceTableColumn('Related Txn', 128),
  _FinanceTableColumn('Expected', 132),
  _FinanceTableColumn('Provider Amt', 144),
  _FinanceTableColumn('Diff', 132),
  _FinanceTableColumn('Currency', 96),
  _FinanceTableColumn('Type', 220),
  _FinanceTableColumn('Status', 144),
  _FinanceTableColumn('Owner', 132),
];

const _exportColumns = [
  _FinanceTableColumn('Created', 152),
  _FinanceTableColumn('ID', 116),
  _FinanceTableColumn('Type', 132),
  _FinanceTableColumn('Requested By', 168),
  _FinanceTableColumn('Status', 136),
  _FinanceTableColumn('Rows', 88),
  _FinanceTableColumn('Download', 104),
  _FinanceTableColumn('Expires', 128),
];

/// Paginated AppTable for admin ledger transactions.
class AdminFinanceTransactionTable extends ConsumerWidget {
  const AdminFinanceTransactionTable({
    super.key,
    required this.filter,
    required this.reloadToken,
    required this.height,
    required this.onSearchChanged,
    required this.onRowTap,
  });

  final AdminFinanceFilter filter;
  final int reloadToken;
  final double height;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminFinanceTransactionId> onRowTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(adminFinanceRepositoryProvider);

    return _ContentSizedFinanceTable(
      height: height,
      contentWidth: _transactionColumns.tableWidth,
      searchQuery: filter.searchQuery,
      searchHint: 'ID, reference, partner, customer...',
      searchNote:
          'Searches ledger rows by transaction ID, reference, partner, and customer.',
      onSearchChanged: onSearchChanged,
      child: AppTable(
        key: ValueKey(
          'admin-finance-transactions-$reloadToken-${filter.hashCode}',
        ),
        columns: _transactionColumns.dataColumns(context),
        getTotalRows: () => repository.getTransactionTotalRows(filter),
        getData: (setRowSelection, startingAt, count) async {
          final records = await repository.getTransactions(
            filter: filter,
            startingAt: startingAt,
            count: count,
          );

          return records
              .map(
                (record) => _transactionRow(context, record, setRowSelection),
              )
              .toList();
        },
        defaultRowsPerPage: _defaultRowsPerPage,
      ),
    );
  }

  DataRow _transactionRow(
    BuildContext context,
    AdminFinanceTransactionRecord record,
    SetRowSelectionCallback setRowSelection,
  ) {
    final rowKey = ValueKey<String>(
      'admin-finance-transaction-${record.id.value}',
    );

    return DataRow(
      key: rowKey,
      onSelectChanged: (selected) {
        if (selected == null) {
          return;
        }
        setRowSelection(rowKey, selected);
        onRowTap(record.id);
      },
      cells: [
        DataCell(_TextCell(formatAdminDateTime(record.createdAt))),
        DataCell(_TextCell(record.id.value)),
        DataCell(_TextCell(record.reference)),
        DataCell(_TextCell(record.partnerName)),
        DataCell(_TextCell(record.customerName)),
        DataCell(_TextCell(record.sourceType.label)),
        DataCell(_TextCell(record.type.label)),
        DataCell(
          _TextCell(formatAdminCurrency(record.grossAmount, record.currency)),
        ),
        DataCell(
          _TextCell(formatAdminCurrency(record.feeAmount, record.currency)),
        ),
        DataCell(
          _TextCell(formatAdminCurrency(record.netAmount, record.currency)),
        ),
        DataCell(_TextCell(record.currency)),
        DataCell(AdminFinanceStatusChip(label: record.transactionStatus.label)),
        DataCell(AdminFinanceStatusChip(label: record.settlementStatus.label)),
        DataCell(AdminFinanceStatusChip(label: record.payoutStatus.label)),
        DataCell(_TextCell(record.provider.label)),
        DataCell(
          record.isFlagged
              ? Tooltip(
                  message: 'Flagged',
                  child: Icon(
                    Icons.flag_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 18,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Paginated AppTable for admin payouts.
class AdminFinancePayoutTable extends ConsumerWidget {
  const AdminFinancePayoutTable({
    super.key,
    required this.filter,
    required this.reloadToken,
    required this.height,
    required this.onSearchChanged,
    required this.onRowTap,
  });

  final AdminFinanceFilter filter;
  final int reloadToken;
  final double height;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminFinancePayoutId> onRowTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(adminFinanceRepositoryProvider);

    return _ContentSizedFinanceTable(
      height: height,
      contentWidth: _payoutColumns.tableWidth,
      searchQuery: filter.searchQuery,
      searchHint: 'Payout ID or partner...',
      searchNote: 'Searches payout rows by payout ID and partner.',
      onSearchChanged: onSearchChanged,
      child: AppTable(
        key: ValueKey('admin-finance-payouts-$reloadToken-${filter.hashCode}'),
        columns: _payoutColumns.dataColumns(context),
        getTotalRows: () => repository.getPayoutTotalRows(filter),
        getData: (setRowSelection, startingAt, count) async {
          final records = await repository.getPayouts(
            filter: filter,
            startingAt: startingAt,
            count: count,
          );

          return records
              .map((record) => _payoutRow(record, setRowSelection))
              .toList();
        },
        defaultRowsPerPage: _defaultRowsPerPage,
      ),
    );
  }

  DataRow _payoutRow(
    AdminFinancePayoutRecord record,
    SetRowSelectionCallback setRowSelection,
  ) {
    final rowKey = ValueKey<String>('admin-finance-payout-${record.id.value}');

    return DataRow(
      key: rowKey,
      onSelectChanged: (selected) {
        if (selected == null) {
          return;
        }
        setRowSelection(rowKey, selected);
        onRowTap(record.id);
      },
      cells: [
        DataCell(_TextCell(formatAdminDate(record.scheduledDate))),
        DataCell(_TextCell(record.id.value)),
        DataCell(_TextCell(record.partnerName)),
        DataCell(_TextCell(record.periodLabel)),
        DataCell(
          _TextCell(
            formatAdminCurrency(record.includedVolume, record.currency),
          ),
        ),
        DataCell(
          _TextCell(
            formatAdminCurrency(record.feesAndAdjustments, record.currency),
          ),
        ),
        DataCell(
          _TextCell(formatAdminCurrency(record.netPayout, record.currency)),
        ),
        DataCell(_TextCell(record.currency)),
        DataCell(_TextCell(record.method)),
        DataCell(AdminFinanceStatusChip(label: record.status.label)),
        DataCell(_TextCell(record.attemptCount.toString())),
        DataCell(_TextCell(record.failureReason ?? '-')),
        DataCell(_TextCell(record.holdReason ?? '-')),
      ],
    );
  }
}

/// Paginated AppTable for refund cases.
class AdminFinanceRefundCaseTable extends ConsumerWidget {
  const AdminFinanceRefundCaseTable({
    super.key,
    required this.filter,
    required this.reloadToken,
    required this.height,
    required this.onSearchChanged,
    required this.onRowTap,
  });

  final AdminFinanceFilter filter;
  final int reloadToken;
  final double height;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminFinanceRefundCaseId> onRowTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(adminFinanceRepositoryProvider);

    return _ContentSizedFinanceTable(
      height: height,
      contentWidth: _refundColumns.tableWidth,
      searchQuery: filter.searchQuery,
      searchHint: 'Case, transaction, partner, customer...',
      searchNote:
          'Searches refund rows by case ID, transaction ID, partner, customer, and reason.',
      onSearchChanged: onSearchChanged,
      child: AppTable(
        key: ValueKey('admin-finance-refunds-$reloadToken-${filter.hashCode}'),
        columns: _refundColumns.dataColumns(context),
        getTotalRows: () => repository.getRefundCaseTotalRows(filter),
        getData: (setRowSelection, startingAt, count) async {
          final records = await repository.getRefundCases(
            filter: filter,
            startingAt: startingAt,
            count: count,
          );

          return records
              .map((record) => _refundCaseRow(record, setRowSelection))
              .toList();
        },
        defaultRowsPerPage: _defaultRowsPerPage,
      ),
    );
  }

  DataRow _refundCaseRow(
    AdminFinanceRefundCaseRecord record,
    SetRowSelectionCallback setRowSelection,
  ) {
    final rowKey = ValueKey<String>('admin-finance-refund-${record.id.value}');

    return DataRow(
      key: rowKey,
      onSelectChanged: (selected) {
        if (selected == null) {
          return;
        }
        setRowSelection(rowKey, selected);
        onRowTap(record.id);
      },
      cells: [
        DataCell(_TextCell(formatAdminDate(record.requestedAt))),
        DataCell(_TextCell(record.id.value)),
        DataCell(_TextCell(record.caseType.label)),
        DataCell(_TextCell(record.transactionId.value)),
        DataCell(_TextCell(record.partnerName)),
        DataCell(_TextCell(record.customerName)),
        DataCell(
          _TextCell(formatAdminCurrency(record.amount, record.currency)),
        ),
        DataCell(_TextCell(record.currency)),
        DataCell(_TextCell(record.reason, maxLines: 2)),
        DataCell(_TextCell(record.owner)),
        DataCell(AdminFinanceStatusChip(label: record.status.label)),
        DataCell(
          _SlaCell(hours: record.slaHours, breached: record.slaBreached),
        ),
        DataCell(AdminFinanceRiskDot(tone: record.riskTone)),
      ],
    );
  }
}

/// Paginated AppTable for reconciliation exceptions.
class AdminFinanceReconciliationTable extends ConsumerWidget {
  const AdminFinanceReconciliationTable({
    super.key,
    required this.filter,
    required this.reloadToken,
    required this.height,
    required this.onSearchChanged,
    required this.onRowTap,
  });

  final AdminFinanceFilter filter;
  final int reloadToken;
  final double height;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminFinanceReconciliationId> onRowTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(adminFinanceRepositoryProvider);

    return _ContentSizedFinanceTable(
      height: height,
      contentWidth: _reconciliationColumns.tableWidth,
      searchQuery: filter.searchQuery,
      searchHint: 'Exception, provider event, transaction...',
      searchNote:
          'Searches reconciliation rows by exception ID, provider event, related transaction, and owner.',
      onSearchChanged: onSearchChanged,
      child: AppTable(
        key: ValueKey(
          'admin-finance-reconciliation-$reloadToken-${filter.hashCode}',
        ),
        columns: _reconciliationColumns.dataColumns(context),
        getTotalRows: () => repository.getReconciliationTotalRows(filter),
        getData: (setRowSelection, startingAt, count) async {
          final records = await repository.getReconciliationExceptions(
            filter: filter,
            startingAt: startingAt,
            count: count,
          );

          return records
              .map((record) => _reconciliationRow(record, setRowSelection))
              .toList();
        },
        defaultRowsPerPage: _defaultRowsPerPage,
      ),
    );
  }

  DataRow _reconciliationRow(
    AdminFinanceReconciliationException record,
    SetRowSelectionCallback setRowSelection,
  ) {
    final rowKey = ValueKey<String>(
      'admin-finance-reconciliation-${record.id.value}',
    );

    return DataRow(
      key: rowKey,
      onSelectChanged: (selected) {
        if (selected == null) {
          return;
        }
        setRowSelection(rowKey, selected);
        onRowTap(record.id);
      },
      cells: [
        DataCell(_TextCell(formatAdminDate(record.detectedAt))),
        DataCell(_TextCell(record.id.value)),
        DataCell(_TextCell(record.provider.label)),
        DataCell(_TextCell(record.providerEventId)),
        DataCell(_TextCell(record.relatedTransactionId?.value ?? '-')),
        DataCell(
          _TextCell(
            formatAdminCurrency(record.expectedAmount, record.currency),
          ),
        ),
        DataCell(
          _TextCell(
            formatAdminCurrency(record.providerAmount, record.currency),
          ),
        ),
        DataCell(
          _TextCell(formatAdminCurrency(record.difference, record.currency)),
        ),
        DataCell(_TextCell(record.currency)),
        DataCell(_TextCell(record.type.label, maxLines: 2)),
        DataCell(AdminFinanceStatusChip(label: record.status.label)),
        DataCell(_TextCell(record.owner)),
      ],
    );
  }
}

/// AppTable for export jobs.
class AdminFinanceExportTable extends StatelessWidget {
  const AdminFinanceExportTable({
    super.key,
    required this.records,
    required this.height,
  });

  final List<AdminFinanceExportJob> records;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _ContentSizedFinanceTable(
      height: height,
      contentWidth: _exportColumns.tableWidth,
      child: AppTable(
        key: ValueKey('admin-finance-exports-${records.hashCode}'),
        columns: _exportColumns.dataColumns(context),
        getTotalRows: () async => records.length,
        getData: (_, startingAt, count) async {
          if (startingAt >= records.length) {
            return [];
          }

          final end = (startingAt + count).clamp(0, records.length);
          return records
              .sublist(startingAt, end)
              .map((record) => _exportRow(context, record))
              .toList();
        },
        defaultRowsPerPage: _defaultRowsPerPage,
      ),
    );
  }

  DataRow _exportRow(BuildContext context, AdminFinanceExportJob record) {
    return DataRow(
      key: ValueKey<String>('admin-finance-export-${record.id.value}'),
      cells: [
        DataCell(_TextCell(formatAdminDateTime(record.createdAt))),
        DataCell(_TextCell(record.id.value)),
        DataCell(_TextCell(record.type.label)),
        DataCell(_TextCell(record.requestedBy)),
        DataCell(AdminFinanceStatusChip(label: record.status.label)),
        DataCell(_TextCell(record.rowCount.toString())),
        DataCell(
          record.downloadUrl != null
              ? Tooltip(
                  message: 'Download ready',
                  child: Icon(
                    Icons.download_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : const Text('-'),
        ),
        DataCell(
          _TextCell(
            record.expiresAt != null ? formatAdminDate(record.expiresAt!) : '-',
          ),
        ),
      ],
    );
  }
}

class _FinanceTableColumn {
  const _FinanceTableColumn(this.label, this.width);

  final String label;
  final double width;
}

extension _FinanceTableColumns on List<_FinanceTableColumn> {
  double get tableWidth {
    return fold<double>(
      _tableChromeWidth,
      (width, column) => width + column.width,
    );
  }

  List<DataColumn> dataColumns(BuildContext context) {
    return map(
      (column) => DataColumn2(
        fixedWidth: column.width,
        headingRowAlignment: MainAxisAlignment.start,
        label: _HeaderCell(column.label),
      ),
    ).toList();
  }
}

class _ContentSizedFinanceTable extends StatefulWidget {
  const _ContentSizedFinanceTable({
    required this.height,
    required this.contentWidth,
    required this.child,
    this.searchQuery,
    this.searchHint,
    this.searchNote,
    this.onSearchChanged,
  });

  final double height;
  final double contentWidth;
  final Widget child;
  final String? searchQuery;
  final String? searchHint;
  final String? searchNote;
  final ValueChanged<String>? onSearchChanged;

  @override
  State<_ContentSizedFinanceTable> createState() =>
      _ContentSizedFinanceTableState();
}

class _ContentSizedFinanceTableState extends State<_ContentSizedFinanceTable> {
  late final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.onSearchChanged != null) ...[
            _FinanceTableSearchHeader(
              value: widget.searchQuery ?? '',
              hintText: widget.searchHint ?? 'Search finance records...',
              note: widget.searchNote ?? 'Searches the rows in this table.',
              onChanged: widget.onSearchChanged!,
            ),
            AppDimens.verticalSmall,
          ],
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final viewportWidth = constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : widget.contentWidth;
                final tableWidth = math.max(viewportWidth, widget.contentWidth);
                final hasOverflow = tableWidth > viewportWidth;

                return Scrollbar(
                  controller: _horizontalController,
                  thumbVisibility: hasOverflow,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      height: constraints.maxHeight,
                      child: widget.child,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceTableSearchHeader extends StatefulWidget {
  const _FinanceTableSearchHeader({
    required this.value,
    required this.hintText,
    required this.note,
    required this.onChanged,
  });

  final String value;
  final String hintText;
  final String note;
  final ValueChanged<String> onChanged;

  @override
  State<_FinanceTableSearchHeader> createState() =>
      _FinanceTableSearchHeaderState();
}

class _FinanceTableSearchHeaderState extends State<_FinanceTableSearchHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _FinanceTableSearchHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) return;

    _controller.value = TextEditingValue(
      text: widget.value,
      selection: TextSelection.collapsed(offset: widget.value.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (value == widget.value) return;
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: TextField(
        controller: _controller,
        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        cursorColor: colorScheme.primary,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Search this table',
          helperText: widget.note,
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search, size: 18),
          border: OutlineInputBorder(borderRadius: AppDimens.radiusSm),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSmMd,
            vertical: AppDimens.spaceSmMd,
          ),
        ),
        onChanged: _handleChanged,
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _TextCell extends StatelessWidget {
  const _TextCell(this.value, {this.maxLines = 1});

  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}

class _SlaCell extends StatelessWidget {
  const _SlaCell({required this.hours, required this.breached});

  final int hours;
  final bool breached;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${hours}h'),
        if (breached) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.warning_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ],
    );
  }
}
