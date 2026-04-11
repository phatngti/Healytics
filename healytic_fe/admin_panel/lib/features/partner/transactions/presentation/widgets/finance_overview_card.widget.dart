import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:flutter/material.dart';

class FinanceOverviewCard extends StatelessWidget {
  const FinanceOverviewCard({super.key, required this.summary});

  final FinanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 20,
        children: [
          _OverviewItem(
            label: 'Available Balance',
            value: formatFinanceCurrency(
              summary.availableBalance,
              summary.currency,
            ),
          ),
          _OverviewItem(
            label: 'Pending Balance',
            value: formatFinanceCurrency(
              summary.pendingBalance,
              summary.currency,
            ),
          ),
          _OverviewItem(
            label: 'Next Payout Date',
            value: summary.nextPayoutAt == null
                ? 'No payout scheduled'
                : formatFinanceDate(summary.nextPayoutAt!),
          ),
          _OverviewItem(
            label: 'Payout Method / Status',
            value:
                '${summary.payoutMethod ?? 'Primary account'} • ${summary.payoutStatus?.label ?? 'Ready'}',
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  const _OverviewItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
