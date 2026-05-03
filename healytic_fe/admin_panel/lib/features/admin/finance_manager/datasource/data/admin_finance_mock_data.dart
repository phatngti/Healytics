import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';

// ────────────────────────────────────────────────────
// Helpers
// ────────────────────────────────────────────────────

DateTime _d(int y, int m, int d, [int h = 0, int min = 0]) =>
    DateTime(y, m, d, h, min);

final _now = DateTime(2026, 4, 28, 14, 30);

// ────────────────────────────────────────────────────
// Overview
// ────────────────────────────────────────────────────

const mockAdminFinanceOverview = AdminFinanceOverview(
  grossVolume: 2456800000,
  netRevenue: 2210120000,
  platformFeeRevenue: 246680000,
  refundExposure: 38400000,
  failedPaymentAmount: 12600000,
  pendingPayoutAmount: 184200000,
  heldPayoutAmount: 42000000,
  unreconciledAmount: 8940000,
  currency: 'VND',
);

// ────────────────────────────────────────────────────
// Trend Points (30-day sample)
// ────────────────────────────────────────────────────

final mockAdminFinanceTrend = List.generate(30, (i) {
  final date = _d(2026, 3, 30 + i);
  final base = 80000000.0 + (i % 7) * 4000000;
  return AdminFinanceTrendPoint(
    date: date,
    grossAmount: base,
    netAmount: base * 0.9,
    refundAmount: base * 0.015,
    payoutAmount: base * 0.88,
  );
});

// ────────────────────────────────────────────────────
// Alerts
// ────────────────────────────────────────────────────

final mockAdminFinanceAlerts = <AdminFinanceAlert>[
  AdminFinanceAlert(
    id: 'alert-001',
    title: 'High refund volume detected',
    description:
        'Refund requests exceeded 5% of gross volume '
        'in the last 7 days.',
    tone: AdminFinanceRiskTone.warning,
    createdAt: _d(2026, 4, 27, 9, 15),
  ),
  AdminFinanceAlert(
    id: 'alert-002',
    title: '3 payouts held for review',
    description:
        'Payout batches for Wellness Spa, Zen Yoga '
        'Studio, and NutriLife are on hold.',
    tone: AdminFinanceRiskTone.critical,
    createdAt: _d(2026, 4, 26, 16, 42),
  ),
  AdminFinanceAlert(
    id: 'alert-003',
    title: 'Reconciliation exceptions rising',
    description:
        '10 unresolved exceptions detected across '
        'Stripe and MoMo providers this week.',
    tone: AdminFinanceRiskTone.warning,
    createdAt: _d(2026, 4, 25, 11, 0),
  ),
  AdminFinanceAlert(
    id: 'alert-004',
    title: 'Platform fee revenue on track',
    description:
        'Month-to-date platform fee revenue is 12% '
        'above forecast.',
    tone: AdminFinanceRiskTone.positive,
    createdAt: _d(2026, 4, 24, 8, 30),
  ),
];

// ────────────────────────────────────────────────────
// Transactions (60 records)
// ────────────────────────────────────────────────────

final _txnStatuses = [
  AdminFinanceTransactionStatus.paid,
  AdminFinanceTransactionStatus.pending,
  AdminFinanceTransactionStatus.refunded,
  AdminFinanceTransactionStatus.failed,
  AdminFinanceTransactionStatus.canceled,
];

final _settlementStatuses = [
  AdminFinanceSettlementStatus.settled,
  AdminFinanceSettlementStatus.unsettled,
  AdminFinanceSettlementStatus.scheduled,
  AdminFinanceSettlementStatus.held,
];

final _payoutStatuses = [
  AdminFinancePayoutStatus.paidOut,
  AdminFinancePayoutStatus.notAssigned,
  AdminFinancePayoutStatus.inPayout,
  AdminFinancePayoutStatus.failed,
  AdminFinancePayoutStatus.held,
];

final _providers = [
  AdminFinanceProvider.stripe,
  AdminFinanceProvider.momo,
  AdminFinanceProvider.bankTransfer,
  AdminFinanceProvider.manual,
];

final _partners = [
  'Wellness Spa',
  'Zen Yoga Studio',
  'NutriLife Clinic',
  'ClearMind Therapy',
  'ActiveFit Gym',
  'HealWell Center',
  'MindBody Lab',
  'VitalCare Physio',
];

final _customers = [
  'Nguyen Van A',
  'Tran Thi B',
  'Le Van C',
  'Pham Thi D',
  'Hoang Van E',
  'Vo Thi F',
  'Bui Van G',
  'Dang Thi H',
];

final _txnTypes = [
  AdminFinanceTransactionType.charge,
  AdminFinanceTransactionType.charge,
  AdminFinanceTransactionType.charge,
  AdminFinanceTransactionType.refund,
  AdminFinanceTransactionType.fee,
];

final mockAdminFinanceTransactions =
    List<AdminFinanceTransactionRecord>.generate(60, (i) {
  final idx = i + 1;
  final padded = idx.toString().padLeft(3, '0');
  final gross = 200000.0 + (i * 37500);
  final fee = gross * 0.1;
  final isFlagged = i % 13 == 0;
  return AdminFinanceTransactionRecord(
    id: AdminFinanceTransactionId('admin-txn-$padded'),
    createdAt: _now.subtract(Duration(hours: i * 6)),
    reference: 'REF-${2026000 + idx}',
    partnerName: _partners[i % _partners.length],
    customerName: _customers[i % _customers.length],
    sourceType: i % 3 == 0
        ? AdminFinanceSourceType.productOrder
        : AdminFinanceSourceType.serviceBooking,
    type: _txnTypes[i % _txnTypes.length],
    grossAmount: gross,
    feeAmount: fee,
    netAmount: gross - fee,
    currency: i == 58 ? 'USD' : 'VND',
    transactionStatus:
        _txnStatuses[i % _txnStatuses.length],
    settlementStatus:
        _settlementStatuses[i % _settlementStatuses.length],
    payoutStatus:
        _payoutStatuses[i % _payoutStatuses.length],
    provider: _providers[i % _providers.length],
    isFlagged: isFlagged,
    notesCount: isFlagged ? 2 : 0,
    payoutId: i % 5 == 0
        ? AdminFinancePayoutId(
            'admin-payout-${((i ~/ 5) + 1).toString().padLeft(3, '0')}',
          )
        : null,
  );
});

// ────────────────────────────────────────────────────
// Payouts (12 records)
// ────────────────────────────────────────────────────

final _payoutMethods = [
  'Bank Transfer',
  'Stripe Connect',
  'MoMo Wallet',
];

final mockAdminFinancePayouts =
    List<AdminFinancePayoutRecord>.generate(12, (i) {
  final idx = i + 1;
  final padded = idx.toString().padLeft(3, '0');
  final volume = 8000000.0 + i * 1200000;
  final fees = volume * 0.1;
  final status = AdminFinancePayoutStatus
      .values[i % AdminFinancePayoutStatus.values.length];
  return AdminFinancePayoutRecord(
    id: AdminFinancePayoutId('admin-payout-$padded'),
    scheduledDate:
        _now.subtract(Duration(days: i * 3)),
    partnerName: _partners[i % _partners.length],
    periodLabel: 'Apr ${1 + i * 2}–${2 + i * 2}, 2026',
    includedVolume: volume,
    feesAndAdjustments: fees,
    netPayout: volume - fees,
    currency: 'VND',
    method: _payoutMethods[i % _payoutMethods.length],
    status: status,
    attemptCount: status == AdminFinancePayoutStatus.failed
        ? 3
        : 1,
    notesCount: i % 4 == 0 ? 1 : 0,
    failureReason:
        status == AdminFinancePayoutStatus.failed
            ? 'Bank account verification expired'
            : null,
    holdReason: status == AdminFinancePayoutStatus.held
        ? 'Pending compliance review'
        : null,
  );
});

// ────────────────────────────────────────────────────
// Refund Cases (18 records)
// ────────────────────────────────────────────────────

final _refundReasons = [
  'Service not rendered',
  'Duplicate charge',
  'Unauthorized transaction',
  'Service quality issue',
  'Booking error',
  'Product defect',
];

final _refundOwners = [
  'Auto-assigned',
  'Finance Team',
  'Support Lead',
  'Compliance',
];

final mockAdminFinanceRefundCases =
    List<AdminFinanceRefundCaseRecord>.generate(18, (i) {
  final idx = i + 1;
  final padded = idx.toString().padLeft(3, '0');
  final status = AdminFinanceRefundCaseStatus.values[
      i % AdminFinanceRefundCaseStatus.values.length];
  final slaHours = 24 + (i % 3) * 24;
  final slaBreached = i % 5 == 0;
  return AdminFinanceRefundCaseRecord(
    id: AdminFinanceRefundCaseId(
      'admin-refund-$padded',
    ),
    requestedAt:
        _now.subtract(Duration(hours: i * 14)),
    transactionId: AdminFinanceTransactionId(
      'admin-txn-${(i + 1).toString().padLeft(3, '0')}',
    ),
    partnerName: _partners[i % _partners.length],
    customerName: _customers[i % _customers.length],
    caseType: i % 4 == 0
        ? AdminFinanceRefundCaseType.dispute
        : AdminFinanceRefundCaseType.refund,
    amount: 150000.0 + i * 25000,
    currency: 'VND',
    reason: _refundReasons[i % _refundReasons.length],
    owner: _refundOwners[i % _refundOwners.length],
    status: status,
    slaHours: slaHours,
    slaBreached: slaBreached,
    riskTone: slaBreached
        ? AdminFinanceRiskTone.critical
        : status == AdminFinanceRefundCaseStatus.approved
            ? AdminFinanceRiskTone.positive
            : status ==
                    AdminFinanceRefundCaseStatus.underReview
                ? AdminFinanceRiskTone.warning
                : AdminFinanceRiskTone.neutral,
  );
});

// ────────────────────────────────────────────────────
// Reconciliation Exceptions (10 records)
// ────────────────────────────────────────────────────

final mockAdminFinanceReconciliationExceptions =
    List<AdminFinanceReconciliationException>.generate(
  10,
  (i) {
    final idx = i + 1;
    final padded = idx.toString().padLeft(3, '0');
    final expected = 500000.0 + i * 100000;
    final providerAmt = expected + (i.isEven ? 50000 : -30000);
    final type = AdminFinanceReconciliationType.values[
        i %
            AdminFinanceReconciliationType.values.length];
    return AdminFinanceReconciliationException(
      id: AdminFinanceReconciliationId(
        'admin-recon-$padded',
      ),
      detectedAt:
          _now.subtract(Duration(hours: i * 18)),
      provider: _providers[i % _providers.length],
      providerEventId: 'evt_stripe_${1000 + idx}',
      relatedTransactionId: i % 3 != 0
          ? AdminFinanceTransactionId(
              'admin-txn-${(i + 1).toString().padLeft(3, '0')}',
            )
          : null,
      expectedAmount: expected,
      providerAmount: providerAmt,
      difference: providerAmt - expected,
      currency: 'VND',
      type: type,
      status: AdminFinanceReconciliationStatus.values[
          i %
              AdminFinanceReconciliationStatus
                  .values.length],
      owner: _refundOwners[i % _refundOwners.length],
      summary: '${type.label} detected for '
          '${_providers[i % _providers.length].label}',
    );
  },
);

// ────────────────────────────────────────────────────
// Partner Exposure (8 records)
// ────────────────────────────────────────────────────

final mockAdminFinancePartnerExposure =
    List<AdminFinancePartnerExposure>.generate(8, (i) {
  final volume = 300000000.0 - i * 30000000;
  return AdminFinancePartnerExposure(
    partnerId: AdminFinancePartnerId(
      'partner-${(i + 1).toString().padLeft(3, '0')}',
    ),
    partnerName: _partners[i % _partners.length],
    totalVolume: volume,
    pendingPayouts: volume * 0.08,
    refundExposure: volume * 0.015,
    failedPayments: volume * 0.005,
    heldFunds: i % 3 == 0 ? volume * 0.02 : 0,
    currency: 'VND',
    riskTone: i < 2
        ? AdminFinanceRiskTone.critical
        : i < 4
            ? AdminFinanceRiskTone.warning
            : AdminFinanceRiskTone.neutral,
  );
});

// ────────────────────────────────────────────────────
// Export Jobs (8 records)
// ────────────────────────────────────────────────────

final mockAdminFinanceExports =
    List<AdminFinanceExportJob>.generate(8, (i) {
  final idx = i + 1;
  final padded = idx.toString().padLeft(3, '0');
  final status = AdminFinanceExportStatus.values[
      i % AdminFinanceExportStatus.values.length];
  return AdminFinanceExportJob(
    id: AdminFinanceExportId('admin-export-$padded'),
    createdAt: _now.subtract(Duration(hours: i * 12)),
    type: AdminFinanceExportType.values[
        i % AdminFinanceExportType.values.length],
    requestedBy: 'Admin User',
    status: status,
    rowCount: 100 + i * 50,
    downloadUrl:
        status == AdminFinanceExportStatus.ready
            ? 'https://storage.healytics.vn/'
                'exports/finance-$padded.csv'
            : null,
    expiresAt: status == AdminFinanceExportStatus.ready
        ? _now.add(const Duration(days: 7))
        : null,
  );
});

// ────────────────────────────────────────────────────
// Audit Events & Notes (shared across details)
// ────────────────────────────────────────────────────

List<AdminFinanceAuditEvent> mockAuditTrailFor(
  String prefix,
) => [
  AdminFinanceAuditEvent(
    id: AdminFinanceAuditEventId('$prefix-audit-001'),
    label: 'Created',
    detail: 'Record created by system.',
    performedBy: 'System',
    occurredAt: _d(2026, 4, 20, 10, 0),
  ),
  AdminFinanceAuditEvent(
    id: AdminFinanceAuditEventId('$prefix-audit-002'),
    label: 'Reviewed',
    detail: 'Reviewed by finance team.',
    performedBy: 'Finance Admin',
    occurredAt: _d(2026, 4, 22, 14, 30),
  ),
  AdminFinanceAuditEvent(
    id: AdminFinanceAuditEventId('$prefix-audit-003'),
    label: 'Updated',
    detail: 'Status changed after verification.',
    performedBy: 'Finance Admin',
    occurredAt: _d(2026, 4, 25, 9, 15),
  ),
];

List<AdminFinanceNote> mockNotesFor(
  String prefix,
) => [
  AdminFinanceNote(
    id: AdminFinanceNoteId('$prefix-note-001'),
    content: 'Verified with payment provider records.',
    createdBy: 'Finance Admin',
    createdAt: _d(2026, 4, 22, 15, 0),
  ),
  AdminFinanceNote(
    id: AdminFinanceNoteId('$prefix-note-002'),
    content: 'Escalated for compliance review.',
    createdBy: 'Compliance Team',
    createdAt: _d(2026, 4, 24, 11, 30),
  ),
];

// ────────────────────────────────────────────────────
// Transaction Details
// ────────────────────────────────────────────────────

AdminFinanceTransactionDetail
    mockTransactionDetailFor(
  AdminFinanceTransactionId id,
) {
  final record = mockAdminFinanceTransactions.firstWhere(
    (r) => r.id == id,
    orElse: () => mockAdminFinanceTransactions.first,
  );
  return AdminFinanceTransactionDetail(
    record: record,
    providerEvents: [
      AdminFinanceProviderEvent(
        id: 'pe-${id.value}-001',
        eventType: 'payment_intent.succeeded',
        provider: record.provider,
        occurredAt: record.createdAt,
        detail: 'Payment intent confirmed.',
        rawPayload: '{"id": "pi_xxx", "status": "succeeded"}',
      ),
    ],
    auditTrail: mockAuditTrailFor(id.value),
    notes: mockNotesFor(id.value),
    relatedRefundCases: mockAdminFinanceRefundCases
        .where((r) => r.transactionId == id)
        .toList(),
  );
}

// ────────────────────────────────────────────────────
// Payout Details
// ────────────────────────────────────────────────────

AdminFinancePayoutDetail mockPayoutDetailFor(
  AdminFinancePayoutId id,
) {
  final record = mockAdminFinancePayouts.firstWhere(
    (r) => r.id == id,
    orElse: () => mockAdminFinancePayouts.first,
  );
  return AdminFinancePayoutDetail(
    record: record,
    includedTransactions: mockAdminFinanceTransactions
        .where((t) => t.payoutId == id)
        .toList(),
    attempts: List.generate(
      record.attemptCount,
      (i) => AdminFinancePayoutAttempt(
        attemptNumber: i + 1,
        attemptedAt: record.scheduledDate.add(
          Duration(hours: i * 4),
        ),
        status: i < record.attemptCount - 1
            ? 'Failed'
            : record.status.label,
        failureReason: i < record.attemptCount - 1
            ? 'Network timeout'
            : record.failureReason,
      ),
    ),
    maskedDestination: '****-****-****-1234',
    auditTrail: mockAuditTrailFor(id.value),
    notes: mockNotesFor(id.value),
  );
}

// ────────────────────────────────────────────────────
// Refund Case Details
// ────────────────────────────────────────────────────

AdminFinanceRefundCaseDetail mockRefundCaseDetailFor(
  AdminFinanceRefundCaseId id,
) {
  final record = mockAdminFinanceRefundCases.firstWhere(
    (r) => r.id == id,
    orElse: () => mockAdminFinanceRefundCases.first,
  );
  return AdminFinanceRefundCaseDetail(
    record: record,
    customerRequest:
        'I would like a full refund because: '
        '${record.reason}.',
    partnerResponse:
        'We acknowledge the issue and are working '
        'to resolve it promptly.',
    evidenceLinks: [
      'https://storage.healytics.vn/evidence/'
          '${id.value}-receipt.pdf',
      'https://storage.healytics.vn/evidence/'
          '${id.value}-screenshot.png',
    ],
    decisionNote: record.status ==
            AdminFinanceRefundCaseStatus.approved
        ? 'Approved after evidence review.'
        : record.status ==
                AdminFinanceRefundCaseStatus.rejected
            ? 'Rejected: insufficient evidence.'
            : '',
    auditTrail: mockAuditTrailFor(id.value),
    notes: mockNotesFor(id.value),
  );
}

// ────────────────────────────────────────────────────
// Reconciliation Details
// ────────────────────────────────────────────────────

AdminFinanceReconciliationDetail
    mockReconciliationDetailFor(
  AdminFinanceReconciliationId id,
) {
  final exception =
      mockAdminFinanceReconciliationExceptions.firstWhere(
    (r) => r.id == id,
    orElse: () =>
        mockAdminFinanceReconciliationExceptions.first,
  );
  return AdminFinanceReconciliationDetail(
    exception: exception,
    providerEventContext:
        'Provider event ${exception.providerEventId} '
        'recorded at ${exception.detectedAt}.',
    ledgerContext: exception.relatedTransactionId != null
        ? 'Ledger transaction '
            '${exception.relatedTransactionId} found.'
        : 'No matching ledger transaction.',
    resolutionNotes: exception.status ==
            AdminFinanceReconciliationStatus.resolved
        ? 'Resolved after manual amount adjustment.'
        : '',
    auditTrail: mockAuditTrailFor(id.value),
    notes: mockNotesFor(id.value),
  );
}
