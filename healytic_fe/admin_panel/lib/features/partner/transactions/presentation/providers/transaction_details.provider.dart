import 'package:admin_panel/features/partner/transactions/data/transactions_impl.repository.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionDetailsProvider =
    FutureProvider.family<TransactionDetail, TransactionRecordId>((
      ref,
      transactionId,
    ) async {
      final repository = ref.read(transactionsRepositoryProvider);
      return repository.getTransactionById(transactionId);
    });
