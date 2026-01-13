import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from './entities/account.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';

/**
 * Service facade for managing user accounts.
 * Delegates mutation operations to dedicated handlers.
 * Handles CRUD operations and authentication-related data.
 */
@Injectable()
export class AccountService {
  private readonly logger = new Logger(AccountService.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    private readonly createAccountHandler: CreateAccountHandler,
    private readonly setSurveyHandler: SetSurveyHandler,
    private readonly setRefreshTokenHandler: SetRefreshTokenHandler,
  ) {}

  /**
   * Facade: Delegates to CreateAccountHandler.
   * @param data - Partial account data to create
   * @returns The created account
   */
  async create(data: Partial<Account>): Promise<Account> {
    return this.createAccountHandler.execute(data);
  }

  /**
   * Retrieves the survey data for an account.
   * @param accountId - The account ID
   * @returns The survey data or null if not set
   */
  async getSurvey(accountId: string): Promise<Record<string, unknown> | null> {
    const account = await this.accountRepo.findOne({
      where: { id: accountId },
      select: ['id', 'survey'],
    });
    return account?.survey ?? null;
  }

  /**
   * Facade: Delegates to SetSurveyHandler.
   * @param accountId - The account ID
   * @param survey - The survey data to set
   * @returns The updated account
   */
  async setSurvey(
    accountId: string,
    survey: Record<string, unknown> | null,
  ): Promise<Account> {
    return this.setSurveyHandler.execute(accountId, survey);
  }

  /**
   * Clears the survey data for an account.
   * @param accountId - The account ID
   */
  async clearSurvey(accountId: string): Promise<void> {
    await this.accountRepo.update(accountId, { survey: null });
    this.logger.log(`Survey cleared for account: ${accountId}`);
  }

  /**
   * Finds an account by email address.
   * @param email - The email to search for
   * @returns The account or null if not found
   */
  async findByEmail(email: string): Promise<Account | null> {
    return this.accountRepo.findOneBy({ email });
  }

  /**
   * Retrieves all accounts.
   * @returns Array of all accounts
   */
  async findAll(): Promise<Account[]> {
    return this.accountRepo.find();
  }

  /**
   * Finds an account by ID.
   * @param id - The account ID
   * @returns The account or null if not found
   */
  async findOne(id: string): Promise<Account | null> {
    return this.accountRepo.findOneBy({ id });
  }

  /**
   * Finds an account including the refresh token hash.
   * Used for token validation during refresh flow.
   * @param id - The account ID
   * @returns The account with refresh hash or null
   */
  async findOneWithRefreshHash(id: string): Promise<Account | null> {
    return this.accountRepo.findOne({
      where: { id },
      select: [
        'id',
        'email',
        'passwordHash',
        'refreshTokenHash',
        'isActive',
        'createdAt',
        'updatedAt',
      ],
      relations: ['userProfile'],
    });
  }

  /**
   * Facade: Delegates to SetRefreshTokenHandler.
   * @param id - The account ID
   * @param refreshTokenHash - The hashed refresh token
   * @returns The updated account
   */
  async setRefreshTokenHash(
    id: string,
    refreshTokenHash: string,
  ): Promise<Account> {
    return this.setRefreshTokenHandler.execute(id, refreshTokenHash);
  }

  /**
   * Removes the refresh token from an account (logout).
   * @param id - The account ID
   */
  async removeRefreshToken(id: string): Promise<void> {
    await this.accountRepo.update(id, { refreshTokenHash: null });
    this.logger.log(`Refresh token removed for account: ${id}`);
  }
}
