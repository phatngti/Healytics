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


/// tests for PartnerTransactionsApi
void main() {
  // final instance = PartnerTransactionsApi();

  group('tests for PartnerTransactionsApi', () {
    // Flag or unflag transaction for review
    //
    //Future<PartnerTransactionRecordDto> partnerTransactionsControllerFlagForReview(String transactionId, FlagReviewDto flagReviewDto) async
    test('test partnerTransactionsControllerFlagForReview', () async {
      // TODO
    });

    // Get aggregated finance summary metrics
    //
    //Future<PartnerFinanceSummaryDto> partnerTransactionsControllerGetSummary({ String search, String startDate, String endDate, PartnerFinancePeriod period, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, String currency }) async
    test('test partnerTransactionsControllerGetSummary', () async {
      // TODO
    });

    // Get transaction detail with payout and refund cases
    //
    //Future<PartnerTransactionDetailDto> partnerTransactionsControllerGetTransactionDetail(String transactionId) async
    test('test partnerTransactionsControllerGetTransactionDetail', () async {
      // TODO
    });

    // List partner transactions with filters and pagination
    //
    //Future partnerTransactionsControllerGetTransactions({ String search, String startDate, String endDate, PartnerFinancePeriod period, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, String currency, num page, num limit }) async
    test('test partnerTransactionsControllerGetTransactions', () async {
      // TODO
    });

    // Get finance trend data (daily buckets)
    //
    //Future<List<PartnerFinanceTrendPointDto>> partnerTransactionsControllerGetTrend({ String search, String startDate, String endDate, PartnerFinancePeriod period, PartnerCommerceSourceType sourceType, PartnerTransactionType transactionType, PartnerTransactionStatus transactionStatus, PartnerSettlementStatus settlementStatus, PartnerPayoutStatus payoutStatus, String currency }) async
    test('test partnerTransactionsControllerGetTrend', () async {
      // TODO
    });

    // Mark transaction settlement status
    //
    //Future<PartnerTransactionRecordDto> partnerTransactionsControllerMarkSettled(String transactionId, MarkSettlementDto markSettlementDto) async
    test('test partnerTransactionsControllerMarkSettled', () async {
      // TODO
    });

  });
}
