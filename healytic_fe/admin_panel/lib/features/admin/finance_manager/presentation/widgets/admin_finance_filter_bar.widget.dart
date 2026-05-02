import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance_state.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Dense filter bar with dropdowns and toggles.
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
  final ValueChanged<AdminFinanceSourceType?>
      onSourceTypeChanged;
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
  final ValueChanged<AdminFinanceProvider?>
      onProviderChanged;
  final ValueChanged<String?> onCurrencyChanged;
  final ValueChanged<bool> onFlaggedChanged;
  final ValueChanged<bool> onSlaBreachedChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filter = state.filter;

    return Wrap(
      spacing: AppDimens.spaceSmMd,
      runSpacing: AppDimens.spaceSmMd,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search
        SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search...',
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: AppDimens.radiusSm,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSmMd,
                vertical: AppDimens.spaceSmMd,
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ),

        // Source Type
        _EnumDropdown<AdminFinanceSourceType>(
          hint: 'Source',
          value: filter.sourceType,
          values: AdminFinanceSourceType.values,
          labelOf: (v) => v.label,
          onChanged: onSourceTypeChanged,
        ),

        // Transaction Type
        _EnumDropdown<AdminFinanceTransactionType>(
          hint: 'Txn Type',
          value: filter.transactionType,
          values: AdminFinanceTransactionType.values,
          labelOf: (v) => v.label,
          onChanged: onTransactionTypeChanged,
        ),

        // Transaction Status
        _EnumDropdown<AdminFinanceTransactionStatus>(
          hint: 'Payment',
          value: filter.transactionStatus,
          values: AdminFinanceTransactionStatus.values,
          labelOf: (v) => v.label,
          onChanged: onTransactionStatusChanged,
        ),

        // Settlement Status
        _EnumDropdown<AdminFinanceSettlementStatus>(
          hint: 'Settlement',
          value: filter.settlementStatus,
          values: AdminFinanceSettlementStatus.values,
          labelOf: (v) => v.label,
          onChanged: onSettlementStatusChanged,
        ),

        // Payout Status
        _EnumDropdown<AdminFinancePayoutStatus>(
          hint: 'Payout',
          value: filter.payoutStatus,
          values: AdminFinancePayoutStatus.values,
          labelOf: (v) => v.label,
          onChanged: onPayoutStatusChanged,
        ),

        // Refund Status
        _EnumDropdown<AdminFinanceRefundCaseStatus>(
          hint: 'Refund',
          value: filter.refundCaseStatus,
          values: AdminFinanceRefundCaseStatus.values,
          labelOf: (v) => v.label,
          onChanged: onRefundCaseStatusChanged,
        ),

        // Reconciliation Status
        _EnumDropdown<AdminFinanceReconciliationStatus>(
          hint: 'Recon',
          value: filter.reconciliationStatus,
          values:
              AdminFinanceReconciliationStatus.values,
          labelOf: (v) => v.label,
          onChanged: onReconciliationStatusChanged,
        ),

        // Provider
        _EnumDropdown<AdminFinanceProvider>(
          hint: 'Provider',
          value: filter.provider,
          values: AdminFinanceProvider.values,
          labelOf: (v) => v.label,
          onChanged: onProviderChanged,
        ),

        // Currency
        _EnumDropdown<String>(
          hint: 'Currency',
          value: filter.currency,
          values: const ['VND', 'USD'],
          labelOf: (v) => v,
          onChanged: onCurrencyChanged,
        ),

        // Flagged toggle
        FilterChip(
          label: const Text('Flagged'),
          selected: filter.onlyFlagged,
          showCheckmark: true,
          onSelected: onFlaggedChanged,
        ),

        // SLA Breached toggle
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
}

class _EnumDropdown<T> extends StatelessWidget {
  const _EnumDropdown({
    required this.hint,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  final String hint;
  final T? value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: DropdownButtonFormField<T>(
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: AppDimens.radiusSm,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSmMd,
            vertical: AppDimens.spaceSmMd,
          ),
        ),
        value: value,
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(
              'All',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
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
