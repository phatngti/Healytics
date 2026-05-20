import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';

/**
 * Handler for setting refresh token hash.
 *
 * Uses a direct UPDATE instead of a full transaction because:
 * - Single-column idempotent update doesn't need ACID guarantees
 * - Under load (100 UPS), transaction overhead (connect→begin→select→update→commit→release)
 *   consumes 6 DB round-trips per login vs 1 for a direct UPDATE
 * - The old transaction also held a dedicated connection from the pool for the entire duration
 */
@Injectable()
export class SetRefreshTokenHandler {
  private readonly logger = new Logger(SetRefreshTokenHandler.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  /**
   * Sets the refresh token hash for an account using a direct UPDATE.
   * No transaction needed — this is an idempotent single-column update.
   *
   * @param accountId - The account ID
   * @param refreshTokenHash - The hashed refresh token
   * @returns The updated account (minimal select)
   */
  async execute(accountId: string, refreshTokenHash: string): Promise<Account> {
    await this.accountRepo.update(accountId, { refreshTokenHash });
    this.logger.debug(`Refresh token set for account: ${accountId}`);
    // Return a minimal account object — callers only need the ID
    return { id: accountId, refreshTokenHash } as Account;
  }
}
