//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerTransactionsApi {
  PartnerTransactionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Flag or unflag transaction for review
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  ///
  /// * [FlagReviewDto] flagReviewDto (required):
  Future<Response> partnerTransactionsControllerFlagForReviewWithHttpInfo(String transactionId, FlagReviewDto flagReviewDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions/{transactionId}/review-flag'
      .replaceAll('{transactionId}', transactionId);

    // ignore: prefer_final_locals
    Object? postBody = flagReviewDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Flag or unflag transaction for review
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  ///
  /// * [FlagReviewDto] flagReviewDto (required):
  Future<PartnerTransactionRecordDto?> partnerTransactionsControllerFlagForReview(String transactionId, FlagReviewDto flagReviewDto,) async {
    final response = await partnerTransactionsControllerFlagForReviewWithHttpInfo(transactionId, flagReviewDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerTransactionRecordDto',) as PartnerTransactionRecordDto;
    
    }
    return null;
  }

  /// Get aggregated finance summary metrics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  Future<Response> partnerTransactionsControllerGetSummaryWithHttpInfo({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions/finance/summary';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (sourceType != null) {
      queryParams.addAll(_queryParams('', 'sourceType', sourceType));
    }
    if (transactionType != null) {
      queryParams.addAll(_queryParams('', 'transactionType', transactionType));
    }
    if (transactionStatus != null) {
      queryParams.addAll(_queryParams('', 'transactionStatus', transactionStatus));
    }
    if (settlementStatus != null) {
      queryParams.addAll(_queryParams('', 'settlementStatus', settlementStatus));
    }
    if (payoutStatus != null) {
      queryParams.addAll(_queryParams('', 'payoutStatus', payoutStatus));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get aggregated finance summary metrics
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  Future<PartnerFinanceSummaryDto?> partnerTransactionsControllerGetSummary({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, }) async {
    final response = await partnerTransactionsControllerGetSummaryWithHttpInfo( search: search, startDate: startDate, endDate: endDate, period: period, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, currency: currency, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerFinanceSummaryDto',) as PartnerFinanceSummaryDto;
    
    }
    return null;
  }

  /// Get transaction detail with payout and refund cases
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  Future<Response> partnerTransactionsControllerGetTransactionDetailWithHttpInfo(String transactionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions/{transactionId}'
      .replaceAll('{transactionId}', transactionId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get transaction detail with payout and refund cases
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  Future<PartnerTransactionDetailDto?> partnerTransactionsControllerGetTransactionDetail(String transactionId,) async {
    final response = await partnerTransactionsControllerGetTransactionDetailWithHttpInfo(transactionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerTransactionDetailDto',) as PartnerTransactionDetailDto;
    
    }
    return null;
  }

  /// List partner transactions with filters and pagination
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page (1-100)
  Future<Response> partnerTransactionsControllerGetTransactionsWithHttpInfo({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (sourceType != null) {
      queryParams.addAll(_queryParams('', 'sourceType', sourceType));
    }
    if (transactionType != null) {
      queryParams.addAll(_queryParams('', 'transactionType', transactionType));
    }
    if (transactionStatus != null) {
      queryParams.addAll(_queryParams('', 'transactionStatus', transactionStatus));
    }
    if (settlementStatus != null) {
      queryParams.addAll(_queryParams('', 'settlementStatus', settlementStatus));
    }
    if (payoutStatus != null) {
      queryParams.addAll(_queryParams('', 'payoutStatus', payoutStatus));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List partner transactions with filters and pagination
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page (1-100)
  Future<void> partnerTransactionsControllerGetTransactions({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, num? page, num? limit, }) async {
    final response = await partnerTransactionsControllerGetTransactionsWithHttpInfo( search: search, startDate: startDate, endDate: endDate, period: period, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, currency: currency, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get finance trend data (daily buckets)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  Future<Response> partnerTransactionsControllerGetTrendWithHttpInfo({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions/finance/trend';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (sourceType != null) {
      queryParams.addAll(_queryParams('', 'sourceType', sourceType));
    }
    if (transactionType != null) {
      queryParams.addAll(_queryParams('', 'transactionType', transactionType));
    }
    if (transactionStatus != null) {
      queryParams.addAll(_queryParams('', 'transactionStatus', transactionStatus));
    }
    if (settlementStatus != null) {
      queryParams.addAll(_queryParams('', 'settlementStatus', settlementStatus));
    }
    if (payoutStatus != null) {
      queryParams.addAll(_queryParams('', 'payoutStatus', payoutStatus));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get finance trend data (daily buckets)
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///   Free-text search (max 120 chars)
  ///
  /// * [String] startDate:
  ///   Inclusive start date (ISO 8601)
  ///
  /// * [String] endDate:
  ///   Inclusive end date (ISO 8601)
  ///
  /// * [PartnerFinancePeriod] period:
  ///   Relative time window (ignored when both startDate and endDate are set)
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///   Filter by commerce source
  ///
  /// * [PartnerTransactionType] transactionType:
  ///   Filter by transaction type
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///   Filter by transaction status
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///   Filter by settlement status
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///   Filter by payout status
  ///
  /// * [String] currency:
  ///   ISO 4217 currency code
  Future<List<PartnerFinanceTrendPointDto>?> partnerTransactionsControllerGetTrend({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, }) async {
    final response = await partnerTransactionsControllerGetTrendWithHttpInfo( search: search, startDate: startDate, endDate: endDate, period: period, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, currency: currency, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PartnerFinanceTrendPointDto>') as List)
        .cast<PartnerFinanceTrendPointDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Mark transaction settlement status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  ///
  /// * [MarkSettlementDto] markSettlementDto (required):
  Future<Response> partnerTransactionsControllerMarkSettledWithHttpInfo(String transactionId, MarkSettlementDto markSettlementDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/transactions/{transactionId}/settlement'
      .replaceAll('{transactionId}', transactionId);

    // ignore: prefer_final_locals
    Object? postBody = markSettlementDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark transaction settlement status
  ///
  /// Parameters:
  ///
  /// * [String] transactionId (required):
  ///
  /// * [MarkSettlementDto] markSettlementDto (required):
  Future<PartnerTransactionRecordDto?> partnerTransactionsControllerMarkSettled(String transactionId, MarkSettlementDto markSettlementDto,) async {
    final response = await partnerTransactionsControllerMarkSettledWithHttpInfo(transactionId, markSettlementDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerTransactionRecordDto',) as PartnerTransactionRecordDto;
    
    }
    return null;
  }
}
