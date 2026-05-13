import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';
import { AdminFinanceReconciliationException } from '@/common/entities/admin-finance-reconciliation-exception.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import {
  AdminFinanceProvider,
  AdminFinanceReconciliationStatus,
  AdminFinanceReconciliationType,
} from './dto/admin-finance.enums';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';

/**
 * CRON-based reconciliation job that runs every 10 minutes.
 *
 * Scans the partner finance tables for anomalies and automatically
 * creates AdminFinanceReconciliationException records when mismatches
 * are detected. Uses deterministic providerEventId keys for idempotent
 * upserts — running the job multiple times won't create duplicates.
 *
 * Detection checks:
 *   ① Stale pending payments (PENDING > 24h)
 *   ② Payout volume mismatches (SUM(txn) ≠ payout.includedVolume)
 *   ③ Refund amount mismatches (refundCase.amount ≠ txn.grossAmount)
 *   ④ Orphaned payout links (txn.payoutId → missing payout)
 *   ⑤ Duplicate payout inclusions (same txn in multiple payouts)
 *   ⑥ Flagged but unsettled (flagged + UNSETTLED > 48h)
 */
@Injectable()
export class ReconciliationJobService {
  private readonly logger = new Logger(ReconciliationJobService.name);

  constructor(
    @InjectRepository(AdminFinanceReconciliationException)
    private readonly reconRepo: Repository<AdminFinanceReconciliationException>,
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
    @InjectRepository(PartnerPayoutTransaction)
    private readonly payoutTxnRepo: Repository<PartnerPayoutTransaction>,
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
  ) {}

  @Cron(CronExpression.EVERY_10_MINUTES)
  async runReconciliation(): Promise<void> {
    this.logger.log('🔍 Running reconciliation checks...');
    const start = Date.now();
    let created = 0;

    created += await this.checkStalePendingPayments();
    created += await this.checkPayoutVolumeMismatches();
    created += await this.checkRefundAmountMismatches();
    created += await this.checkOrphanedPayoutLinks();
    created += await this.checkDuplicatePayoutInclusions();
    created += await this.checkFlaggedUnsettled();

    const duration = ((Date.now() - start) / 1000).toFixed(2);
    this.logger.log(
      `✅ Reconciliation completed in ${duration}s — ${created} new exception(s)`,
    );
  }

  // ── Check ①: Stale Pending Payments ──────────────────────────

  /**
   * Detects transactions stuck in PENDING status for more than 24 hours.
   * These indicate a payment that was never confirmed or rejected.
   */
  private async checkStalePendingPayments(): Promise<number> {
    const cutoff = new Date(Date.now() - 24 * 60 * 60 * 1000);

    const staleTxns = await this.txnRepo
      .createQueryBuilder('txn')
      .where('txn.status = :status', {
        status: PartnerTransactionStatus.PENDING,
      })
      .andWhere('txn.createdAt < :cutoff', { cutoff })
      .andWhere('txn.deletedAt IS NULL')
      .getMany();

    let created = 0;
    for (const txn of staleTxns) {
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_STALE_PENDING_${txn.id}`,
        relatedTransactionId: txn.id,
        provider: this.providerFromLabel(txn.paymentMethodLabel),
        expectedAmount: Number(txn.grossAmount),
        providerAmount: 0,
        currency: txn.currency,
        type: AdminFinanceReconciliationType.STALE_PENDING_PAYMENT,
        owner: 'Payment Operations',
        summary: `Payment stuck in PENDING for ${this.hoursAgo(txn.createdAt)}h — transaction ${txn.reference}`,
        ledgerContext: `Transaction ${txn.id} created at ${txn.createdAt.toISOString()}, status=${txn.status}, gross=${txn.grossAmount} ${txn.currency}`,
      });
      if (wasCreated) created++;
    }

    if (staleTxns.length > 0) {
      this.logger.log(
        `  ① Stale pending: ${staleTxns.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Check ②: Payout Volume Mismatches ────────────────────────

  /**
   * Detects payouts where the sum of included transaction gross amounts
   * does not match the payout's declared includedVolume.
   */
  private async checkPayoutVolumeMismatches(): Promise<number> {
    const rows: Array<{
      payoutId: string;
      includedVolume: string;
      actualVolume: string;
      currency: string;
      methodLabel: string;
    }> = await this.payoutRepo
      .createQueryBuilder('pp')
      .leftJoin(
        PartnerPayoutTransaction,
        'ppt',
        'ppt.payout_id = pp.id',
      )
      .leftJoin(
        PartnerLedgerTransaction,
        'plt',
        'plt.id = ppt.transaction_id',
      )
      .select([
        'pp.id AS "payoutId"',
        'pp.included_volume AS "includedVolume"',
        'COALESCE(SUM(plt.gross_amount), 0) AS "actualVolume"',
        'pp.currency AS "currency"',
        'pp.method_label AS "methodLabel"',
      ])
      .where('pp.deletedAt IS NULL')
      .groupBy('pp.id')
      .having(
        'ABS(pp.included_volume - COALESCE(SUM(plt.gross_amount), 0)) > 0.01',
      )
      .getRawMany();

    let created = 0;
    for (const row of rows) {
      const expected = Number(row.includedVolume);
      const actual = Number(row.actualVolume);
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_PAYOUT_MISMATCH_${row.payoutId}`,
        relatedTransactionId: null,
        provider: this.providerFromLabel(row.methodLabel),
        expectedAmount: expected,
        providerAmount: actual,
        currency: row.currency,
        type: AdminFinanceReconciliationType.PAYOUT_MISMATCH,
        owner: 'Finance Reconciliation',
        summary: `Payout volume mismatch: declared ${this.formatAmount(expected, row.currency)} but transactions total ${this.formatAmount(actual, row.currency)}`,
        providerEventContext: `Payout ${row.payoutId}`,
        ledgerContext: `Expected includedVolume=${expected}, actual SUM(grossAmount)=${actual}, diff=${(actual - expected).toFixed(2)}`,
      });
      if (wasCreated) created++;
    }

    if (rows.length > 0) {
      this.logger.log(
        `  ② Payout mismatches: ${rows.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Check ③: Refund Amount Mismatches ────────────────────────

  /**
   * Detects refund cases where the refund amount does not match
   * the related transaction's gross amount for REFUND-type transactions.
   */
  private async checkRefundAmountMismatches(): Promise<number> {
    const rows: Array<{
      refundCaseId: string;
      refundAmount: string;
      txnGrossAmount: string;
      transactionId: string;
      currency: string;
      paymentMethodLabel: string | null;
    }> = await this.refundCaseRepo
      .createQueryBuilder('prc')
      .innerJoin(
        PartnerLedgerTransaction,
        'plt',
        'plt.id = prc.transaction_id',
      )
      .select([
        'prc.id AS "refundCaseId"',
        'prc.amount AS "refundAmount"',
        'plt.gross_amount AS "txnGrossAmount"',
        'prc.transaction_id AS "transactionId"',
        'prc.currency AS "currency"',
        'plt.payment_method_label AS "paymentMethodLabel"',
      ])
      .where('ABS(prc.amount - plt.gross_amount) > 0.01')
      .andWhere('plt.type = :refundType', {
        refundType: PartnerTransactionType.REFUND,
      })
      .andWhere('prc.deletedAt IS NULL')
      .andWhere('plt.deletedAt IS NULL')
      .getRawMany();

    let created = 0;
    for (const row of rows) {
      const expected = Number(row.txnGrossAmount);
      const refunded = Number(row.refundAmount);
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_REFUND_MISMATCH_${row.refundCaseId}`,
        relatedTransactionId: row.transactionId,
        provider: this.providerFromLabel(row.paymentMethodLabel),
        expectedAmount: expected,
        providerAmount: refunded,
        currency: row.currency,
        type: AdminFinanceReconciliationType.REFUND_MISMATCH,
        owner: 'Refund Operations',
        summary: `Refund amount mismatch: transaction ${this.formatAmount(expected, row.currency)} vs refund case ${this.formatAmount(refunded, row.currency)}`,
        ledgerContext: `RefundCase ${row.refundCaseId} amount=${refunded}, Transaction ${row.transactionId} grossAmount=${expected}`,
      });
      if (wasCreated) created++;
    }

    if (rows.length > 0) {
      this.logger.log(
        `  ③ Refund mismatches: ${rows.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Check ④: Orphaned Payout Links ───────────────────────────

  /**
   * Detects transactions that reference a payoutId which no longer exists
   * in the partner_payouts table (data integrity issue).
   */
  private async checkOrphanedPayoutLinks(): Promise<number> {
    const orphans: Array<{
      txnId: string;
      payoutId: string;
      grossAmount: string;
      currency: string;
      paymentMethodLabel: string | null;
      reference: string;
    }> = await this.txnRepo
      .createQueryBuilder('plt')
      .leftJoin(PartnerPayout, 'pp', 'pp.id = plt.payout_id')
      .select([
        'plt.id AS "txnId"',
        'plt.payout_id AS "payoutId"',
        'plt.gross_amount AS "grossAmount"',
        'plt.currency AS "currency"',
        'plt.payment_method_label AS "paymentMethodLabel"',
        'plt.reference AS "reference"',
      ])
      .where('plt.payout_id IS NOT NULL')
      .andWhere('pp.id IS NULL')
      .andWhere('plt.deletedAt IS NULL')
      .getRawMany();

    let created = 0;
    for (const row of orphans) {
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_ORPHAN_PAYOUT_${row.txnId}`,
        relatedTransactionId: row.txnId,
        provider: this.providerFromLabel(row.paymentMethodLabel),
        expectedAmount: Number(row.grossAmount),
        providerAmount: 0,
        currency: row.currency,
        type: AdminFinanceReconciliationType.MISSING_LEDGER_RECORD,
        owner: 'Data Integrity',
        summary: `Transaction ${row.reference} references non-existent payout ${row.payoutId}`,
        ledgerContext: `Transaction ${row.txnId} has payoutId=${row.payoutId} but no matching payout record exists`,
      });
      if (wasCreated) created++;
    }

    if (orphans.length > 0) {
      this.logger.log(
        `  ④ Orphaned payouts: ${orphans.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Check ⑤: Duplicate Payout Inclusions ─────────────────────

  /**
   * Detects transactions that are linked to multiple payouts,
   * which would cause the same charge to be disbursed twice.
   */
  private async checkDuplicatePayoutInclusions(): Promise<number> {
    const duplicates: Array<{
      transactionId: string;
      payoutCount: string;
    }> = await this.payoutTxnRepo
      .createQueryBuilder('ppt')
      .select([
        'ppt.transaction_id AS "transactionId"',
        'COUNT(DISTINCT ppt.payout_id) AS "payoutCount"',
      ])
      .groupBy('ppt.transaction_id')
      .having('COUNT(DISTINCT ppt.payout_id) > 1')
      .getRawMany();

    let created = 0;
    for (const row of duplicates) {
      const txn = await this.txnRepo.findOne({
        where: { id: row.transactionId },
      });
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_DUP_PAYOUT_${row.transactionId}`,
        relatedTransactionId: row.transactionId,
        provider: this.providerFromLabel(txn?.paymentMethodLabel),
        expectedAmount: 1,
        providerAmount: Number(row.payoutCount),
        currency: txn?.currency ?? 'VND',
        type: AdminFinanceReconciliationType.DUPLICATE_PROVIDER_EVENT,
        owner: 'Finance Reconciliation',
        summary: `Transaction included in ${row.payoutCount} payouts (expected exactly 1)`,
        ledgerContext: `Transaction ${row.transactionId} appears in ${row.payoutCount} distinct payouts`,
      });
      if (wasCreated) created++;
    }

    if (duplicates.length > 0) {
      this.logger.log(
        `  ⑤ Duplicate inclusions: ${duplicates.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Check ⑥: Flagged but Unsettled ───────────────────────────

  /**
   * Detects transactions that were flagged for review but remain
   * in UNSETTLED settlement status for more than 48 hours.
   */
  private async checkFlaggedUnsettled(): Promise<number> {
    const cutoff = new Date(Date.now() - 48 * 60 * 60 * 1000);

    const flagged = await this.txnRepo
      .createQueryBuilder('txn')
      .where('txn.flaggedForReview = true')
      .andWhere('txn.settlementStatus = :status', {
        status: PartnerSettlementStatus.UNSETTLED,
      })
      .andWhere('txn.createdAt < :cutoff', { cutoff })
      .andWhere('txn.deletedAt IS NULL')
      .getMany();

    let created = 0;
    for (const txn of flagged) {
      const wasCreated = await this.upsertException({
        providerEventId: `RECON_FLAGGED_UNSETTLED_${txn.id}`,
        relatedTransactionId: txn.id,
        provider: this.providerFromLabel(txn.paymentMethodLabel),
        expectedAmount: Number(txn.grossAmount),
        providerAmount: 0,
        currency: txn.currency,
        type: AdminFinanceReconciliationType.MISSING_PROVIDER_EVENT,
        owner: 'Settlement Operations',
        summary: `Flagged transaction unsettled for ${this.hoursAgo(txn.createdAt)}h — ${txn.reference}`,
        ledgerContext: `Transaction ${txn.id} flagged for review, settlementStatus=${txn.settlementStatus}, created ${txn.createdAt.toISOString()}`,
      });
      if (wasCreated) created++;
    }

    if (flagged.length > 0) {
      this.logger.log(
        `  ⑥ Flagged unsettled: ${flagged.length} found, ${created} new`,
      );
    }
    return created;
  }

  // ── Shared Helpers ───────────────────────────────────────────

  /**
   * Idempotent upsert: creates a new exception or updates an active one.
   * Resolved exceptions are never reopened automatically.
   *
   * @returns true if a NEW exception was created
   */
  private async upsertException(params: {
    providerEventId: string;
    relatedTransactionId: string | null;
    provider: AdminFinanceProvider;
    expectedAmount: number;
    providerAmount: number;
    currency: string;
    type: AdminFinanceReconciliationType;
    owner: string;
    summary: string;
    providerEventContext?: string;
    ledgerContext?: string;
  }): Promise<boolean> {
    const existing = await this.reconRepo.findOne({
      where: { providerEventId: params.providerEventId },
    });

    if (existing) {
      // Already resolved → don't reopen automatically
      if (existing.status === AdminFinanceReconciliationStatus.RESOLVED) {
        return false;
      }
      // Still active → update amounts and summary (they may have changed)
      existing.expectedAmount = params.expectedAmount;
      existing.providerAmount = params.providerAmount;
      existing.difference = params.providerAmount - params.expectedAmount;
      existing.summary = params.summary;
      await this.reconRepo.save(existing);
      return false;
    }

    // Create new exception
    await this.reconRepo.save(
      this.reconRepo.create({
        detectedAt: new Date(),
        provider: params.provider,
        providerEventId: params.providerEventId,
        relatedTransactionId: params.relatedTransactionId,
        expectedAmount: params.expectedAmount,
        providerAmount: params.providerAmount,
        difference: params.providerAmount - params.expectedAmount,
        currency: params.currency,
        type: params.type,
        status: AdminFinanceReconciliationStatus.OPEN,
        owner: params.owner,
        summary: params.summary,
        providerEventContext: params.providerEventContext ?? null,
        ledgerContext: params.ledgerContext ?? null,
        resolutionNotes: null,
      }),
    );
    return true;
  }

  private providerFromLabel(label?: string | null): AdminFinanceProvider {
    const value = (label ?? '').toLowerCase();
    if (value.includes('stripe')) return AdminFinanceProvider.STRIPE;
    if (value.includes('momo')) return AdminFinanceProvider.MOMO;
    if (value.includes('vnpay')) return AdminFinanceProvider.VNPAY;
    if (value.includes('bank') || value.includes('transfer'))
      return AdminFinanceProvider.BANK_TRANSFER;
    return AdminFinanceProvider.MANUAL;
  }

  private hoursAgo(date: Date): number {
    return Math.floor((Date.now() - date.getTime()) / 3600000);
  }

  private formatAmount(amount: number, currency: string): string {
    return `${amount.toLocaleString('vi-VN')} ${currency}`;
  }
}
