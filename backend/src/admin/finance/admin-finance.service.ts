import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository, SelectQueryBuilder } from 'typeorm';
import { AdminFinanceExportJob } from '@/common/entities/admin-finance-export-job.entity';
import { AdminFinanceNote } from '@/common/entities/admin-finance-note.entity';
import { AdminFinanceReconciliationException } from '@/common/entities/admin-finance-reconciliation-exception.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayoutAttempt } from '@/common/entities/partner-payout-attempt.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import {
  AdminFinanceCreateExportDto,
  AdminFinanceCreateNoteDto,
  AdminFinanceNoteActionDto,
  AdminFinanceRequiredNoteActionDto,
  AdminFinanceReviewFlagActionDto,
  AdminFinanceSettlementActionDto,
} from './dto/admin-finance-action.dto';
import {
  AdminFinanceExportStatus,
  AdminFinanceNoteEntityType,
  AdminFinancePeriod,
  AdminFinanceProvider,
  AdminFinanceReconciliationStatus,
  AdminFinanceRiskTone,
} from './dto/admin-finance.enums';
import { AdminFinanceQueryDto } from './dto/admin-finance-query.dto';
import {
  AdminFinanceAlertDto,
  AdminFinanceAuditEventDto,
  AdminFinanceExportJobDto,
  AdminFinanceNoteDto,
  AdminFinanceOverviewDto,
  AdminFinancePageMetaDto,
  AdminFinancePartnerExposureDto,
  AdminFinancePayoutAttemptDto,
  AdminFinancePayoutDetailDto,
  AdminFinancePayoutPageDto,
  AdminFinancePayoutRecordDto,
  AdminFinanceProviderEventDto,
  AdminFinanceReconciliationDetailDto,
  AdminFinanceReconciliationExceptionDto,
  AdminFinanceReconciliationPageDto,
  AdminFinanceRefundCaseDetailDto,
  AdminFinanceRefundCasePageDto,
  AdminFinanceRefundCaseRecordDto,
  AdminFinanceTransactionDetailDto,
  AdminFinanceTransactionPageDto,
  AdminFinanceTransactionRecordDto,
  AdminFinanceTrendPointDto,
} from './dto/admin-finance-response.dto';

export type AdminFinanceActor = {
  id?: string;
  email?: string;
  username?: string;
  role?: string;
} | null;

type DateRange = { start: Date; end: Date };

@Injectable()
export class AdminFinanceService {
  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
    @InjectRepository(PartnerPayoutTransaction)
    private readonly payoutTxnRepo: Repository<PartnerPayoutTransaction>,
    @InjectRepository(PartnerPayoutAttempt)
    private readonly payoutAttemptRepo: Repository<PartnerPayoutAttempt>,
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
    @InjectRepository(PartnerTransactionTimeline)
    private readonly timelineRepo: Repository<PartnerTransactionTimeline>,
    @InjectRepository(AdminFinanceNote)
    private readonly noteRepo: Repository<AdminFinanceNote>,
    @InjectRepository(AdminFinanceReconciliationException)
    private readonly reconRepo: Repository<AdminFinanceReconciliationException>,
    @InjectRepository(AdminFinanceExportJob)
    private readonly exportRepo: Repository<AdminFinanceExportJob>,
  ) {}

  async getSummary(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceOverviewDto> {
    const currency = query.currency ?? 'VND';
    const range = this.getDateRange(query);

    const txnQb = this.txnRepo
      .createQueryBuilder('txn')
      .leftJoin('txn.partner', 'partner')
      .where('txn.currency = :currency', { currency })
      .andWhere('txn.createdAt >= :start', { start: range.start })
      .andWhere('txn.createdAt <= :end', { end: range.end });
    this.applyTransactionFilters(txnQb, query);

    const txnAgg = await txnQb
      .select([
        `COALESCE(SUM(CASE WHEN txn.type = :chargeType THEN txn.gross_amount ELSE 0 END), 0) AS "grossVolume"`,
        `COALESCE(SUM(txn.gross_amount - txn.fee_amount), 0) AS "netRevenue"`,
        `COALESCE(SUM(txn.fee_amount), 0) AS "platformFeeRevenue"`,
        `COALESCE(SUM(CASE WHEN txn.status = :failedStatus THEN txn.gross_amount ELSE 0 END), 0) AS "failedPaymentAmount"`,
      ])
      .setParameters({
        chargeType: PartnerTransactionType.CHARGE,
        failedStatus: PartnerTransactionStatus.FAILED,
      })
      .getRawOne();

    const refundQb = this.refundCaseRepo
      .createQueryBuilder('rc')
      .leftJoin('rc.partner', 'partner')
      .where('rc.currency = :currency', { currency })
      .andWhere('rc.requestedAt >= :start', { start: range.start })
      .andWhere('rc.requestedAt <= :end', { end: range.end })
      .andWhere('rc.status IN (:...openStatuses)', {
        openStatuses: [
          PartnerRefundCaseStatus.PENDING,
          PartnerRefundCaseStatus.UNDER_REVIEW,
        ],
      });
    this.applyRefundFilters(refundQb, query);
    const refundAgg = await refundQb
      .select('COALESCE(SUM(rc.amount), 0)', 'refundExposure')
      .getRawOne();

    const payoutQb = this.payoutRepo
      .createQueryBuilder('p')
      .leftJoin('p.partner', 'partner')
      .where('p.currency = :currency', { currency })
      .andWhere('p.scheduledDate >= :start', { start: range.start })
      .andWhere('p.scheduledDate <= :end', { end: range.end });
    this.applyPayoutFilters(payoutQb, query);
    const payoutAgg = await payoutQb
      .select([
        `COALESCE(SUM(CASE WHEN p.status IN (:...pendingPayoutStatuses) THEN p.net_payout ELSE 0 END), 0) AS "pendingPayoutAmount"`,
        `COALESCE(SUM(CASE WHEN p.status = :heldStatus THEN p.net_payout ELSE 0 END), 0) AS "heldPayoutAmount"`,
      ])
      .setParameters({
        pendingPayoutStatuses: [
          PartnerPayoutStatus.NOT_ASSIGNED,
          PartnerPayoutStatus.IN_PAYOUT,
        ],
        heldStatus: PartnerPayoutStatus.HELD,
      })
      .getRawOne();

    const reconQb = this.reconRepo
      .createQueryBuilder('recon')
      .where('recon.currency = :currency', { currency })
      .andWhere('recon.detectedAt >= :start', { start: range.start })
      .andWhere('recon.detectedAt <= :end', { end: range.end })
      .andWhere('recon.status IN (:...openStatuses)', {
        openStatuses: [
          AdminFinanceReconciliationStatus.OPEN,
          AdminFinanceReconciliationStatus.UNDER_REVIEW,
          AdminFinanceReconciliationStatus.REOPENED,
        ],
      });
    this.applyReconciliationFilters(reconQb, query);
    const reconAgg = await reconQb
      .select('COALESCE(SUM(ABS(recon.difference)), 0)', 'unreconciledAmount')
      .getRawOne();

    const dto = new AdminFinanceOverviewDto();
    dto.grossVolume = Number(txnAgg?.grossVolume ?? 0);
    dto.netRevenue = Number(txnAgg?.netRevenue ?? 0);
    dto.platformFeeRevenue = Number(txnAgg?.platformFeeRevenue ?? 0);
    dto.refundExposure = Number(refundAgg?.refundExposure ?? 0);
    dto.failedPaymentAmount = Number(txnAgg?.failedPaymentAmount ?? 0);
    dto.pendingPayoutAmount = Number(payoutAgg?.pendingPayoutAmount ?? 0);
    dto.heldPayoutAmount = Number(payoutAgg?.heldPayoutAmount ?? 0);
    dto.unreconciledAmount = Number(reconAgg?.unreconciledAmount ?? 0);
    dto.currency = currency;
    return dto;
  }

  async getTrend(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceTrendPointDto[]> {
    const currency = query.currency ?? 'VND';
    const range = this.getDateRange(query);

    const txnQb = this.txnRepo
      .createQueryBuilder('txn')
      .leftJoin('txn.partner', 'partner')
      .where('txn.currency = :currency', { currency })
      .andWhere('txn.createdAt >= :start', { start: range.start })
      .andWhere('txn.createdAt <= :end', { end: range.end });
    this.applyTransactionFilters(txnQb, query);

    const txnRows = await txnQb
      .select([
        `to_char(date_trunc('day', txn.created_at), 'YYYY-MM-DD') AS "date"`,
        `COALESCE(SUM(CASE WHEN txn.type = :chargeType THEN txn.gross_amount ELSE 0 END), 0) AS "grossAmount"`,
        `COALESCE(SUM(txn.gross_amount - txn.fee_amount), 0) AS "netAmount"`,
        `COALESCE(SUM(CASE WHEN txn.type = :refundType THEN txn.gross_amount ELSE 0 END), 0) AS "refundAmount"`,
      ])
      .setParameters({
        chargeType: PartnerTransactionType.CHARGE,
        refundType: PartnerTransactionType.REFUND,
      })
      .groupBy(`date_trunc('day', txn.created_at)`)
      .orderBy(`date_trunc('day', txn.created_at)`, 'ASC')
      .getRawMany();

    const payoutQb = this.payoutRepo
      .createQueryBuilder('p')
      .leftJoin('p.partner', 'partner')
      .select([
        `to_char(date_trunc('day', p.scheduled_date), 'YYYY-MM-DD') AS "date"`,
        `COALESCE(SUM(p.net_payout), 0) AS "payoutAmount"`,
      ])
      .where('p.currency = :currency', { currency })
      .andWhere('p.scheduledDate >= :start', { start: range.start })
      .andWhere('p.scheduledDate <= :end', { end: range.end });
    this.applyPayoutFilters(payoutQb, query);
    const payoutRows = await payoutQb
      .groupBy(`date_trunc('day', p.scheduled_date)`)
      .getRawMany();

    const byDate = new Map<string, AdminFinanceTrendPointDto>();
    for (const row of txnRows) {
      const dto = new AdminFinanceTrendPointDto();
      dto.date = row.date;
      dto.grossAmount = Number(row.grossAmount ?? 0);
      dto.netAmount = Number(row.netAmount ?? 0);
      dto.refundAmount = Number(row.refundAmount ?? 0);
      dto.payoutAmount = 0;
      byDate.set(dto.date, dto);
    }

    for (const row of payoutRows) {
      const date = row.date;
      const dto = byDate.get(date) ?? new AdminFinanceTrendPointDto();
      dto.date = date;
      dto.grossAmount ??= 0;
      dto.netAmount ??= 0;
      dto.refundAmount ??= 0;
      dto.payoutAmount = Number(row.payoutAmount ?? 0);
      byDate.set(date, dto);
    }

    return Array.from(byDate.values()).sort((a, b) =>
      a.date.localeCompare(b.date),
    );
  }

  async getAlerts(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceAlertDto[]> {
    const overview = await this.getSummary(query);
    const now = new Date().toISOString();
    const alerts: AdminFinanceAlertDto[] = [];

    if (overview.failedPaymentAmount > 0) {
      alerts.push(
        this.alert(
          'failed-payments',
          'Failed payments detected',
          `${overview.failedPaymentAmount} ${overview.currency} requires review.`,
          AdminFinanceRiskTone.CRITICAL,
          now,
        ),
      );
    }
    if (overview.heldPayoutAmount > 0) {
      alerts.push(
        this.alert(
          'held-payouts',
          'Payouts are on hold',
          `${overview.heldPayoutAmount} ${overview.currency} is currently held.`,
          AdminFinanceRiskTone.WARNING,
          now,
        ),
      );
    }
    if (overview.unreconciledAmount > 0) {
      alerts.push(
        this.alert(
          'reconciliation',
          'Open reconciliation exceptions',
          `${overview.unreconciledAmount} ${overview.currency} is unreconciled.`,
          AdminFinanceRiskTone.WARNING,
          now,
        ),
      );
    }
    if (overview.platformFeeRevenue > 0) {
      alerts.push(
        this.alert(
          'fee-revenue',
          'Platform fee revenue updated',
          `${overview.platformFeeRevenue} ${overview.currency} booked for the selected period.`,
          AdminFinanceRiskTone.POSITIVE,
          now,
        ),
      );
    }

    return alerts;
  }

  async listTransactions(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceTransactionPageDto> {
    const { page, limit } = this.getPage(query);
    const qb = this.txnRepo
      .createQueryBuilder('txn')
      .leftJoinAndSelect('txn.partner', 'partner')
      .leftJoinAndSelect('txn.timelineEvents', 'timeline');
    this.applyTransactionFilters(qb, query);
    qb.orderBy('txn.createdAt', 'DESC')
      .addOrderBy('txn.id', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();
    const noteCounts = await this.countNotes(
      AdminFinanceNoteEntityType.TRANSACTION,
      items.map((item) => item.id),
    );
    const dto = new AdminFinanceTransactionPageDto();
    dto.data = items.map((item) => this.mapTransactionRecord(item, noteCounts));
    dto.meta = AdminFinancePageMetaDto.create(total, page, limit);
    return dto;
  }

  async getTransactionDetail(
    id: string,
  ): Promise<AdminFinanceTransactionDetailDto> {
    const transaction = await this.txnRepo.findOne({
      where: { id },
      relations: { partner: true, timelineEvents: true },
    });
    if (!transaction) {
      throw new NotFoundException('Transaction not found');
    }

    const refunds = await this.refundCaseRepo.find({
      where: { transactionId: id },
      relations: { partner: true, transaction: true },
      order: { requestedAt: 'DESC' },
    });
    const noteCounts = await this.countNotes(
      AdminFinanceNoteEntityType.TRANSACTION,
      [id],
    );
    const notes = await this.getNotes(
      AdminFinanceNoteEntityType.TRANSACTION,
      id,
    );

    const dto = new AdminFinanceTransactionDetailDto();
    dto.record = this.mapTransactionRecord(transaction, noteCounts);
    dto.providerEvents = (transaction.timelineEvents ?? []).map((event) =>
      this.mapProviderEvent(event, transaction.paymentMethodLabel),
    );
    dto.auditTrail = this.timelineToAudit(
      transaction.timelineEvents ?? [],
      notes,
    );
    dto.notes = this.mapNotes(notes, transaction.notes);
    dto.relatedRefundCases = refunds.map((refund) =>
      this.mapRefundCaseRecord(refund),
    );
    return dto;
  }

  async markSettlement(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceSettlementActionDto,
  ): Promise<AdminFinanceTransactionRecordDto> {
    if (!dto.note?.trim()) {
      throw new BadRequestException('Settlement note is required');
    }
    const transaction = await this.loadTransactionOrThrow(id);
    transaction.settlementStatus = dto.settlementStatus;
    await this.txnRepo.save(transaction);
    await this.addTimeline(
      transaction,
      `Settlement marked ${dto.settlementStatus}`,
      dto.note,
      actor,
    );
    await this.createNote(
      actor,
      AdminFinanceNoteEntityType.TRANSACTION,
      id,
      dto.note,
    );
    return this.mapTransactionRecord(
      transaction,
      await this.countNotes(AdminFinanceNoteEntityType.TRANSACTION, [id]),
    );
  }

  async flagTransaction(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceReviewFlagActionDto,
  ): Promise<AdminFinanceTransactionRecordDto> {
    const transaction = await this.loadTransactionOrThrow(id);
    transaction.flaggedForReview = dto.flagged;
    await this.txnRepo.save(transaction);
    const description =
      dto.note?.trim() ||
      (dto.flagged
        ? 'Flagged for admin finance review'
        : 'Review flag cleared');
    await this.addTimeline(
      transaction,
      dto.flagged ? 'Review flag added' : 'Review flag cleared',
      description,
      actor,
    );
    if (dto.note?.trim()) {
      await this.createNote(
        actor,
        AdminFinanceNoteEntityType.TRANSACTION,
        id,
        dto.note,
      );
    }
    return this.mapTransactionRecord(
      transaction,
      await this.countNotes(AdminFinanceNoteEntityType.TRANSACTION, [id]),
    );
  }

  async listPayouts(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinancePayoutPageDto> {
    const { page, limit } = this.getPage(query);
    const qb = this.payoutRepo
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.partner', 'partner');
    this.applyPayoutFilters(qb, query);
    qb.orderBy('p.scheduledDate', 'DESC')
      .addOrderBy('p.id', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();
    const noteCounts = await this.countNotes(
      AdminFinanceNoteEntityType.PAYOUT,
      items.map((item) => item.id),
    );
    const dto = new AdminFinancePayoutPageDto();
    dto.data = items.map((item) => this.mapPayoutRecord(item, noteCounts));
    dto.meta = AdminFinancePageMetaDto.create(total, page, limit);
    return dto;
  }

  async getPayoutDetail(id: string): Promise<AdminFinancePayoutDetailDto> {
    const payout = await this.payoutRepo.findOne({
      where: { id },
      relations: { partner: true, attempts: true },
    });
    if (!payout) {
      throw new NotFoundException('Payout not found');
    }
    const links = await this.payoutTxnRepo.find({ where: { payoutId: id } });
    const txns = links.length
      ? await this.txnRepo.find({
          where: { id: In(links.map((link) => link.transactionId)) },
          relations: { partner: true, timelineEvents: true },
        })
      : [];
    const notes = await this.getNotes(AdminFinanceNoteEntityType.PAYOUT, id);
    const noteCounts = await this.countNotes(
      AdminFinanceNoteEntityType.PAYOUT,
      [id],
    );

    const dto = new AdminFinancePayoutDetailDto();
    dto.record = this.mapPayoutRecord(payout, noteCounts);
    dto.includedTransactions = txns.map((txn) =>
      this.mapTransactionRecord(txn),
    );
    dto.attempts = (payout.attempts ?? [])
      .sort((a, b) => a.attemptNumber - b.attemptNumber)
      .map((attempt) => this.mapPayoutAttempt(attempt));
    dto.maskedDestination = payout.maskedDestination ?? payout.methodLabel;
    dto.auditTrail = this.payoutAttemptsToAudit(
      payout,
      payout.attempts ?? [],
      notes,
    );
    dto.notes = this.mapNotes(notes);
    return dto;
  }

  async retryPayout(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    const payout = await this.loadPayoutOrThrow(id);
    const attemptNumber = Number(payout.attemptCount ?? 0) + 1;
    payout.status = PartnerPayoutStatus.IN_PAYOUT;
    payout.attemptCount = attemptNumber;
    payout.failureReason = null;
    payout.holdReason = null;
    await this.payoutRepo.save(payout);
    await this.payoutAttemptRepo.save(
      this.payoutAttemptRepo.create({
        payoutId: id,
        partnerId: payout.partnerId,
        attemptNumber,
        attemptedAt: new Date(),
        status: PartnerPayoutStatus.IN_PAYOUT,
        failureReason: null,
      }),
    );
    if (dto.note?.trim()) {
      await this.createNote(
        actor,
        AdminFinanceNoteEntityType.PAYOUT,
        id,
        dto.note,
      );
    }
    return this.getPayoutDetail(id);
  }

  async holdPayout(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    const payout = await this.loadPayoutOrThrow(id);
    payout.status = PartnerPayoutStatus.HELD;
    payout.holdReason = dto.note;
    await this.payoutRepo.save(payout);
    await this.createNote(
      actor,
      AdminFinanceNoteEntityType.PAYOUT,
      id,
      dto.note,
    );
    return this.getPayoutDetail(id);
  }

  async releasePayoutHold(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    const payout = await this.loadPayoutOrThrow(id);
    payout.status = PartnerPayoutStatus.NOT_ASSIGNED;
    payout.holdReason = null;
    await this.payoutRepo.save(payout);
    if (dto.note?.trim()) {
      await this.createNote(
        actor,
        AdminFinanceNoteEntityType.PAYOUT,
        id,
        dto.note,
      );
    }
    return this.getPayoutDetail(id);
  }

  async listRefundCases(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceRefundCasePageDto> {
    const { page, limit } = this.getPage(query);
    const qb = this.refundCaseRepo
      .createQueryBuilder('rc')
      .leftJoinAndSelect('rc.partner', 'partner')
      .leftJoinAndSelect('rc.transaction', 'txn');
    this.applyRefundFilters(qb, query);
    qb.orderBy('rc.requestedAt', 'DESC')
      .addOrderBy('rc.id', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();
    const dto = new AdminFinanceRefundCasePageDto();
    dto.data = items.map((item) => this.mapRefundCaseRecord(item));
    dto.meta = AdminFinancePageMetaDto.create(total, page, limit);
    return dto;
  }

  async getRefundCaseDetail(
    id: string,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    const refundCase = await this.refundCaseRepo.findOne({
      where: { id },
      relations: { partner: true, transaction: true },
    });
    if (!refundCase) {
      throw new NotFoundException('Refund case not found');
    }
    const notes = await this.getNotes(
      AdminFinanceNoteEntityType.REFUND_CASE,
      id,
    );
    const dto = new AdminFinanceRefundCaseDetailDto();
    dto.record = this.mapRefundCaseRecord(refundCase);
    dto.customerRequest = refundCase.customerRequest ?? refundCase.reason ?? '';
    dto.partnerResponse = refundCase.partnerResponse ?? '';
    dto.evidenceLinks = refundCase.evidenceLinks ?? [];
    dto.decisionNote = refundCase.decisionNote ?? '';
    dto.auditTrail = this.notesToAudit(notes);
    dto.notes = this.mapNotes(notes);
    return dto;
  }

  async approveRefundCase(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    const refundCase = await this.loadRefundCaseOrThrow(id);
    refundCase.status = PartnerRefundCaseStatus.APPROVED;
    refundCase.decisionNote = dto.note?.trim() || refundCase.decisionNote;
    await this.refundCaseRepo.save(refundCase);
    if (dto.note?.trim()) {
      await this.createNote(
        actor,
        AdminFinanceNoteEntityType.REFUND_CASE,
        id,
        dto.note,
      );
    }
    return this.getRefundCaseDetail(id);
  }

  async rejectRefundCase(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    const refundCase = await this.loadRefundCaseOrThrow(id);
    refundCase.status = PartnerRefundCaseStatus.REJECTED;
    refundCase.decisionNote = dto.note;
    await this.refundCaseRepo.save(refundCase);
    await this.createNote(
      actor,
      AdminFinanceNoteEntityType.REFUND_CASE,
      id,
      dto.note,
    );
    return this.getRefundCaseDetail(id);
  }

  async listReconciliation(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceReconciliationPageDto> {
    const { page, limit } = this.getPage(query);
    const qb = this.reconRepo.createQueryBuilder('recon');
    this.applyReconciliationFilters(qb, query);
    qb.orderBy('recon.detectedAt', 'DESC')
      .addOrderBy('recon.id', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();
    const dto = new AdminFinanceReconciliationPageDto();
    dto.data = items.map((item) => this.mapReconciliation(item));
    dto.meta = AdminFinancePageMetaDto.create(total, page, limit);
    return dto;
  }

  async getReconciliationDetail(
    id: string,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    const recon = await this.reconRepo.findOne({ where: { id } });
    if (!recon) {
      throw new NotFoundException('Reconciliation exception not found');
    }
    const notes = await this.getNotes(
      AdminFinanceNoteEntityType.RECONCILIATION,
      id,
    );
    const dto = new AdminFinanceReconciliationDetailDto();
    dto.exception = this.mapReconciliation(recon);
    dto.providerEventContext = recon.providerEventContext ?? '';
    dto.ledgerContext = recon.ledgerContext ?? '';
    dto.resolutionNotes = recon.resolutionNotes ?? '';
    dto.auditTrail = this.notesToAudit(notes);
    dto.notes = this.mapNotes(notes);
    return dto;
  }

  async resolveReconciliation(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    const recon = await this.loadReconciliationOrThrow(id);
    recon.status = AdminFinanceReconciliationStatus.RESOLVED;
    recon.resolutionNotes = dto.note;
    await this.reconRepo.save(recon);
    await this.createNote(
      actor,
      AdminFinanceNoteEntityType.RECONCILIATION,
      id,
      dto.note,
    );
    return this.getReconciliationDetail(id);
  }

  async reopenReconciliation(
    actor: AdminFinanceActor,
    id: string,
    dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    const recon = await this.loadReconciliationOrThrow(id);
    recon.status = AdminFinanceReconciliationStatus.REOPENED;
    if (dto.note?.trim()) {
      recon.resolutionNotes = dto.note;
    }
    await this.reconRepo.save(recon);
    if (dto.note?.trim()) {
      await this.createNote(
        actor,
        AdminFinanceNoteEntityType.RECONCILIATION,
        id,
        dto.note,
      );
    }
    return this.getReconciliationDetail(id);
  }

  async getPartnerExposure(
    query: AdminFinanceQueryDto,
  ): Promise<AdminFinancePartnerExposureDto[]> {
    const currency = query.currency ?? 'VND';
    const range = this.getDateRange(query);
    const rows = await this.txnRepo
      .createQueryBuilder('txn')
      .leftJoin('txn.partner', 'partner')
      .select([
        'txn.partner_id AS "partnerId"',
        'partner.brand_name AS "partnerName"',
        `COALESCE(SUM(CASE WHEN txn.type = :chargeType THEN txn.gross_amount ELSE 0 END), 0) AS "totalVolume"`,
        `COALESCE(SUM(CASE WHEN txn.payout_status IN (:...pendingPayoutStatuses) THEN txn.gross_amount - txn.fee_amount ELSE 0 END), 0) AS "pendingPayouts"`,
        `COALESCE(SUM(CASE WHEN txn.status = :failedStatus THEN txn.gross_amount ELSE 0 END), 0) AS "failedPayments"`,
        `COALESCE(SUM(CASE WHEN txn.payout_status = :heldStatus THEN txn.gross_amount - txn.fee_amount ELSE 0 END), 0) AS "heldFunds"`,
      ])
      .where('txn.currency = :currency', { currency })
      .andWhere('txn.createdAt >= :start', { start: range.start })
      .andWhere('txn.createdAt <= :end', { end: range.end })
      .andWhere(query.partnerId ? 'txn.partnerId = :partnerId' : '1=1', {
        partnerId: query.partnerId,
      })
      .setParameters({
        chargeType: PartnerTransactionType.CHARGE,
        failedStatus: PartnerTransactionStatus.FAILED,
        heldStatus: PartnerPayoutStatus.HELD,
        pendingPayoutStatuses: [
          PartnerPayoutStatus.NOT_ASSIGNED,
          PartnerPayoutStatus.IN_PAYOUT,
        ],
      })
      .groupBy('txn.partner_id')
      .addGroupBy('partner.brand_name')
      .orderBy('"heldFunds"', 'DESC')
      .addOrderBy('"failedPayments"', 'DESC')
      .limit(25)
      .getRawMany();

    const partnerIds = rows.map((row) => row.partnerId).filter(Boolean);
    const refundExposure = await this.getRefundExposureByPartner(
      partnerIds,
      currency,
      range,
    );

    return rows.map((row) => {
      const dto = new AdminFinancePartnerExposureDto();
      dto.partnerId = row.partnerId;
      dto.partnerName = row.partnerName ?? 'Unknown Partner';
      dto.totalVolume = Number(row.totalVolume ?? 0);
      dto.pendingPayouts = Number(row.pendingPayouts ?? 0);
      dto.refundExposure = refundExposure.get(row.partnerId) ?? 0;
      dto.failedPayments = Number(row.failedPayments ?? 0);
      dto.heldFunds = Number(row.heldFunds ?? 0);
      dto.currency = currency;
      dto.riskTone =
        dto.heldFunds > 0 || dto.failedPayments > 0
          ? AdminFinanceRiskTone.CRITICAL
          : dto.refundExposure > 0
            ? AdminFinanceRiskTone.WARNING
            : AdminFinanceRiskTone.NEUTRAL;
      return dto;
    });
  }

  async getExports(): Promise<AdminFinanceExportJobDto[]> {
    const jobs = await this.exportRepo.find({
      order: { createdAt: 'DESC' },
      take: 50,
    });
    return jobs.map((job) => this.mapExportJob(job));
  }

  async createExport(
    actor: AdminFinanceActor,
    dto: AdminFinanceCreateExportDto,
  ): Promise<AdminFinanceExportJobDto> {
    const job = await this.exportRepo.save(
      this.exportRepo.create({
        type: dto.type,
        requestedByAccountId: actor?.id ?? null,
        requestedByName: this.actorName(actor),
        status: AdminFinanceExportStatus.QUEUED,
        rowCount: 0,
        downloadUrl: null,
        expiresAt: null,
      }),
    );
    return this.mapExportJob(job);
  }

  async addNote(
    actor: AdminFinanceActor,
    dto: AdminFinanceCreateNoteDto,
  ): Promise<AdminFinanceNoteDto> {
    const note = await this.createNote(
      actor,
      dto.entityType,
      dto.entityId,
      dto.content,
    );
    return this.mapNote(note);
  }

  private applyTransactionFilters(
    qb: SelectQueryBuilder<PartnerLedgerTransaction>,
    query: AdminFinanceQueryDto,
  ) {
    if (query.search) {
      qb.andWhere(
        '(txn.id::text ILIKE :search OR txn.reference ILIKE :search OR txn.customer_name_snapshot ILIKE :search OR txn.source_title_snapshot ILIKE :search OR partner.brand_name ILIKE :search)',
        { search: `%${query.search}%` },
      );
    }
    if (query.startDate) {
      qb.andWhere('txn.createdAt >= :startDate', {
        startDate: this.startOfDay(query.startDate),
      });
    }
    if (query.endDate) {
      qb.andWhere('txn.createdAt <= :endDate', {
        endDate: this.endOfDay(query.endDate),
      });
    }
    if (query.partnerId)
      qb.andWhere('txn.partnerId = :partnerId', { partnerId: query.partnerId });
    if (query.customerId)
      qb.andWhere('txn.sourceId = :customerId', {
        customerId: query.customerId,
      });
    if (query.sourceType)
      qb.andWhere('txn.sourceType = :sourceType', {
        sourceType: query.sourceType,
      });
    if (query.transactionType)
      qb.andWhere('txn.type = :transactionType', {
        transactionType: query.transactionType,
      });
    if (query.transactionStatus)
      qb.andWhere('txn.status = :transactionStatus', {
        transactionStatus: query.transactionStatus,
      });
    if (query.settlementStatus)
      qb.andWhere('txn.settlementStatus = :settlementStatus', {
        settlementStatus: query.settlementStatus,
      });
    if (query.payoutStatus)
      qb.andWhere('txn.payoutStatus = :payoutStatus', {
        payoutStatus: query.payoutStatus,
      });
    if (query.currency)
      qb.andWhere('txn.currency = :filterCurrency', {
        filterCurrency: query.currency,
      });
    if (query.minAmount !== undefined)
      qb.andWhere('txn.grossAmount >= :minAmount', {
        minAmount: query.minAmount,
      });
    if (query.maxAmount !== undefined)
      qb.andWhere('txn.grossAmount <= :maxAmount', {
        maxAmount: query.maxAmount,
      });
    if (query.onlyFlagged) qb.andWhere('txn.flaggedForReview = true');
    if (query.provider) {
      qb.andWhere(
        'LOWER(COALESCE(txn.payment_method_label, :manual)) LIKE :provider',
        {
          manual: 'manual',
          provider: `%${this.providerSearchTerm(query.provider)}%`,
        },
      );
    }
  }

  private applyPayoutFilters(
    qb: SelectQueryBuilder<PartnerPayout>,
    query: AdminFinanceQueryDto,
  ) {
    if (query.search) {
      qb.andWhere(
        '(p.id::text ILIKE :search OR p.method_label ILIKE :search OR partner.brand_name ILIKE :search)',
        {
          search: `%${query.search}%`,
        },
      );
    }
    if (query.startDate)
      qb.andWhere('p.scheduledDate >= :startDate', {
        startDate: this.startOfDay(query.startDate),
      });
    if (query.endDate)
      qb.andWhere('p.scheduledDate <= :endDate', {
        endDate: this.endOfDay(query.endDate),
      });
    if (query.partnerId)
      qb.andWhere('p.partnerId = :partnerId', { partnerId: query.partnerId });
    if (query.payoutStatus)
      qb.andWhere('p.status = :payoutStatus', {
        payoutStatus: query.payoutStatus,
      });
    if (query.currency)
      qb.andWhere('p.currency = :filterCurrency', {
        filterCurrency: query.currency,
      });
    if (query.minAmount !== undefined)
      qb.andWhere('p.netPayout >= :minAmount', { minAmount: query.minAmount });
    if (query.maxAmount !== undefined)
      qb.andWhere('p.netPayout <= :maxAmount', { maxAmount: query.maxAmount });
    if (query.provider) {
      qb.andWhere('LOWER(COALESCE(p.method_label, :manual)) LIKE :provider', {
        manual: 'manual',
        provider: `%${this.providerSearchTerm(query.provider)}%`,
      });
    }
  }

  private applyRefundFilters(
    qb: SelectQueryBuilder<PartnerRefundCase>,
    query: AdminFinanceQueryDto,
  ) {
    if (query.search) {
      qb.andWhere(
        '(rc.id::text ILIKE :search OR rc.reason ILIKE :search OR rc.owner ILIKE :search OR partner.brand_name ILIKE :search)',
        {
          search: `%${query.search}%`,
        },
      );
    }
    if (query.startDate)
      qb.andWhere('rc.requestedAt >= :startDate', {
        startDate: this.startOfDay(query.startDate),
      });
    if (query.endDate)
      qb.andWhere('rc.requestedAt <= :endDate', {
        endDate: this.endOfDay(query.endDate),
      });
    if (query.partnerId)
      qb.andWhere('rc.partnerId = :partnerId', { partnerId: query.partnerId });
    if (query.refundCaseStatus)
      qb.andWhere('rc.status = :refundCaseStatus', {
        refundCaseStatus: query.refundCaseStatus,
      });
    if (query.refundCaseType)
      qb.andWhere('rc.caseType = :refundCaseType', {
        refundCaseType: query.refundCaseType,
      });
    if (query.currency)
      qb.andWhere('rc.currency = :filterCurrency', {
        filterCurrency: query.currency,
      });
    if (query.minAmount !== undefined)
      qb.andWhere('rc.amount >= :minAmount', { minAmount: query.minAmount });
    if (query.maxAmount !== undefined)
      qb.andWhere('rc.amount <= :maxAmount', { maxAmount: query.maxAmount });
    if (query.onlySlaBreached)
      qb.andWhere('rc.slaDueAt < :now', { now: new Date() });
  }

  private applyReconciliationFilters(
    qb: SelectQueryBuilder<AdminFinanceReconciliationException>,
    query: AdminFinanceQueryDto,
  ) {
    if (query.search) {
      qb.andWhere(
        '(recon.id::text ILIKE :search OR recon.provider_event_id ILIKE :search OR recon.summary ILIKE :search OR recon.owner ILIKE :search)',
        {
          search: `%${query.search}%`,
        },
      );
    }
    if (query.startDate)
      qb.andWhere('recon.detectedAt >= :startDate', {
        startDate: this.startOfDay(query.startDate),
      });
    if (query.endDate)
      qb.andWhere('recon.detectedAt <= :endDate', {
        endDate: this.endOfDay(query.endDate),
      });
    if (query.provider)
      qb.andWhere('recon.provider = :provider', { provider: query.provider });
    if (query.reconciliationStatus)
      qb.andWhere('recon.status = :status', {
        status: query.reconciliationStatus,
      });
    if (query.currency)
      qb.andWhere('recon.currency = :filterCurrency', {
        filterCurrency: query.currency,
      });
    if (query.minAmount !== undefined)
      qb.andWhere('ABS(recon.difference) >= :minAmount', {
        minAmount: query.minAmount,
      });
    if (query.maxAmount !== undefined)
      qb.andWhere('ABS(recon.difference) <= :maxAmount', {
        maxAmount: query.maxAmount,
      });
  }

  private async loadTransactionOrThrow(
    id: string,
  ): Promise<PartnerLedgerTransaction> {
    const transaction = await this.txnRepo.findOne({
      where: { id },
      relations: { partner: true, timelineEvents: true },
    });
    if (!transaction) throw new NotFoundException('Transaction not found');
    return transaction;
  }

  private async loadPayoutOrThrow(id: string): Promise<PartnerPayout> {
    const payout = await this.payoutRepo.findOne({
      where: { id },
      relations: { partner: true, attempts: true },
    });
    if (!payout) throw new NotFoundException('Payout not found');
    return payout;
  }

  private async loadRefundCaseOrThrow(id: string): Promise<PartnerRefundCase> {
    const refundCase = await this.refundCaseRepo.findOne({
      where: { id },
      relations: { partner: true, transaction: true },
    });
    if (!refundCase) throw new NotFoundException('Refund case not found');
    return refundCase;
  }

  private async loadReconciliationOrThrow(
    id: string,
  ): Promise<AdminFinanceReconciliationException> {
    const recon = await this.reconRepo.findOne({ where: { id } });
    if (!recon)
      throw new NotFoundException('Reconciliation exception not found');
    return recon;
  }

  private mapTransactionRecord(
    entity: PartnerLedgerTransaction,
    noteCounts = new Map<string, number>(),
  ): AdminFinanceTransactionRecordDto {
    const dto = new AdminFinanceTransactionRecordDto();
    dto.id = entity.id;
    dto.createdAt = entity.createdAt?.toISOString();
    dto.reference = entity.reference;
    dto.partnerName = entity.partner?.brandName ?? 'Unknown Partner';
    dto.customerName = entity.customerNameSnapshot;
    dto.sourceType = entity.sourceType;
    dto.type = entity.type;
    dto.grossAmount = Number(entity.grossAmount);
    dto.feeAmount = Number(entity.feeAmount);
    dto.netAmount = dto.grossAmount - dto.feeAmount;
    dto.currency = entity.currency;
    dto.transactionStatus = entity.status;
    dto.settlementStatus = entity.settlementStatus;
    dto.payoutStatus = entity.payoutStatus;
    dto.provider = this.providerFromLabel(entity.paymentMethodLabel);
    dto.isFlagged = entity.flaggedForReview;
    dto.notesCount = (noteCounts.get(entity.id) ?? 0) + (entity.notes ? 1 : 0);
    dto.payoutId = entity.payoutId ?? null;
    return dto;
  }

  private mapPayoutRecord(
    entity: PartnerPayout,
    noteCounts = new Map<string, number>(),
  ): AdminFinancePayoutRecordDto {
    const dto = new AdminFinancePayoutRecordDto();
    dto.id = entity.id;
    dto.scheduledDate = entity.scheduledDate?.toISOString();
    dto.partnerName = entity.partner?.brandName ?? 'Unknown Partner';
    dto.periodLabel = `${this.formatDate(entity.periodStart)} - ${this.formatDate(entity.periodEnd)}`;
    dto.includedVolume = Number(entity.includedVolume);
    dto.feesAndAdjustments = Number(entity.feesAdjustments);
    dto.netPayout = Number(entity.netPayout);
    dto.currency = entity.currency;
    dto.method = entity.methodLabel;
    dto.status = entity.status;
    dto.attemptCount = Number(entity.attemptCount ?? 0);
    dto.notesCount = noteCounts.get(entity.id) ?? 0;
    dto.failureReason = entity.failureReason ?? null;
    dto.holdReason = entity.holdReason ?? null;
    return dto;
  }

  private mapPayoutAttempt(
    entity: PartnerPayoutAttempt,
  ): AdminFinancePayoutAttemptDto {
    const dto = new AdminFinancePayoutAttemptDto();
    dto.attemptNumber = entity.attemptNumber;
    dto.attemptedAt = entity.attemptedAt?.toISOString();
    dto.status = entity.status;
    dto.failureReason = entity.failureReason ?? null;
    return dto;
  }

  private mapRefundCaseRecord(
    entity: PartnerRefundCase,
  ): AdminFinanceRefundCaseRecordDto {
    const now = new Date();
    const slaHours = entity.slaDueAt
      ? Math.max(
          0,
          Math.ceil(
            (entity.slaDueAt.getTime() - entity.requestedAt.getTime()) /
              3600000,
          ),
        )
      : 0;
    const slaBreached =
      !!entity.slaDueAt &&
      entity.slaDueAt < now &&
      ![
        PartnerRefundCaseStatus.APPROVED,
        PartnerRefundCaseStatus.REJECTED,
      ].includes(entity.status);
    const dto = new AdminFinanceRefundCaseRecordDto();
    dto.id = entity.id;
    dto.requestedAt = entity.requestedAt?.toISOString();
    dto.transactionId = entity.transactionId;
    dto.partnerName = entity.partner?.brandName ?? 'Unknown Partner';
    dto.customerName = entity.transaction?.customerNameSnapshot ?? '';
    dto.caseType = entity.caseType;
    dto.amount = Number(entity.amount);
    dto.currency = entity.currency;
    dto.reason = entity.reason ?? '';
    dto.owner = entity.owner;
    dto.status = entity.status;
    dto.slaHours = slaHours;
    dto.slaBreached = slaBreached;
    dto.riskTone = slaBreached
      ? AdminFinanceRiskTone.CRITICAL
      : AdminFinanceRiskTone.WARNING;
    return dto;
  }

  private mapReconciliation(
    entity: AdminFinanceReconciliationException,
  ): AdminFinanceReconciliationExceptionDto {
    const dto = new AdminFinanceReconciliationExceptionDto();
    dto.id = entity.id;
    dto.detectedAt = entity.detectedAt?.toISOString();
    dto.provider = entity.provider;
    dto.providerEventId = entity.providerEventId;
    dto.relatedTransactionId = entity.relatedTransactionId ?? null;
    dto.expectedAmount = Number(entity.expectedAmount);
    dto.providerAmount = Number(entity.providerAmount);
    dto.difference = Number(entity.difference);
    dto.currency = entity.currency;
    dto.type = entity.type;
    dto.status = entity.status;
    dto.owner = entity.owner;
    dto.summary = entity.summary;
    return dto;
  }

  private mapExportJob(
    entity: AdminFinanceExportJob,
  ): AdminFinanceExportJobDto {
    const dto = new AdminFinanceExportJobDto();
    dto.id = entity.id;
    dto.createdAt = entity.createdAt?.toISOString();
    dto.type = entity.type;
    dto.requestedBy = entity.requestedByName ?? 'System';
    dto.status = entity.status;
    dto.rowCount = entity.rowCount;
    dto.downloadUrl = entity.downloadUrl ?? null;
    dto.expiresAt = entity.expiresAt?.toISOString() ?? null;
    return dto;
  }

  private mapProviderEvent(
    event: PartnerTransactionTimeline,
    providerLabel: string | null,
  ): AdminFinanceProviderEventDto {
    const dto = new AdminFinanceProviderEventDto();
    dto.id = event.id;
    dto.eventType = event.title;
    dto.provider = this.providerFromLabel(providerLabel);
    dto.occurredAt = event.occurredAt?.toISOString();
    dto.detail = event.description ?? '';
    dto.rawPayload = JSON.stringify(event.metadata ?? {});
    return dto;
  }

  private timelineToAudit(
    events: PartnerTransactionTimeline[],
    notes: AdminFinanceNote[],
  ): AdminFinanceAuditEventDto[] {
    return [
      ...events.map((event) => {
        const dto = new AdminFinanceAuditEventDto();
        dto.id = event.id;
        dto.label = event.title;
        dto.detail = event.description ?? '';
        dto.performedBy = event.actorAccountId ? 'Admin' : 'System';
        dto.occurredAt = event.occurredAt?.toISOString();
        dto.isError = /fail|error|reject/i.test(
          `${event.title} ${event.description ?? ''}`,
        );
        return dto;
      }),
      ...this.notesToAudit(notes),
    ].sort((a, b) => a.occurredAt.localeCompare(b.occurredAt));
  }

  private payoutAttemptsToAudit(
    payout: PartnerPayout,
    attempts: PartnerPayoutAttempt[],
    notes: AdminFinanceNote[],
  ): AdminFinanceAuditEventDto[] {
    const created = new AdminFinanceAuditEventDto();
    created.id = payout.id;
    created.label = 'Payout created';
    created.detail = payout.methodLabel;
    created.performedBy = 'System';
    created.occurredAt = payout.createdAt?.toISOString();
    created.isError = false;
    return [
      created,
      ...attempts.map((attempt) => {
        const dto = new AdminFinanceAuditEventDto();
        dto.id = attempt.id;
        dto.label = `Payout attempt #${attempt.attemptNumber}`;
        dto.detail = attempt.failureReason ?? attempt.status;
        dto.performedBy = 'Admin';
        dto.occurredAt = attempt.attemptedAt?.toISOString();
        dto.isError = attempt.status === PartnerPayoutStatus.FAILED;
        return dto;
      }),
      ...this.notesToAudit(notes),
    ].sort((a, b) => a.occurredAt.localeCompare(b.occurredAt));
  }

  private notesToAudit(notes: AdminFinanceNote[]): AdminFinanceAuditEventDto[] {
    return notes.map((note) => {
      const dto = new AdminFinanceAuditEventDto();
      dto.id = note.id;
      dto.label = 'Admin note added';
      dto.detail = note.content;
      dto.performedBy = note.createdByName ?? 'Admin';
      dto.occurredAt = note.createdAt?.toISOString();
      dto.isError = false;
      return dto;
    });
  }

  private async addTimeline(
    transaction: PartnerLedgerTransaction,
    title: string,
    description: string,
    actor: AdminFinanceActor,
  ) {
    await this.timelineRepo.save(
      this.timelineRepo.create({
        transactionId: transaction.id,
        partnerId: transaction.partnerId,
        title,
        description,
        occurredAt: new Date(),
        actorAccountId: actor?.id ?? null,
        metadata: { adminFinance: true },
      }),
    );
  }

  private async createNote(
    actor: AdminFinanceActor,
    entityType: AdminFinanceNoteEntityType,
    entityId: string,
    content: string,
  ): Promise<AdminFinanceNote> {
    return this.noteRepo.save(
      this.noteRepo.create({
        entityType,
        entityId,
        content,
        createdByAccountId: actor?.id ?? null,
        createdByName: this.actorName(actor),
      }),
    );
  }

  private async countNotes(
    entityType: AdminFinanceNoteEntityType,
    entityIds: string[],
  ): Promise<Map<string, number>> {
    if (!entityIds.length) return new Map();
    const rows = await this.noteRepo
      .createQueryBuilder('note')
      .select('note.entityId', 'entityId')
      .addSelect('COUNT(note.id)', 'count')
      .where('note.entityType = :entityType', { entityType })
      .andWhere('note.entityId IN (:...entityIds)', { entityIds })
      .groupBy('note.entityId')
      .getRawMany();
    return new Map(rows.map((row) => [row.entityId, Number(row.count)]));
  }

  private async getNotes(
    entityType: AdminFinanceNoteEntityType,
    entityId: string,
  ): Promise<AdminFinanceNote[]> {
    return this.noteRepo.find({
      where: { entityType, entityId },
      order: { createdAt: 'ASC' },
    });
  }

  private mapNotes(
    notes: AdminFinanceNote[],
    legacyNote?: string | null,
  ): AdminFinanceNoteDto[] {
    const mapped = notes.map((note) => this.mapNote(note));
    if (legacyNote) {
      const dto = new AdminFinanceNoteDto();
      dto.id = `legacy-${mapped.length}`;
      dto.content = legacyNote;
      dto.createdBy = 'System';
      dto.createdAt = new Date(0).toISOString();
      return [dto, ...mapped];
    }
    return mapped;
  }

  private mapNote(entity: AdminFinanceNote): AdminFinanceNoteDto {
    const dto = new AdminFinanceNoteDto();
    dto.id = entity.id;
    dto.content = entity.content;
    dto.createdBy = entity.createdByName ?? 'Admin';
    dto.createdAt = entity.createdAt?.toISOString();
    return dto;
  }

  private async getRefundExposureByPartner(
    partnerIds: string[],
    currency: string,
    range: DateRange,
  ): Promise<Map<string, number>> {
    if (!partnerIds.length) return new Map();
    const rows = await this.refundCaseRepo
      .createQueryBuilder('rc')
      .select('rc.partnerId', 'partnerId')
      .addSelect('COALESCE(SUM(rc.amount), 0)', 'amount')
      .where('rc.partnerId IN (:...partnerIds)', { partnerIds })
      .andWhere('rc.currency = :currency', { currency })
      .andWhere('rc.requestedAt >= :start', { start: range.start })
      .andWhere('rc.requestedAt <= :end', { end: range.end })
      .andWhere('rc.status IN (:...statuses)', {
        statuses: [
          PartnerRefundCaseStatus.PENDING,
          PartnerRefundCaseStatus.UNDER_REVIEW,
        ],
      })
      .groupBy('rc.partnerId')
      .getRawMany();
    return new Map(rows.map((row) => [row.partnerId, Number(row.amount)]));
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

  private providerSearchTerm(provider: AdminFinanceProvider): string {
    return provider === AdminFinanceProvider.BANK_TRANSFER
      ? 'bank'
      : provider.toLowerCase();
  }

  private getDateRange(query: AdminFinanceQueryDto): DateRange {
    const end = query.endDate ? this.endOfDay(query.endDate) : new Date();
    if (query.startDate) {
      return { start: this.startOfDay(query.startDate), end };
    }

    const period = query.period ?? AdminFinancePeriod.THIRTY_DAYS;
    if (period === AdminFinancePeriod.THIS_MONTH) {
      return {
        start: new Date(end.getFullYear(), end.getMonth(), 1),
        end,
      };
    }
    if (period === AdminFinancePeriod.LAST_MONTH) {
      const start = new Date(end.getFullYear(), end.getMonth() - 1, 1);
      const lastMonthEnd = new Date(
        end.getFullYear(),
        end.getMonth(),
        0,
        23,
        59,
        59,
        999,
      );
      return { start, end: lastMonthEnd };
    }

    const daysMap: Record<AdminFinancePeriod, number> = {
      [AdminFinancePeriod.SEVEN_DAYS]: 7,
      [AdminFinancePeriod.THIRTY_DAYS]: 30,
      [AdminFinancePeriod.NINETY_DAYS]: 90,
      [AdminFinancePeriod.THIS_MONTH]: 30,
      [AdminFinancePeriod.LAST_MONTH]: 30,
      [AdminFinancePeriod.CUSTOM]: 30,
    };
    const start = new Date(end);
    start.setDate(start.getDate() - daysMap[period]);
    start.setHours(0, 0, 0, 0);
    return { start, end };
  }

  private getPage(query: AdminFinanceQueryDto): {
    page: number;
    limit: number;
  } {
    return {
      page: Math.max(1, Number(query.page ?? 1)),
      limit: Math.min(100, Math.max(1, Number(query.limit ?? 50))),
    };
  }

  private startOfDay(value: string): Date {
    const date = new Date(value);
    date.setHours(0, 0, 0, 0);
    return date;
  }

  private endOfDay(value: string): Date {
    const date = new Date(value);
    date.setHours(23, 59, 59, 999);
    return date;
  }

  private formatDate(value: Date): string {
    return value?.toISOString().slice(0, 10) ?? '';
  }

  private actorName(actor: AdminFinanceActor): string {
    return actor?.email ?? actor?.username ?? actor?.id ?? 'Admin';
  }

  private alert(
    id: string,
    title: string,
    description: string,
    tone: AdminFinanceRiskTone,
    createdAt: string,
  ): AdminFinanceAlertDto {
    const dto = new AdminFinanceAlertDto();
    dto.id = id;
    dto.title = title;
    dto.description = description;
    dto.tone = tone;
    dto.createdAt = createdAt;
    return dto;
  }
}
