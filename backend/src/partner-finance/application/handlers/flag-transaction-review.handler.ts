import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';
import { FlagReviewDto } from '@/partner-finance/dto/request/flag-review.dto';
import { PartnerTransactionRecordDto } from '@/partner-finance/dto/response/partner-transaction-record.dto';

@Injectable()
export class FlagTransactionReviewHandler {
  private readonly logger = new Logger(FlagTransactionReviewHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    transactionId: string,
    accountId: string,
    dto: FlagReviewDto,
  ): Promise<PartnerTransactionRecordDto> {
    this.logger.log(`Flagging review for txn: ${transactionId}`);

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const txn = await queryRunner.manager.findOne(PartnerLedgerTransaction, {
        where: { id: transactionId, partnerId },
        relations: ['timelineEvents'],
      });

      if (!txn) {
        throw new NotFoundException(`Transaction ${transactionId} not found`);
      }

      txn.flaggedForReview = dto.flaggedForReview;

      await queryRunner.manager.save(PartnerLedgerTransaction, txn);

      // Add timeline event
      const event = queryRunner.manager.create(PartnerTransactionTimeline, {
        transactionId: txn.id,
        partnerId,
        title: dto.flaggedForReview
          ? 'Flagged for review'
          : 'Review flag removed',
        description:
          dto.note ??
          (dto.flaggedForReview
            ? 'Partner requested finance review'
            : 'Review flag cleared'),
        occurredAt: new Date(),
        actorAccountId: accountId,
      });
      await queryRunner.manager.save(PartnerTransactionTimeline, event);

      await queryRunner.commitTransaction();

      const updated = await this.dataSource.manager.findOne(
        PartnerLedgerTransaction,
        {
          where: { id: transactionId },
          relations: ['timelineEvents'],
        },
      );

      return PartnerTransactionRecordDto.fromEntity(updated!);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Flag review failed: ${error.message}`, error.stack);
      if (error instanceof NotFoundException) throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
