import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerFinancePageQueryDto } from '@/partner-finance/dto/query/partner-finance-page-query.dto';
import { PartnerPayoutRecordDto } from '@/partner-finance/dto/response/partner-payout-record.dto';
import { PartnerFinancePageMetaDto } from '@/partner-finance/dto/response/partner-finance-page-meta.dto';

@Injectable()
export class ListPartnerPayoutsHandler {
  private readonly logger = new Logger(ListPartnerPayoutsHandler.name);

  constructor(
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
    @InjectRepository(PartnerPayoutTransaction)
    private readonly payoutTxnRepo: Repository<PartnerPayoutTransaction>,
  ) {}

  async execute(
    partnerId: string,
    query: PartnerFinancePageQueryDto,
  ): Promise<{ data: PartnerPayoutRecordDto[]; meta: PartnerFinancePageMetaDto }> {
    this.logger.log(`Listing payouts for partner: ${partnerId}`);

    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    const qb = this.payoutRepo
      .createQueryBuilder('p')
      .where('p.partnerId = :partnerId', { partnerId });

    if (query.search) {
      qb.andWhere(
        '(p.id::text ILIKE :search OR p.method_label ILIKE :search)',
        { search: `%${query.search}%` },
      );
    }
    if (query.payoutStatus) {
      qb.andWhere('p.status = :status', { status: query.payoutStatus });
    }
    if (query.currency) {
      qb.andWhere('p.currency = :currency', { currency: query.currency });
    }
    if (query.startDate) {
      qb.andWhere('p.scheduledDate >= :startDate', { startDate: new Date(query.startDate) });
    }
    if (query.endDate) {
      const end = new Date(query.endDate);
      end.setHours(23, 59, 59, 999);
      qb.andWhere('p.scheduledDate <= :endDate', { endDate: end });
    }

    qb.orderBy('p.scheduledDate', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();

    // Load included transaction IDs for each payout
    const data = await Promise.all(
      items.map(async (payout) => {
        const txnIds = await this.payoutTxnRepo
          .find({ where: { payoutId: payout.id } })
          .then((rows) => rows.map((r) => r.transactionId));
        return PartnerPayoutRecordDto.fromEntity(payout, txnIds);
      }),
    );

    return {
      data,
      meta: PartnerFinancePageMetaDto.create(total, page, limit),
    };
  }
}
