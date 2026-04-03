import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Account } from '@/common/entities/account.entity';

/**
 * Handler for setting survey data with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class SetSurveyHandler {
  private readonly logger = new Logger(SetSurveyHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the set survey command within a transaction.
   * @param accountId - The account ID
   * @param survey - The survey data to set
   * @returns The updated account
   */
  async execute(
    accountId: string,
    survey: Record<string, unknown> | null,
  ): Promise<Account> {
    this.logger.log(`Executing SetSurveyHandler for account: ${accountId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration: Load account
      const account = await queryRunner.manager.findOne(Account, {
        where: { id: accountId },
      });

      if (!account) {
        throw new NotFoundException('User not found');
      }

      // 2. Domain Action: Update survey
      account.survey = survey;
      const savedAccount = await queryRunner.manager.save(Account, account);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Survey set successfully for account: ${accountId}`);

      return savedAccount;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(`Failed to set survey: ${error.message}`, error.stack);
      throw new InternalServerErrorException(
        'Transaction failed during survey update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
