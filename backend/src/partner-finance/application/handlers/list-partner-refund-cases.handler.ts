import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerFinancePageQueryDto } from '@/partner-finance/dto/query/partner-finance-page-query.dto';
import { PartnerRefundCaseRecordDto } from '@/partner-finance/dto/response/partner-refund-case-record.dto';
import { PartnerFinancePageMetaDto } from '@/partner-finance/dto/response/partner-finance-page-meta.dto';

@Injectable()
export class ListPartnerRefundCasesHandler {
  private readonly logger = new Logger(ListPartnerRefundCasesHandler.name);

  constructor(
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
  ) {}

  async execute(
    partnerId: string,
    query: PartnerFinancePageQueryDto,
  ): Promise<{ data: PartnerRefundCaseRecordDto[]; meta: PartnerFinancePageMetaDto }> {
    this.logger.log(`Listing refund cases for partner: ${partnerId}`);

    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    const qb = this.refundCaseRepo
      .createQueryBuilder('rc')
      .where('rc.partnerId = :partnerId', { partnerId });

    if (query.search) {
      qb.andWhere(
        '(rc.id::text ILIKE :search OR rc.transaction_id::text ILIKE :search OR rc.reason ILIKE :search OR rc.owner ILIKE :search)',
        { search: `%${query.search}%` },
      );
    }
    if (query.currency) {
      qb.andWhere('rc.currency = :currency', { currency: query.currency });
    }
    if (query.startDate) {
      qb.andWhere('rc.requestedAt >= :startDate', { startDate: new Date(query.startDate) });
    }
    if (query.endDate) {
      const end = new Date(query.endDate);
      end.setHours(23, 59, 59, 999);
      qb.andWhere('rc.requestedAt <= :endDate', { endDate: end });
    }

    qb.orderBy('rc.requestedAt', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const [items, total] = await qb.getManyAndCount();

    return {
      data: PartnerRefundCaseRecordDto.fromEntities(items),
      meta: PartnerFinancePageMetaDto.create(total, page, limit),
    };
  }
}
