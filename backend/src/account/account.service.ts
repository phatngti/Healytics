import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
  Optional,
} from '@nestjs/common';

import { InjectRepository } from '@nestjs/typeorm';
import { Raw, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { AccountMeResponseDto } from './dto/response/account-me-response.dto';
import { RedisService } from '@/redis/redis.service';
import { createHash } from 'crypto';

/**
 * Service facade for managing user accounts.
 * Delegates mutation operations to dedicated handlers.
 * Handles CRUD operations and authentication-related data.
 */
@Injectable()
export class AccountService {
  private readonly logger = new Logger(AccountService.name);
  private readonly accountMeCacheTtlSeconds = Number(
    process.env.ACCOUNT_ME_CACHE_TTL_SECONDS || 300,
  );
  private readonly emailExistsTrueTtlSeconds = Number(
    process.env.AUTH_EMAIL_EXISTS_TRUE_TTL_SECONDS || 1800,
  );
  private readonly emailExistsFalseTtlSeconds = Number(
    process.env.AUTH_EMAIL_EXISTS_FALSE_TTL_SECONDS || 60,
  );

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    private readonly createAccountHandler: CreateAccountHandler,
    private readonly setSurveyHandler: SetSurveyHandler,
    private readonly setRefreshTokenHandler: SetRefreshTokenHandler,
    @Optional()
    private readonly redisService?: RedisService,
  ) {}

  /**
   * Retrieves the current account with role and user profile.
   * @param accountId - The account ID from the JWT
   * @returns AccountMeResponseDto with full account data
   */
  async getMe(accountId: string): Promise<AccountMeResponseDto> {
    const cacheKey = this.accountMeCacheKey(accountId);
    const cached = await this.getCache<AccountMeResponseDto>(cacheKey);
    if (cached) {
      return cached;
    }

    const account = await this.accountRepo.findOne({
      where: { id: accountId },
      select: {
        id: true,
        email: true,
        role: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,
        userProfile: {
          id: true,
          firstName: true,
          lastName: true,
          phone: true,
          bio: true,
          dateOfBirth: true,
          avatarUrl: true,
          profileCompleted: true,
        },
      } as any,
      relations: { userProfile: true } as any,
      loadEagerRelations: false,
    });

    if (!account) {
      throw new NotFoundException('Account not found');
    }

    const response = this.toAccountMeResponse(account);
    await this.setCache(cacheKey, response, this.accountMeCacheTtlSeconds);
    return response;
  }

  /**
   * Persists the avatar URL (S3 key) on the user
   * profile and returns refreshed account data.
   * @param accountId - The account ID from the JWT
   * @param avatarUrl - The S3 key of the uploaded avatar
   * @returns Refreshed AccountMeResponseDto
   */
  async updateAvatar(
    accountId: string,
    avatarUrl: string,
  ): Promise<AccountMeResponseDto> {
    const account = await this.accountRepo.findOne({
      where: { id: accountId },
      relations: { userProfile: true } as any,
      loadEagerRelations: false,
    });

    if (!account || !account.userProfile) {
      throw new NotFoundException('Account or profile not found');
    }

    account.userProfile.avatarUrl = avatarUrl;
    await this.accountRepo.save(account);
    await this.invalidateAccountMeCache(accountId);

    return this.getMe(accountId);
  }

  /**
   * Facade: Delegates to CreateAccountHandler.
   * @param data - Partial account data to create
   * @returns The created account
   */
  async create(data: Partial<Account>): Promise<Account> {
    const account = await this.createAccountHandler.execute(data);
    if (account.email) {
      await this.markEmailExists(account.email);
    }
    return account;
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
    const account = await this.setSurveyHandler.execute(accountId, survey);
    await this.invalidateAccountMeCache(accountId);
    return account;
  }

  /**
   * Clears the survey data for an account.
   * @param accountId - The account ID
   */
  async clearSurvey(accountId: string): Promise<void> {
    await this.accountRepo.update(accountId, { survey: null });
    await this.invalidateAccountMeCache(accountId);
    this.logger.log(`Survey cleared for account: ${accountId}`);
  }

  /**
   * Finds an account by email address.
   * @param email - The email to search for
   * @returns The account or null if not found
   */
  async findByEmail(email: string): Promise<Account | null> {
    const normalizedEmail = this.normalizeEmail(email);
    return this.accountRepo.findOne({
      where: { email: this.emailEquals(normalizedEmail) },
    });
  }

  /**
   * Retrieves only the columns needed for password validation and token claims.
   * Avoids eager Address loading from the Account -> UserProfile graph.
   */
  async findAuthByEmail(email: string): Promise<Account | null> {
    const normalizedEmail = this.normalizeEmail(email);
    return this.accountRepo.findOne({
      where: { email: this.emailEquals(normalizedEmail) },
      select: {
        id: true,
        email: true,
        passwordHash: true,
        role: true,
        isActive: true,
        userProfile: {
          id: true,
          firstName: true,
          lastName: true,
          profileCompleted: true,
        },
      } as any,
      relations: { userProfile: true } as any,
      loadEagerRelations: false,
    });
  }

  /**
   * Checks whether an account with the given email exists.
   * Used for pre-registration validation (no auth required).
   * @param email - The email to check
   * @returns true if the email is already registered
   */
  async checkEmailExists(email: string): Promise<boolean> {
    const normalizedEmail = this.normalizeEmail(email);
    const cacheKey = this.emailExistsCacheKey(normalizedEmail);
    const cached = await this.getCache<boolean>(cacheKey);
    if (cached !== null) {
      return cached;
    }

    const exists = await this.accountRepo.exist({
      where: { email: this.emailEquals(normalizedEmail) },
    });

    await this.setCache(
      cacheKey,
      exists,
      exists ? this.emailExistsTrueTtlSeconds : this.emailExistsFalseTtlSeconds,
    );
    return exists;
  }

  async markEmailExists(email: string): Promise<void> {
    const normalizedEmail = this.normalizeEmail(email);
    await this.setCache(
      this.emailExistsCacheKey(normalizedEmail),
      true,
      this.emailExistsTrueTtlSeconds,
    );
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
      select: ['id', 'email', 'role', 'refreshTokenHash', 'isActive'],
      loadEagerRelations: false,
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
    await this.invalidateAccountMeCache(id);
    this.logger.log(`Refresh token removed for account: ${id}`);
  }

  async updatePasswordHash(id: string, passwordHash: string): Promise<void> {
    await this.accountRepo.update(id, { passwordHash, refreshTokenHash: null });
    await this.invalidateAccountMeCache(id);
    this.logger.log(`Password hash updated for account: ${id}`);
  }

  async invalidateAccountMeCache(accountId: string): Promise<void> {
    await this.delCache(this.accountMeCacheKey(accountId));
  }

  private toAccountMeResponse(account: Account): AccountMeResponseDto {
    const response = new AccountMeResponseDto();
    response.id = account.id;
    response.email = account.email;
    response.role = account.role;
    response.isActive = account.isActive;
    response.createdAt = account.createdAt;
    response.updatedAt = account.updatedAt;

    if (account.userProfile) {
      response.userProfile = {
        id: account.userProfile.id,
        firstName: account.userProfile.firstName,
        lastName: account.userProfile.lastName,
        phone: account.userProfile.phone,
        bio: account.userProfile.bio,
        dateOfBirth: account.userProfile.dateOfBirth,
        avatarUrl: account.userProfile.avatarUrl ?? null,
        profileCompleted: account.userProfile.profileCompleted,
      };
    } else {
      response.userProfile = null;
    }

    return response;
  }

  private normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  private emailEquals(normalizedEmail: string) {
    return Raw((alias) => `lower(${alias}) = :email`, {
      email: normalizedEmail,
    });
  }

  private emailExistsCacheKey(normalizedEmail: string): string {
    return `cache:auth:email-exists:v1:${this.sha256(normalizedEmail)}`;
  }

  private accountMeCacheKey(accountId: string): string {
    return `cache:account:me:v1:${accountId}`;
  }

  private sha256(value: string): string {
    return createHash('sha256').update(value).digest('hex');
  }

  private async getCache<T>(key: string): Promise<T | null> {
    if (!this.redisService) {
      return null;
    }

    try {
      return await this.redisService.getJson<T>(key);
    } catch (error) {
      this.logger.warn(
        `Redis cache read skipped for "${key}": ${(error as Error).message}`,
      );
      return null;
    }
  }

  private async setCache(
    key: string,
    value: unknown,
    ttlSeconds: number,
  ): Promise<void> {
    if (!this.redisService || ttlSeconds <= 0) {
      return;
    }

    try {
      await this.redisService.setJson(key, value, ttlSeconds);
    } catch (error) {
      this.logger.warn(
        `Redis cache write skipped for "${key}": ${(error as Error).message}`,
      );
    }
  }

  private async delCache(key: string): Promise<void> {
    if (!this.redisService) {
      return;
    }

    try {
      await this.redisService.del(key);
    } catch (error) {
      this.logger.warn(
        `Redis cache delete skipped for "${key}": ${(error as Error).message}`,
      );
    }
  }
}
