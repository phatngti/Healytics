import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerFinanceQueryDto } from '@/partner-finance/dto/query/partner-finance-query.dto';
import { PartnerFinanceSummaryDto } from '@/partner-finance/dto/response/partner-finance-summary.dto';
import { PartnerFinancePeriod } from '@/partner-finance/enums/partner-finance-period.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';

@Injectable()
export class GetFinanceSummaryHandler {
  private readonly logger = new Logger(GetFinanceSummaryHandler.name);

  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
  ) {}

  async execute(
    partnerId: string,
    query: PartnerFinanceQueryDto,
  ): Promise<PartnerFinanceSummaryDto> {
    this.logger.log(`Getting finance summary for partner: ${partnerId}`);

    const currency = query.currency ?? 'VND';
    const dateRange = this.getDateRange(query);

    // Aggregate transaction metrics
    const txnQb = this.txnRepo
      .createQueryBuilder('txn')
      .where('txn.partnerId = :partnerId', { partnerId })
      .andWhere('txn.currency = :currency', { currency })
      .andWhere('txn.createdAt >= :start', { start: dateRange.start })
      .andWhere('txn.createdAt <= :end', { end: dateRange.end });

    const aggregates = await txnQb
      .select([
        `COALESCE(SUM(CASE WHEN txn.type = :chargeType THEN txn.gross_amount ELSE 0 END), 0) AS "grossVolume"`,
        `COALESCE(SUM(CASE WHEN txn.settlement_status = :settledStatus THEN txn.gross_amount - txn.fee_amount ELSE 0 END), 0) AS "netSettled"`,
        `COALESCE(SUM(CASE WHEN txn.payout_status IN (:...pendingPayoutStatuses) THEN txn.gross_amount - txn.fee_amount ELSE 0 END), 0) AS "pendingPayout"`,
      ])
      .setParameters({
        chargeType: PartnerTransactionType.CHARGE,
        settledStatus: PartnerSettlementStatus.SETTLED,
        pendingPayoutStatuses: [PartnerPayoutStatus.NOT_ASSIGNED, PartnerPayoutStatus.IN_PAYOUT],
      })
      .getRawOne();

    // Refund exposure
    const refundExposure = await this.refundCaseRepo
      .createQueryBuilder('rc')
      .select('COALESCE(SUM(rc.amount), 0)', 'total')
      .where('rc.partnerId = :partnerId', { partnerId })
      .andWhere('rc.currency = :currency', { currency })
      .andWhere('rc.status IN (:...openStatuses)', {
        openStatuses: [PartnerRefundCaseStatus.PENDING, PartnerRefundCaseStatus.UNDER_REVIEW],
      })
      .getRawOne();

    // Nearest upcoming or failed payout
    const nextPayout = await this.payoutRepo
      .createQueryBuilder('p')
      .where('p.partnerId = :partnerId', { partnerId })
      .andWhere('p.status IN (:...activeStatuses)', {
        activeStatuses: [PartnerPayoutStatus.IN_PAYOUT, PartnerPayoutStatus.FAILED],
      })
      .orderBy('p.scheduledDate', 'ASC')
      .getOne();

    const grossVolume = Number(aggregates?.grossVolume ?? 0);
    const netSettled = Number(aggregates?.netSettled ?? 0);
    const pendingPayout = Number(aggregates?.pendingPayout ?? 0);
    const refundExp = Number(refundExposure?.total ?? 0);

    const dto = new PartnerFinanceSummaryDto();
    dto.grossVolume = grossVolume;
    dto.netSettled = netSettled;
    dto.pendingPayout = pendingPayout;
    dto.refundExposure = refundExp;
    dto.availableBalance = Math.max(0, netSettled - refundExp);
    dto.pendingBalance = pendingPayout;
    dto.currency = currency;
    dto.nextPayoutAt = nextPayout?.scheduledDate?.toISOString() ?? null;
    dto.payoutMethod = nextPayout?.methodLabel ?? null;
    dto.payoutStatus = nextPayout?.status ?? null;

    return dto;
  }

  private getDateRange(query: PartnerFinanceQueryDto): { start: Date; end: Date } {
    const end = query.endDate ? new Date(query.endDate) : new Date();
    end.setHours(23, 59, 59, 999);

    if (query.startDate) {
      const start = new Date(query.startDate);
      start.setHours(0, 0, 0, 0);
      return { start, end };
    }

    const period = query.period ?? PartnerFinancePeriod.THIRTY_DAYS;
    const daysMap: Record<PartnerFinancePeriod, number> = {
      [PartnerFinancePeriod.SEVEN_DAYS]: 7,
      [PartnerFinancePeriod.THIRTY_DAYS]: 30,
      [PartnerFinancePeriod.NINETY_DAYS]: 90,
    };

    const start = new Date(end);
    start.setDate(start.getDate() - daysMap[period]);
    start.setHours(0, 0, 0, 0);
    return { start, end };
  }
}
