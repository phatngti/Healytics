import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerFinanceQueryDto } from '@/partner-finance/dto/query/partner-finance-query.dto';
import { PartnerFinanceTrendPointDto } from '@/partner-finance/dto/response/partner-finance-trend-point.dto';
import { PartnerFinancePeriod } from '@/partner-finance/enums/partner-finance-period.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';

@Injectable()
export class GetFinanceTrendHandler {
  private readonly logger = new Logger(GetFinanceTrendHandler.name);

  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
  ) {}

  async execute(
    partnerId: string,
    query: PartnerFinanceQueryDto,
  ): Promise<PartnerFinanceTrendPointDto[]> {
    this.logger.log(`Getting finance trend for partner: ${partnerId}`);

    const { start, end } = this.getDateRange(query);
    const currency = query.currency ?? 'VND';

    // Aggregate by calendar day
    const rawRows = await this.txnRepo
      .createQueryBuilder('txn')
      .select([
        `DATE(txn.created_at) AS "date"`,
        `COALESCE(SUM(CASE WHEN txn.type = :chargeType THEN txn.gross_amount ELSE 0 END), 0) AS "grossAmount"`,
        `COALESCE(SUM(txn.gross_amount - txn.fee_amount), 0) AS "netAmount"`,
        `COALESCE(SUM(CASE WHEN txn.type = :refundType THEN txn.gross_amount ELSE 0 END), 0) AS "refundAmount"`,
      ])
      .where('txn.partnerId = :partnerId', { partnerId })
      .andWhere('txn.currency = :currency', { currency })
      .andWhere('txn.createdAt >= :start', { start })
      .andWhere('txn.createdAt <= :end', { end })
      .setParameters({
        chargeType: PartnerTransactionType.CHARGE,
        refundType: PartnerTransactionType.REFUND,
      })
      .groupBy('DATE(txn.created_at)')
      .orderBy('DATE(txn.created_at)', 'ASC')
      .getRawMany();

    // Build lookup from raw data
    const dataMap = new Map<
      string,
      { gross: number; net: number; refund: number }
    >();
    for (const row of rawRows) {
      const dateStr =
        row.date instanceof Date
          ? row.date.toISOString().split('T')[0]
          : String(row.date);
      dataMap.set(dateStr, {
        gross: Number(row.grossAmount),
        net: Number(row.netAmount),
        refund: Number(row.refundAmount),
      });
    }

    // Generate zero-filled daily buckets
    const result: PartnerFinanceTrendPointDto[] = [];
    const current = new Date(start);
    current.setHours(0, 0, 0, 0);
    const endDate = new Date(end);
    endDate.setHours(0, 0, 0, 0);

    while (current <= endDate) {
      const dateStr = current.toISOString().split('T')[0];
      const data = dataMap.get(dateStr);
      const point = new PartnerFinanceTrendPointDto();
      point.date = dateStr;
      point.grossAmount = data?.gross ?? 0;
      point.netAmount = data?.net ?? 0;
      point.refundAmount = data?.refund ?? 0;
      result.push(point);
      current.setDate(current.getDate() + 1);
    }

    return result;
  }

  private getDateRange(query: PartnerFinanceQueryDto): {
    start: Date;
    end: Date;
  } {
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
