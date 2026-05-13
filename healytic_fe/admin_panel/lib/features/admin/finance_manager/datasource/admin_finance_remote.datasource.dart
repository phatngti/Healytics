import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/finance_manager/datasource/data/admin_finance_mock_data.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_openapi/api.dart' as openapi;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ────────────────────────────────────────────────────
// 1. Abstract Interface
// ────────────────────────────────────────────────────

/// Contract for admin finance data access.
abstract class AdminFinanceRemoteDataSource {
  // Overview
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceAlert>> getAlerts(AdminFinancePeriod period);

  // Transactions
  Future<int> getTransactionTotalRows(AdminFinanceFilter filter);

  Future<List<AdminFinanceTransactionRecord>> getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceTransactionDetail> getTransactionDetail(
    AdminFinanceTransactionId id,
  );

  // Payouts
  Future<int> getPayoutTotalRows(AdminFinanceFilter filter);

  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinancePayoutDetail> getPayoutDetail(AdminFinancePayoutId id);

  // Refund Cases
  Future<int> getRefundCaseTotalRows(AdminFinanceFilter filter);

  Future<List<AdminFinanceRefundCaseRecord>> getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceRefundCaseDetail> getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  );

  // Reconciliation
  Future<int> getReconciliationTotalRows(AdminFinanceFilter filter);

  Future<List<AdminFinanceReconciliationException>>
  getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceReconciliationDetail> getReconciliationDetail(
    AdminFinanceReconciliationId id,
  );

  // Partner Exposure
  Future<List<AdminFinancePartnerExposure>> getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  // Exports
  Future<List<AdminFinanceExportJob>> getExports();

  // Actions
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  });

  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  });

  Future<void> approveRefundCase(AdminFinanceRefundCaseId id, {String? note});

  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  });

  Future<void> retryPayout(AdminFinancePayoutId id, {String? note});

  Future<void> holdPayout(AdminFinancePayoutId id, {required String note});

  Future<void> releasePayoutHold(AdminFinancePayoutId id, {String? note});

  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  });

  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  });

  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  });

  Future<AdminFinanceExportJob> createExport(AdminFinanceExportType type);
}

// ────────────────────────────────────────────────────
// 2. Implementation (real API)
// ────────────────────────────────────────────────────

class AdminFinanceRemoteDataSourceImpl implements AdminFinanceRemoteDataSource {
  AdminFinanceRemoteDataSourceImpl({
    ApiService? apiService,
    openapi.AdminFinanceApi? adminFinanceApi,
  }) : assert(
         apiService != null || adminFinanceApi != null,
         'Either apiService or adminFinanceApi must be provided',
       ),
       _api = adminFinanceApi ?? apiService!.adminFinanceApi;

  final openapi.AdminFinanceApi _api;

  @override
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    final p = _query(filter, period: period);
    final dto = await _api.adminFinanceControllerGetSummary(
      search: p.search,
      period: p.period,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
    );
    return _mapOverview(_required(dto, 'overview response'));
  }

  @override
  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    final p = _query(filter, period: period);
    final dtos = await _api.adminFinanceControllerGetTrend(
      search: p.search,
      period: p.period,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
    );
    return dtos?.map(_mapTrendPoint).toList() ?? [];
  }

  @override
  Future<List<AdminFinanceAlert>> getAlerts(AdminFinancePeriod period) async {
    final dtos = await _api.adminFinanceControllerGetAlerts(
      period: _toApiPeriod(period),
    );
    return dtos?.map(_mapAlert).toList() ?? [];
  }

  @override
  Future<int> getTransactionTotalRows(AdminFinanceFilter filter) async {
    final page = await _getTransactionPage(
      filter: filter,
      startingAt: 0,
      count: 1,
    );
    return page.meta.total.toInt();
  }

  @override
  Future<List<AdminFinanceTransactionRecord>> getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final page = await _getTransactionPage(
      filter: filter,
      startingAt: startingAt,
      count: count,
    );
    return page.data.map(_mapTransaction).toList();
  }

  @override
  Future<AdminFinanceTransactionDetail> getTransactionDetail(
    AdminFinanceTransactionId id,
  ) async {
    final dto = await _api.adminFinanceControllerGetTransactionDetail(id.value);
    return _mapTransactionDetail(_required(dto, 'transaction detail response'));
  }

  @override
  Future<int> getPayoutTotalRows(AdminFinanceFilter filter) async {
    final page = await _getPayoutPage(filter: filter, startingAt: 0, count: 1);
    return page.meta.total.toInt();
  }

  @override
  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final page = await _getPayoutPage(
      filter: filter,
      startingAt: startingAt,
      count: count,
    );
    return page.data.map(_mapPayout).toList();
  }

  @override
  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  ) async {
    final dto = await _api.adminFinanceControllerGetPayoutDetail(id.value);
    return _mapPayoutDetail(_required(dto, 'payout detail response'));
  }

  @override
  Future<int> getRefundCaseTotalRows(AdminFinanceFilter filter) async {
    final page = await _getRefundCasePage(
      filter: filter,
      startingAt: 0,
      count: 1,
    );
    return page.meta.total.toInt();
  }

  @override
  Future<List<AdminFinanceRefundCaseRecord>> getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final page = await _getRefundCasePage(
      filter: filter,
      startingAt: startingAt,
      count: count,
    );
    return page.data.map(_mapRefundCase).toList();
  }

  @override
  Future<AdminFinanceRefundCaseDetail> getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  ) async {
    final dto = await _api.adminFinanceControllerGetRefundCaseDetail(id.value);
    return _mapRefundCaseDetail(_required(dto, 'refund case detail response'));
  }

  @override
  Future<int> getReconciliationTotalRows(AdminFinanceFilter filter) async {
    final page = await _getReconciliationPage(
      filter: filter,
      startingAt: 0,
      count: 1,
    );
    return page.meta.total.toInt();
  }

  @override
  Future<List<AdminFinanceReconciliationException>>
  getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final page = await _getReconciliationPage(
      filter: filter,
      startingAt: startingAt,
      count: count,
    );
    return page.data.map(_mapReconciliation).toList();
  }

  @override
  Future<AdminFinanceReconciliationDetail> getReconciliationDetail(
    AdminFinanceReconciliationId id,
  ) async {
    final dto = await _api.adminFinanceControllerGetReconciliationDetail(
      id.value,
    );
    return _mapReconciliationDetail(
      _required(dto, 'reconciliation detail response'),
    );
  }

  @override
  Future<List<AdminFinancePartnerExposure>> getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    final p = _query(filter, period: period);
    final dtos = await _api.adminFinanceControllerGetPartnerExposure(
      search: p.search,
      period: p.period,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
    );
    return dtos?.map(_mapPartnerExposure).toList() ?? [];
  }

  @override
  Future<List<AdminFinanceExportJob>> getExports() async {
    final dtos = await _api.adminFinanceControllerGetExports();
    return dtos?.map(_mapExportJob).toList() ?? [];
  }

  @override
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  }) async {
    await _api.adminFinanceControllerMarkSettlement(
      id.value,
      openapi.AdminFinanceSettlementActionDto(
        settlementStatus: _toApiSettlement(status),
        note: note,
      ),
    );
  }

  @override
  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  }) async {
    await _api.adminFinanceControllerFlagTransaction(
      id.value,
      openapi.AdminFinanceReviewFlagActionDto(flagged: flagged, note: note),
    );
  }

  @override
  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  }) async {
    await _api.adminFinanceControllerApproveRefundCase(
      id.value,
      openapi.AdminFinanceNoteActionDto(note: note),
    );
  }

  @override
  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  }) async {
    await _api.adminFinanceControllerRejectRefundCase(
      id.value,
      openapi.AdminFinanceRequiredNoteActionDto(note: note),
    );
  }

  @override
  Future<void> retryPayout(AdminFinancePayoutId id, {String? note}) async {
    await _api.adminFinanceControllerRetryPayout(
      id.value,
      openapi.AdminFinanceNoteActionDto(note: note),
    );
  }

  @override
  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  }) async {
    await _api.adminFinanceControllerHoldPayout(
      id.value,
      openapi.AdminFinanceRequiredNoteActionDto(note: note),
    );
  }

  @override
  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  }) async {
    await _api.adminFinanceControllerReleasePayoutHold(
      id.value,
      openapi.AdminFinanceNoteActionDto(note: note),
    );
  }

  @override
  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  }) async {
    await _api.adminFinanceControllerResolveReconciliation(
      id.value,
      openapi.AdminFinanceRequiredNoteActionDto(note: note),
    );
  }

  @override
  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  }) async {
    await _api.adminFinanceControllerReopenReconciliation(
      id.value,
      openapi.AdminFinanceNoteActionDto(note: note),
    );
  }

  @override
  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  }) async {
    await _api.adminFinanceControllerAddNote(
      openapi.AdminFinanceCreateNoteDto(
        entityType: _toApiNoteEntityType(entityType),
        entityId: entityId,
        content: content,
      ),
    );
  }

  @override
  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  ) async {
    final dto = await _api.adminFinanceControllerCreateExport(
      openapi.AdminFinanceCreateExportDto(type: _toApiExportType(type)),
    );
    return _mapExportJob(_required(dto, 'create export response'));
  }

  Future<openapi.AdminFinanceTransactionPageDto> _getTransactionPage({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final p = _query(filter, page: _pageFor(startingAt, count), limit: count);
    final dto = await _api.adminFinanceControllerGetTransactions(
      search: p.search,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
      page: p.page,
      limit: p.limit,
    );
    return _required(dto, 'transaction page response');
  }

  Future<openapi.AdminFinancePayoutPageDto> _getPayoutPage({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final p = _query(filter, page: _pageFor(startingAt, count), limit: count);
    final dto = await _api.adminFinanceControllerGetPayouts(
      search: p.search,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
      page: p.page,
      limit: p.limit,
    );
    return _required(dto, 'payout page response');
  }

  Future<openapi.AdminFinanceRefundCasePageDto> _getRefundCasePage({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final p = _query(filter, page: _pageFor(startingAt, count), limit: count);
    final dto = await _api.adminFinanceControllerGetRefundCases(
      search: p.search,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
      page: p.page,
      limit: p.limit,
    );
    return _required(dto, 'refund case page response');
  }

  Future<openapi.AdminFinanceReconciliationPageDto> _getReconciliationPage({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    final p = _query(filter, page: _pageFor(startingAt, count), limit: count);
    final dto = await _api.adminFinanceControllerGetReconciliation(
      search: p.search,
      startDate: p.startDate,
      endDate: p.endDate,
      partnerId: p.partnerId,
      customerId: p.customerId,
      sourceType: p.sourceType,
      transactionType: p.transactionType,
      transactionStatus: p.transactionStatus,
      settlementStatus: p.settlementStatus,
      payoutStatus: p.payoutStatus,
      refundCaseStatus: p.refundCaseStatus,
      refundCaseType: p.refundCaseType,
      reconciliationStatus: p.reconciliationStatus,
      provider: p.provider,
      currency: p.currency,
      minAmount: p.minAmount,
      maxAmount: p.maxAmount,
      onlyFlagged: p.onlyFlagged,
      onlySlaBreached: p.onlySlaBreached,
      page: p.page,
      limit: p.limit,
    );
    return _required(dto, 'reconciliation page response');
  }

  _AdminFinanceQueryParams _query(
    AdminFinanceFilter filter, {
    AdminFinancePeriod? period,
    int? page,
    int? limit,
  }) {
    return _AdminFinanceQueryParams(
      search: filter.searchQuery.trim().isEmpty
          ? null
          : filter.searchQuery.trim(),
      period: period != null ? _toApiPeriod(period) : null,
      startDate: filter.startDate,
      endDate: filter.endDate,
      partnerId: filter.partnerId,
      customerId: filter.customerId,
      sourceType: filter.sourceType != null
          ? _toApiSourceType(filter.sourceType!)
          : null,
      transactionType: filter.transactionType != null
          ? _toApiTransactionType(filter.transactionType!)
          : null,
      transactionStatus: filter.transactionStatus != null
          ? _toApiTransactionStatus(filter.transactionStatus!)
          : null,
      settlementStatus: filter.settlementStatus != null
          ? _toApiSettlement(filter.settlementStatus!)
          : null,
      payoutStatus: filter.payoutStatus != null
          ? _toApiPayoutStatus(filter.payoutStatus!)
          : null,
      refundCaseStatus: filter.refundCaseStatus != null
          ? _toApiRefundCaseStatus(filter.refundCaseStatus!)
          : null,
      refundCaseType: filter.refundCaseType != null
          ? _toApiRefundCaseType(filter.refundCaseType!)
          : null,
      reconciliationStatus: filter.reconciliationStatus != null
          ? _toApiReconciliationStatus(filter.reconciliationStatus!)
          : null,
      provider: filter.provider != null
          ? _toApiProvider(filter.provider!)
          : null,
      currency: filter.currency,
      minAmount: filter.minAmount,
      maxAmount: filter.maxAmount,
      onlyFlagged: filter.onlyFlagged ? true : null,
      onlySlaBreached: filter.onlySlaBreached ? true : null,
      page: page,
      limit: limit,
    );
  }

  AdminFinanceOverview _mapOverview(openapi.AdminFinanceOverviewDto dto) {
    return AdminFinanceOverview(
      grossVolume: dto.grossVolume.toDouble(),
      netRevenue: dto.netRevenue.toDouble(),
      platformFeeRevenue: dto.platformFeeRevenue.toDouble(),
      refundExposure: dto.refundExposure.toDouble(),
      failedPaymentAmount: dto.failedPaymentAmount.toDouble(),
      pendingPayoutAmount: dto.pendingPayoutAmount.toDouble(),
      heldPayoutAmount: dto.heldPayoutAmount.toDouble(),
      unreconciledAmount: dto.unreconciledAmount.toDouble(),
      currency: dto.currency,
    );
  }

  AdminFinanceTrendPoint _mapTrendPoint(openapi.AdminFinanceTrendPointDto dto) {
    return AdminFinanceTrendPoint(
      date: _date(dto.date),
      grossAmount: dto.grossAmount.toDouble(),
      netAmount: dto.netAmount.toDouble(),
      refundAmount: dto.refundAmount.toDouble(),
      payoutAmount: dto.payoutAmount.toDouble(),
    );
  }

  AdminFinanceAlert _mapAlert(openapi.AdminFinanceAlertDto dto) {
    return AdminFinanceAlert(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      tone: _enumByName(
        dto.tone.value,
        AdminFinanceRiskTone.values,
        AdminFinanceRiskTone.neutral,
      ),
      createdAt: _date(dto.createdAt),
    );
  }

  AdminFinanceTransactionRecord _mapTransaction(
    openapi.AdminFinanceTransactionRecordDto dto,
  ) {
    return AdminFinanceTransactionRecord(
      id: AdminFinanceTransactionId(dto.id),
      createdAt: _date(dto.createdAt),
      reference: dto.reference,
      partnerName: dto.partnerName,
      customerName: dto.customerName,
      sourceType: _enumByName(
        dto.sourceType.value,
        AdminFinanceSourceType.values,
        AdminFinanceSourceType.serviceBooking,
      ),
      type: _enumByName(
        dto.type.value,
        AdminFinanceTransactionType.values,
        AdminFinanceTransactionType.charge,
      ),
      grossAmount: dto.grossAmount.toDouble(),
      feeAmount: dto.feeAmount.toDouble(),
      netAmount: dto.netAmount.toDouble(),
      currency: dto.currency,
      transactionStatus: _enumByName(
        dto.transactionStatus.value,
        AdminFinanceTransactionStatus.values,
        AdminFinanceTransactionStatus.pending,
      ),
      settlementStatus: _enumByName(
        dto.settlementStatus.value,
        AdminFinanceSettlementStatus.values,
        AdminFinanceSettlementStatus.unsettled,
      ),
      payoutStatus: _enumByName(
        dto.payoutStatus.value,
        AdminFinancePayoutStatus.values,
        AdminFinancePayoutStatus.notAssigned,
      ),
      provider: _enumByName(
        dto.provider.value,
        AdminFinanceProvider.values,
        AdminFinanceProvider.manual,
      ),
      isFlagged: dto.isFlagged,
      notesCount: dto.notesCount.toInt(),
      payoutId: dto.payoutId != null
          ? AdminFinancePayoutId(dto.payoutId!)
          : null,
    );
  }

  AdminFinanceTransactionDetail _mapTransactionDetail(
    openapi.AdminFinanceTransactionDetailDto dto,
  ) {
    return AdminFinanceTransactionDetail(
      record: _mapTransaction(dto.record),
      providerEvents: dto.providerEvents.map(_mapProviderEvent).toList(),
      auditTrail: dto.auditTrail.map(_mapAudit).toList(),
      notes: dto.notes.map(_mapNote).toList(),
      relatedRefundCases: dto.relatedRefundCases.map(_mapRefundCase).toList(),
    );
  }

  AdminFinancePayoutRecord _mapPayout(openapi.AdminFinancePayoutRecordDto dto) {
    return AdminFinancePayoutRecord(
      id: AdminFinancePayoutId(dto.id),
      scheduledDate: _date(dto.scheduledDate),
      partnerName: dto.partnerName,
      periodLabel: dto.periodLabel,
      includedVolume: dto.includedVolume.toDouble(),
      feesAndAdjustments: dto.feesAndAdjustments.toDouble(),
      netPayout: dto.netPayout.toDouble(),
      currency: dto.currency,
      method: dto.method,
      status: _enumByName(
        dto.status.value,
        AdminFinancePayoutStatus.values,
        AdminFinancePayoutStatus.notAssigned,
      ),
      attemptCount: dto.attemptCount.toInt(),
      notesCount: dto.notesCount.toInt(),
      failureReason: dto.failureReason,
      holdReason: dto.holdReason,
    );
  }

  AdminFinancePayoutDetail _mapPayoutDetail(
    openapi.AdminFinancePayoutDetailDto dto,
  ) {
    return AdminFinancePayoutDetail(
      record: _mapPayout(dto.record),
      includedTransactions: dto.includedTransactions
          .map(_mapTransaction)
          .toList(),
      attempts: dto.attempts.map(_mapPayoutAttempt).toList(),
      maskedDestination: dto.maskedDestination,
      auditTrail: dto.auditTrail.map(_mapAudit).toList(),
      notes: dto.notes.map(_mapNote).toList(),
    );
  }

  AdminFinancePayoutAttempt _mapPayoutAttempt(
    openapi.AdminFinancePayoutAttemptDto dto,
  ) {
    return AdminFinancePayoutAttempt(
      attemptNumber: dto.attemptNumber.toInt(),
      attemptedAt: _date(dto.attemptedAt),
      status: dto.status,
      failureReason: dto.failureReason,
    );
  }

  AdminFinanceRefundCaseRecord _mapRefundCase(
    openapi.AdminFinanceRefundCaseRecordDto dto,
  ) {
    return AdminFinanceRefundCaseRecord(
      id: AdminFinanceRefundCaseId(dto.id),
      requestedAt: _date(dto.requestedAt),
      transactionId: AdminFinanceTransactionId(dto.transactionId),
      partnerName: dto.partnerName,
      customerName: dto.customerName,
      caseType: _enumByName(
        dto.caseType.value,
        AdminFinanceRefundCaseType.values,
        AdminFinanceRefundCaseType.refund,
      ),
      amount: dto.amount.toDouble(),
      currency: dto.currency,
      reason: dto.reason,
      owner: dto.owner,
      status: _enumByName(
        dto.status.value,
        AdminFinanceRefundCaseStatus.values,
        AdminFinanceRefundCaseStatus.pending,
      ),
      slaHours: dto.slaHours.toInt(),
      slaBreached: dto.slaBreached,
      riskTone: _enumByName(
        dto.riskTone.value,
        AdminFinanceRiskTone.values,
        AdminFinanceRiskTone.neutral,
      ),
    );
  }

  AdminFinanceRefundCaseDetail _mapRefundCaseDetail(
    openapi.AdminFinanceRefundCaseDetailDto dto,
  ) {
    return AdminFinanceRefundCaseDetail(
      record: _mapRefundCase(dto.record),
      customerRequest: dto.customerRequest,
      partnerResponse: dto.partnerResponse,
      evidenceLinks: dto.evidenceLinks,
      decisionNote: dto.decisionNote,
      auditTrail: dto.auditTrail.map(_mapAudit).toList(),
      notes: dto.notes.map(_mapNote).toList(),
    );
  }

  AdminFinanceReconciliationException _mapReconciliation(
    openapi.AdminFinanceReconciliationExceptionDto dto,
  ) {
    return AdminFinanceReconciliationException(
      id: AdminFinanceReconciliationId(dto.id),
      detectedAt: _date(dto.detectedAt),
      provider: _enumByName(
        dto.provider.value,
        AdminFinanceProvider.values,
        AdminFinanceProvider.manual,
      ),
      providerEventId: dto.providerEventId,
      relatedTransactionId: dto.relatedTransactionId != null
          ? AdminFinanceTransactionId(dto.relatedTransactionId!)
          : null,
      expectedAmount: dto.expectedAmount.toDouble(),
      providerAmount: dto.providerAmount.toDouble(),
      difference: dto.difference.toDouble(),
      currency: dto.currency,
      type: _enumByName(
        dto.type.value,
        AdminFinanceReconciliationType.values,
        AdminFinanceReconciliationType.amountMismatch,
      ),
      status: _enumByName(
        dto.status.value,
        AdminFinanceReconciliationStatus.values,
        AdminFinanceReconciliationStatus.open,
      ),
      owner: dto.owner,
      summary: dto.summary,
    );
  }

  AdminFinanceReconciliationDetail _mapReconciliationDetail(
    openapi.AdminFinanceReconciliationDetailDto dto,
  ) {
    return AdminFinanceReconciliationDetail(
      exception: _mapReconciliation(dto.exception),
      providerEventContext: dto.providerEventContext,
      ledgerContext: dto.ledgerContext,
      resolutionNotes: dto.resolutionNotes,
      auditTrail: dto.auditTrail.map(_mapAudit).toList(),
      notes: dto.notes.map(_mapNote).toList(),
    );
  }

  AdminFinancePartnerExposure _mapPartnerExposure(
    openapi.AdminFinancePartnerExposureDto dto,
  ) {
    return AdminFinancePartnerExposure(
      partnerId: AdminFinancePartnerId(dto.partnerId),
      partnerName: dto.partnerName,
      totalVolume: dto.totalVolume.toDouble(),
      pendingPayouts: dto.pendingPayouts.toDouble(),
      refundExposure: dto.refundExposure.toDouble(),
      failedPayments: dto.failedPayments.toDouble(),
      heldFunds: dto.heldFunds.toDouble(),
      currency: dto.currency,
      riskTone: _enumByName(
        dto.riskTone.value,
        AdminFinanceRiskTone.values,
        AdminFinanceRiskTone.neutral,
      ),
    );
  }

  AdminFinanceExportJob _mapExportJob(openapi.AdminFinanceExportJobDto dto) {
    return AdminFinanceExportJob(
      id: AdminFinanceExportId(dto.id),
      createdAt: _date(dto.createdAt),
      type: _enumByName(
        dto.type.value,
        AdminFinanceExportType.values,
        AdminFinanceExportType.transactions,
      ),
      requestedBy: dto.requestedBy,
      status: _enumByName(
        dto.status.value,
        AdminFinanceExportStatus.values,
        AdminFinanceExportStatus.queued,
      ),
      rowCount: dto.rowCount.toInt(),
      downloadUrl: dto.downloadUrl,
      expiresAt: dto.expiresAt != null ? _date(dto.expiresAt!) : null,
    );
  }

  AdminFinanceProviderEvent _mapProviderEvent(
    openapi.AdminFinanceProviderEventDto dto,
  ) {
    return AdminFinanceProviderEvent(
      id: dto.id,
      eventType: dto.eventType,
      provider: _enumByName(
        dto.provider.value,
        AdminFinanceProvider.values,
        AdminFinanceProvider.manual,
      ),
      occurredAt: _date(dto.occurredAt),
      detail: dto.detail,
      rawPayload: dto.rawPayload,
    );
  }

  AdminFinanceAuditEvent _mapAudit(openapi.AdminFinanceAuditEventDto dto) {
    return AdminFinanceAuditEvent(
      id: AdminFinanceAuditEventId(dto.id),
      label: dto.label,
      detail: dto.detail,
      performedBy: dto.performedBy,
      occurredAt: _date(dto.occurredAt),
      isError: dto.isError,
    );
  }

  AdminFinanceNote _mapNote(openapi.AdminFinanceNoteDto dto) {
    return AdminFinanceNote(
      id: AdminFinanceNoteId(dto.id),
      content: dto.content,
      createdBy: dto.createdBy,
      createdAt: _date(dto.createdAt),
    );
  }

  DateTime _date(String value) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  int _pageFor(int startingAt, int count) {
    if (count <= 0) return 1;
    return (startingAt ~/ count) + 1;
  }

  T _required<T>(T? value, String label) {
    if (value == null) {
      throw StateError('Admin finance $label was null');
    }
    return value;
  }

  T _enumByName<T extends Enum>(String value, List<T> values, T fallback) {
    return values.firstWhere((e) => e.name == value, orElse: () => fallback);
  }

  openapi.AdminFinancePeriod _toApiPeriod(AdminFinancePeriod period) =>
      switch (period) {
        AdminFinancePeriod.sevenDays => openapi.AdminFinancePeriod.sevenDays,
        AdminFinancePeriod.thirtyDays => openapi.AdminFinancePeriod.thirtyDays,
        AdminFinancePeriod.ninetyDays => openapi.AdminFinancePeriod.ninetyDays,
        AdminFinancePeriod.thisMonth => openapi.AdminFinancePeriod.thisMonth,
        AdminFinancePeriod.lastMonth => openapi.AdminFinancePeriod.lastMonth,
        AdminFinancePeriod.custom => openapi.AdminFinancePeriod.custom,
      };

  openapi.PartnerCommerceSourceType _toApiSourceType(
    AdminFinanceSourceType type,
  ) => switch (type) {
    AdminFinanceSourceType.serviceBooking =>
      openapi.PartnerCommerceSourceType.serviceBooking,
    AdminFinanceSourceType.productOrder =>
      openapi.PartnerCommerceSourceType.productOrder,
  };

  openapi.PartnerTransactionType _toApiTransactionType(
    AdminFinanceTransactionType type,
  ) => switch (type) {
    AdminFinanceTransactionType.charge => openapi.PartnerTransactionType.charge,
    AdminFinanceTransactionType.refund => openapi.PartnerTransactionType.refund,
    AdminFinanceTransactionType.adjustment =>
      openapi.PartnerTransactionType.adjustment,
    AdminFinanceTransactionType.payout => openapi.PartnerTransactionType.payout,
    AdminFinanceTransactionType.fee => openapi.PartnerTransactionType.fee,
  };

  openapi.PartnerTransactionStatus _toApiTransactionStatus(
    AdminFinanceTransactionStatus status,
  ) => switch (status) {
    AdminFinanceTransactionStatus.pending =>
      openapi.PartnerTransactionStatus.pending,
    AdminFinanceTransactionStatus.paid => openapi.PartnerTransactionStatus.paid,
    AdminFinanceTransactionStatus.refunded =>
      openapi.PartnerTransactionStatus.refunded,
    AdminFinanceTransactionStatus.failed =>
      openapi.PartnerTransactionStatus.failed,
    AdminFinanceTransactionStatus.canceled =>
      openapi.PartnerTransactionStatus.canceled,
  };

  openapi.PartnerSettlementStatus _toApiSettlement(
    AdminFinanceSettlementStatus status,
  ) => switch (status) {
    AdminFinanceSettlementStatus.unsettled =>
      openapi.PartnerSettlementStatus.unsettled,
    AdminFinanceSettlementStatus.scheduled =>
      openapi.PartnerSettlementStatus.scheduled,
    AdminFinanceSettlementStatus.settled =>
      openapi.PartnerSettlementStatus.settled,
    AdminFinanceSettlementStatus.held => openapi.PartnerSettlementStatus.held,
  };

  openapi.PartnerPayoutStatus _toApiPayoutStatus(
    AdminFinancePayoutStatus status,
  ) => switch (status) {
    AdminFinancePayoutStatus.notAssigned =>
      openapi.PartnerPayoutStatus.notAssigned,
    AdminFinancePayoutStatus.inPayout => openapi.PartnerPayoutStatus.inPayout,
    AdminFinancePayoutStatus.paidOut => openapi.PartnerPayoutStatus.paidOut,
    AdminFinancePayoutStatus.failed => openapi.PartnerPayoutStatus.failed,
    AdminFinancePayoutStatus.held => openapi.PartnerPayoutStatus.held,
  };

  openapi.PartnerRefundCaseStatus _toApiRefundCaseStatus(
    AdminFinanceRefundCaseStatus status,
  ) => switch (status) {
    AdminFinanceRefundCaseStatus.pending =>
      openapi.PartnerRefundCaseStatus.pending,
    AdminFinanceRefundCaseStatus.underReview =>
      openapi.PartnerRefundCaseStatus.underReview,
    AdminFinanceRefundCaseStatus.approved =>
      openapi.PartnerRefundCaseStatus.approved,
    AdminFinanceRefundCaseStatus.rejected =>
      openapi.PartnerRefundCaseStatus.rejected,
  };

  openapi.PartnerRefundCaseType _toApiRefundCaseType(
    AdminFinanceRefundCaseType type,
  ) => switch (type) {
    AdminFinanceRefundCaseType.refund => openapi.PartnerRefundCaseType.refund,
    AdminFinanceRefundCaseType.dispute => openapi.PartnerRefundCaseType.dispute,
  };

  openapi.AdminFinanceReconciliationStatus _toApiReconciliationStatus(
    AdminFinanceReconciliationStatus status,
  ) => switch (status) {
    AdminFinanceReconciliationStatus.open =>
      openapi.AdminFinanceReconciliationStatus.open,
    AdminFinanceReconciliationStatus.underReview =>
      openapi.AdminFinanceReconciliationStatus.underReview,
    AdminFinanceReconciliationStatus.resolved =>
      openapi.AdminFinanceReconciliationStatus.resolved,
    AdminFinanceReconciliationStatus.reopened =>
      openapi.AdminFinanceReconciliationStatus.reopened,
  };

  openapi.AdminFinanceProvider _toApiProvider(AdminFinanceProvider provider) =>
      switch (provider) {
        AdminFinanceProvider.stripe => openapi.AdminFinanceProvider.stripe,
        AdminFinanceProvider.momo => openapi.AdminFinanceProvider.momo,
        AdminFinanceProvider.vnpay => openapi.AdminFinanceProvider.vnpay,
        AdminFinanceProvider.bankTransfer =>
          openapi.AdminFinanceProvider.bankTransfer,
        AdminFinanceProvider.manual => openapi.AdminFinanceProvider.manual,
      };

  openapi.AdminFinanceExportType _toApiExportType(
    AdminFinanceExportType type,
  ) => switch (type) {
    AdminFinanceExportType.transactions =>
      openapi.AdminFinanceExportType.transactions,
    AdminFinanceExportType.payouts => openapi.AdminFinanceExportType.payouts,
    AdminFinanceExportType.refundCases =>
      openapi.AdminFinanceExportType.refundCases,
    AdminFinanceExportType.reconciliation =>
      openapi.AdminFinanceExportType.reconciliation,
    AdminFinanceExportType.partnerExposure =>
      openapi.AdminFinanceExportType.partnerExposure,
    AdminFinanceExportType.monthlySummary =>
      openapi.AdminFinanceExportType.monthlySummary,
  };

  openapi.AdminFinanceNoteEntityType _toApiNoteEntityType(String entityType) =>
      switch (entityType) {
        'transaction' => openapi.AdminFinanceNoteEntityType.transaction,
        'payout' => openapi.AdminFinanceNoteEntityType.payout,
        'refundCase' => openapi.AdminFinanceNoteEntityType.refundCase,
        'reconciliation' => openapi.AdminFinanceNoteEntityType.reconciliation,
        _ => openapi.AdminFinanceNoteEntityType.transaction,
      };
}

class _AdminFinanceQueryParams {
  const _AdminFinanceQueryParams({
    this.search,
    this.period,
    this.startDate,
    this.endDate,
    this.partnerId,
    this.customerId,
    this.sourceType,
    this.transactionType,
    this.transactionStatus,
    this.settlementStatus,
    this.payoutStatus,
    this.refundCaseStatus,
    this.refundCaseType,
    this.reconciliationStatus,
    this.provider,
    this.currency,
    this.minAmount,
    this.maxAmount,
    this.onlyFlagged,
    this.onlySlaBreached,
    this.page,
    this.limit,
  });

  final String? search;
  final openapi.AdminFinancePeriod? period;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? partnerId;
  final String? customerId;
  final openapi.PartnerCommerceSourceType? sourceType;
  final openapi.PartnerTransactionType? transactionType;
  final openapi.PartnerTransactionStatus? transactionStatus;
  final openapi.PartnerSettlementStatus? settlementStatus;
  final openapi.PartnerPayoutStatus? payoutStatus;
  final openapi.PartnerRefundCaseStatus? refundCaseStatus;
  final openapi.PartnerRefundCaseType? refundCaseType;
  final openapi.AdminFinanceReconciliationStatus? reconciliationStatus;
  final openapi.AdminFinanceProvider? provider;
  final String? currency;
  final num? minAmount;
  final num? maxAmount;
  final bool? onlyFlagged;
  final bool? onlySlaBreached;
  final num? page;
  final num? limit;
}

// ────────────────────────────────────────────────────
// 3. Mock (for development & testing)
// ────────────────────────────────────────────────────

class AdminFinanceRemoteDataSourceMock implements AdminFinanceRemoteDataSource {
  static const _delay = Duration(milliseconds: 250);

  // ── Overview ──────────────────────────────────────

  @override
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceOverview;
  }

  @override
  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceTrend;
  }

  @override
  Future<List<AdminFinanceAlert>> getAlerts(AdminFinancePeriod period) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceAlerts;
  }

  // ── Transactions ──────────────────────────────────

  @override
  Future<int> getTransactionTotalRows(AdminFinanceFilter filter) async {
    final filtered = _filterTransactions(mockAdminFinanceTransactions, filter);
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceTransactionRecord>> getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterTransactions(mockAdminFinanceTransactions, filter);
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  Future<AdminFinanceTransactionDetail> getTransactionDetail(
    AdminFinanceTransactionId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockTransactionDetailFor(id);
  }

  // ── Payouts ───────────────────────────────────────

  @override
  Future<int> getPayoutTotalRows(AdminFinanceFilter filter) async {
    final filtered = _filterPayouts(mockAdminFinancePayouts, filter);
    return filtered.length;
  }

  @override
  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterPayouts(mockAdminFinancePayouts, filter);
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockPayoutDetailFor(id);
  }

  // ── Refund Cases ──────────────────────────────────

  @override
  Future<int> getRefundCaseTotalRows(AdminFinanceFilter filter) async {
    final filtered = _filterRefundCases(mockAdminFinanceRefundCases, filter);
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceRefundCaseRecord>> getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterRefundCases(mockAdminFinanceRefundCases, filter);
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  Future<AdminFinanceRefundCaseDetail> getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockRefundCaseDetailFor(id);
  }

  // ── Reconciliation ────────────────────────────────

  @override
  Future<int> getReconciliationTotalRows(AdminFinanceFilter filter) async {
    final filtered = _filterReconciliation(
      mockAdminFinanceReconciliationExceptions,
      filter,
    );
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceReconciliationException>>
  getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterReconciliation(
      mockAdminFinanceReconciliationExceptions,
      filter,
    );
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  Future<AdminFinanceReconciliationDetail> getReconciliationDetail(
    AdminFinanceReconciliationId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockReconciliationDetailFor(id);
  }

  // ── Partner Exposure ──────────────────────────────

  @override
  Future<List<AdminFinancePartnerExposure>> getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinancePartnerExposure;
  }

  // ── Exports ───────────────────────────────────────

  @override
  Future<List<AdminFinanceExportJob>> getExports() async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceExports;
  }

  // ── Mock Actions ──────────────────────────────────

  @override
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> retryPayout(AdminFinancePayoutId id, {String? note}) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  ) async {
    await Future<void>.delayed(_delay);
    return AdminFinanceExportJob(
      id: const AdminFinanceExportId('admin-export-new'),
      createdAt: DateTime.now(),
      type: type,
      requestedBy: 'Admin User',
      status: AdminFinanceExportStatus.queued,
      rowCount: 0,
    );
  }
}

// ────────────────────────────────────────────────────
// Filter helpers (local to mock)
// ────────────────────────────────────────────────────

List<AdminFinanceTransactionRecord> _filterTransactions(
  List<AdminFinanceTransactionRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.reference.toLowerCase().contains(q) &&
          !r.partnerName.toLowerCase().contains(q) &&
          !r.customerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.transactionStatus != null &&
        r.transactionStatus != filter.transactionStatus) {
      return false;
    }
    if (filter.settlementStatus != null &&
        r.settlementStatus != filter.settlementStatus) {
      return false;
    }
    if (filter.payoutStatus != null && r.payoutStatus != filter.payoutStatus) {
      return false;
    }
    if (filter.sourceType != null && r.sourceType != filter.sourceType) {
      return false;
    }
    if (filter.transactionType != null && r.type != filter.transactionType) {
      return false;
    }
    if (filter.provider != null && r.provider != filter.provider) {
      return false;
    }
    if (filter.currency != null && r.currency != filter.currency) {
      return false;
    }
    if (filter.onlyFlagged && !r.isFlagged) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinancePayoutRecord> _filterPayouts(
  List<AdminFinancePayoutRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.partnerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.payoutStatus != null && r.status != filter.payoutStatus) {
      return false;
    }
    if (filter.currency != null && r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinanceRefundCaseRecord> _filterRefundCases(
  List<AdminFinanceRefundCaseRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.partnerName.toLowerCase().contains(q) &&
          !r.customerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.refundCaseStatus != null &&
        r.status != filter.refundCaseStatus) {
      return false;
    }
    if (filter.refundCaseType != null && r.caseType != filter.refundCaseType) {
      return false;
    }
    if (filter.onlySlaBreached && !r.slaBreached) {
      return false;
    }
    if (filter.currency != null && r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinanceReconciliationException> _filterReconciliation(
  List<AdminFinanceReconciliationException> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.providerEventId.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q) &&
          !r.owner.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.reconciliationStatus != null &&
        r.status != filter.reconciliationStatus) {
      return false;
    }
    if (filter.provider != null && r.provider != filter.provider) {
      return false;
    }
    if (filter.currency != null && r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

// ────────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────────

final adminFinanceRemoteDataSourceProvider =
    Provider<AdminFinanceRemoteDataSource>((ref) {
      final isMock = Store.get(StoreKey.mockFlag, false);
      if (isMock) {
        return AdminFinanceRemoteDataSourceMock();
      }

      final apiService = ref.read(apiServiceProvider);
      return AdminFinanceRemoteDataSourceImpl(apiService: apiService);
    });
