import { Injectable, Logger, NotFoundException, ConflictException } from '@nestjs/common';

import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { AccountMeResponseDto } from './dto/response/account-me-response.dto';
import { plainToInstance } from 'class-transformer';

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
   * Retrieves the current account with role and user profile.
   * @param accountId - The account ID from the JWT
   * @returns AccountMeResponseDto with full account data
   */
  async getMe(accountId: string): Promise<AccountMeResponseDto> {
    const account = await this.accountRepo.findOne({
      where: { id: accountId },
      relations: ['userProfile'],
    });

    if (!account) {
      throw new NotFoundException('Account not found');
    }

    return plainToInstance(AccountMeResponseDto, account, {
      excludeExtraneousValues: true,
    });
  }

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
   * Returns survey data wrapped in SurveyResponseDto.
   * Used by the controller as a dumb adapter.
   * @param accountId - The account ID
   * @returns SurveyResponseDto
   */
  async getSurveyResponse(accountId: string): Promise<SurveyResponseDto> {
    const survey = await this.getSurvey(accountId);
    const response = new SurveyResponseDto();
    response.survey = survey ?? null;
    return response;
  }

  /**
   * Creates a one-shot survey for the current user.
   * Throws ConflictException if survey already exists.
   * Business logic moved from controller per enterprise pattern §10.
   * @param accountId - The account ID
   * @param survey - The survey data
   * @returns SurveyResponseDto
   */
  async createSurvey(
    accountId: string,
    survey: Record<string, unknown>,
  ): Promise<SurveyResponseDto> {
    const existing = await this.getSurvey(accountId);
    if (existing !== null) {
      this.logger.warn(`Survey already exists for account: ${accountId}`);
      throw new ConflictException('Survey already exists');
    }
    const updated = await this.setSurveyHandler.execute(accountId, survey);
    const response = new SurveyResponseDto();
    response.survey = updated.survey ?? null;
    return response;
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
