import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ReconciliationJobService } from './reconciliation-job.service';
import { AdminFinanceReconciliationException } from '@/common/entities/admin-finance-reconciliation-exception.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import {
  AdminFinanceReconciliationStatus,
  AdminFinanceReconciliationType,
} from './dto/admin-finance.enums';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';

// ── Mock QueryBuilder ──────────────────────────────────────────

function createMockQueryBuilder(results: unknown[] = []) {
  const qb: Record<string, jest.Mock> = {};
  const chainMethods = [
    'where',
    'andWhere',
    'select',
    'addSelect',
    'leftJoin',
    'innerJoin',
    'groupBy',
    'addGroupBy',
    'having',
    'orderBy',
    'setParameters',
  ];
  for (const method of chainMethods) {
    qb[method] = jest.fn().mockReturnValue(qb);
  }
  qb['getMany'] = jest.fn().mockResolvedValue(results);
  qb['getRawMany'] = jest.fn().mockResolvedValue(results);
  return qb;
}

// ── Mock Repository Factory ────────────────────────────────────

function createMockRepo() {
  return {
    findOne: jest.fn().mockResolvedValue(null),
    find: jest.fn().mockResolvedValue([]),
    save: jest.fn().mockImplementation((entity) =>
      Promise.resolve({ id: 'new-id', ...entity }),
    ),
    create: jest.fn().mockImplementation((entity) => entity),
    createQueryBuilder: jest.fn().mockReturnValue(createMockQueryBuilder()),
  };
}

// ── Test Fixtures ──────────────────────────────────────────────

const daysAgo = (days: number): Date => {
  const d = new Date();
  d.setDate(d.getDate() - days);
  return d;
};

function staleTxnFixture(overrides: Partial<PartnerLedgerTransaction> = {}) {
  return {
    id: 'txn-stale-001',
    reference: 'REF-STALE-001',
    grossAmount: 500000,
    currency: 'VND',
    status: PartnerTransactionStatus.PENDING,
    paymentMethodLabel: 'MoMo Wallet',
    createdAt: daysAgo(3),
    ...overrides,
  } as PartnerLedgerTransaction;
}

function flaggedTxnFixture(overrides: Partial<PartnerLedgerTransaction> = {}) {
  return {
    id: 'txn-flagged-001',
    reference: 'REF-FLAGGED-001',
    grossAmount: 300000,
    currency: 'VND',
    settlementStatus: PartnerSettlementStatus.UNSETTLED,
    flaggedForReview: true,
    paymentMethodLabel: 'VNPay',
    createdAt: daysAgo(5),
    ...overrides,
  } as PartnerLedgerTransaction;
}

// ── Tests ──────────────────────────────────────────────────────

describe('ReconciliationJobService', () => {
  let service: ReconciliationJobService;
  let reconRepo: ReturnType<typeof createMockRepo>;
  let txnRepo: ReturnType<typeof createMockRepo>;
  let payoutRepo: ReturnType<typeof createMockRepo>;
  let payoutTxnRepo: ReturnType<typeof createMockRepo>;
  let refundCaseRepo: ReturnType<typeof createMockRepo>;

  beforeEach(async () => {
    reconRepo = createMockRepo();
    txnRepo = createMockRepo();
    payoutRepo = createMockRepo();
    payoutTxnRepo = createMockRepo();
    refundCaseRepo = createMockRepo();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReconciliationJobService,
        {
          provide: getRepositoryToken(AdminFinanceReconciliationException),
          useValue: reconRepo,
        },
        {
          provide: getRepositoryToken(PartnerLedgerTransaction),
          useValue: txnRepo,
        },
        {
          provide: getRepositoryToken(PartnerPayout),
          useValue: payoutRepo,
        },
        {
          provide: getRepositoryToken(PartnerPayoutTransaction),
          useValue: payoutTxnRepo,
        },
        {
          provide: getRepositoryToken(PartnerRefundCase),
          useValue: refundCaseRepo,
        },
      ],
    }).compile();

    service = module.get(ReconciliationJobService);
  });

  afterEach(() => jest.clearAllMocks());

  describe('runReconciliation', () => {
    it('should run all 6 checks without errors when no anomalies exist', async () => {
      await expect(service.runReconciliation()).resolves.not.toThrow();
    });
  });

  describe('Check ① — Stale Pending Payments', () => {
    it('should create exception for transaction pending > 24h', async () => {
      const staleTxn = staleTxnFixture();
      const txnQb = createMockQueryBuilder([staleTxn]);
      txnRepo.createQueryBuilder.mockReturnValue(txnQb);

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.STALE_PENDING_PAYMENT,
          relatedTransactionId: 'txn-stale-001',
          expectedAmount: 500000,
          providerAmount: 0,
          status: AdminFinanceReconciliationStatus.OPEN,
          owner: 'Payment Operations',
        }),
      );
      expect(reconRepo.save).toHaveBeenCalled();
    });

    it('should not create duplicate for already-detected stale payment', async () => {
      const staleTxn = staleTxnFixture();
      const txnQb = createMockQueryBuilder([staleTxn]);
      txnRepo.createQueryBuilder.mockReturnValue(txnQb);

      // Existing OPEN exception
      reconRepo.findOne.mockResolvedValue({
        id: 'existing-id',
        providerEventId: 'RECON_STALE_PENDING_txn-stale-001',
        status: AdminFinanceReconciliationStatus.OPEN,
        expectedAmount: 500000,
        providerAmount: 0,
        difference: -500000,
        summary: 'old summary',
      });

      await service.runReconciliation();

      // Should update existing, not create new
      expect(reconRepo.create).not.toHaveBeenCalledWith(
        expect.objectContaining({
          providerEventId: 'RECON_STALE_PENDING_txn-stale-001',
        }),
      );
    });

    it('should skip resolved exceptions — never reopen automatically', async () => {
      const staleTxn = staleTxnFixture();
      const txnQb = createMockQueryBuilder([staleTxn]);
      txnRepo.createQueryBuilder.mockReturnValue(txnQb);

      reconRepo.findOne.mockResolvedValue({
        id: 'resolved-id',
        providerEventId: 'RECON_STALE_PENDING_txn-stale-001',
        status: AdminFinanceReconciliationStatus.RESOLVED,
      });

      await service.runReconciliation();

      // Should not update resolved exception
      expect(reconRepo.save).not.toHaveBeenCalledWith(
        expect.objectContaining({ id: 'resolved-id' }),
      );
    });
  });

  describe('Check ② — Payout Volume Mismatches', () => {
    it('should create exception when payout volume does not match transactions', async () => {
      const mismatchRow = {
        payoutId: 'payout-001',
        includedVolume: '1000000',
        actualVolume: '950000',
        currency: 'VND',
        methodLabel: 'Vietcombank ending 1122',
      };
      const payoutQb = createMockQueryBuilder([mismatchRow]);
      payoutRepo.createQueryBuilder.mockReturnValue(payoutQb);

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.PAYOUT_MISMATCH,
          expectedAmount: 1000000,
          providerAmount: 950000,
          owner: 'Finance Reconciliation',
        }),
      );
    });
  });

  describe('Check ③ — Refund Amount Mismatches', () => {
    it('should create exception when refund amount differs from transaction', async () => {
      const mismatchRow = {
        refundCaseId: 'rc-001',
        refundAmount: '380000',
        txnGrossAmount: '400000',
        transactionId: 'txn-refund-001',
        currency: 'VND',
        paymentMethodLabel: 'MoMo Wallet',
      };
      const refundQb = createMockQueryBuilder([mismatchRow]);
      refundCaseRepo.createQueryBuilder.mockReturnValue(refundQb);

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.REFUND_MISMATCH,
          expectedAmount: 400000,
          providerAmount: 380000,
          relatedTransactionId: 'txn-refund-001',
          owner: 'Refund Operations',
        }),
      );
    });
  });

  describe('Check ④ — Orphaned Payout Links', () => {
    it('should create exception for transaction with missing payout', async () => {
      const orphanRow = {
        txnId: 'txn-orphan-001',
        payoutId: 'payout-deleted-001',
        grossAmount: '750000',
        currency: 'VND',
        paymentMethodLabel: null,
        reference: 'REF-ORPHAN-001',
      };
      const emptyQb = createMockQueryBuilder([]);
      const orphanQb = createMockQueryBuilder([orphanRow]);

      // Check ① uses txnRepo (stale pending → empty),
      // Check ④ uses txnRepo (orphaned payouts → match),
      // Check ⑥ uses txnRepo (flagged unsettled → empty)
      txnRepo.createQueryBuilder
        .mockReturnValueOnce(emptyQb)   // ① stale pending
        .mockReturnValueOnce(orphanQb)  // ④ orphaned payouts
        .mockReturnValueOnce(emptyQb);  // ⑥ flagged unsettled

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.MISSING_LEDGER_RECORD,
          relatedTransactionId: 'txn-orphan-001',
          owner: 'Data Integrity',
        }),
      );
    });
  });

  describe('Check ⑤ — Duplicate Payout Inclusions', () => {
    it('should create exception for transaction in multiple payouts', async () => {
      const dupRow = {
        transactionId: 'txn-dup-001',
        payoutCount: '3',
      };
      const payoutTxnQb = createMockQueryBuilder([dupRow]);
      payoutTxnRepo.createQueryBuilder.mockReturnValue(payoutTxnQb);
      txnRepo.findOne.mockResolvedValue({
        id: 'txn-dup-001',
        paymentMethodLabel: 'Stripe',
        currency: 'VND',
      });

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.DUPLICATE_PROVIDER_EVENT,
          expectedAmount: 1,
          providerAmount: 3,
          owner: 'Finance Reconciliation',
        }),
      );
    });
  });

  describe('Check ⑥ — Flagged but Unsettled', () => {
    it('should create exception for flagged transaction unsettled > 48h', async () => {
      const flaggedTxn = flaggedTxnFixture();
      // First call returns stale pending check (empty), subsequent calls return different results
      // Since all checks use createQueryBuilder, we need to handle ordering
      const emptyQb = createMockQueryBuilder([]);
      const flaggedQb = createMockQueryBuilder([flaggedTxn]);

      // Mock ordering: checks 1-5 return empty, check 6 returns the flagged txn
      // Check ① uses txnRepo, Check ② uses payoutRepo, Check ③ uses refundCaseRepo,
      // Check ④ uses txnRepo, Check ⑤ uses payoutTxnRepo, Check ⑥ uses txnRepo
      txnRepo.createQueryBuilder
        .mockReturnValueOnce(emptyQb) // ① stale pending
        .mockReturnValueOnce(emptyQb) // ④ orphaned payouts
        .mockReturnValueOnce(flaggedQb); // ⑥ flagged unsettled

      await service.runReconciliation();

      expect(reconRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          type: AdminFinanceReconciliationType.MISSING_PROVIDER_EVENT,
          relatedTransactionId: 'txn-flagged-001',
          expectedAmount: 300000,
          providerAmount: 0,
          owner: 'Settlement Operations',
        }),
      );
    });
  });

  describe('Idempotency', () => {
    it('should update amounts on active exception without creating new one', async () => {
      const staleTxn = staleTxnFixture({ grossAmount: 600000 });
      const txnQb = createMockQueryBuilder([staleTxn]);
      txnRepo.createQueryBuilder.mockReturnValue(txnQb);

      const existingException = {
        id: 'existing-recon-001',
        providerEventId: 'RECON_STALE_PENDING_txn-stale-001',
        status: AdminFinanceReconciliationStatus.UNDER_REVIEW,
        expectedAmount: 500000,
        providerAmount: 0,
        difference: -500000,
        summary: 'old summary',
      };
      reconRepo.findOne.mockResolvedValue(existingException);

      await service.runReconciliation();

      // Should update the existing exception with new amount
      expect(reconRepo.save).toHaveBeenCalledWith(
        expect.objectContaining({
          id: 'existing-recon-001',
          expectedAmount: 600000,
        }),
      );

      // Should NOT call create for this providerEventId
      expect(reconRepo.create).not.toHaveBeenCalledWith(
        expect.objectContaining({
          providerEventId: 'RECON_STALE_PENDING_txn-stale-001',
        }),
      );
    });
  });
});
