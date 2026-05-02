import { Injectable, Logger, NotFoundException, ConflictException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';
import { RefundCaseActionDto } from '@/partner-finance/dto/request/refund-case-action.dto';
import { PartnerRefundCaseRecordDto } from '@/partner-finance/dto/response/partner-refund-case-record.dto';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';

@Injectable()
export class RejectPartnerRefundCaseHandler {
  private readonly logger = new Logger(RejectPartnerRefundCaseHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    caseId: string,
    accountId: string,
    dto: RefundCaseActionDto,
  ): Promise<PartnerRefundCaseRecordDto> {
    this.logger.log(`Rejecting refund case: ${caseId}`);

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const refundCase = await queryRunner.manager.findOne(PartnerRefundCase, {
        where: { id: caseId, partnerId },
      });

      if (!refundCase) {
        throw new NotFoundException(`Refund case ${caseId} not found`);
      }

      if (
        refundCase.status !== PartnerRefundCaseStatus.PENDING &&
        refundCase.status !== PartnerRefundCaseStatus.UNDER_REVIEW
      ) {
        throw new ConflictException(
          `Cannot reject case in ${refundCase.status} status`,
        );
      }

      refundCase.status = PartnerRefundCaseStatus.REJECTED;
      await queryRunner.manager.save(PartnerRefundCase, refundCase);

      // Check if there are other open refund cases on the same transaction
      const openCasesCount = await queryRunner.manager.count(PartnerRefundCase, {
        where: [
          { transactionId: refundCase.transactionId, partnerId, status: PartnerRefundCaseStatus.PENDING },
          { transactionId: refundCase.transactionId, partnerId, status: PartnerRefundCaseStatus.UNDER_REVIEW },
        ],
      });

      // Release held settlement if no other open cases remain
      if (openCasesCount === 0) {
        const txn = await queryRunner.manager.findOne(PartnerLedgerTransaction, {
          where: { id: refundCase.transactionId, partnerId },
        });
        if (txn && txn.settlementStatus === PartnerSettlementStatus.HELD) {
          txn.settlementStatus = PartnerSettlementStatus.SCHEDULED;
          await queryRunner.manager.save(PartnerLedgerTransaction, txn);
        }
      }

      // Add timeline event to linked transaction
      const event = queryRunner.manager.create(PartnerTransactionTimeline, {
        transactionId: refundCase.transactionId,
        partnerId,
        title: 'Refund case rejected',
        description: dto.note ?? `Refund case ${caseId} rejected`,
        occurredAt: new Date(),
        actorAccountId: accountId,
      });
      await queryRunner.manager.save(PartnerTransactionTimeline, event);

      await queryRunner.commitTransaction();
      this.logger.log(`Refund case rejected: ${caseId}`);

      return PartnerRefundCaseRecordDto.fromEntity(refundCase);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Reject failed: ${error.message}`, error.stack);
      if (error instanceof NotFoundException || error instanceof ConflictException) throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
