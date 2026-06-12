import {
  Injectable,
  Logger,
  ConflictException,
  UnauthorizedException,
  ForbiddenException,
  BadRequestException,
  Optional,
} from '@nestjs/common';
import { AccountService } from '@/account/account.service';
import { RegisterDto } from './dto/request/register.dto';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import * as bcrypt from 'bcrypt';
import { createHash, randomBytes, randomInt } from 'crypto';
import { JwtService } from '@nestjs/jwt';
import { Role } from '@/account/enum/role.enum';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Account } from '@/common/entities/account.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { RedisService } from '@/redis/redis.service';
import { PasswordResetMailerService } from './password-reset-mailer.service';
import { ForgotPasswordDto } from './dto/request/forgot-password.dto';
import { ResetPasswordDto } from './dto/request/reset-password.dto';
import { ValidatePasswordResetCodeDto } from './dto/request/validate-password-reset-code.dto';
import { PasswordResetResponseDto } from './dto/response/password-reset-response.dto';
import { ValidatePasswordResetCodeResponseDto } from './dto/response/validate-password-reset-code-response.dto';

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

interface PasswordResetJwtPayload extends AuthJwtPayload {
  purpose?: 'password_reset';
  nonce?: string;
}

interface PasswordResetCodeRecord {
  accountId: string;
  codeHash: string;
  attempts: number;
  expiresAt: string;
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
  private readonly passwordResetExpires: string;
  private readonly passwordResetTtlSeconds: number;
  private readonly passwordResetCodeTtlSeconds: number;
  private readonly passwordResetMaxAttempts: number;
  private readonly localPasswordResetCodes = new Map<
    string,
    PasswordResetCodeRecord
  >();

  constructor(
    private readonly accountService: AccountService,
    private readonly jwtService: JwtService,
    private readonly partnerService: PartnersService,
    private readonly passwordResetMailer: PasswordResetMailerService,
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
    this.passwordResetExpires =
      process.env.AUTH_PASSWORD_RESET_EXPIRES_IN || '15m';
    this.passwordResetTtlSeconds = this.parseDurationSeconds(
      this.passwordResetExpires,
      15 * 60,
    );
    this.passwordResetCodeTtlSeconds = this.parsePositiveInteger(
      process.env.AUTH_PASSWORD_RESET_CODE_TTL_SECONDS,
      10 * 60,
    );
    this.passwordResetMaxAttempts = this.parsePositiveInteger(
      process.env.AUTH_PASSWORD_RESET_MAX_ATTEMPTS,
      5,
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
    const user = await this.accountService.createRegisteredUser(
      email,
      hash,
      dto.profile,
    );
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

  async requestUserPasswordReset(
    dto: ForgotPasswordDto,
  ): Promise<PasswordResetResponseDto> {
    const email = dto.email.trim().toLowerCase();
    const response = this.passwordResetRequestedResponse();
    const account = await this.accountService.findByEmail(email);

    if (!account || !account.isActive) {
      this.logger.warn(`Password reset requested for unknown email: ${email}`);
      return response;
    }

    const code = this.generatePasswordResetCode();
    await this.storePasswordResetCode(account, code);
    await this.passwordResetMailer.sendPasswordResetCode(account.email, code);
    this.logger.log(`Password reset code queued for account: ${account.id}`);
    return response;
  }

  async validateUserPasswordResetCode(
    dto: ValidatePasswordResetCodeDto,
  ): Promise<ValidatePasswordResetCodeResponseDto> {
    const email = dto.email.trim().toLowerCase();
    const account = await this.accountService.findByEmail(email);
    if (!account || !account.isActive) {
      throw new BadRequestException('Invalid or expired password reset code');
    }

    await this.consumePasswordResetCode(email, dto.code);
    const resetToken = await this.createPasswordResetToken(account);

    return {
      message: 'Password reset code verified.',
      resetToken,
    };
  }

  async resetUserPassword(
    dto: ResetPasswordDto,
  ): Promise<PasswordResetResponseDto> {
    const payload = this.verifyPasswordResetToken(dto.token);

    if (
      !payload.sub ||
      payload.purpose !== 'password_reset' ||
      !payload.nonce
    ) {
      throw new BadRequestException('Invalid password reset token');
    }

    await this.consumePasswordResetToken(payload.sub, payload.nonce, dto.token);

    const account = await this.accountService.findOne(payload.sub);
    if (!account || !account.isActive) {
      throw new BadRequestException('Invalid password reset token');
    }

    const passwordHash = await bcrypt.hash(dto.password, 10);
    await this.accountService.updatePasswordHash(account.id, passwordHash);
    await this.deleteRedisRefreshSession(account.id);

    const response = new PasswordResetResponseDto();
    response.message = 'Password reset successfully.';
    return response;
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

    const partnerVerification = await this.getPartnerVerificationInfo(userId);
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
      this.buildJwtPayload(
        user.id,
        user.email,
        user.role,
        profile,
        undefined,
        user.createdAt,
      ),
    );
    return tokens;
  }

  private generatePasswordResetCode(): string {
    if (process.env.NODE_ENV === 'test') {
      const fixedCode = process.env.TEST_PASSWORD_RESET_CODE?.trim();
      if (fixedCode && /^\d{6}$/.test(fixedCode)) {
        return fixedCode;
      }
    }
    return randomInt(0, 1000000).toString().padStart(6, '0');
  }

  private async storePasswordResetCode(
    account: Account,
    code: string,
  ): Promise<void> {
    const email = account.email.trim().toLowerCase();
    const key = this.passwordResetCodeKey(email);
    const record: PasswordResetCodeRecord = {
      accountId: account.id,
      codeHash: this.hashPasswordResetCode(email, code),
      attempts: 0,
      expiresAt: new Date(
        Date.now() + this.passwordResetCodeTtlSeconds * 1000,
      ).toISOString(),
    };

    if (this.redisService && this.passwordResetCodeTtlSeconds > 0) {
      await this.redisService.setJson(
        key,
        record,
        this.passwordResetCodeTtlSeconds,
      );
      return;
    }

    this.localPasswordResetCodes.set(key, record);
    this.logger.warn(
      'Redis is unavailable for password reset codes; using process-local storage.',
    );
  }

  private async consumePasswordResetCode(
    email: string,
    code: string,
  ): Promise<void> {
    const normalizedEmail = email.trim().toLowerCase();
    const key = this.passwordResetCodeKey(normalizedEmail);
    const record = await this.getPasswordResetCodeRecord(key);

    if (!record || new Date(record.expiresAt).getTime() <= Date.now()) {
      await this.deletePasswordResetCodeRecord(key);
      throw new BadRequestException('Invalid or expired password reset code');
    }

    const incomingHash = this.hashPasswordResetCode(normalizedEmail, code);
    if (record.codeHash !== incomingHash) {
      record.attempts += 1;
      if (record.attempts >= this.passwordResetMaxAttempts) {
        await this.deletePasswordResetCodeRecord(key);
      } else {
        await this.setPasswordResetCodeRecord(key, record);
      }
      throw new BadRequestException('Invalid or expired password reset code');
    }

    await this.deletePasswordResetCodeRecord(key);
  }

  private async getPasswordResetCodeRecord(
    key: string,
  ): Promise<PasswordResetCodeRecord | null> {
    if (this.redisService) {
      return this.redisService.getJson<PasswordResetCodeRecord>(key);
    }
    return this.localPasswordResetCodes.get(key) ?? null;
  }

  private async setPasswordResetCodeRecord(
    key: string,
    record: PasswordResetCodeRecord,
  ): Promise<void> {
    const ttlSeconds = Math.max(
      1,
      Math.ceil((new Date(record.expiresAt).getTime() - Date.now()) / 1000),
    );
    if (this.redisService) {
      await this.redisService.setJson(key, record, ttlSeconds);
      return;
    }
    this.localPasswordResetCodes.set(key, record);
  }

  private async deletePasswordResetCodeRecord(key: string): Promise<void> {
    if (this.redisService) {
      await this.redisService.del(key);
      return;
    }
    this.localPasswordResetCodes.delete(key);
  }

  private async createPasswordResetToken(account: Account): Promise<string> {
    const nonce = randomBytes(16).toString('hex');
    const payload: PasswordResetJwtPayload = {
      sub: account.id,
      email: account.email,
      role: account.role,
      purpose: 'password_reset',
      nonce,
    };
    const token = await this.signJwt(payload, this.passwordResetExpires);

    if (this.redisService && this.passwordResetTtlSeconds > 0) {
      await this.redisService.set(
        this.passwordResetKey(account.id, nonce),
        this.sha256(token),
        this.passwordResetTtlSeconds,
      );
    } else {
      this.logger.warn(
        'Redis is unavailable for password reset tokens; using JWT expiry only.',
      );
    }

    return token;
  }

  private verifyPasswordResetToken(token: string): PasswordResetJwtPayload {
    try {
      return this.jwtService.verify(token);
    } catch {
      throw new BadRequestException('Invalid or expired password reset token');
    }
  }

  private async consumePasswordResetToken(
    accountId: string,
    nonce: string,
    token: string,
  ): Promise<void> {
    if (!this.redisService) {
      return;
    }

    const key = this.passwordResetKey(accountId, nonce);
    const storedHash = await this.redisService.get(key);
    if (!storedHash || storedHash !== this.sha256(token)) {
      throw new BadRequestException('Invalid or expired password reset token');
    }
    await this.redisService.del(key);
  }

  private passwordResetRequestedResponse(): PasswordResetResponseDto {
    const response = new PasswordResetResponseDto();
    response.message =
      'If the email is registered, a password reset code has been sent.';
    return response;
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
      const fullName = [profile.firstName ?? '', profile.lastName ?? '']
        .join(' ')
        .trim();
      payload.name = fullName || undefined;
      payload.firstName = profile.firstName ?? undefined;
      payload.lastName = profile.lastName ?? undefined;
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
      const session =
        await this.redisService!.getJson<RefreshSessionRecord>(key);
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

    const partnerProfile =
      await this.partnerService.getPartnerProfile(accountId);
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
    claims: Pick<AuthJwtPayload, 'firstName' | 'lastName' | 'profileCompleted'>,
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

  private passwordResetKey(accountId: string, nonce: string): string {
    return `auth:password-reset:v1:${accountId}:${nonce}`;
  }

  private passwordResetCodeKey(email: string): string {
    return `auth:password-reset-code:v1:${this.sha256(email)}`;
  }

  private hashPasswordResetCode(email: string, code: string): string {
    return this.sha256(`${email}:${code}`);
  }

  private sha256(value: string): string {
    return createHash('sha256').update(value).digest('hex');
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

  private parsePositiveInteger(
    value: string | undefined,
    fallback: number,
  ): number {
    const numeric = Number(value);
    if (!Number.isFinite(numeric) || numeric <= 0) {
      return fallback;
    }
    return Math.floor(numeric);
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
