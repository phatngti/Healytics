import 'package:admin_panel/features/partner/transactions/data/transactions_remote.datasource.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/domain/transactions.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsImplRepository implements TransactionsRepository {
  TransactionsImplRepository({required this.remoteDataSource});

  final TransactionsRemoteDataSource remoteDataSource;

  @override
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  ) {
    return remoteDataSource.getFinanceSummary(filter, period);
  }

  @override
  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  ) {
    return remoteDataSource.getFinanceTrend(filter, period);
  }

  @override
  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) {
    return remoteDataSource.getTransactions(
      startingAt: startingAt,
      count: count,
      filter: filter,
    );
  }

  @override
  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) {
    return remoteDataSource.getPayouts(
      startingAt: startingAt,
      count: count,
      filter: filter,
    );
  }

  @override
  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) {
    return remoteDataSource.getRefundCases(
      startingAt: startingAt,
      count: count,
      filter: filter,
    );
  }

  @override
  Future<TransactionDetail> getTransactionById(TransactionRecordId id) {
    return remoteDataSource.getTransactionById(id);
  }

  @override
  Future<void> markTransactionSettled(TransactionRecordId id) {
    return remoteDataSource.markTransactionSettled(id);
  }

  @override
  Future<void> flagTransactionForReview(TransactionRecordId id) {
    return remoteDataSource.flagTransactionForReview(id);
  }

  @override
  Future<void> approveRefundCase(String caseId) {
    return remoteDataSource.approveRefundCase(caseId);
  }

  @override
  Future<void> rejectRefundCase(String caseId) {
    return remoteDataSource.rejectRefundCase(caseId);
  }

  @override
  Future<void> retryPayout(String payoutId) {
    return remoteDataSource.retryPayout(payoutId);
  }
}

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final remoteDataSource = ref.read(transactionsRemoteDataSourceProvider);
  return TransactionsImplRepository(remoteDataSource: remoteDataSource);
});
