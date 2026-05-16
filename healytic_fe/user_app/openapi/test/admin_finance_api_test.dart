//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:user_openapi/api.dart';
import 'package:test/test.dart';


/// tests for AdminFinanceApi
void main() {
  // final instance = AdminFinanceApi();

  group('tests for AdminFinanceApi', () {
    // Add a note to a finance entity
    //
    //Future<AdminFinanceNoteDto> adminFinanceControllerAddNote(AdminFinanceCreateNoteDto adminFinanceCreateNoteDto) async
    test('test adminFinanceControllerAddNote', () async {
      // TODO
    });

    // Approve a refund or dispute case
    //
    //Future<AdminFinanceRefundCaseDetailDto> adminFinanceControllerApproveRefundCase(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto) async
    test('test adminFinanceControllerApproveRefundCase', () async {
      // TODO
    });

    // Create a finance export job
    //
    //Future<AdminFinanceExportJobDto> adminFinanceControllerCreateExport(AdminFinanceCreateExportDto adminFinanceCreateExportDto) async
    test('test adminFinanceControllerCreateExport', () async {
      // TODO
    });

    // Flag or unflag a transaction for finance review
    //
    //Future<AdminFinanceTransactionRecordDto> adminFinanceControllerFlagTransaction(String id, AdminFinanceReviewFlagActionDto adminFinanceReviewFlagActionDto) async
    test('test adminFinanceControllerFlagTransaction', () async {
      // TODO
    });

    // Get derived operational finance alerts
    //
    //Future<List<AdminFinanceAlertDto>> adminFinanceControllerGetAlerts({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetAlerts', () async {
      // TODO
    });

    // List finance export jobs
    //
    //Future<List<AdminFinanceExportJobDto>> adminFinanceControllerGetExports() async
    test('test adminFinanceControllerGetExports', () async {
      // TODO
    });

    // Rank partner financial exposure
    //
    //Future<List<AdminFinancePartnerExposureDto>> adminFinanceControllerGetPartnerExposure({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetPartnerExposure', () async {
      // TODO
    });

    // Get payout detail
    //
    //Future<AdminFinancePayoutDetailDto> adminFinanceControllerGetPayoutDetail(String id) async
    test('test adminFinanceControllerGetPayoutDetail', () async {
      // TODO
    });

    // List platform payouts
    //
    //Future<AdminFinancePayoutPageDto> adminFinanceControllerGetPayouts({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetPayouts', () async {
      // TODO
    });

    // List reconciliation exceptions
    //
    //Future<AdminFinanceReconciliationPageDto> adminFinanceControllerGetReconciliation({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetReconciliation', () async {
      // TODO
    });

    // Get reconciliation exception detail
    //
    //Future<AdminFinanceReconciliationDetailDto> adminFinanceControllerGetReconciliationDetail(String id) async
    test('test adminFinanceControllerGetReconciliationDetail', () async {
      // TODO
    });

    // Get refund or dispute case detail
    //
    //Future<AdminFinanceRefundCaseDetailDto> adminFinanceControllerGetRefundCaseDetail(String id) async
    test('test adminFinanceControllerGetRefundCaseDetail', () async {
      // TODO
    });

    // List platform refund and dispute cases
    //
    //Future<AdminFinanceRefundCasePageDto> adminFinanceControllerGetRefundCases({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetRefundCases', () async {
      // TODO
    });

    // Get platform-wide admin finance summary metrics
    //
    //Future<AdminFinanceOverviewDto> adminFinanceControllerGetSummary({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetSummary', () async {
      // TODO
    });

    // Get platform ledger transaction detail
    //
    //Future<AdminFinanceTransactionDetailDto> adminFinanceControllerGetTransactionDetail(String id) async
    test('test adminFinanceControllerGetTransactionDetail', () async {
      // TODO
    });

    // List platform ledger transactions
    //
    //Future<AdminFinanceTransactionPageDto> adminFinanceControllerGetTransactions({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetTransactions', () async {
      // TODO
    });

    // Get platform-wide finance trend data
    //
    //Future<List<AdminFinanceTrendPointDto>> adminFinanceControllerGetTrend({ String search, AdminFinancePeriod period, DateTime startDate, DateTime endDate, String partnerId, String customerId, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, PartnerRefundCaseStatus refundCaseStatus, PartnerRefundCaseType refundCaseType, AdminFinanceReconciliationStatus reconciliationStatus, AdminFinanceProvider provider, String currency, num minAmount, num maxAmount, bool onlyFlagged, bool onlySlaBreached, num page, num limit }) async
    test('test adminFinanceControllerGetTrend', () async {
      // TODO
    });

    // Place an admin hold on a payout
    //
    //Future<AdminFinancePayoutDetailDto> adminFinanceControllerHoldPayout(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto) async
    test('test adminFinanceControllerHoldPayout', () async {
      // TODO
    });

    // Mark transaction settlement status with an admin note
    //
    //Future<AdminFinanceTransactionRecordDto> adminFinanceControllerMarkSettlement(String id, AdminFinanceSettlementActionDto adminFinanceSettlementActionDto) async
    test('test adminFinanceControllerMarkSettlement', () async {
      // TODO
    });

    // Reject a refund or dispute case
    //
    //Future<AdminFinanceRefundCaseDetailDto> adminFinanceControllerRejectRefundCase(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto) async
    test('test adminFinanceControllerRejectRefundCase', () async {
      // TODO
    });

    // Release an admin hold from a payout
    //
    //Future<AdminFinancePayoutDetailDto> adminFinanceControllerReleasePayoutHold(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto) async
    test('test adminFinanceControllerReleasePayoutHold', () async {
      // TODO
    });

    // Reopen a reconciliation exception
    //
    //Future<AdminFinanceReconciliationDetailDto> adminFinanceControllerReopenReconciliation(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto) async
    test('test adminFinanceControllerReopenReconciliation', () async {
      // TODO
    });

    // Resolve a reconciliation exception
    //
    //Future<AdminFinanceReconciliationDetailDto> adminFinanceControllerResolveReconciliation(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto) async
    test('test adminFinanceControllerResolveReconciliation', () async {
      // TODO
    });

    // Retry a failed or held payout
    //
    //Future<AdminFinancePayoutDetailDto> adminFinanceControllerRetryPayout(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto) async
    test('test adminFinanceControllerRetryPayout', () async {
      // TODO
    });

  });
}
