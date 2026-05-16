import { BadRequestException } from '@nestjs/common';
import { AdminFinanceService } from './admin-finance.service';
import {
  AdminFinanceExportType,
  AdminFinanceNoteEntityType,
  AdminFinancePeriod,
  AdminFinanceReconciliationStatus,
} from './dto/admin-finance.enums';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';

type MockRepo = {
  createQueryBuilder: jest.Mock;
  findOne: jest.Mock;
  find: jest.Mock;
  save: jest.Mock;
  create: jest.Mock;
};

const actor = { id: 'admin-1', email: 'finance@healytics.test' };

function createRepo(): MockRepo {
  return {
    createQueryBuilder: jest.fn(),
    findOne: jest.fn(),
    find: jest.fn(),
    save: jest.fn(async (value) => value),
    create: jest.fn((value) => value),
  };
}

function createQueryBuilder(
  result: {
    rawOne?: Record<string, unknown>;
    rawMany?: Record<string, unknown>[];
    manyAndCount?: [unknown[], number];
  } = {},
) {
  const qb = {
    leftJoin: jest.fn().mockReturnThis(),
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    select: jest.fn().mockReturnThis(),
    addSelect: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    setParameters: jest.fn().mockReturnThis(),
    groupBy: jest.fn().mockReturnThis(),
    addGroupBy: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    addOrderBy: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    limit: jest.fn().mockReturnThis(),
    getRawOne: jest.fn(async () => result.rawOne ?? {}),
    getRawMany: jest.fn(async () => result.rawMany ?? []),
    getManyAndCount: jest.fn(async () => result.manyAndCount ?? [[], 0]),
  };
  return qb;
}

function transactionFixture(overrides: Record<string, unknown> = {}) {
  return {
    id: 'txn-1',
    createdAt: new Date('2026-05-01T10:00:00Z'),
    reference: 'BK-001',
    partnerId: 'partner-1',
    partner: { brandName: 'Healytics Spa' },
    customerNameSnapshot: 'A Customer',
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    type: PartnerTransactionType.CHARGE,
    grossAmount: 1000,
    feeAmount: 120,
    currency: 'VND',
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.UNSETTLED,
    payoutStatus: PartnerPayoutStatus.NOT_ASSIGNED,
    paymentMethodLabel: 'VNPay',
    flaggedForReview: false,
    notes: null,
    payoutId: null,
    timelineEvents: [],
    ...overrides,
  };
}

function payoutFixture(overrides: Record<string, unknown> = {}) {
  return {
    id: 'payout-1',
    partnerId: 'partner-1',
    status: PartnerPayoutStatus.FAILED,
    attemptCount: 1,
    failureReason: 'timeout',
    holdReason: null,
    partner: { brandName: 'Healytics Spa' },
    scheduledDate: new Date('2026-05-02T10:00:00Z'),
    periodStart: new Date('2026-05-01T00:00:00Z'),
    periodEnd: new Date('2026-05-02T00:00:00Z'),
    includedVolume: 1000,
    feesAdjustments: 100,
    netPayout: 900,
    currency: 'VND',
    methodLabel: 'Bank transfer',
    maskedDestination: '**** 4242',
    createdAt: new Date('2026-05-02T10:00:00Z'),
    attempts: [],
    ...overrides,
  };
}

function refundCaseFixture(overrides: Record<string, unknown> = {}) {
  return {
    id: 'refund-1',
    status: PartnerRefundCaseStatus.PENDING,
    decisionNote: null,
    partner: { brandName: 'Healytics Spa' },
    transaction: { customerNameSnapshot: 'A Customer' },
    transactionId: 'txn-1',
    requestedAt: new Date('2026-05-02T10:00:00Z'),
    slaDueAt: new Date('2026-05-03T10:00:00Z'),
    caseType: 'refund',
    amount: 100,
    currency: 'VND',
    reason: 'Customer request',
    owner: 'Finance',
    customerRequest: null,
    partnerResponse: null,
    evidenceLinks: [],
    ...overrides,
  };
}

function reconciliationFixture(overrides: Record<string, unknown> = {}) {
  return {
    id: 'recon-1',
    status: AdminFinanceReconciliationStatus.OPEN,
    resolutionNotes: '',
    detectedAt: new Date('2026-05-02T10:00:00Z'),
    provider: 'vnpay',
    providerEventId: 'evt-1',
    relatedTransactionId: 'txn-1',
    expectedAmount: 1000,
    providerAmount: 900,
    difference: -100,
    currency: 'VND',
    type: 'amountMismatch',
    owner: 'Finance',
    summary: 'Amount mismatch',
    providerEventContext: '',
    ledgerContext: '',
    ...overrides,
  };
}

describe('AdminFinanceService', () => {
  let txnRepo: MockRepo;
  let payoutRepo: MockRepo;
  let payoutTxnRepo: MockRepo;
  let payoutAttemptRepo: MockRepo;
  let refundCaseRepo: MockRepo;
  let timelineRepo: MockRepo;
  let noteRepo: MockRepo;
  let reconRepo: MockRepo;
  let exportRepo: MockRepo;
  let service: AdminFinanceService;

  beforeEach(() => {
    txnRepo = createRepo();
    payoutRepo = createRepo();
    payoutTxnRepo = createRepo();
    payoutAttemptRepo = createRepo();
    refundCaseRepo = createRepo();
    timelineRepo = createRepo();
    noteRepo = createRepo();
    reconRepo = createRepo();
    exportRepo = createRepo();

    noteRepo.createQueryBuilder.mockReturnValue(
      createQueryBuilder({ rawMany: [] }),
    );
    noteRepo.find.mockResolvedValue([]);

    service = new AdminFinanceService(
      txnRepo as any,
      payoutRepo as any,
      payoutTxnRepo as any,
      payoutAttemptRepo as any,
      refundCaseRepo as any,
      timelineRepo as any,
      noteRepo as any,
      reconRepo as any,
      exportRepo as any,
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('aggregates summary metrics and applies admin query filters', async () => {
    const txnQb = createQueryBuilder({
      rawOne: {
        grossVolume: '1200',
        netRevenue: '1020',
        platformFeeRevenue: '180',
        failedPaymentAmount: '300',
      },
    });
    const refundQb = createQueryBuilder({
      rawOne: { refundExposure: '125' },
    });
    const payoutQb = createQueryBuilder({
      rawOne: { pendingPayoutAmount: '700', heldPayoutAmount: '200' },
    });
    const reconQb = createQueryBuilder({
      rawOne: { unreconciledAmount: '50' },
    });
    txnRepo.createQueryBuilder.mockReturnValue(txnQb);
    refundCaseRepo.createQueryBuilder.mockReturnValue(refundQb);
    payoutRepo.createQueryBuilder.mockReturnValue(payoutQb);
    reconRepo.createQueryBuilder.mockReturnValue(reconQb);

    const result = await service.getSummary({
      search: 'spa',
      period: AdminFinancePeriod.SEVEN_DAYS,
      currency: 'VND',
      partnerId: 'partner-1',
      onlyFlagged: true,
    } as any);

    expect(result).toMatchObject({
      grossVolume: 1200,
      netRevenue: 1020,
      platformFeeRevenue: 180,
      refundExposure: 125,
      failedPaymentAmount: 300,
      pendingPayoutAmount: 700,
      heldPayoutAmount: 200,
      unreconciledAmount: 50,
      currency: 'VND',
    });
    expect(txnQb.andWhere).toHaveBeenCalledWith(
      expect.stringContaining('partner.brand_name'),
      { search: '%spa%' },
    );
    expect(txnQb.andWhere).toHaveBeenCalledWith('txn.partnerId = :partnerId', {
      partnerId: 'partner-1',
    });
    expect(txnQb.andWhere).toHaveBeenCalledWith('txn.flaggedForReview = true');
    expect(payoutQb.setParameters).toHaveBeenCalledWith(
      expect.objectContaining({ heldStatus: PartnerPayoutStatus.HELD }),
    );
  });

  it('returns transaction page metadata from the backend page query', async () => {
    const transaction = transactionFixture();
    const txnQb = createQueryBuilder({ manyAndCount: [[transaction], 21] });
    txnRepo.createQueryBuilder.mockReturnValue(txnQb);

    const result = await service.listTransactions({
      page: 3,
      limit: 10,
      provider: 'vnpay',
    } as any);

    expect(result.meta).toMatchObject({
      total: 21,
      page: 3,
      limit: 10,
      totalPages: 3,
    });
    expect(result.data[0]).toMatchObject({
      id: 'txn-1',
      provider: 'vnpay',
      payoutStatus: PartnerPayoutStatus.NOT_ASSIGNED,
    });
    expect(txnQb.skip).toHaveBeenCalledWith(20);
    expect(txnQb.take).toHaveBeenCalledWith(10);
    expect(txnQb.andWhere).toHaveBeenCalledWith(
      'LOWER(COALESCE(txn.payment_method_label, :manual)) LIKE :provider',
      { manual: 'manual', provider: '%vnpay%' },
    );
  });

  it('requires a settlement note and persists settlement review state', async () => {
    const transaction = transactionFixture();
    txnRepo.findOne.mockResolvedValue(transaction);
    noteRepo.save.mockImplementation(async (value) => ({
      id: 'note-1',
      createdAt: new Date('2026-05-02T10:00:00Z'),
      ...value,
    }));

    await expect(
      service.markSettlement(actor, 'txn-1', {
        settlementStatus: PartnerSettlementStatus.SETTLED,
        note: '',
      } as any),
    ).rejects.toBeInstanceOf(BadRequestException);

    await service.markSettlement(actor, 'txn-1', {
      settlementStatus: PartnerSettlementStatus.SETTLED,
      note: 'Matched bank deposit',
    } as any);

    expect(transaction.settlementStatus).toBe(PartnerSettlementStatus.SETTLED);
    expect(txnRepo.save).toHaveBeenCalledWith(transaction);
    expect(timelineRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        transactionId: 'txn-1',
        title: 'Settlement marked settled',
        actorAccountId: 'admin-1',
      }),
    );
    expect(noteRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        entityType: AdminFinanceNoteEntityType.TRANSACTION,
        entityId: 'txn-1',
        content: 'Matched bank deposit',
        createdByName: 'finance@healytics.test',
      }),
    );
  });

  it('handles payout retry, hold, and hold release state transitions', async () => {
    const payout = payoutFixture();
    payoutRepo.findOne.mockResolvedValue(payout);
    jest.spyOn(service, 'getPayoutDetail').mockResolvedValue({} as any);

    await service.retryPayout(actor, 'payout-1', { note: 'Retry now' });
    expect(payout.status).toBe(PartnerPayoutStatus.IN_PAYOUT);
    expect(payout.attemptCount).toBe(2);
    expect(payout.failureReason).toBeNull();
    expect(payoutAttemptRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        payoutId: 'payout-1',
        attemptNumber: 2,
        status: PartnerPayoutStatus.IN_PAYOUT,
      }),
    );

    await service.holdPayout(actor, 'payout-1', {
      note: 'Manual review',
    });
    expect(payout.status).toBe(PartnerPayoutStatus.HELD);
    expect(payout.holdReason).toBe('Manual review');

    await service.releasePayoutHold(actor, 'payout-1', {
      note: 'Cleared',
    });
    expect(payout.status).toBe(PartnerPayoutStatus.NOT_ASSIGNED);
    expect(payout.holdReason).toBeNull();
  });

  it('persists refund approval and rejection decisions', async () => {
    const refundCase = refundCaseFixture();
    refundCaseRepo.findOne.mockResolvedValue(refundCase);
    jest.spyOn(service, 'getRefundCaseDetail').mockResolvedValue({} as any);

    await service.approveRefundCase(actor, 'refund-1', {
      note: 'Eligible',
    });
    expect(refundCase.status).toBe(PartnerRefundCaseStatus.APPROVED);
    expect(refundCase.decisionNote).toBe('Eligible');

    await service.rejectRefundCase(actor, 'refund-1', {
      note: 'Outside policy',
    });
    expect(refundCase.status).toBe(PartnerRefundCaseStatus.REJECTED);
    expect(refundCase.decisionNote).toBe('Outside policy');
    expect(noteRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        entityType: AdminFinanceNoteEntityType.REFUND_CASE,
        entityId: 'refund-1',
        content: 'Outside policy',
      }),
    );
  });

  it('resolves and reopens reconciliation exceptions with notes', async () => {
    const recon = reconciliationFixture();
    reconRepo.findOne.mockResolvedValue(recon);
    jest.spyOn(service, 'getReconciliationDetail').mockResolvedValue({} as any);

    await service.resolveReconciliation(actor, 'recon-1', {
      note: 'Provider correction posted',
    });
    expect(recon.status).toBe(AdminFinanceReconciliationStatus.RESOLVED);
    expect(recon.resolutionNotes).toBe('Provider correction posted');

    await service.reopenReconciliation(actor, 'recon-1', {
      note: 'Mismatch returned',
    });
    expect(recon.status).toBe(AdminFinanceReconciliationStatus.REOPENED);
    expect(recon.resolutionNotes).toBe('Mismatch returned');
    expect(noteRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        entityType: AdminFinanceNoteEntityType.RECONCILIATION,
        entityId: 'recon-1',
        content: 'Mismatch returned',
      }),
    );
  });

  it('creates export jobs with the requesting admin identity', async () => {
    exportRepo.save.mockImplementation(async (value) => ({
      id: 'export-1',
      createdAt: new Date('2026-05-02T10:00:00Z'),
      ...value,
    }));

    const result = await service.createExport(actor, {
      type: AdminFinanceExportType.TRANSACTIONS,
    });

    expect(exportRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        type: AdminFinanceExportType.TRANSACTIONS,
        requestedByAccountId: 'admin-1',
        requestedByName: 'finance@healytics.test',
      }),
    );
    expect(result).toMatchObject({
      id: 'export-1',
      type: AdminFinanceExportType.TRANSACTIONS,
      requestedBy: 'finance@healytics.test',
    });
  });
});
