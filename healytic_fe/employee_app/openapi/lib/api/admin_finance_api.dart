//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceApi {
  AdminFinanceApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add a note to a finance entity
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminFinanceCreateNoteDto] adminFinanceCreateNoteDto (required):
  Future<Response> adminFinanceControllerAddNoteWithHttpInfo(AdminFinanceCreateNoteDto adminFinanceCreateNoteDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/notes';

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceCreateNoteDto;

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

  /// Add a note to a finance entity
  ///
  /// Parameters:
  ///
  /// * [AdminFinanceCreateNoteDto] adminFinanceCreateNoteDto (required):
  Future<AdminFinanceNoteDto?> adminFinanceControllerAddNote(AdminFinanceCreateNoteDto adminFinanceCreateNoteDto,) async {
    final response = await adminFinanceControllerAddNoteWithHttpInfo(adminFinanceCreateNoteDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceNoteDto',) as AdminFinanceNoteDto;
    
    }
    return null;
  }

  /// Approve a refund or dispute case
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<Response> adminFinanceControllerApproveRefundCaseWithHttpInfo(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/refund-cases/{id}/approve'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceNoteActionDto;

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
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<AdminFinanceRefundCaseDetailDto?> adminFinanceControllerApproveRefundCase(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    final response = await adminFinanceControllerApproveRefundCaseWithHttpInfo(id, adminFinanceNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceRefundCaseDetailDto',) as AdminFinanceRefundCaseDetailDto;
    
    }
    return null;
  }

  /// Create a finance export job
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminFinanceCreateExportDto] adminFinanceCreateExportDto (required):
  Future<Response> adminFinanceControllerCreateExportWithHttpInfo(AdminFinanceCreateExportDto adminFinanceCreateExportDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/exports';

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceCreateExportDto;

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

  /// Create a finance export job
  ///
  /// Parameters:
  ///
  /// * [AdminFinanceCreateExportDto] adminFinanceCreateExportDto (required):
  Future<AdminFinanceExportJobDto?> adminFinanceControllerCreateExport(AdminFinanceCreateExportDto adminFinanceCreateExportDto,) async {
    final response = await adminFinanceControllerCreateExportWithHttpInfo(adminFinanceCreateExportDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceExportJobDto',) as AdminFinanceExportJobDto;
    
    }
    return null;
  }

  /// Flag or unflag a transaction for finance review
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceReviewFlagActionDto] adminFinanceReviewFlagActionDto (required):
  Future<Response> adminFinanceControllerFlagTransactionWithHttpInfo(String id, AdminFinanceReviewFlagActionDto adminFinanceReviewFlagActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/transactions/{id}/review-flag'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceReviewFlagActionDto;

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

  /// Flag or unflag a transaction for finance review
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceReviewFlagActionDto] adminFinanceReviewFlagActionDto (required):
  Future<AdminFinanceTransactionRecordDto?> adminFinanceControllerFlagTransaction(String id, AdminFinanceReviewFlagActionDto adminFinanceReviewFlagActionDto,) async {
    final response = await adminFinanceControllerFlagTransactionWithHttpInfo(id, adminFinanceReviewFlagActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceTransactionRecordDto',) as AdminFinanceTransactionRecordDto;
    
    }
    return null;
  }

  /// Get derived operational finance alerts
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetAlertsWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/alerts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// Get derived operational finance alerts
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<List<AdminFinanceAlertDto>?> adminFinanceControllerGetAlerts({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetAlertsWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminFinanceAlertDto>') as List)
        .cast<AdminFinanceAlertDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// List finance export jobs
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminFinanceControllerGetExportsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/exports';

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

  /// List finance export jobs
  Future<List<AdminFinanceExportJobDto>?> adminFinanceControllerGetExports() async {
    final response = await adminFinanceControllerGetExportsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminFinanceExportJobDto>') as List)
        .cast<AdminFinanceExportJobDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Rank partner financial exposure
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetPartnerExposureWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/partner-exposure';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// Rank partner financial exposure
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<List<AdminFinancePartnerExposureDto>?> adminFinanceControllerGetPartnerExposure({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetPartnerExposureWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminFinancePartnerExposureDto>') as List)
        .cast<AdminFinancePartnerExposureDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get payout detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminFinanceControllerGetPayoutDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/payouts/{id}'
      .replaceAll('{id}', id);

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

  /// Get payout detail
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminFinancePayoutDetailDto?> adminFinanceControllerGetPayoutDetail(String id,) async {
    final response = await adminFinanceControllerGetPayoutDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinancePayoutDetailDto',) as AdminFinancePayoutDetailDto;
    
    }
    return null;
  }

  /// List platform payouts
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetPayoutsWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/payouts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// List platform payouts
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<AdminFinancePayoutPageDto?> adminFinanceControllerGetPayouts({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetPayoutsWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinancePayoutPageDto',) as AdminFinancePayoutPageDto;
    
    }
    return null;
  }

  /// List reconciliation exceptions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetReconciliationWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/reconciliation';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// List reconciliation exceptions
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<AdminFinanceReconciliationPageDto?> adminFinanceControllerGetReconciliation({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetReconciliationWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceReconciliationPageDto',) as AdminFinanceReconciliationPageDto;
    
    }
    return null;
  }

  /// Get reconciliation exception detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminFinanceControllerGetReconciliationDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/reconciliation/{id}'
      .replaceAll('{id}', id);

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

  /// Get reconciliation exception detail
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminFinanceReconciliationDetailDto?> adminFinanceControllerGetReconciliationDetail(String id,) async {
    final response = await adminFinanceControllerGetReconciliationDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceReconciliationDetailDto',) as AdminFinanceReconciliationDetailDto;
    
    }
    return null;
  }

  /// Get refund or dispute case detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminFinanceControllerGetRefundCaseDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/refund-cases/{id}'
      .replaceAll('{id}', id);

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

  /// Get refund or dispute case detail
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminFinanceRefundCaseDetailDto?> adminFinanceControllerGetRefundCaseDetail(String id,) async {
    final response = await adminFinanceControllerGetRefundCaseDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceRefundCaseDetailDto',) as AdminFinanceRefundCaseDetailDto;
    
    }
    return null;
  }

  /// List platform refund and dispute cases
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetRefundCasesWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/refund-cases';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// List platform refund and dispute cases
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<AdminFinanceRefundCasePageDto?> adminFinanceControllerGetRefundCases({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetRefundCasesWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceRefundCasePageDto',) as AdminFinanceRefundCasePageDto;
    
    }
    return null;
  }

  /// Get platform-wide admin finance summary metrics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetSummaryWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/summary';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// Get platform-wide admin finance summary metrics
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<AdminFinanceOverviewDto?> adminFinanceControllerGetSummary({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetSummaryWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceOverviewDto',) as AdminFinanceOverviewDto;
    
    }
    return null;
  }

  /// Get platform ledger transaction detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminFinanceControllerGetTransactionDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/transactions/{id}'
      .replaceAll('{id}', id);

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

  /// Get platform ledger transaction detail
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminFinanceTransactionDetailDto?> adminFinanceControllerGetTransactionDetail(String id,) async {
    final response = await adminFinanceControllerGetTransactionDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceTransactionDetailDto',) as AdminFinanceTransactionDetailDto;
    
    }
    return null;
  }

  /// List platform ledger transactions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetTransactionsWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/transactions';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// List platform ledger transactions
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<AdminFinanceTransactionPageDto?> adminFinanceControllerGetTransactions({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetTransactionsWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceTransactionPageDto',) as AdminFinanceTransactionPageDto;
    
    }
    return null;
  }

  /// Get platform-wide finance trend data
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> adminFinanceControllerGetTrendWithHttpInfo({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/trend';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }
    if (endDate != null) {
      queryParams.addAll(_queryParams('', 'endDate', endDate));
    }
    if (partnerId != null) {
      queryParams.addAll(_queryParams('', 'partnerId', partnerId));
    }
    if (customerId != null) {
      queryParams.addAll(_queryParams('', 'customerId', customerId));
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
    if (refundCaseStatus != null) {
      queryParams.addAll(_queryParams('', 'refundCaseStatus', refundCaseStatus));
    }
    if (refundCaseType != null) {
      queryParams.addAll(_queryParams('', 'refundCaseType', refundCaseType));
    }
    if (reconciliationStatus != null) {
      queryParams.addAll(_queryParams('', 'reconciliationStatus', reconciliationStatus));
    }
    if (provider != null) {
      queryParams.addAll(_queryParams('', 'provider', provider));
    }
    if (currency != null) {
      queryParams.addAll(_queryParams('', 'currency', currency));
    }
    if (minAmount != null) {
      queryParams.addAll(_queryParams('', 'minAmount', minAmount));
    }
    if (maxAmount != null) {
      queryParams.addAll(_queryParams('', 'maxAmount', maxAmount));
    }
    if (onlyFlagged != null) {
      queryParams.addAll(_queryParams('', 'onlyFlagged', onlyFlagged));
    }
    if (onlySlaBreached != null) {
      queryParams.addAll(_queryParams('', 'onlySlaBreached', onlySlaBreached));
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

  /// Get platform-wide finance trend data
  ///
  /// Parameters:
  ///
  /// * [String] search:
  ///
  /// * [AdminFinancePeriod] period:
  ///
  /// * [DateTime] startDate:
  ///
  /// * [DateTime] endDate:
  ///
  /// * [String] partnerId:
  ///
  /// * [String] customerId:
  ///
  /// * [PartnerCommerceSourceType] sourceType:
  ///
  /// * [PartnerTransactionType] transactionType:
  ///
  /// * [PartnerTransactionStatus] transactionStatus:
  ///
  /// * [PartnerSettlementStatus] settlementStatus:
  ///
  /// * [PartnerPayoutStatus] payoutStatus:
  ///
  /// * [PartnerRefundCaseStatus] refundCaseStatus:
  ///
  /// * [PartnerRefundCaseType] refundCaseType:
  ///
  /// * [AdminFinanceReconciliationStatus] reconciliationStatus:
  ///
  /// * [AdminFinanceProvider] provider:
  ///
  /// * [String] currency:
  ///
  /// * [num] minAmount:
  ///
  /// * [num] maxAmount:
  ///
  /// * [bool] onlyFlagged:
  ///
  /// * [bool] onlySlaBreached:
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<List<AdminFinanceTrendPointDto>?> adminFinanceControllerGetTrend({ String? search, AdminFinancePeriod? period, DateTime? startDate, DateTime? endDate, String? partnerId, String? customerId, PartnerCommerceSourceType? sourceType, PartnerTransactionType? transactionType, PartnerTransactionStatus? transactionStatus, PartnerSettlementStatus? settlementStatus, PartnerPayoutStatus? payoutStatus, PartnerRefundCaseStatus? refundCaseStatus, PartnerRefundCaseType? refundCaseType, AdminFinanceReconciliationStatus? reconciliationStatus, AdminFinanceProvider? provider, String? currency, num? minAmount, num? maxAmount, bool? onlyFlagged, bool? onlySlaBreached, num? page, num? limit, }) async {
    final response = await adminFinanceControllerGetTrendWithHttpInfo( search: search, period: period, startDate: startDate, endDate: endDate, partnerId: partnerId, customerId: customerId, sourceType: sourceType, transactionType: transactionType, transactionStatus: transactionStatus, settlementStatus: settlementStatus, payoutStatus: payoutStatus, refundCaseStatus: refundCaseStatus, refundCaseType: refundCaseType, reconciliationStatus: reconciliationStatus, provider: provider, currency: currency, minAmount: minAmount, maxAmount: maxAmount, onlyFlagged: onlyFlagged, onlySlaBreached: onlySlaBreached, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminFinanceTrendPointDto>') as List)
        .cast<AdminFinanceTrendPointDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Place an admin hold on a payout
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<Response> adminFinanceControllerHoldPayoutWithHttpInfo(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/payouts/{id}/hold'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceRequiredNoteActionDto;

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

  /// Place an admin hold on a payout
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<AdminFinancePayoutDetailDto?> adminFinanceControllerHoldPayout(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    final response = await adminFinanceControllerHoldPayoutWithHttpInfo(id, adminFinanceRequiredNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinancePayoutDetailDto',) as AdminFinancePayoutDetailDto;
    
    }
    return null;
  }

  /// Mark transaction settlement status with an admin note
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceSettlementActionDto] adminFinanceSettlementActionDto (required):
  Future<Response> adminFinanceControllerMarkSettlementWithHttpInfo(String id, AdminFinanceSettlementActionDto adminFinanceSettlementActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/transactions/{id}/settlement'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceSettlementActionDto;

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

  /// Mark transaction settlement status with an admin note
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceSettlementActionDto] adminFinanceSettlementActionDto (required):
  Future<AdminFinanceTransactionRecordDto?> adminFinanceControllerMarkSettlement(String id, AdminFinanceSettlementActionDto adminFinanceSettlementActionDto,) async {
    final response = await adminFinanceControllerMarkSettlementWithHttpInfo(id, adminFinanceSettlementActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceTransactionRecordDto',) as AdminFinanceTransactionRecordDto;
    
    }
    return null;
  }

  /// Reject a refund or dispute case
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<Response> adminFinanceControllerRejectRefundCaseWithHttpInfo(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/refund-cases/{id}/reject'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceRequiredNoteActionDto;

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
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<AdminFinanceRefundCaseDetailDto?> adminFinanceControllerRejectRefundCase(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    final response = await adminFinanceControllerRejectRefundCaseWithHttpInfo(id, adminFinanceRequiredNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceRefundCaseDetailDto',) as AdminFinanceRefundCaseDetailDto;
    
    }
    return null;
  }

  /// Release an admin hold from a payout
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<Response> adminFinanceControllerReleasePayoutHoldWithHttpInfo(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/payouts/{id}/release-hold'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceNoteActionDto;

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

  /// Release an admin hold from a payout
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<AdminFinancePayoutDetailDto?> adminFinanceControllerReleasePayoutHold(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    final response = await adminFinanceControllerReleasePayoutHoldWithHttpInfo(id, adminFinanceNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinancePayoutDetailDto',) as AdminFinancePayoutDetailDto;
    
    }
    return null;
  }

  /// Reopen a reconciliation exception
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<Response> adminFinanceControllerReopenReconciliationWithHttpInfo(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/reconciliation/{id}/reopen'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceNoteActionDto;

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

  /// Reopen a reconciliation exception
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<AdminFinanceReconciliationDetailDto?> adminFinanceControllerReopenReconciliation(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    final response = await adminFinanceControllerReopenReconciliationWithHttpInfo(id, adminFinanceNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceReconciliationDetailDto',) as AdminFinanceReconciliationDetailDto;
    
    }
    return null;
  }

  /// Resolve a reconciliation exception
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<Response> adminFinanceControllerResolveReconciliationWithHttpInfo(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/reconciliation/{id}/resolve'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceRequiredNoteActionDto;

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

  /// Resolve a reconciliation exception
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceRequiredNoteActionDto] adminFinanceRequiredNoteActionDto (required):
  Future<AdminFinanceReconciliationDetailDto?> adminFinanceControllerResolveReconciliation(String id, AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,) async {
    final response = await adminFinanceControllerResolveReconciliationWithHttpInfo(id, adminFinanceRequiredNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinanceReconciliationDetailDto',) as AdminFinanceReconciliationDetailDto;
    
    }
    return null;
  }

  /// Retry a failed or held payout
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<Response> adminFinanceControllerRetryPayoutWithHttpInfo(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/finance/payouts/{id}/retry'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = adminFinanceNoteActionDto;

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

  /// Retry a failed or held payout
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [AdminFinanceNoteActionDto] adminFinanceNoteActionDto (required):
  Future<AdminFinancePayoutDetailDto?> adminFinanceControllerRetryPayout(String id, AdminFinanceNoteActionDto adminFinanceNoteActionDto,) async {
    final response = await adminFinanceControllerRetryPayoutWithHttpInfo(id, adminFinanceNoteActionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminFinancePayoutDetailDto',) as AdminFinancePayoutDetailDto;
    
    }
    return null;
  }
}
