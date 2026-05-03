import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerFinancePageQueryDto } from '@/partner-finance/dto/query/partner-finance-page-query.dto';
import { PartnerTransactionRecordDto } from '@/partner-finance/dto/response/partner-transaction-record.dto';
import { PartnerFinancePageMetaDto } from '@/partner-finance/dto/response/partner-finance-page-meta.dto';

@Injectable()
export class ListPartnerTransactionsHandler {
  private readonly logger = new Logger(ListPartnerTransactionsHandler.name);

  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
  ) {}

  async execute(
    partnerId: string,
    query: PartnerFinancePageQueryDto,
  ): Promise<{ data: PartnerTransactionRecordDto[]; meta: PartnerFinancePageMetaDto }> {
    this.logger.log(`Listing transactions for partner: ${partnerId}`);

    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    const qb = this.txnRepo
      .createQueryBuilder('txn')
      .leftJoinAndSelect('txn.timelineEvents', 'timeline')
      .where('txn.partnerId = :partnerId', { partnerId });

    // Apply filters
    if (query.search) {
      qb.andWhere(
        '(txn.id::text ILIKE :search OR txn.reference ILIKE :search OR txn.customer_name_snapshot ILIKE :search OR txn.source_title_snapshot ILIKE :search)',
        { search: `%${query.search}%` },
      );
    }
    if (query.startDate) {
      qb.andWhere('txn.createdAt >= :startDate', { startDate: new Date(query.startDate) });
    }
    if (query.endDate) {
      const end = new Date(query.endDate);
      end.setHours(23, 59, 59, 999);
      qb.andWhere('txn.createdAt <= :endDate', { endDate: end });
    }
    if (query.sourceType) {
      qb.andWhere('txn.sourceType = :sourceType', { sourceType: query.sourceType });
    }
    if (query.transactionType) {
      qb.andWhere('txn.type = :transactionType', { transactionType: query.transactionType });
    }
    if (query.transactionStatus) {
      qb.andWhere('txn.status = :transactionStatus', { transactionStatus: query.transactionStatus });
    }
    if (query.settlementStatus) {
      qb.andWhere('txn.settlementStatus = :settlementStatus', { settlementStatus: query.settlementStatus });
    }
    if (query.payoutStatus) {
      qb.andWhere('txn.payoutStatus = :payoutStatus', { payoutStatus: query.payoutStatus });
    }
    if (query.currency) {
      qb.andWhere('txn.currency = :currency', { currency: query.currency });
    }

    qb.orderBy('txn.createdAt', 'DESC')
      .addOrderBy('txn.id', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();

    return {
      data: PartnerTransactionRecordDto.fromEntities(items),
      meta: PartnerFinancePageMetaDto.create(total, page, limit),
    };
  }
}
