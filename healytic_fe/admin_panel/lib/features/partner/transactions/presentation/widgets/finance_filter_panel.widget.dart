import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinanceFilterPanel extends ConsumerStatefulWidget {
  const FinanceFilterPanel({super.key});

  @override
  ConsumerState<FinanceFilterPanel> createState() => _FinanceFilterPanelState();
}

class _FinanceFilterPanelState extends ConsumerState<FinanceFilterPanel> {
  late FinanceFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(transactionsManagerProvider).filter;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(transactionsManagerProvider.notifier);
    return SizedBox(
      width: 380,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _DatePickerTile(
              label: 'Start date',
              value: _draft.startDate,
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(startDate: value);
              }),
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              label: 'End date',
              value: _draft.endDate,
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(endDate: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CommerceSourceType?>(
              initialValue: _draft.sourceType,
              decoration: const InputDecoration(labelText: 'Source'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All sources')),
                ...CommerceSourceType.values.map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                ),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(sourceType: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TransactionType?>(
              initialValue: _draft.transactionType,
              decoration: const InputDecoration(labelText: 'Transaction type'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All types')),
                ...TransactionType.values.map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                ),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(transactionType: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TransactionStatus?>(
              initialValue: _draft.transactionStatus,
              decoration: const InputDecoration(labelText: 'Lifecycle status'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All statuses'),
                ),
                ...TransactionStatus.values.map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                ),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(transactionStatus: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SettlementStatus?>(
              initialValue: _draft.settlementStatus,
              decoration: const InputDecoration(labelText: 'Settlement status'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All settlements'),
                ),
                ...SettlementStatus.values.map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                ),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(settlementStatus: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PayoutStatus?>(
              initialValue: _draft.payoutStatus,
              decoration: const InputDecoration(labelText: 'Payout status'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All payout states'),
                ),
                ...PayoutStatus.values.map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                ),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(payoutStatus: value);
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _draft.currency,
              decoration: const InputDecoration(labelText: 'Currency'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All currencies')),
                DropdownMenuItem(value: 'VND', child: Text('VND')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
              ],
              onChanged: (value) => setState(() {
                _draft = _draft.copyWith(currency: value);
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _draft = const FinanceFilter();
                    });
                    notifier.clearFilters();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => notifier.updateFilter(_draft),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2025),
          lastDate: DateTime(2027),
          initialDate: value ?? DateTime(2026, 4, 9),
        );
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: value == null
              ? null
              : IconButton(
                  onPressed: () => onChanged(null),
                  icon: const Icon(Icons.clear),
                ),
        ),
        child: Text(value == null ? 'Select date' : formatFinanceDate(value!)),
      ),
    );
  }
}
