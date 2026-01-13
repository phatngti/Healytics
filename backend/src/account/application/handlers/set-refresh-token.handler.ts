import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Account } from '../../entities/account.entity';

/**
 * Handler for setting refresh token hash with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class SetRefreshTokenHandler {
  private readonly logger = new Logger(SetRefreshTokenHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the set refresh token command within a transaction.
   * @param accountId - The account ID
   * @param refreshTokenHash - The hashed refresh token
   * @returns The updated account
   */
  async execute(accountId: string, refreshTokenHash: string): Promise<Account> {
    this.logger.log(`Executing SetRefreshTokenHandler for account: ${accountId}`);
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

      // 2. Domain Action: Update refresh token hash
      account.refreshTokenHash = refreshTokenHash;
      const savedAccount = await queryRunner.manager.save(Account, account);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Refresh token set successfully for account: ${accountId}`);

      return savedAccount;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(
        `Failed to set refresh token: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during refresh token update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
