import { Injectable, Logger, NotFoundException, ConflictException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';
import { MarkSettlementDto } from '@/partner-finance/dto/request/mark-settlement.dto';
import { PartnerTransactionRecordDto } from '@/partner-finance/dto/response/partner-transaction-record.dto';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';

@Injectable()
export class MarkTransactionSettledHandler {
  private readonly logger = new Logger(MarkTransactionSettledHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    transactionId: string,
    accountId: string,
    dto: MarkSettlementDto,
  ): Promise<PartnerTransactionRecordDto> {
    this.logger.log(`Marking settlement for txn: ${transactionId}`);

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

      // Invariant: reject terminal statuses
      const terminalStatuses = [
        PartnerTransactionStatus.FAILED,
        PartnerTransactionStatus.CANCELED,
        PartnerTransactionStatus.REFUNDED,
      ];
      if (terminalStatuses.includes(txn.status)) {
        throw new ConflictException(
          `Cannot settle transaction in ${txn.status} status`,
        );
      }

      txn.settlementStatus = dto.settlementStatus;

      // Auto-move payout status to inPayout when settling
      if (
        dto.settlementStatus === PartnerSettlementStatus.SETTLED &&
        txn.payoutStatus === PartnerPayoutStatus.NOT_ASSIGNED
      ) {
        txn.payoutStatus = PartnerPayoutStatus.IN_PAYOUT;
      }

      if (dto.note) {
        txn.notes = dto.note;
      }

      await queryRunner.manager.save(PartnerLedgerTransaction, txn);

      // Add timeline event
      const event = queryRunner.manager.create(PartnerTransactionTimeline, {
        transactionId: txn.id,
        partnerId,
        title: `Settlement marked: ${dto.settlementStatus}`,
        description: dto.note ?? `Settlement status changed to ${dto.settlementStatus}`,
        occurredAt: new Date(),
        actorAccountId: accountId,
      });
      await queryRunner.manager.save(PartnerTransactionTimeline, event);

      await queryRunner.commitTransaction();
      this.logger.log(`Settlement updated for txn: ${transactionId}`);

      // Reload with relations
      const updated = await this.dataSource.manager.findOne(PartnerLedgerTransaction, {
        where: { id: transactionId },
        relations: ['timelineEvents'],
      });

      return PartnerTransactionRecordDto.fromEntity(updated!);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Settlement failed: ${error.message}`, error.stack);
      if (error instanceof NotFoundException || error instanceof ConflictException) throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
