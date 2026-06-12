import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { RetryPayoutDto } from '@/partner-finance/dto/request/retry-payout.dto';
import { PartnerPayoutRecordDto } from '@/partner-finance/dto/response/partner-payout-record.dto';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';

@Injectable()
export class RetryPartnerPayoutHandler {
  private readonly logger = new Logger(RetryPartnerPayoutHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    payoutId: string,
    dto: RetryPayoutDto,
  ): Promise<PartnerPayoutRecordDto> {
    this.logger.log(`Retrying payout: ${payoutId}`);

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const payout = await queryRunner.manager.findOne(PartnerPayout, {
        where: { id: payoutId, partnerId },
      });

      if (!payout) {
        throw new NotFoundException(`Payout ${payoutId} not found`);
      }

      if (payout.status !== PartnerPayoutStatus.FAILED) {
        throw new ConflictException(
          `Only failed payouts can be retried. Current status: ${payout.status}`,
        );
      }

      // Move to retry state
      payout.status = PartnerPayoutStatus.IN_PAYOUT;

      // Recalculate scheduled date (next business day)
      const nextDate = new Date();
      nextDate.setDate(nextDate.getDate() + 1);
      payout.scheduledDate = nextDate;

      await queryRunner.manager.save(PartnerPayout, payout);

      await queryRunner.commitTransaction();
      this.logger.log(`Payout retried: ${payoutId}`);

      // Load transaction IDs
      const txnIds = await this.dataSource.manager
        .find(PartnerPayoutTransaction, { where: { payoutId } })
        .then((rows) => rows.map((r) => r.transactionId));

      return PartnerPayoutRecordDto.fromEntity(payout, txnIds);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Retry failed: ${error.message}`, error.stack);
      if (
        error instanceof NotFoundException ||
        error instanceof ConflictException
      )
        throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
