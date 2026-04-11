import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'filters transactions by search query and updates workflow actions',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(transactionsManagerProvider.notifier);

      notifier.setSearchQuery('BK-240408-001');
      final filtered = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(filtered, hasLength(1));
      expect(filtered.single.reference, 'BK-240408-001');

      notifier.clearFilters();

      final targetId = TransactionRecordId('txn_240315_002');
      final before = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(
        before.firstWhere((item) => item.id == targetId).settlementStatus,
        SettlementStatus.unsettled,
      );

      await notifier.markTransactionSettled(targetId);
      final after = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(
        after.firstWhere((item) => item.id == targetId).settlementStatus,
        SettlementStatus.settled,
      );

      await notifier.approveRefundCase('rf_240406_001');
      final refundCases = await notifier.getRefundCases(
        startingAt: 0,
        count: 20,
      );
      expect(
        refundCases
            .firstWhere((item) => item.id.value == 'rf_240406_001')
            .status,
        RefundCaseStatus.approved,
      );
    },
  );
}
