import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance_state.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Dense filter bar that shows only tab-relevant
/// filters with clear labels.
class AdminFinanceFilterBar extends StatelessWidget {
  const AdminFinanceFilterBar({
    super.key,
    required this.state,
    required this.onSearchChanged,
    required this.onSourceTypeChanged,
    required this.onTransactionTypeChanged,
    required this.onTransactionStatusChanged,
    required this.onSettlementStatusChanged,
    required this.onPayoutStatusChanged,
    required this.onRefundCaseStatusChanged,
    required this.onReconciliationStatusChanged,
    required this.onProviderChanged,
    required this.onCurrencyChanged,
    required this.onFlaggedChanged,
    required this.onSlaBreachedChanged,
    required this.onReset,
  });

  final AdminFinanceWorkspaceState state;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminFinanceSourceType?> onSourceTypeChanged;
  final ValueChanged<AdminFinanceTransactionType?>
      onTransactionTypeChanged;
  final ValueChanged<AdminFinanceTransactionStatus?>
      onTransactionStatusChanged;
  final ValueChanged<AdminFinanceSettlementStatus?>
      onSettlementStatusChanged;
  final ValueChanged<AdminFinancePayoutStatus?>
      onPayoutStatusChanged;
  final ValueChanged<AdminFinanceRefundCaseStatus?>
      onRefundCaseStatusChanged;
  final ValueChanged<AdminFinanceReconciliationStatus?>
      onReconciliationStatusChanged;
  final ValueChanged<AdminFinanceProvider?> onProviderChanged;
  final ValueChanged<String?> onCurrencyChanged;
  final ValueChanged<bool> onFlaggedChanged;
  final ValueChanged<bool> onSlaBreachedChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filter = state.filter;
    final tab = state.activeTab;

    return Wrap(
      spacing: AppDimens.spaceSmMd,
      runSpacing: AppDimens.spaceSmMd,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search — always visible
        SizedBox(
          width: 200,
          child: TextField(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.transparent,
            ),
            cursorColor: Colors.transparent,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Search',
              hintText: 'ID, partner…',
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: AppDimens.radiusSm,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSmMd,
                vertical: AppDimens.spaceSmMd,
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ),

        // --- Common filters (all data tabs) ---
        ..._commonFilters(filter, tab),

        // --- Tab-specific filters ---
        ..._tabSpecificFilters(filter, tab),

        // Flagged toggle — relevant for ledger & overview
        if (_showFlaggedFilter(tab))
          FilterChip(
            label: const Text('Flagged'),
            selected: filter.onlyFlagged,
            showCheckmark: true,
            onSelected: onFlaggedChanged,
          ),

        // SLA Breached toggle — relevant for payouts &
        // reconciliation
        if (_showSlaFilter(tab))
          FilterChip(
            label: const Text('SLA Breached'),
            selected: filter.onlySlaBreached,
            showCheckmark: true,
            onSelected: onSlaBreachedChanged,
          ),

        // Reset
        if (filter.hasActiveFilters)
          TextButton.icon(
            icon: Icon(
              Icons.clear_all_rounded,
              color: cs.error,
              size: 18,
            ),
            label: Text(
              'Reset',
              style: TextStyle(color: cs.error),
            ),
            onPressed: onReset,
          ),
      ],
    );
  }

  /// Filters shown across most data-bearing tabs.
  List<Widget> _commonFilters(
    AdminFinanceFilter filter,
    AdminFinanceWorkspaceTab tab,
  ) {
    // Overview & exports don't need row-level filters
    if (tab == AdminFinanceWorkspaceTab.overview ||
        tab == AdminFinanceWorkspaceTab.exports) {
      return [];
    }

    return [
      _EnumDropdown<AdminFinanceProvider>(
        label: 'Provider',
        value: filter.provider,
        values: AdminFinanceProvider.values,
        labelOf: (v) => v.label,
        onChanged: onProviderChanged,
      ),
      _EnumDropdown<String>(
        label: 'Currency',
        value: filter.currency,
        values: const ['VND', 'USD'],
        labelOf: (v) => v,
        onChanged: onCurrencyChanged,
      ),
    ];
  }

  /// Filters specific to the currently active tab.
  List<Widget> _tabSpecificFilters(
    AdminFinanceFilter filter,
    AdminFinanceWorkspaceTab tab,
  ) {
    return switch (tab) {
      AdminFinanceWorkspaceTab.ledger => [
          _EnumDropdown<AdminFinanceSourceType>(
            label: 'Source',
            value: filter.sourceType,
            values: AdminFinanceSourceType.values,
            labelOf: (v) => v.label,
            onChanged: onSourceTypeChanged,
          ),
          _EnumDropdown<AdminFinanceTransactionType>(
            label: 'Txn Type',
            value: filter.transactionType,
            values: AdminFinanceTransactionType.values,
            labelOf: (v) => v.label,
            onChanged: onTransactionTypeChanged,
          ),
          _EnumDropdown<AdminFinanceTransactionStatus>(
            label: 'Payment',
            value: filter.transactionStatus,
            values:
                AdminFinanceTransactionStatus.values,
            labelOf: (v) => v.label,
            onChanged: onTransactionStatusChanged,
          ),
          _EnumDropdown<AdminFinanceSettlementStatus>(
            label: 'Settlement',
            value: filter.settlementStatus,
            values:
                AdminFinanceSettlementStatus.values,
            labelOf: (v) => v.label,
            onChanged: onSettlementStatusChanged,
          ),
        ],
      AdminFinanceWorkspaceTab.payouts => [
          _EnumDropdown<AdminFinancePayoutStatus>(
            label: 'Payout Status',
            value: filter.payoutStatus,
            values: AdminFinancePayoutStatus.values,
            labelOf: (v) => v.label,
            onChanged: onPayoutStatusChanged,
          ),
        ],
      AdminFinanceWorkspaceTab.refunds => [
          _EnumDropdown<AdminFinanceRefundCaseStatus>(
            label: 'Refund Status',
            value: filter.refundCaseStatus,
            values:
                AdminFinanceRefundCaseStatus.values,
            labelOf: (v) => v.label,
            onChanged: onRefundCaseStatusChanged,
          ),
        ],
      AdminFinanceWorkspaceTab.reconciliation => [
          _EnumDropdown<
              AdminFinanceReconciliationStatus>(
            label: 'Recon Status',
            value: filter.reconciliationStatus,
            values:
                AdminFinanceReconciliationStatus
                    .values,
            labelOf: (v) => v.label,
            onChanged: onReconciliationStatusChanged,
          ),
        ],
      _ => [],
    };
  }

  bool _showFlaggedFilter(AdminFinanceWorkspaceTab tab) {
    return tab == AdminFinanceWorkspaceTab.overview ||
        tab == AdminFinanceWorkspaceTab.ledger;
  }

  bool _showSlaFilter(AdminFinanceWorkspaceTab tab) {
    return tab == AdminFinanceWorkspaceTab.payouts ||
        tab == AdminFinanceWorkspaceTab.reconciliation;
  }
}

class _EnumDropdown<T> extends StatelessWidget {
  const _EnumDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<T>(
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: AppDimens.radiusSm,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSmMd,
            vertical: AppDimens.spaceSmMd,
          ),
        ),
        initialValue: value,
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(
              'All',
              style:
                  Theme.of(context).textTheme.bodySmall,
            ),
          ),
          ...values.map(
            (v) => DropdownMenuItem<T>(
              value: v,
              child: Text(
                labelOf(v),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
