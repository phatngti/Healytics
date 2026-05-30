import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
  BadRequestException,
  Optional,
} from '@nestjs/common';

import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, EntityManager, Raw, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Address } from '@/common/entities/address.entity';
import { Location } from '@/common/entities/location.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { AccountMeResponseDto } from './dto/response/account-me-response.dto';
import { RedisService } from '@/redis/redis.service';
import { createHash } from 'crypto';
import { RegisterProfileDto } from '@/auth/dto/request/register-profile.dto';
import { UpdateAccountAddressDto } from './dto/request/update-account-address.dto';
import { UpdateAccountProfileDto } from './dto/request/update-account-profile.dto';
import { LocationsService } from '@/locations/locations.service';
import { MapboxService } from '@/mapbox/mapbox.service';
import { Role } from './enum/role.enum';

type AddressLocationInput = Pick<
  UpdateAccountAddressDto,
  'streetAddress' | 'provinceId' | 'districtId' | 'wardId'
>;

interface PreparedAddress {
  street: string;
  ward: string;
  district: string;
  cityOrProvince: string;
  provinceId: string;
  districtId: string;
  wardId: string;
  coordinates: string | null;
  latitude: number | null;
  longitude: number | null;
}

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
    private readonly dataSource: DataSource,
    private readonly createAccountHandler: CreateAccountHandler,
    private readonly setSurveyHandler: SetSurveyHandler,
    private readonly setRefreshTokenHandler: SetRefreshTokenHandler,
    private readonly locationsService: LocationsService,
    private readonly mapboxService: MapboxService,
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
          address: {
            id: true,
            street: true,
            ward: true,
            district: true,
            cityOrProvince: true,
            provinceId: true,
            districtId: true,
            wardId: true,
            coordinates: true,
          },
        },
      } as any,
      relations: { userProfile: { address: true } } as any,
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

  async updateProfile(
    accountId: string,
    dto: UpdateAccountProfileDto,
  ): Promise<AccountMeResponseDto> {
    await this.dataSource.transaction(async (manager) => {
      const account = await manager.findOne(Account, {
        where: { id: accountId },
        relations: { userProfile: true } as any,
        loadEagerRelations: false,
      });

      if (!account) {
        throw new NotFoundException('Account not found');
      }

      const userProfile =
        account.userProfile ??
        manager.create(UserProfile, {
          accountId: account.id,
        });

      userProfile.firstName = this.normalizeProfileField(dto.firstName);
      userProfile.lastName = this.normalizeProfileField(dto.lastName);
      userProfile.phone = this.normalizeProfileField(dto.phone);
      if (dto.dateOfBirth !== undefined) {
        userProfile.dateOfBirth = dto.dateOfBirth
          ? new Date(dto.dateOfBirth)
          : null;
      }
      if (dto.profileCompleted !== undefined) {
        userProfile.profileCompleted = dto.profileCompleted;
      }

      await manager.save(UserProfile, userProfile);
    });

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

  async createRegisteredUser(
    email: string,
    passwordHash: string,
    profile?: RegisterProfileDto,
  ): Promise<Account> {
    const preparedAddress = profile?.address
      ? await this.prepareAddress(profile.address)
      : null;

    const account = await this.dataSource.transaction(async (manager) => {
      const accountEntity = manager.create(Account, {
        email,
        passwordHash,
        role: Role.USER,
        isActive: true,
      });
      const savedAccount = await manager.save(Account, accountEntity);

      let savedAddress: Address | null = null;
      if (preparedAddress) {
        const address = manager.create(Address, {
          street: preparedAddress.street,
          ward: preparedAddress.ward,
          district: preparedAddress.district,
          cityOrProvince: preparedAddress.cityOrProvince,
          provinceId: preparedAddress.provinceId,
          districtId: preparedAddress.districtId,
          wardId: preparedAddress.wardId,
          coordinates: preparedAddress.coordinates,
        });
        savedAddress = await manager.save(Address, address);
        await this.writeAddressLocation(
          manager,
          savedAddress.id,
          preparedAddress,
        );
      }

      if (profile) {
        const userProfile = manager.create(UserProfile, {
          firstName: profile.firstName,
          lastName: profile.lastName,
          phone: profile.phone,
          bio: profile.bio,
          dateOfBirth: profile.dateOfBirth
            ? new Date(profile.dateOfBirth)
            : undefined,
          accountId: savedAccount.id,
          addressId: savedAddress?.id ?? null,
        });
        const savedProfile = await manager.save(UserProfile, userProfile);
        if (savedAddress) {
          savedProfile.address = savedAddress;
        }
        savedAccount.userProfile = savedProfile;
      }

      return savedAccount;
    });

    await this.markEmailExists(email);
    return account;
  }

  async updateAddress(
    accountId: string,
    dto: UpdateAccountAddressDto,
  ): Promise<AccountMeResponseDto> {
    const preparedAddress = await this.prepareAddress(dto);

    await this.dataSource.transaction(async (manager) => {
      const account = await manager.findOne(Account, {
        where: { id: accountId },
        relations: { userProfile: { address: true } } as any,
        loadEagerRelations: false,
      });

      if (!account) {
        throw new NotFoundException('Account not found');
      }
      const userProfile =
        account.userProfile ??
        manager.create(UserProfile, {
          accountId: account.id,
        });

      const address = userProfile.address ?? manager.create(Address);
      address.street = preparedAddress.street;
      address.ward = preparedAddress.ward;
      address.district = preparedAddress.district;
      address.cityOrProvince = preparedAddress.cityOrProvince;
      address.provinceId = preparedAddress.provinceId;
      address.districtId = preparedAddress.districtId;
      address.wardId = preparedAddress.wardId;
      address.coordinates = preparedAddress.coordinates;

      const savedAddress = await manager.save(Address, address);
      if (userProfile.addressId !== savedAddress.id) {
        userProfile.addressId = savedAddress.id;
        await manager.save(UserProfile, userProfile);
      }
      await this.writeAddressLocation(
        manager,
        savedAddress.id,
        preparedAddress,
      );
    });

    await this.invalidateAccountMeCache(accountId);
    return this.getMe(accountId);
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
        address: account.userProfile.address
          ? {
              street: account.userProfile.address.street,
              ward: account.userProfile.address.ward,
              district: account.userProfile.address.district,
              cityOrProvince: account.userProfile.address.cityOrProvince,
              provinceId: account.userProfile.address.provinceId,
              districtId: account.userProfile.address.districtId,
              wardId: account.userProfile.address.wardId,
              latitude: account.userProfile.address.latitude,
              longitude: account.userProfile.address.longitude,
            }
          : null,
      };
    } else {
      response.userProfile = null;
    }

    return response;
  }

  private normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  private normalizeProfileField(
    value: string | null | undefined,
  ): string | null {
    const normalized = value?.trim() ?? '';
    return normalized.length === 0 ? null : normalized;
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

  private async prepareAddress(
    dto: AddressLocationInput,
  ): Promise<PreparedAddress> {
    const street = dto.streetAddress.trim();
    if (!street) {
      throw new BadRequestException('Street address is required');
    }

    try {
      await this.locationsService.validateAddress(
        dto.provinceId,
        dto.districtId,
        dto.wardId,
      );
    } catch (error) {
      throw new BadRequestException(
        `Invalid address: ${(error as Error).message}`,
      );
    }

    const locationRepo = this.dataSource.getRepository(Location);
    const [province, district, ward] = await Promise.all([
      locationRepo.findOne({ where: { id: dto.provinceId } }),
      locationRepo.findOne({ where: { id: dto.districtId } }),
      locationRepo.findOne({ where: { id: dto.wardId } }),
    ]);

    if (!province || !district || !ward) {
      throw new BadRequestException('Invalid address location selection');
    }

    const fullAddress = [
      street,
      ward.fullName || ward.name,
      district.fullName || district.name,
      province.fullName || province.name,
      'Vietnam',
    ].join(', ');

    let latitude: number | null = null;
    let longitude: number | null = null;
    try {
      const geoResult = await this.mapboxService.geocode(fullAddress);
      const firstResult = geoResult.results[0];
      if (firstResult) {
        latitude = firstResult.lat;
        longitude = firstResult.lng;
      } else {
        this.logger.warn(
          `User address geocoding returned no results: ${fullAddress}`,
        );
      }
    } catch (error) {
      this.logger.warn(
        `User address geocoding failed (non-blocking): ${(error as Error).message}`,
      );
    }

    return {
      street,
      ward: ward.fullName || ward.name,
      district: district.fullName || district.name,
      cityOrProvince: province.fullName || province.name,
      provinceId: province.id,
      districtId: district.id,
      wardId: ward.id,
      coordinates:
        latitude != null && longitude != null
          ? `${latitude},${longitude}`
          : null,
      latitude,
      longitude,
    };
  }

  private async writeAddressLocation(
    manager: EntityManager,
    addressId: string,
    address: PreparedAddress,
  ): Promise<void> {
    if (address.latitude == null || address.longitude == null) {
      await manager.query(`UPDATE address SET location = NULL WHERE id = $1`, [
        addressId,
      ]);
      return;
    }

    await manager.query(
      `
        UPDATE address
        SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography
        WHERE id = $3
      `,
      [address.longitude, address.latitude, addressId],
    );
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
