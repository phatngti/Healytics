import {
  Injectable,
  Logger,
  ConflictException,
  UnauthorizedException,
  ForbiddenException,
  Optional,
} from '@nestjs/common';
import { AccountService } from '@/account/account.service';
import { RegisterDto } from './dto/request/register.dto';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import * as bcrypt from 'bcrypt';
import { createHash } from 'crypto';
import { JwtService } from '@nestjs/jwt';
import { Role } from '@/account/enum/role.enum';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Account } from '@/common/entities/account.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { RedisService } from '@/redis/redis.service';

/** Roles allowed for admin/partner login */
const ADMIN_ROLES: Role[] = [Role.ADMIN, Role.HEALTH_PARTNER, Role.EMPLOYEE];

/** Roles allowed for user login */
const USER_ROLES: Role[] = [Role.USER];

/** Partner verification info for JWT payload */
export interface PartnerVerificationInfo {
  verificationStatus: PartnerVerificationStatus;
  verificationCompletedAt: Date | null;
  partnerProfileCompleted: boolean;
}

/** JWT payload structure */
interface AuthJwtPayload {
  sub: string;
  email?: string;
  role?: Role;
  name?: string;
  firstName?: string;
  lastName?: string;
  profileCompleted?: boolean;
  createdAt?: string;
  verificationStatus?: PartnerVerificationStatus;
  verificationCompletedAt?: string | null;
  partnerProfileCompleted?: boolean;
}

interface RefreshSessionRecord extends AuthJwtPayload {
  hash: string;
  issuedAt: string;
  expiresAt: string;
}

interface ValidatedRefreshToken {
  user: Account;
  payload: AuthJwtPayload;
  oldHash: string;
  source: 'redis' | 'db';
  session?: RefreshSessionRecord;
}

interface CreateTokenOptions {
  persistRefreshSession?: boolean;
}

/** Validated user from authentication */
export interface ValidatedUser {
  id: string;
  email: string;
  role: Role;
  userProfile?: UserProfile;
  roleNotAllowed?: boolean;
  createdAt?: Date;
}

/**
 * Authentication service handling registration, login, and token management.
 *
 * Performance notes (1000 CCU / 100 UPS target):
 * - User passwords use native bcrypt to avoid pure-JS event-loop pressure.
 * - Refresh token hashes use SHA-256 because refresh JWTs are high entropy.
 * - Refresh sessions are stored in Redis with DB fallback for migration.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  /** Pre-parsed token expiry values — avoids repeated env reads */
  private readonly accessExpires: string;
  private readonly refreshExpires: string;
  private readonly refreshTtlSeconds: number;
  private readonly refreshSessionStore: 'redis' | 'db';
  private readonly refreshDbFallback: boolean;
  private readonly refreshDualWrite: boolean;
  private readonly partnerVerificationCacheTtlSeconds: number;

  constructor(
    private readonly accountService: AccountService,
    private readonly jwtService: JwtService,
    private readonly partnerService: PartnersService,
    @Optional()
    private readonly redisService?: RedisService,
  ) {
    this.accessExpires = process.env.JWT_EXPIRES_IN || '3600s';
    this.refreshExpires = process.env.JWT_REFRESH_EXPIRES_IN || '7d';
    this.refreshTtlSeconds = this.parseDurationSeconds(
      this.refreshExpires,
      7 * 24 * 60 * 60,
    );
    this.refreshSessionStore =
      process.env.AUTH_REFRESH_SESSION_STORE === 'db' ? 'db' : 'redis';
    this.refreshDbFallback = process.env.AUTH_REFRESH_DB_FALLBACK !== 'false';
    this.refreshDualWrite = process.env.AUTH_REFRESH_DUAL_WRITE === 'true';
    this.partnerVerificationCacheTtlSeconds = Number(
      process.env.PARTNER_VERIFICATION_CACHE_TTL_SECONDS || 300,
    );
  }

  /**
   * Creates access and refresh tokens for a user.
   * @param userId - The user's ID
   * @param email - The user's email
   * @param role - The user's role
   * @param profile - Optional user profile
   * @param partnerVerification - Optional partner verification info
   * @param options - Token creation options
   * @param accountCreatedAt - The account creation timestamp to embed in the token
   * @returns The generated tokens
   */
  async createTokensForUser(
    userId: string,
    email?: string,
    role?: Role,
    profile?: UserProfile,
    partnerVerification?: PartnerVerificationInfo,
    options: CreateTokenOptions = {},
    accountCreatedAt?: Date,
  ): Promise<AuthTokensDto> {
    const payload = this.buildJwtPayload(
      userId,
      email,
      role,
      profile,
      partnerVerification,
      accountCreatedAt,
    );

    const [access_token, refresh_token] = await Promise.all([
      this.signJwt(payload, this.accessExpires),
      this.signJwt(payload, this.refreshExpires),
    ]);

    if (options.persistRefreshSession !== false) {
      await this.persistRefreshSession(userId, refresh_token, payload);
    }

    return {
      access_token,
      access_expires_in: this.accessExpires,
      refresh_token,
      refresh_expires_in: this.refreshExpires,
    } as AuthTokensDto;
  }

  /**
   * Registers a new user (USER role only).
   * @param dto - Registration data
   * @returns Authentication tokens
   */
  async register(dto: RegisterDto): Promise<AuthTokensDto> {
    const email = dto.email.trim().toLowerCase();
    const emailExists = await this.accountService.checkEmailExists(email);
    if (emailExists) {
      throw new ConflictException('Email already in use');
    }
    const hash = await bcrypt.hash(dto.password, 10);
    const createData: Partial<Account> = {
      email,
      passwordHash: hash,
      role: Role.USER,
    };
    if (dto.profile) {
      const profileData = { ...dto.profile } as UserProfile;
      if (profileData.dateOfBirth) {
        profileData.dateOfBirth = new Date(profileData.dateOfBirth);
      }
      createData.userProfile = profileData;
    }
    const user = await this.accountService.create(createData);
    this.logger.log(`User registered: ${user.id}`);
    const tokens = await this.createTokensForUser(
      user.id,
      user.email,
      user.role,
      user.userProfile,
    );
    return tokens;
  }

  /**
   * Validates user credentials.
   * @param email - User email
   * @param password - User password
   * @returns The validated user or null
   */
  async validateUser(
    email: string,
    password: string,
  ): Promise<ValidatedUser | null> {
    const user = await this.accountService.findAuthByEmail(email);
    if (!user) return null;
    if (!user.isActive) return null;

    const isMatch = await bcrypt.compare(password, user.passwordHash || '');
    if (!isMatch) return null;
    const { passwordHash, ...rest } = user as Account & {
      passwordHash?: string;
    };
    return rest as ValidatedUser;
  }

  /**
   * Validates user credentials and checks role.
   * @param email - User email
   * @param password - User password
   * @param allowedRoles - Roles allowed to login
   * @returns The validated user or null
   */
  async validateUserWithRole(
    email: string,
    password: string,
    allowedRoles: Role[],
  ): Promise<ValidatedUser | null> {
    const user = await this.validateUser(email, password);
    if (!user) return null;
    if (!allowedRoles.includes(user.role)) {
      return { ...user, roleNotAllowed: true };
    }
    return user;
  }

  /**
   * Logs in a regular user (USER role).
   * @param user - The validated user
   * @returns Authentication tokens
   */
  async loginUser(user: ValidatedUser): Promise<AuthTokensDto> {
    const userId = user.id;
    const userEmail = user.email;
    const userRole = user.role;
    if (!userId) {
      throw new UnauthorizedException('User ID is missing');
    }
    if (user.roleNotAllowed) {
      throw new ForbiddenException(
        'This account is not authorized for user login. Please use the admin portal.',
      );
    }
    if (!USER_ROLES.includes(userRole)) {
      throw new ForbiddenException(
        'This account is not authorized for user login. Please use the admin portal.',
      );
    }
    this.logger.log(`User login: ${userId}`);
    return this.createTokensForUser(
      userId,
      userEmail,
      userRole,
      user.userProfile,
      undefined,
      {},
      user.createdAt,
    );
  }

  /**
   * Logs in an admin/partner user (ADMIN, HEALTH_PARTNER, EMPLOYEE roles).
   * @param user - The validated user
   * @returns Authentication tokens
   */
  async loginAdmin(user: ValidatedUser): Promise<AuthTokensDto> {
    const userId = user.id;
    const userEmail = user.email;
    const userRole = user.role;
    if (!userId) {
      throw new UnauthorizedException('Admin ID is missing');
    }
    if (user.roleNotAllowed) {
      throw new ForbiddenException(
        'This account is not authorized for admin login.',
      );
    }
    if (!ADMIN_ROLES.includes(userRole)) {
      throw new ForbiddenException(
        'This account is not authorized for admin login.',
      );
    }
    this.logger.log(`Admin login: ${userId}`);
    return this.createTokensForUser(
      userId,
      userEmail,
      userRole,
      user.userProfile,
      undefined,
      {},
      user.createdAt,
    );
  }

  /**
   * Logs in an employee user (EMPLOYEE role only).
   * @param user - The validated user
   * @returns Authentication tokens
   */
  async loginEmployee(user: ValidatedUser): Promise<AuthTokensDto> {
    const userId = user.id;
    const userEmail = user.email;
    const userRole = user.role;
    if (!userId) {
      throw new UnauthorizedException('Employee ID is missing');
    }
    if (user.roleNotAllowed || userRole !== Role.EMPLOYEE) {
      throw new ForbiddenException(
        'This account is not authorized for employee login.',
      );
    }
    this.logger.log(`Employee login: ${userId}`);
    return this.createTokensForUser(
      userId,
      userEmail,
      userRole,
      user.userProfile,
      undefined,
      {},
      user.createdAt,
    );
  }

  /**
   * Logs in a partner user (HEALTH_PARTNER role only).
   * @param user - The validated user
   * @returns Authentication tokens
   */
  async loginPartner(user: ValidatedUser): Promise<AuthTokensDto> {
    const userId = user.id;
    const userEmail = user.email;
    const userRole = user.role;

    if (!userId) {
      throw new UnauthorizedException('Partner ID is missing');
    }

    if (user.roleNotAllowed || userRole !== Role.HEALTH_PARTNER) {
      throw new ForbiddenException(
        'This account is not authorized for partner login.',
      );
    }

    const partnerVerification =
      await this.getPartnerVerificationInfo(userId);
    if (!partnerVerification) {
      throw new ForbiddenException(
        'This account is not authorized for partner login.',
      );
    }

    this.logger.log(`Partner login: ${userId}`);
    return this.createTokensForUser(
      userId,
      userEmail,
      userRole,
      user.userProfile,
      partnerVerification,
      {},
      user.createdAt,
    );
  }

  // ============================================================================
  // Token Refresh
  // ============================================================================

  /**
   * Validates a refresh token and returns the associated account.
   * Extracted from refresh() and refreshPartner() to eliminate code duplication.
   *
   * @param refreshToken - The refresh token to validate
   * @returns The validated account
   * @throws UnauthorizedException if the token is invalid, expired, or revoked
   */
  private async _validateRefreshToken(
    refreshToken: string,
  ): Promise<ValidatedRefreshToken> {
    if (!refreshToken) {
      throw new UnauthorizedException('No refresh token provided');
    }

    let payload: AuthJwtPayload;
    try {
      payload = this.jwtService.verify(refreshToken);
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const userId = payload?.sub;
    if (!userId) {
      throw new UnauthorizedException('Invalid token payload');
    }

    const incomingHash = createHash('sha256')
      .update(refreshToken)
      .digest('hex');

    const redisSession = await this.validateRedisRefreshSession(
      userId,
      incomingHash,
      payload,
    );
    if (redisSession) {
      return redisSession;
    }

    if (!this.refreshDbFallback) {
      throw new UnauthorizedException('Refresh token revoked');
    }

    const user = await this.accountService.findOneWithRefreshHash(userId);
    if (!user || !user.refreshTokenHash || !user.isActive) {
      throw new UnauthorizedException('Refresh token revoked');
    }

    if (incomingHash !== user.refreshTokenHash) {
      // Hash mismatch — possible token reuse attack or race condition.
      // Revoke the stored token to force re-authentication.
      await this.accountService.removeRefreshToken(userId).catch(() => {});
      throw new UnauthorizedException('Refresh token does not match');
    }

    return {
      user,
      payload,
      oldHash: incomingHash,
      source: 'db',
    };
  }

  /**
   * Refreshes authentication tokens for a partner, including verification info.
   * @param refreshToken - The refresh token
   * @returns New authentication tokens with partner verification data
   */
  async refreshPartner(refreshToken: string): Promise<AuthTokensDto> {
    const validation = await this._validateRefreshToken(refreshToken);
    const { user } = validation;

    // Ensure the user is a partner
    if (user.role !== Role.HEALTH_PARTNER) {
      throw new ForbiddenException('This account is not a partner account');
    }

    // Fetch partner profile for verification info
    let partnerVerification: PartnerVerificationInfo | undefined;
    try {
      partnerVerification =
        (await this.getPartnerVerificationInfo(user.id)) ?? undefined;
    } catch {
      // Partner profile may not exist yet — continue without verification info
    }

    this.logger.log(`Partner token refreshed for user: ${user.id}`);
    const profile =
      user.userProfile ??
      this.userProfileFromClaims(validation.session ?? validation.payload);
    const tokens = await this.createTokensForUser(
      user.id,
      user.email,
      user.role,
      profile,
      partnerVerification,
      { persistRefreshSession: false },
      user.createdAt,
    );
    await this.rotateRefreshSession(
      validation,
      tokens.refresh_token,
      this.buildJwtPayload(
        user.id,
        user.email,
        user.role,
        profile,
        partnerVerification,
        user.createdAt,
      ),
    );
    return tokens;
  }

  /**
   * Refreshes authentication tokens.
   * @param refreshToken - The refresh token
   * @returns New authentication tokens
   */
  async refresh(refreshToken: string): Promise<AuthTokensDto> {
    const validation = await this._validateRefreshToken(refreshToken);
    const { user } = validation;

    this.logger.log(`Token refreshed for user: ${user.id}`);
    const profile =
      user.userProfile ??
      this.userProfileFromClaims(validation.session ?? validation.payload);
    const tokens = await this.createTokensForUser(
      user.id,
      user.email,
      user.role,
      profile,
      undefined,
      { persistRefreshSession: false },
      user.createdAt,
    );
    await this.rotateRefreshSession(
      validation,
      tokens.refresh_token,
      this.buildJwtPayload(user.id, user.email, user.role, profile, undefined, user.createdAt),
    );
    return tokens;
  }

  private buildJwtPayload(
    userId: string,
    email?: string,
    role?: Role,
    profile?: UserProfile,
    partnerVerification?: PartnerVerificationInfo,
    accountCreatedAt?: Date,
  ): AuthJwtPayload {
    const payload: AuthJwtPayload = { sub: userId, email, role };
    if (profile) {
      const fullName = [
        profile.firstName ?? '',
        profile.lastName ?? '',
      ]
        .join(' ')
        .trim();
      payload.name = fullName || undefined;
      payload.firstName = profile.firstName;
      payload.lastName = profile.lastName;
      payload.profileCompleted = profile.profileCompleted;
    }

    if (accountCreatedAt) {
      payload.createdAt = accountCreatedAt.toISOString();
    }

    if (partnerVerification) {
      payload.verificationStatus = partnerVerification.verificationStatus;
      payload.verificationCompletedAt =
        partnerVerification.verificationCompletedAt?.toISOString() ?? null;
      payload.partnerProfileCompleted =
        partnerVerification.partnerProfileCompleted;
    }

    return payload;
  }

  private async signJwt(
    payload: AuthJwtPayload,
    expiresIn: string,
  ): Promise<string> {
    if (typeof this.jwtService.signAsync === 'function') {
      return this.jwtService.signAsync(payload, {
        expiresIn: expiresIn as any,
      });
    }

    return this.jwtService.sign(payload, {
      expiresIn: expiresIn as any,
    });
  }

  private async validateRedisRefreshSession(
    userId: string,
    incomingHash: string,
    payload: AuthJwtPayload,
  ): Promise<ValidatedRefreshToken | null> {
    if (!this.shouldUseRedisRefreshSessions()) {
      return null;
    }

    const key = this.refreshSessionKey(userId);

    try {
      const session = await this.redisService!.getJson<RefreshSessionRecord>(
        key,
      );
      if (!session) {
        return null;
      }

      if (session.hash !== incomingHash) {
        await this.redisService!.del(key).catch(() => undefined);
        await this.accountService.removeRefreshToken(userId).catch(() => {});
        throw new UnauthorizedException('Refresh token does not match');
      }

      return {
        user: this.accountFromRefreshClaims(userId, session, payload),
        payload,
        oldHash: incomingHash,
        source: 'redis',
        session,
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }

      this.logger.warn(
        `Redis refresh validation skipped for user ${userId}: ${(error as Error).message}`,
      );
      return null;
    }
  }

  private async getPartnerVerificationInfo(
    accountId: string,
  ): Promise<PartnerVerificationInfo | null> {
    const cacheKey = `cache:partner:verification:v1:${accountId}`;
    if (this.redisService && this.partnerVerificationCacheTtlSeconds > 0) {
      try {
        const cached =
          await this.redisService.getJson<PartnerVerificationInfo>(cacheKey);
        if (cached) {
          return this.hydratePartnerVerificationInfo(cached);
        }
      } catch (error) {
        this.logger.warn(
          `Partner verification cache read skipped for ${accountId}: ${(error as Error).message}`,
        );
      }
    }

    const partnerProfile = await this.partnerService.getPartnerProfile(
      accountId,
    );
    if (!partnerProfile) {
      return null;
    }

    const info: PartnerVerificationInfo = {
      verificationStatus: partnerProfile.verificationStatus,
      verificationCompletedAt: partnerProfile.verificationCompletedAt,
      partnerProfileCompleted:
        this.partnerService.isPartnerProfileCompleted(partnerProfile),
    };

    if (this.redisService && this.partnerVerificationCacheTtlSeconds > 0) {
      await this.redisService
        .setJson(cacheKey, info, this.partnerVerificationCacheTtlSeconds)
        .catch((error) => {
          this.logger.warn(
            `Partner verification cache write skipped for ${accountId}: ${(error as Error).message}`,
          );
        });
    }

    return info;
  }

  private hydratePartnerVerificationInfo(
    value: PartnerVerificationInfo,
  ): PartnerVerificationInfo {
    return {
      ...value,
      verificationCompletedAt: value.verificationCompletedAt
        ? new Date(value.verificationCompletedAt)
        : null,
    };
  }

  private async persistRefreshSession(
    userId: string,
    refreshToken: string,
    payload: AuthJwtPayload,
  ): Promise<void> {
    const refreshHash = this.hashRefreshToken(refreshToken);

    if (this.shouldUseRedisRefreshSessions()) {
      try {
        await this.redisService!.setJson(
          this.refreshSessionKey(userId),
          this.buildRefreshSessionRecord(refreshHash, payload),
          this.refreshTtlSeconds,
        );

        if (this.refreshDualWrite) {
          await this.accountService.setRefreshTokenHash(userId, refreshHash);
        }
        return;
      } catch (error) {
        this.logger.warn(
          `Redis refresh session write failed for user ${userId}: ${(error as Error).message}`,
        );

        if (!this.refreshDbFallback) {
          throw error;
        }
      }
    }

    await this.accountService.setRefreshTokenHash(userId, refreshHash);
  }

  private async rotateRefreshSession(
    validation: ValidatedRefreshToken,
    newRefreshToken: string,
    nextPayload: AuthJwtPayload,
  ): Promise<void> {
    const newHash = this.hashRefreshToken(newRefreshToken);

    if (validation.source === 'redis') {
      if (!this.shouldUseRedisRefreshSessions()) {
        throw new UnauthorizedException('Refresh token rotation unavailable');
      }

      try {
        const result = await this.redisService!.compareJsonHashAndSet(
          this.refreshSessionKey(validation.user.id),
          validation.oldHash,
          this.buildRefreshSessionRecord(newHash, nextPayload),
          this.refreshTtlSeconds,
        );

        if (result === 'ok') {
          if (this.refreshDualWrite) {
            await this.accountService.setRefreshTokenHash(
              validation.user.id,
              newHash,
            );
          }
          return;
        }

        if (result === 'missing') {
          throw new UnauthorizedException('Refresh token revoked');
        }

        await this.deleteRedisRefreshSession(validation.user.id);
        await this.accountService
          .removeRefreshToken(validation.user.id)
          .catch(() => {});
        throw new UnauthorizedException('Refresh token does not match');
      } catch (error) {
        if (error instanceof UnauthorizedException) {
          throw error;
        }

        this.logger.warn(
          `Redis refresh rotation failed for user ${validation.user.id}: ${(error as Error).message}`,
        );
        throw new UnauthorizedException('Refresh token rotation failed');
      }
    }

    await this.persistRefreshSession(
      validation.user.id,
      newRefreshToken,
      nextPayload,
    );
  }

  private async deleteRedisRefreshSession(userId: string): Promise<void> {
    if (!this.shouldUseRedisRefreshSessions()) {
      return;
    }

    try {
      await this.redisService!.del(this.refreshSessionKey(userId));
    } catch (error) {
      this.logger.warn(
        `Redis refresh session delete failed for user ${userId}: ${(error as Error).message}`,
      );
    }
  }

  private accountFromRefreshClaims(
    userId: string,
    session: RefreshSessionRecord,
    payload: AuthJwtPayload,
  ): Account {
    const email = session.email ?? payload.email;
    const role = session.role ?? payload.role;

    if (!email || !role) {
      throw new UnauthorizedException('Invalid token payload');
    }

    return {
      id: userId,
      email,
      role,
      isActive: true,
      userProfile: this.userProfileFromClaims(session),
    } as Account;
  }

  private userProfileFromClaims(
    claims: Pick<
      AuthJwtPayload,
      'firstName' | 'lastName' | 'profileCompleted'
    >,
  ): UserProfile | undefined {
    const hasProfileClaims =
      claims.firstName !== undefined ||
      claims.lastName !== undefined ||
      claims.profileCompleted !== undefined;

    if (!hasProfileClaims) {
      return undefined;
    }

    return {
      firstName: claims.firstName,
      lastName: claims.lastName,
      profileCompleted: claims.profileCompleted ?? false,
    } as UserProfile;
  }

  private buildRefreshSessionRecord(
    refreshHash: string,
    payload: AuthJwtPayload,
  ): RefreshSessionRecord {
    const issuedAt = new Date();
    const expiresAt = new Date(
      issuedAt.getTime() + this.refreshTtlSeconds * 1000,
    );

    return {
      ...payload,
      hash: refreshHash,
      issuedAt: issuedAt.toISOString(),
      expiresAt: expiresAt.toISOString(),
    };
  }

  private shouldUseRedisRefreshSessions(): boolean {
    return this.refreshSessionStore === 'redis' && !!this.redisService;
  }

  private refreshSessionKey(userId: string): string {
    return `auth:refresh:v1:${userId}`;
  }

  private hashRefreshToken(refreshToken: string): string {
    return createHash('sha256').update(refreshToken).digest('hex');
  }

  private parseDurationSeconds(value: string, fallbackSeconds: number): number {
    const trimmed = value.trim();
    const numeric = Number(trimmed);
    if (Number.isFinite(numeric) && numeric > 0) {
      return numeric;
    }

    const match = /^(\d+)\s*([smhdw])$/i.exec(trimmed);
    if (!match) {
      return fallbackSeconds;
    }

    const amount = Number(match[1]);
    const unit = match[2].toLowerCase();
    const multipliers: Record<string, number> = {
      s: 1,
      m: 60,
      h: 60 * 60,
      d: 24 * 60 * 60,
      w: 7 * 24 * 60 * 60,
    };

    return amount * multipliers[unit];
  }

  /**
   * Logs out the current user by invalidating their refresh token.
   * Business logic moved from controller per enterprise pattern §10.
   * @param userId - The user's ID
   * @returns Logout confirmation
   */
  async logout(userId?: string): Promise<LogoutResponseDto> {
    try {
      if (userId) {
        await this.deleteRedisRefreshSession(userId);
        await this.accountService.removeRefreshToken(userId);
        this.logger.log(`User logged out: ${userId}`);
      }
    } catch (error) {
      this.logger.warn(
        `Logout cleanup failed for user: ${userId}`,
        error.message,
      );
    }

    const response = new LogoutResponseDto();
    response.message = 'Logged out successfully';
    return response;
  }
}
