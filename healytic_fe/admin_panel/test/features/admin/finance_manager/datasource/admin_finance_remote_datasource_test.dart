import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_remote.datasource.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_openapi/api.dart' as openapi;
import 'package:flutter_test/flutter_test.dart';

const _iso = '2026-05-01T10:00:00.000Z';

void main() {
  group('AdminFinanceRemoteDataSourceImpl', () {
    test('maps API responses, page metadata, and finance enums', () async {
      final api = _FakeAdminFinanceApi();
      final dataSource = AdminFinanceRemoteDataSourceImpl(adminFinanceApi: api);
      final filter = AdminFinanceFilter(
        searchQuery: '  spa  ',
        startDate: DateTime.utc(2026, 5, 1),
        endDate: DateTime.utc(2026, 5, 2),
        partnerId: 'partner-1',
        provider: AdminFinanceProvider.vnpay,
        payoutStatus: AdminFinancePayoutStatus.held,
        currency: 'VND',
        minAmount: 100,
        maxAmount: 2000,
        onlyFlagged: true,
      );

      final overview = await dataSource.getOverview(
        AdminFinancePeriod.sevenDays,
        filter,
      );
      expect(overview.grossVolume, 1000);
      expect(overview.heldPayoutAmount, 200);
      expect(api.lastSearch, 'spa');
      expect(api.lastPeriod, openapi.AdminFinancePeriod.sevenDays);
      expect(api.lastProvider, openapi.AdminFinanceProvider.vnpay);
      expect(api.lastPayoutStatus, openapi.PartnerPayoutStatus.held);
      expect(api.lastOnlyFlagged, isTrue);

      final trend = await dataSource.getTrend(
        AdminFinancePeriod.thirtyDays,
        filter,
      );
      expect(trend.single.payoutAmount, 750);

      final alerts = await dataSource.getAlerts(AdminFinancePeriod.thirtyDays);
      expect(alerts.single.tone, AdminFinanceRiskTone.warning);

      final total = await dataSource.getTransactionTotalRows(filter);
      expect(total, 42);
      expect(api.lastTransactionPage, 1);
      expect(api.lastTransactionLimit, 1);

      final transactions = await dataSource.getTransactions(
        filter: filter,
        startingAt: 20,
        count: 10,
      );
      expect(api.lastTransactionPage, 3);
      expect(api.lastTransactionLimit, 10);
      expect(transactions.single.provider, AdminFinanceProvider.vnpay);
      expect(transactions.single.payoutStatus, AdminFinancePayoutStatus.held);

      final transactionDetail = await dataSource.getTransactionDetail(
        const AdminFinanceTransactionId('txn-1'),
      );
      expect(transactionDetail.notes.single.content, 'Reviewed');

      expect(await dataSource.getPayoutTotalRows(filter), 9);
      final payouts = await dataSource.getPayouts(
        filter: filter,
        startingAt: 10,
        count: 10,
      );
      expect(payouts.single.status, AdminFinancePayoutStatus.held);

      final payoutDetail = await dataSource.getPayoutDetail(
        const AdminFinancePayoutId('payout-1'),
      );
      expect(payoutDetail.attempts.single.attemptNumber, 2);
      expect(payoutDetail.maskedDestination, '**** 4242');

      expect(await dataSource.getRefundCaseTotalRows(filter), 5);
      final refundCases = await dataSource.getRefundCases(
        filter: filter,
        startingAt: 0,
        count: 10,
      );
      expect(refundCases.single.status, AdminFinanceRefundCaseStatus.pending);

      final refundDetail = await dataSource.getRefundCaseDetail(
        const AdminFinanceRefundCaseId('refund-1'),
      );
      expect(refundDetail.customerRequest, 'Customer asked for refund');

      expect(await dataSource.getReconciliationTotalRows(filter), 7);
      final reconciliationRows = await dataSource.getReconciliationExceptions(
        filter: filter,
        startingAt: 0,
        count: 10,
      );
      expect(
        reconciliationRows.single.status,
        AdminFinanceReconciliationStatus.open,
      );

      final reconciliationDetail = await dataSource.getReconciliationDetail(
        const AdminFinanceReconciliationId('recon-1'),
      );
      expect(reconciliationDetail.resolutionNotes, 'Waiting on provider');

      final exposure = await dataSource.getPartnerExposure(
        AdminFinancePeriod.sevenDays,
        filter,
      );
      expect(exposure.single.riskTone, AdminFinanceRiskTone.critical);

      final exports = await dataSource.getExports();
      expect(exports.single.status, AdminFinanceExportStatus.queued);
    });

    test(
      'sends generated action payloads for notes, exports, and workflows',
      () async {
        final api = _FakeAdminFinanceApi();
        final dataSource = AdminFinanceRemoteDataSourceImpl(
          adminFinanceApi: api,
        );

        await dataSource.markSettlement(
          const AdminFinanceTransactionId('txn-1'),
          AdminFinanceSettlementStatus.settled,
          note: 'Matched deposit',
        );
        expect(api.settlementId, 'txn-1');
        expect(
          api.settlementAction?.settlementStatus,
          openapi.PartnerSettlementStatus.settled,
        );
        expect(api.settlementAction?.note, 'Matched deposit');

        await dataSource.flagTransaction(
          const AdminFinanceTransactionId('txn-1'),
          flagged: true,
          note: 'Risk review',
        );
        expect(api.flagAction?.flagged, isTrue);
        expect(api.flagAction?.note, 'Risk review');

        await dataSource.approveRefundCase(
          const AdminFinanceRefundCaseId('refund-1'),
          note: 'Eligible',
        );
        expect(api.approveRefundAction?.note, 'Eligible');

        await dataSource.rejectRefundCase(
          const AdminFinanceRefundCaseId('refund-1'),
          note: 'Outside policy',
        );
        expect(api.rejectRefundAction?.note, 'Outside policy');

        await dataSource.retryPayout(
          const AdminFinancePayoutId('payout-1'),
          note: 'Retry now',
        );
        expect(api.retryPayoutAction?.note, 'Retry now');

        await dataSource.holdPayout(
          const AdminFinancePayoutId('payout-1'),
          note: 'Manual review',
        );
        expect(api.holdPayoutAction?.note, 'Manual review');

        await dataSource.releasePayoutHold(
          const AdminFinancePayoutId('payout-1'),
          note: 'Cleared',
        );
        expect(api.releaseHoldAction?.note, 'Cleared');

        await dataSource.resolveReconciliation(
          const AdminFinanceReconciliationId('recon-1'),
          note: 'Provider correction posted',
        );
        expect(
          api.resolveReconciliationAction?.note,
          'Provider correction posted',
        );

        await dataSource.reopenReconciliation(
          const AdminFinanceReconciliationId('recon-1'),
          note: 'Mismatch returned',
        );
        expect(api.reopenReconciliationAction?.note, 'Mismatch returned');

        await dataSource.addNote(
          entityType: 'reconciliation',
          entityId: 'recon-1',
          content: 'Follow up with provider',
        );
        expect(
          api.createNoteAction?.entityType,
          openapi.AdminFinanceNoteEntityType.reconciliation,
        );
        expect(api.createNoteAction?.entityId, 'recon-1');

        final export = await dataSource.createExport(
          AdminFinanceExportType.monthlySummary,
        );
        expect(
          api.createExportAction?.type,
          openapi.AdminFinanceExportType.monthlySummary,
        );
        expect(export.type, AdminFinanceExportType.monthlySummary);
      },
    );
  });
}

class _FakeAdminFinanceApi extends openapi.AdminFinanceApi {
  String? lastSearch;
  openapi.AdminFinancePeriod? lastPeriod;
  openapi.AdminFinanceProvider? lastProvider;
  openapi.PartnerPayoutStatus? lastPayoutStatus;
  bool? lastOnlyFlagged;
  num? lastTransactionPage;
  num? lastTransactionLimit;

  String? settlementId;
  openapi.AdminFinanceSettlementActionDto? settlementAction;
  openapi.AdminFinanceReviewFlagActionDto? flagAction;
  openapi.AdminFinanceNoteActionDto? approveRefundAction;
  openapi.AdminFinanceRequiredNoteActionDto? rejectRefundAction;
  openapi.AdminFinanceNoteActionDto? retryPayoutAction;
  openapi.AdminFinanceRequiredNoteActionDto? holdPayoutAction;
  openapi.AdminFinanceNoteActionDto? releaseHoldAction;
  openapi.AdminFinanceRequiredNoteActionDto? resolveReconciliationAction;
  openapi.AdminFinanceNoteActionDto? reopenReconciliationAction;
  openapi.AdminFinanceCreateNoteDto? createNoteAction;
  openapi.AdminFinanceCreateExportDto? createExportAction;

  void _captureQuery({
    String? search,
    openapi.AdminFinancePeriod? period,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.AdminFinanceProvider? provider,
    bool? onlyFlagged,
  }) {
    lastSearch = search;
    lastPeriod = period;
    lastPayoutStatus = payoutStatus;
    lastProvider = provider;
    lastOnlyFlagged = onlyFlagged;
  }

  @override
  Future<openapi.AdminFinanceOverviewDto?> adminFinanceControllerGetSummary({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    _captureQuery(
      search: search,
      period: period,
      payoutStatus: payoutStatus,
      provider: provider,
      onlyFlagged: onlyFlagged,
    );
    return openapi.AdminFinanceOverviewDto(
      grossVolume: 1000,
      netRevenue: 850,
      platformFeeRevenue: 150,
      refundExposure: 75,
      failedPaymentAmount: 50,
      pendingPayoutAmount: 400,
      heldPayoutAmount: 200,
      unreconciledAmount: 25,
      currency: 'VND',
    );
  }

  @override
  Future<List<openapi.AdminFinanceTrendPointDto>?>
  adminFinanceControllerGetTrend({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return [
      openapi.AdminFinanceTrendPointDto(
        date: '2026-05-01',
        grossAmount: 1000,
        netAmount: 850,
        refundAmount: 75,
        payoutAmount: 750,
      ),
    ];
  }

  @override
  Future<List<openapi.AdminFinanceAlertDto>?> adminFinanceControllerGetAlerts({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return [
      openapi.AdminFinanceAlertDto(
        id: 'alert-1',
        title: 'Held payout',
        description: 'Payout is on hold',
        tone: openapi.AdminFinanceRiskTone.warning,
        createdAt: _iso,
      ),
    ];
  }

  @override
  Future<openapi.AdminFinanceTransactionPageDto?>
  adminFinanceControllerGetTransactions({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    lastTransactionPage = page;
    lastTransactionLimit = limit;
    return openapi.AdminFinanceTransactionPageDto(
      data: [_transactionRecord()],
      meta: _meta(total: 42, page: page ?? 1, limit: limit ?? 10),
    );
  }

  @override
  Future<openapi.AdminFinanceTransactionDetailDto?>
  adminFinanceControllerGetTransactionDetail(String id) async {
    return openapi.AdminFinanceTransactionDetailDto(
      record: _transactionRecord(id: id),
      notes: [_note()],
    );
  }

  @override
  Future<openapi.AdminFinancePayoutPageDto?> adminFinanceControllerGetPayouts({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return openapi.AdminFinancePayoutPageDto(
      data: [_payoutRecord()],
      meta: _meta(total: 9, page: page ?? 1, limit: limit ?? 10),
    );
  }

  @override
  Future<openapi.AdminFinancePayoutDetailDto?>
  adminFinanceControllerGetPayoutDetail(String id) async {
    return openapi.AdminFinancePayoutDetailDto(
      record: _payoutRecord(id: id),
      attempts: [
        openapi.AdminFinancePayoutAttemptDto(
          attemptNumber: 2,
          attemptedAt: _iso,
          status: 'inPayout',
        ),
      ],
      maskedDestination: '**** 4242',
      notes: [_note()],
    );
  }

  @override
  Future<openapi.AdminFinanceRefundCasePageDto?>
  adminFinanceControllerGetRefundCases({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return openapi.AdminFinanceRefundCasePageDto(
      data: [_refundCaseRecord()],
      meta: _meta(total: 5, page: page ?? 1, limit: limit ?? 10),
    );
  }

  @override
  Future<openapi.AdminFinanceRefundCaseDetailDto?>
  adminFinanceControllerGetRefundCaseDetail(String id) async {
    return openapi.AdminFinanceRefundCaseDetailDto(
      record: _refundCaseRecord(id: id),
      customerRequest: 'Customer asked for refund',
      partnerResponse: 'Partner acknowledged',
      decisionNote: '',
      notes: [_note()],
    );
  }

  @override
  Future<openapi.AdminFinanceReconciliationPageDto?>
  adminFinanceControllerGetReconciliation({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return openapi.AdminFinanceReconciliationPageDto(
      data: [_reconciliationRecord()],
      meta: _meta(total: 7, page: page ?? 1, limit: limit ?? 10),
    );
  }

  @override
  Future<openapi.AdminFinanceReconciliationDetailDto?>
  adminFinanceControllerGetReconciliationDetail(String id) async {
    return openapi.AdminFinanceReconciliationDetailDto(
      exception: _reconciliationRecord(id: id),
      providerEventContext: 'Provider event',
      ledgerContext: 'Ledger event',
      resolutionNotes: 'Waiting on provider',
      notes: [_note()],
    );
  }

  @override
  Future<List<openapi.AdminFinancePartnerExposureDto>?>
  adminFinanceControllerGetPartnerExposure({
    String? search,
    openapi.AdminFinancePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? partnerId,
    String? customerId,
    openapi.PartnerCommerceSourceType? sourceType,
    openapi.PartnerTransactionType? transactionType,
    openapi.PartnerTransactionStatus? transactionStatus,
    openapi.PartnerSettlementStatus? settlementStatus,
    openapi.PartnerPayoutStatus? payoutStatus,
    openapi.PartnerRefundCaseStatus? refundCaseStatus,
    openapi.PartnerRefundCaseType? refundCaseType,
    openapi.AdminFinanceReconciliationStatus? reconciliationStatus,
    openapi.AdminFinanceProvider? provider,
    String? currency,
    num? minAmount,
    num? maxAmount,
    bool? onlyFlagged,
    bool? onlySlaBreached,
    num? page,
    num? limit,
  }) async {
    return [
      openapi.AdminFinancePartnerExposureDto(
        partnerId: 'partner-1',
        partnerName: 'Partner',
        totalVolume: 1000,
        pendingPayouts: 400,
        refundExposure: 100,
        failedPayments: 50,
        heldFunds: 200,
        currency: 'VND',
        riskTone: openapi.AdminFinanceRiskTone.critical,
      ),
    ];
  }

  @override
  Future<List<openapi.AdminFinanceExportJobDto>?>
  adminFinanceControllerGetExports() async {
    return [_exportJob()];
  }

  @override
  Future<openapi.AdminFinanceTransactionRecordDto?>
  adminFinanceControllerMarkSettlement(
    String id,
    openapi.AdminFinanceSettlementActionDto adminFinanceSettlementActionDto,
  ) async {
    settlementId = id;
    settlementAction = adminFinanceSettlementActionDto;
    return _transactionRecord(id: id);
  }

  @override
  Future<openapi.AdminFinanceTransactionRecordDto?>
  adminFinanceControllerFlagTransaction(
    String id,
    openapi.AdminFinanceReviewFlagActionDto adminFinanceReviewFlagActionDto,
  ) async {
    flagAction = adminFinanceReviewFlagActionDto;
    return _transactionRecord(id: id);
  }

  @override
  Future<openapi.AdminFinanceRefundCaseDetailDto?>
  adminFinanceControllerApproveRefundCase(
    String id,
    openapi.AdminFinanceNoteActionDto adminFinanceNoteActionDto,
  ) async {
    approveRefundAction = adminFinanceNoteActionDto;
    return adminFinanceControllerGetRefundCaseDetail(id);
  }

  @override
  Future<openapi.AdminFinanceRefundCaseDetailDto?>
  adminFinanceControllerRejectRefundCase(
    String id,
    openapi.AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,
  ) async {
    rejectRefundAction = adminFinanceRequiredNoteActionDto;
    return adminFinanceControllerGetRefundCaseDetail(id);
  }

  @override
  Future<openapi.AdminFinancePayoutDetailDto?>
  adminFinanceControllerRetryPayout(
    String id,
    openapi.AdminFinanceNoteActionDto adminFinanceNoteActionDto,
  ) async {
    retryPayoutAction = adminFinanceNoteActionDto;
    return adminFinanceControllerGetPayoutDetail(id);
  }

  @override
  Future<openapi.AdminFinancePayoutDetailDto?> adminFinanceControllerHoldPayout(
    String id,
    openapi.AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,
  ) async {
    holdPayoutAction = adminFinanceRequiredNoteActionDto;
    return adminFinanceControllerGetPayoutDetail(id);
  }

  @override
  Future<openapi.AdminFinancePayoutDetailDto?>
  adminFinanceControllerReleasePayoutHold(
    String id,
    openapi.AdminFinanceNoteActionDto adminFinanceNoteActionDto,
  ) async {
    releaseHoldAction = adminFinanceNoteActionDto;
    return adminFinanceControllerGetPayoutDetail(id);
  }

  @override
  Future<openapi.AdminFinanceReconciliationDetailDto?>
  adminFinanceControllerResolveReconciliation(
    String id,
    openapi.AdminFinanceRequiredNoteActionDto adminFinanceRequiredNoteActionDto,
  ) async {
    resolveReconciliationAction = adminFinanceRequiredNoteActionDto;
    return adminFinanceControllerGetReconciliationDetail(id);
  }

  @override
  Future<openapi.AdminFinanceReconciliationDetailDto?>
  adminFinanceControllerReopenReconciliation(
    String id,
    openapi.AdminFinanceNoteActionDto adminFinanceNoteActionDto,
  ) async {
    reopenReconciliationAction = adminFinanceNoteActionDto;
    return adminFinanceControllerGetReconciliationDetail(id);
  }

  @override
  Future<openapi.AdminFinanceNoteDto?> adminFinanceControllerAddNote(
    openapi.AdminFinanceCreateNoteDto adminFinanceCreateNoteDto,
  ) async {
    createNoteAction = adminFinanceCreateNoteDto;
    return _note();
  }

  @override
  Future<openapi.AdminFinanceExportJobDto?> adminFinanceControllerCreateExport(
    openapi.AdminFinanceCreateExportDto adminFinanceCreateExportDto,
  ) async {
    createExportAction = adminFinanceCreateExportDto;
    return _exportJob(type: adminFinanceCreateExportDto.type);
  }
}

openapi.AdminFinancePageMetaDto _meta({
  required num total,
  required num page,
  required num limit,
}) {
  return openapi.AdminFinancePageMetaDto(
    total: total,
    page: page,
    limit: limit,
    totalPages: (total / limit).ceil(),
  );
}

openapi.AdminFinanceTransactionRecordDto _transactionRecord({
  String id = 'txn-1',
}) {
  return openapi.AdminFinanceTransactionRecordDto(
    id: id,
    createdAt: _iso,
    reference: 'BK-001',
    partnerName: 'Partner',
    customerName: 'Customer',
    sourceType: openapi.PartnerCommerceSourceType.serviceBooking,
    type: openapi.PartnerTransactionType.charge,
    grossAmount: 1000,
    feeAmount: 150,
    netAmount: 850,
    currency: 'VND',
    transactionStatus: openapi.PartnerTransactionStatus.paid,
    settlementStatus: openapi.PartnerSettlementStatus.settled,
    payoutStatus: openapi.PartnerPayoutStatus.held,
    provider: openapi.AdminFinanceProvider.vnpay,
    isFlagged: true,
    notesCount: 1,
    payoutId: 'payout-1',
  );
}

openapi.AdminFinancePayoutRecordDto _payoutRecord({String id = 'payout-1'}) {
  return openapi.AdminFinancePayoutRecordDto(
    id: id,
    scheduledDate: _iso,
    partnerName: 'Partner',
    periodLabel: '2026-05-01 - 2026-05-02',
    includedVolume: 1000,
    feesAndAdjustments: 150,
    netPayout: 850,
    currency: 'VND',
    method: 'Bank transfer',
    status: openapi.PartnerPayoutStatus.held,
    attemptCount: 2,
    notesCount: 1,
    holdReason: 'Manual review',
  );
}

openapi.AdminFinanceRefundCaseRecordDto _refundCaseRecord({
  String id = 'refund-1',
}) {
  return openapi.AdminFinanceRefundCaseRecordDto(
    id: id,
    requestedAt: _iso,
    transactionId: 'txn-1',
    partnerName: 'Partner',
    customerName: 'Customer',
    caseType: openapi.PartnerRefundCaseType.refund,
    amount: 100,
    currency: 'VND',
    reason: 'Customer request',
    owner: 'Finance',
    status: openapi.PartnerRefundCaseStatus.pending,
    slaHours: 24,
    slaBreached: false,
    riskTone: openapi.AdminFinanceRiskTone.warning,
  );
}

openapi.AdminFinanceReconciliationExceptionDto _reconciliationRecord({
  String id = 'recon-1',
}) {
  return openapi.AdminFinanceReconciliationExceptionDto(
    id: id,
    detectedAt: _iso,
    provider: openapi.AdminFinanceProvider.vnpay,
    providerEventId: 'evt-1',
    relatedTransactionId: 'txn-1',
    expectedAmount: 1000,
    providerAmount: 900,
    difference: -100,
    currency: 'VND',
    type: openapi.AdminFinanceReconciliationType.amountMismatch,
    status: openapi.AdminFinanceReconciliationStatus.open,
    owner: 'Finance',
    summary: 'Amount mismatch',
  );
}

openapi.AdminFinanceExportJobDto _exportJob({
  openapi.AdminFinanceExportType type =
      openapi.AdminFinanceExportType.transactions,
}) {
  return openapi.AdminFinanceExportJobDto(
    id: 'export-1',
    createdAt: _iso,
    type: type,
    requestedBy: 'Admin',
    status: openapi.AdminFinanceExportStatus.queued,
    rowCount: 0,
  );
}

openapi.AdminFinanceNoteDto _note() {
  return openapi.AdminFinanceNoteDto(
    id: 'note-1',
    content: 'Reviewed',
    createdBy: 'Admin',
    createdAt: _iso,
  );
}
