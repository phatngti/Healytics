import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Account } from '@/common/entities/account.entity';

/**
 * Handler for creating accounts with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class CreateAccountHandler {
  private readonly logger = new Logger(CreateAccountHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create account command within a transaction.
   * @param command - Partial account data to create
   * @returns The created account
   */
  async execute(command: Partial<Account>): Promise<Account> {
    this.logger.log(`Executing CreateAccountHandler for: ${command.email}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Domain Action: Create Account entity
      const account = queryRunner.manager.create(Account, command);
      const savedAccount = await queryRunner.manager.save(Account, account);

      // 2. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Account created successfully: ${savedAccount.id}`);

      return savedAccount;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create account: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during account creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
