import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:admin_openapi/api.dart' as openapi;
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/transactions/data/transactions_remote.datasource.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';

// ============================================================
// 2. REAL API IMPLEMENTATION
// ============================================================

/// Real implementation using the generated OpenAPI
/// client for Partner Finance endpoints.
class TransactionsRemoteDataSourceImpl
    implements TransactionsRemoteDataSource {
  TransactionsRemoteDataSourceImpl({
    required ApiService apiService,
  })  : _txnApi =
            apiService.partnerTransactionsApi,
        _payApi = apiService.partnerPayoutsApi,
        _refApi =
            apiService.partnerRefundCasesApi;

  final openapi.PartnerTransactionsApi _txnApi;
  final openapi.PartnerPayoutsApi _payApi;
  final openapi.PartnerRefundCasesApi _refApi;

  // ── Query Methods ─────────────────────────────

  @override
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    final f = _filterParams(filter);
    final dto = await _txnApi
        .partnerTransactionsControllerGetSummary(
      search: f.search,
      startDate: f.startDate,
      endDate: f.endDate,
      period: _toApiPeriod(period),
      sourceType: f.sourceType,
      transactionType: f.transactionType,
      transactionStatus: f.transactionStatus,
      settlementStatus: f.settlementStatus,
      payoutStatus: f.payoutStatus,
      currency: f.currency,
    );
    if (dto == null) {
      throw const TransactionsDataException(
        'Summary response was null',
      );
    }
    return _mapSummary(dto);
  }

  @override
  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    final f = _filterParams(filter);
    final dtos = await _txnApi
        .partnerTransactionsControllerGetTrend(
      search: f.search,
      startDate: f.startDate,
      endDate: f.endDate,
      period: _toApiPeriod(period),
      sourceType: f.sourceType,
      transactionType: f.transactionType,
      transactionStatus: f.transactionStatus,
      settlementStatus: f.settlementStatus,
      payoutStatus: f.payoutStatus,
      currency: f.currency,
    );
    return dtos?.map(_mapTrendPoint).toList() ??
        [];
  }

  @override
  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final page = (startingAt ~/ count) + 1;
    final f = _filterParams(filter);
    final response = await _txnApi
        .partnerTransactionsControllerGetTransactionsWithHttpInfo(
      search: f.search,
      startDate: f.startDate,
      endDate: f.endDate,
      sourceType: f.sourceType,
      transactionType: f.transactionType,
      transactionStatus: f.transactionStatus,
      settlementStatus: f.settlementStatus,
      payoutStatus: f.payoutStatus,
      currency: f.currency,
      page: page,
      limit: count,
    );
    return _decodePaginatedList(
      response,
      _mapTransactionRecord,
    );
  }

  @override
  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final page = (startingAt ~/ count) + 1;
    final f = _filterParams(filter);
    final response = await _payApi
        .partnerPayoutsControllerGetPayoutsWithHttpInfo(
      search: f.search,
      startDate: f.startDate,
      endDate: f.endDate,
      sourceType: f.sourceType,
      transactionType: f.transactionType,
      transactionStatus: f.transactionStatus,
      settlementStatus: f.settlementStatus,
      payoutStatus: f.payoutStatus,
      currency: f.currency,
      page: page,
      limit: count,
    );
    return _decodePaginatedList(
      response,
      _mapPayoutRecord,
    );
  }

  @override
  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final page = (startingAt ~/ count) + 1;
    final f = _filterParams(filter);
    final response = await _refApi
        .partnerRefundCasesControllerGetRefundCasesWithHttpInfo(
      search: f.search,
      startDate: f.startDate,
      endDate: f.endDate,
      sourceType: f.sourceType,
      transactionType: f.transactionType,
      transactionStatus: f.transactionStatus,
      settlementStatus: f.settlementStatus,
      payoutStatus: f.payoutStatus,
      currency: f.currency,
      page: page,
      limit: count,
    );
    return _decodePaginatedList(
      response,
      _mapRefundCaseRecord,
    );
  }

  @override
  Future<TransactionDetail> getTransactionById(
    TransactionRecordId id,
  ) async {
    final dto = await _txnApi
        .partnerTransactionsControllerGetTransactionDetail(
      id.value,
    );
    if (dto == null) {
      throw TransactionsDataException(
        'Transaction detail was null for $id',
      );
    }
    return _mapDetail(dto);
  }

  // ── Mutation Methods ──────────────────────────

  @override
  Future<void> markTransactionSettled(
    TransactionRecordId id,
  ) async {
    await _txnApi
        .partnerTransactionsControllerMarkSettled(
      id.value,
      openapi.MarkSettlementDto(
        settlementStatus:
            openapi.PartnerSettlementStatus.settled,
      ),
    );
  }

  @override
  Future<void> flagTransactionForReview(
    TransactionRecordId id,
  ) async {
    await _txnApi
        .partnerTransactionsControllerFlagForReview(
      id.value,
      openapi.FlagReviewDto(
        flaggedForReview: true,
      ),
    );
  }

  @override
  Future<void> approveRefundCase(
    String caseId,
  ) async {
    await _refApi
        .partnerRefundCasesControllerApprove(
      caseId,
      openapi.RefundCaseActionDto(),
    );
  }

  @override
  Future<void> rejectRefundCase(
    String caseId,
  ) async {
    await _refApi
        .partnerRefundCasesControllerReject(
      caseId,
      openapi.RefundCaseActionDto(),
    );
  }

  @override
  Future<void> retryPayout(String payoutId) async {
    await _payApi
        .partnerPayoutsControllerRetryPayout(
      payoutId,
      openapi.RetryPayoutDto(),
    );
  }

  // ── Shared Filter Builder ─────────────────────

  _FilterParams _filterParams(FinanceFilter f) {
    return _FilterParams(
      search: f.searchQuery.isEmpty
          ? null
          : f.searchQuery,
      startDate: f.startDate
          ?.toIso8601String()
          .split('T')
          .first,
      endDate: f.endDate
          ?.toIso8601String()
          .split('T')
          .first,
      sourceType: f.sourceType != null
          ? _toApiSourceType(f.sourceType!)
          : null,
      transactionType: f.transactionType != null
          ? _toApiTxnType(f.transactionType!)
          : null,
      transactionStatus:
          f.transactionStatus != null
              ? _toApiTxnStatus(
                  f.transactionStatus!)
              : null,
      settlementStatus:
          f.settlementStatus != null
              ? _toApiSettlement(
                  f.settlementStatus!)
              : null,
      payoutStatus: f.payoutStatus != null
          ? _toApiPayout(f.payoutStatus!)
          : null,
      currency: f.currency,
    );
  }

  // ── Paginated Response Decoder ────────────────

  /// Decodes a `WithHttpInfo` response whose
  /// generated method returns `void` due to
  /// missing response schema in the OpenAPI spec.
  List<T> _decodePaginatedList<T>(
    http.Response response,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (response.statusCode >= 400) {
      throw TransactionsDataException(
        'HTTP ${response.statusCode}',
      );
    }
    final json = jsonDecode(response.body)
        as Map<String, dynamic>;
    final dataList =
        (json['data'] as List?) ?? [];
    return dataList
        .map(
          (e) =>
              mapper(e as Map<String, dynamic>),
        )
        .toList();
  }

  // ── DTO → Domain Mappers (typed returns) ──────

  FinanceSummary _mapSummary(
    openapi.PartnerFinanceSummaryDto dto,
  ) {
    return FinanceSummary(
      grossVolume: dto.grossVolume.toDouble(),
      netSettled: dto.netSettled.toDouble(),
      pendingPayout:
          dto.pendingPayout.toDouble(),
      refundExposure:
          dto.refundExposure.toDouble(),
      availableBalance:
          dto.availableBalance.toDouble(),
      pendingBalance:
          dto.pendingBalance.toDouble(),
      currency: dto.currency,
      nextPayoutAt: dto.nextPayoutAt != null
          ? DateTime.tryParse(dto.nextPayoutAt!)
          : null,
      payoutMethod: dto.payoutMethod,
      payoutStatus: dto.payoutStatus != null
          ? _fromApiPayoutStatus(
              dto.payoutStatus!)
          : null,
    );
  }

  FinanceTrendPoint _mapTrendPoint(
    openapi.PartnerFinanceTrendPointDto dto,
  ) {
    return FinanceTrendPoint(
      date: DateTime.tryParse(dto.date) ??
          DateTime.now(),
      grossAmount:
          dto.grossAmount.toDouble(),
      netAmount: dto.netAmount.toDouble(),
      refundAmount:
          dto.refundAmount.toDouble(),
    );
  }

  TransactionDetail _mapDetail(
    openapi.PartnerTransactionDetailDto dto,
  ) {
    return TransactionDetail(
      record: _mapRecordDto(dto.record),
      payoutRecord: dto.payoutRecord != null
          ? _mapPayoutDto(dto.payoutRecord!)
          : null,
      relatedRefundCases: dto.relatedRefundCases
          .map(_mapRefundCaseDto)
          .toList(),
      sourceSummaryTitle:
          dto.sourceSummaryTitle,
      sourceSummarySubtitle:
          dto.sourceSummarySubtitle,
    );
  }

  // ── DTO → Domain (generated DTO objects) ──────

  TransactionRecord _mapRecordDto(
    openapi.PartnerTransactionRecordDto dto,
  ) {
    return TransactionRecord(
      id: TransactionRecordId(dto.id),
      createdAt:
          DateTime.tryParse(dto.createdAt) ??
              DateTime.now(),
      type: _fromApiTxnType(dto.type),
      sourceType:
          _fromApiSourceType(dto.sourceType),
      reference: dto.reference,
      customerName: dto.customerName,
      grossAmount:
          dto.grossAmount.toDouble(),
      feeAmount: dto.feeAmount.toDouble(),
      currency: dto.currency,
      status: _fromApiTxnStatus(dto.status),
      settlementStatus: _fromApiSettlement(
        dto.settlementStatus,
      ),
      payoutStatus:
          _fromApiPayoutStatus(dto.payoutStatus),
      paymentMethod: dto.paymentMethod,
      sourceTitle: dto.sourceTitle,
      sourceSubtitle: dto.sourceSubtitle,
      timeline: dto.timeline
          .map(_mapTimelineDto)
          .toList(),
      flaggedForReview: dto.flaggedForReview,
      notes: dto.notes,
      payoutId: dto.payoutId != null
          ? PayoutRecordId(dto.payoutId!)
          : null,
    );
  }

  TransactionTimelineEvent _mapTimelineDto(
    openapi
        .PartnerTransactionTimelineEventDto dto,
  ) {
    return TransactionTimelineEvent(
      title: dto.title,
      description: dto.description,
      occurredAt:
          DateTime.tryParse(dto.occurredAt) ??
              DateTime.now(),
    );
  }

  PayoutRecord _mapPayoutDto(
    openapi.PartnerPayoutRecordDto dto,
  ) {
    return PayoutRecord(
      id: PayoutRecordId(dto.id),
      periodLabel: dto.periodLabel,
      includedVolume:
          dto.includedVolume.toDouble(),
      feesAdjustments:
          dto.feesAdjustments.toDouble(),
      netPayout: dto.netPayout.toDouble(),
      scheduledDate:
          DateTime.tryParse(dto.scheduledDate) ??
              DateTime.now(),
      method: dto.method,
      status:
          _fromApiPayoutStatus(dto.status),
      currency: dto.currency,
      includedTransactionIds: dto
          .includedTransactionIds
          .map(TransactionRecordId.new)
          .toList(),
    );
  }

  RefundCaseRecord _mapRefundCaseDto(
    openapi.PartnerRefundCaseRecordDto dto,
  ) {
    return RefundCaseRecord(
      id: RefundCaseRecordId(dto.id),
      transactionId:
          TransactionRecordId(dto.transactionId),
      caseType:
          _fromApiRefundCaseType(dto.caseType),
      requestedAt:
          DateTime.tryParse(dto.requestedAt) ??
              DateTime.now(),
      amount: dto.amount.toDouble(),
      currency: dto.currency,
      reason: dto.reason,
      owner: dto.owner,
      status:
          _fromApiRefundCaseStatus(dto.status),
      slaHours: dto.slaHours.toInt(),
    );
  }

  // ── JSON → Domain (void-return endpoints) ─────

  TransactionRecord _mapTransactionRecord(
    Map<String, dynamic> j,
  ) {
    return TransactionRecord(
      id: TransactionRecordId(
        j['id'] as String,
      ),
      createdAt: DateTime.tryParse(
            j['createdAt'] as String? ?? '',
          ) ??
          DateTime.now(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == j['type'],
        orElse: () => TransactionType.charge,
      ),
      sourceType:
          CommerceSourceType.values.firstWhere(
        (e) => e.name == j['sourceType'],
        orElse: () =>
            CommerceSourceType.serviceBooking,
      ),
      reference:
          j['reference'] as String? ?? '',
      customerName:
          j['customerName'] as String? ?? '',
      grossAmount:
          (j['grossAmount'] as num?)
                  ?.toDouble() ??
              0,
      feeAmount:
          (j['feeAmount'] as num?)?.toDouble() ??
              0,
      currency:
          j['currency'] as String? ?? 'VND',
      status:
          TransactionStatus.values.firstWhere(
        (e) => e.name == j['status'],
        orElse: () => TransactionStatus.pending,
      ),
      settlementStatus:
          SettlementStatus.values.firstWhere(
        (e) => e.name == j['settlementStatus'],
        orElse: () =>
            SettlementStatus.unsettled,
      ),
      payoutStatus:
          PayoutStatus.values.firstWhere(
        (e) => e.name == j['payoutStatus'],
        orElse: () => PayoutStatus.notAssigned,
      ),
      paymentMethod:
          j['paymentMethod'] as String? ?? '',
      sourceTitle:
          j['sourceTitle'] as String? ?? '',
      sourceSubtitle:
          j['sourceSubtitle'] as String? ?? '',
      timeline:
          ((j['timeline'] as List?) ?? [])
              .map(
                (t) =>
                    TransactionTimelineEvent(
                  title:
                      t['title'] as String? ??
                          '',
                  description:
                      t['description']
                              as String? ??
                          '',
                  occurredAt: DateTime.tryParse(
                        t['occurredAt']
                                as String? ??
                            '',
                      ) ??
                      DateTime.now(),
                ),
              )
              .toList(),
      flaggedForReview:
          j['flaggedForReview'] as bool? ??
              false,
      notes: j['notes'] as String?,
      payoutId: j['payoutId'] != null
          ? PayoutRecordId(
              j['payoutId'] as String,
            )
          : null,
    );
  }

  PayoutRecord _mapPayoutRecord(
    Map<String, dynamic> j,
  ) {
    return PayoutRecord(
      id: PayoutRecordId(j['id'] as String),
      periodLabel:
          j['periodLabel'] as String? ?? '',
      includedVolume:
          (j['includedVolume'] as num?)
                  ?.toDouble() ??
              0,
      feesAdjustments:
          (j['feesAdjustments'] as num?)
                  ?.toDouble() ??
              0,
      netPayout:
          (j['netPayout'] as num?)?.toDouble() ??
              0,
      scheduledDate: DateTime.tryParse(
            j['scheduledDate'] as String? ?? '',
          ) ??
          DateTime.now(),
      method: j['method'] as String? ?? '',
      status: PayoutStatus.values.firstWhere(
        (e) => e.name == j['status'],
        orElse: () => PayoutStatus.notAssigned,
      ),
      currency:
          j['currency'] as String? ?? 'VND',
      includedTransactionIds:
          ((j['includedTransactionIds']
                      as List?) ??
                  [])
              .map(
                (id) => TransactionRecordId(
                  id as String,
                ),
              )
              .toList(),
    );
  }

  RefundCaseRecord _mapRefundCaseRecord(
    Map<String, dynamic> j,
  ) {
    return RefundCaseRecord(
      id: RefundCaseRecordId(
        j['id'] as String,
      ),
      transactionId: TransactionRecordId(
        j['transactionId'] as String,
      ),
      caseType:
          RefundCaseType.values.firstWhere(
        (e) => e.name == j['caseType'],
        orElse: () => RefundCaseType.refund,
      ),
      requestedAt: DateTime.tryParse(
            j['requestedAt'] as String? ?? '',
          ) ??
          DateTime.now(),
      amount:
          (j['amount'] as num?)?.toDouble() ?? 0,
      currency:
          j['currency'] as String? ?? 'VND',
      reason: j['reason'] as String? ?? '',
      owner: j['owner'] as String? ?? '',
      status:
          RefundCaseStatus.values.firstWhere(
        (e) => e.name == j['status'],
        orElse: () => RefundCaseStatus.pending,
      ),
      slaHours:
          (j['slaHours'] as num?)?.toInt() ?? 0,
    );
  }
}

// ============================================================
// ENUM CONVERTERS
// ============================================================

// ── Domain → API ────────────────────────────────

openapi.PartnerFinancePeriod _toApiPeriod(
  FinancePeriod p,
) =>
    switch (p) {
      FinancePeriod.sevenDays =>
        openapi.PartnerFinancePeriod.sevenDays,
      FinancePeriod.thirtyDays =>
        openapi.PartnerFinancePeriod.thirtyDays,
      FinancePeriod.ninetyDays =>
        openapi.PartnerFinancePeriod.ninetyDays,
    };

openapi.PartnerCommerceSourceType
    _toApiSourceType(
  CommerceSourceType s,
) =>
        switch (s) {
          CommerceSourceType.serviceBooking =>
            openapi.PartnerCommerceSourceType
                .serviceBooking,
          CommerceSourceType.productOrder =>
            openapi.PartnerCommerceSourceType
                .productOrder,
        };

openapi.PartnerTransactionType _toApiTxnType(
  TransactionType t,
) =>
    switch (t) {
      TransactionType.charge =>
        openapi.PartnerTransactionType.charge,
      TransactionType.refund =>
        openapi.PartnerTransactionType.refund,
      TransactionType.adjustment =>
        openapi.PartnerTransactionType.adjustment,
      TransactionType.payout =>
        openapi.PartnerTransactionType.payout,
      TransactionType.fee =>
        openapi.PartnerTransactionType.fee,
    };

openapi.PartnerTransactionStatus _toApiTxnStatus(
  TransactionStatus s,
) =>
    switch (s) {
      TransactionStatus.pending =>
        openapi.PartnerTransactionStatus.pending,
      TransactionStatus.paid =>
        openapi.PartnerTransactionStatus.paid,
      TransactionStatus.refunded =>
        openapi.PartnerTransactionStatus.refunded,
      TransactionStatus.failed =>
        openapi.PartnerTransactionStatus.failed,
      TransactionStatus.canceled =>
        openapi.PartnerTransactionStatus.canceled,
    };

openapi.PartnerSettlementStatus _toApiSettlement(
  SettlementStatus s,
) =>
    switch (s) {
      SettlementStatus.unsettled =>
        openapi.PartnerSettlementStatus.unsettled,
      SettlementStatus.scheduled =>
        openapi.PartnerSettlementStatus.scheduled,
      SettlementStatus.settled =>
        openapi.PartnerSettlementStatus.settled,
      SettlementStatus.held =>
        openapi.PartnerSettlementStatus.held,
    };

openapi.PartnerPayoutStatus _toApiPayout(
  PayoutStatus s,
) =>
    switch (s) {
      PayoutStatus.notAssigned =>
        openapi.PartnerPayoutStatus.notAssigned,
      PayoutStatus.inPayout =>
        openapi.PartnerPayoutStatus.inPayout,
      PayoutStatus.paidOut =>
        openapi.PartnerPayoutStatus.paidOut,
      PayoutStatus.failed =>
        openapi.PartnerPayoutStatus.failed,
    };

// ── API → Domain ────────────────────────────────

TransactionType _fromApiTxnType(
  openapi.PartnerTransactionType t,
) =>
    TransactionType.values.firstWhere(
      (e) => e.name == t.value,
      orElse: () => TransactionType.charge,
    );

CommerceSourceType _fromApiSourceType(
  openapi.PartnerCommerceSourceType s,
) =>
    CommerceSourceType.values.firstWhere(
      (e) => e.name == s.value,
      orElse: () =>
          CommerceSourceType.serviceBooking,
    );

TransactionStatus _fromApiTxnStatus(
  openapi.PartnerTransactionStatus s,
) =>
    TransactionStatus.values.firstWhere(
      (e) => e.name == s.value,
      orElse: () => TransactionStatus.pending,
    );

SettlementStatus _fromApiSettlement(
  openapi.PartnerSettlementStatus s,
) =>
    SettlementStatus.values.firstWhere(
      (e) => e.name == s.value,
      orElse: () => SettlementStatus.unsettled,
    );

PayoutStatus _fromApiPayoutStatus(
  openapi.PartnerPayoutStatus s,
) =>
    PayoutStatus.values.firstWhere(
      (e) => e.name == s.value,
      orElse: () => PayoutStatus.notAssigned,
    );

RefundCaseType _fromApiRefundCaseType(
  openapi.PartnerRefundCaseType t,
) =>
    RefundCaseType.values.firstWhere(
      (e) => e.name == t.value,
      orElse: () => RefundCaseType.refund,
    );

RefundCaseStatus _fromApiRefundCaseStatus(
  openapi.PartnerRefundCaseStatus s,
) =>
    RefundCaseStatus.values.firstWhere(
      (e) => e.name == s.value,
      orElse: () => RefundCaseStatus.pending,
    );

// ============================================================
// FILTER PARAMS VALUE OBJECT
// ============================================================

/// Groups the common filter query parameters
/// shared across all finance list endpoints.
class _FilterParams {
  const _FilterParams({
    this.search,
    this.startDate,
    this.endDate,
    this.sourceType,
    this.transactionType,
    this.transactionStatus,
    this.settlementStatus,
    this.payoutStatus,
    this.currency,
  });

  final String? search;
  final String? startDate;
  final String? endDate;
  final openapi.PartnerCommerceSourceType?
      sourceType;
  final openapi.PartnerTransactionType?
      transactionType;
  final openapi.PartnerTransactionStatus?
      transactionStatus;
  final openapi.PartnerSettlementStatus?
      settlementStatus;
  final openapi.PartnerPayoutStatus? payoutStatus;
  final String? currency;
}

// ============================================================
// CUSTOM EXCEPTIONS
// ============================================================

/// Exception for transaction data fetch failures.
class TransactionsDataException
    implements Exception {
  const TransactionsDataException(this.message);

  final String message;

  @override
  String toString() =>
      'TransactionsDataException: $message';
}
