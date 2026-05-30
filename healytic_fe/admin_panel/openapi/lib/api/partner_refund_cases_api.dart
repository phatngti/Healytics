//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerRefundCasesApi {
  PartnerRefundCasesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Approve a refund or dispute case
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] caseId (required):
  ///
  /// * [RefundCaseActionDto] refundCaseActionDto (required):
  Future<Response> partnerRefundCasesControllerApproveWithHttpInfo(String caseId, RefundCaseActionDto refundCaseActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/refund-cases/{caseId}/approve'
      .replaceAll('{caseId}', caseId);

    // ignore: prefer_final_locals
    Object? postBody = refundCaseActionDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Approve a refund or dispute case
  ///
  /// Parameters:
  ///
  /// * [String] caseId (required):
  ///
  /// * [RefundCaseActionDto] refundCaseActionDto (required):
  Future<PartnerRefundCaseRecordDto?> partnerRefundCasesControllerApprove(String caseId, RefundCaseActionDto refundCaseActionDto,) async {
    final response = await partnerRefundCasesControllerApproveWithHttpInfo(caseId, refundCaseActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerRefundCaseRecordDto',) as PartnerRefundCaseRecordDto;

    }
    return null;
  }

  /// List refund and dispute cases
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
  Future<Response> partnerRefundCasesControllerGetRefundCasesWithHttpInfo({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/refund-cases';

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

  /// List refund and dispute cases
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
  Future<void> partnerRefundCasesControllerGetRefundCases({ String? search, String? startDate, String? endDate, PartnerFinancePeriod? period, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, String? currency, num? page, num? limit, }) async {
    final response = await partnerRefundCasesControllerGetRefundCasesWithHttpInfo( search: search, startDate: startDate, endDate: endDate, period: period, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, currency: currency, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Reject a refund or dispute case
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] caseId (required):
  ///
  /// * [RefundCaseActionDto] refundCaseActionDto (required):
  Future<Response> partnerRefundCasesControllerRejectWithHttpInfo(String caseId, RefundCaseActionDto refundCaseActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/refund-cases/{caseId}/reject'
      .replaceAll('{caseId}', caseId);

    // ignore: prefer_final_locals
    Object? postBody = refundCaseActionDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Reject a refund or dispute case
  ///
  /// Parameters:
  ///
  /// * [String] caseId (required):
  ///
  /// * [RefundCaseActionDto] refundCaseActionDto (required):
  Future<PartnerRefundCaseRecordDto?> partnerRefundCasesControllerReject(String caseId, RefundCaseActionDto refundCaseActionDto,) async {
    final response = await partnerRefundCasesControllerRejectWithHttpInfo(caseId, refundCaseActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerRefundCaseRecordDto',) as PartnerRefundCaseRecordDto;

    }
    return null;
  }
}
