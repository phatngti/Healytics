import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';

abstract class TransactionsRepository {
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  );

  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  );

  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<TransactionDetail> getTransactionById(TransactionRecordId id);

  Future<void> markTransactionSettled(TransactionRecordId id);

  Future<void> flagTransactionForReview(TransactionRecordId id);

  Future<void> approveRefundCase(String caseId);

  Future<void> rejectRefundCase(String caseId);

  Future<void> retryPayout(String payoutId);
}
