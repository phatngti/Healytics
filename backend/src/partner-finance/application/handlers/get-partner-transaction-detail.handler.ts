import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerTransactionDetailDto } from '@/partner-finance/dto/response/partner-transaction-detail.dto';
import { PartnerTransactionRecordDto } from '@/partner-finance/dto/response/partner-transaction-record.dto';
import { PartnerPayoutRecordDto } from '@/partner-finance/dto/response/partner-payout-record.dto';
import { PartnerRefundCaseRecordDto } from '@/partner-finance/dto/response/partner-refund-case-record.dto';

@Injectable()
export class GetPartnerTransactionDetailHandler {
  private readonly logger = new Logger(GetPartnerTransactionDetailHandler.name);

  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txnRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
    @InjectRepository(PartnerPayoutTransaction)
    private readonly payoutTxnRepo: Repository<PartnerPayoutTransaction>,
  ) {}

  async execute(
    partnerId: string,
    transactionId: string,
  ): Promise<PartnerTransactionDetailDto> {
    this.logger.log(`Getting transaction detail: ${transactionId} for partner: ${partnerId}`);

    const txn = await this.txnRepo.findOne({
      where: { id: transactionId, partnerId },
      relations: ['timelineEvents'],
    });

    if (!txn) {
      throw new NotFoundException(`Transaction with ID ${transactionId} not found`);
    }

    // Sort timeline events chronologically
    if (txn.timelineEvents) {
      txn.timelineEvents.sort(
        (a, b) => new Date(a.occurredAt).getTime() - new Date(b.occurredAt).getTime(),
      );
    }

    // Load linked payout if assigned
    let payoutRecord: PartnerPayoutRecordDto | null = null;
    if (txn.payoutId) {
      const payout = await this.payoutRepo.findOne({
        where: { id: txn.payoutId, partnerId },
      });
      if (payout) {
        const txnIds = await this.payoutTxnRepo
          .find({ where: { payoutId: payout.id } })
          .then((rows) => rows.map((r) => r.transactionId));
        payoutRecord = PartnerPayoutRecordDto.fromEntity(payout, txnIds);
      }
    }

    // Load related refund/dispute cases
    const refundCases = await this.refundCaseRepo.find({
      where: { transactionId, partnerId },
      order: { requestedAt: 'DESC' },
    });

    const dto = new PartnerTransactionDetailDto();
    dto.record = PartnerTransactionRecordDto.fromEntity(txn);
    dto.payoutRecord = payoutRecord;
    dto.relatedRefundCases = PartnerRefundCaseRecordDto.fromEntities(refundCases);
    dto.sourceSummaryTitle = txn.sourceTitleSnapshot ?? '';
    dto.sourceSummarySubtitle = txn.sourceSubtitleSnapshot ?? '';

    return dto;
  }
}
