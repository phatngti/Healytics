import {
  Injectable,
  Logger,
  ConflictException,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import { AccountService } from '@/account/account.service';
import { RegisterDto } from './dto/request/register.dto';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';
import { Role } from '@/account/enum/role.enum';
import { UserProfile } from '@/account/entities/user-profile.entity';
import { Account } from '@/account/entities/account.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';

/** Roles allowed for admin/partner login */
const ADMIN_ROLES: Role[] = [Role.ADMIN, Role.HEALTH_PARTNER, Role.EMPLOYEE];

/** Roles allowed for user login */
const USER_ROLES: Role[] = [Role.USER];

/** Partner verification info for JWT payload */
export interface PartnerVerificationInfo {
  verificationStatus: PartnerVerificationStatus;
  verificationCompletedAt: Date | null;
}

/** JWT payload structure */
interface AuthJwtPayload {
  sub: string;
  email?: string;
  role?: Role;
  firstName?: string;
  lastName?: string;
  profileCompleted?: boolean;
  verificationStatus?: PartnerVerificationStatus;
  verificationCompletedAt?: string | null;
}

/** Validated user from authentication */
export interface ValidatedUser {
  id: string;
  email: string;
  role: Role;
  userProfile?: UserProfile;
  roleNotAllowed?: boolean;
}

/**
 * Authentication service handling registration, login, and token management.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly accountService: AccountService,
    private readonly jwtService: JwtService,
    private readonly partnerService: PartnersService,
  ) { }

  /**
   * Creates access and refresh tokens for a user.
   * @param userId - The user's ID
   * @param email - The user's email
   * @param role - The user's role
   * @param profile - Optional user profile
   * @param partnerVerification - Optional partner verification info
   * @returns The generated tokens
   */
  async createTokensForUser(
    userId: string,
    email?: string,
    role?: Role,
    profile?: UserProfile,
    partnerVerification?: PartnerVerificationInfo,
  ): Promise<AuthTokensDto> {
    const payload: AuthJwtPayload = { sub: userId, email, role };
    if (profile) {
      payload.firstName = profile.firstName;
      payload.lastName = profile.lastName;
      payload.profileCompleted = profile.profileCompleted;
    }

    console.log('partnerVerification', partnerVerification);
    if (partnerVerification) {
      payload.verificationStatus = partnerVerification.verificationStatus;
      payload.verificationCompletedAt = partnerVerification.verificationCompletedAt?.toISOString() ?? null;
    }
    const accessExpires = process.env.JWT_EXPIRES_IN || '3600s';
    const refreshExpires = process.env.JWT_REFRESH_EXPIRES_IN || '7d';
    const access_token = this.jwtService.sign(payload, {
      expiresIn: accessExpires as any,
    });
    const refresh_token = this.jwtService.sign(payload, {
      expiresIn: refreshExpires as any,
    });
    const refreshHash = await bcrypt.hash(refresh_token, 10);
    await this.accountService.setRefreshTokenHash(userId, refreshHash);
    return {
      access_token,
      access_expires_in: accessExpires,
      refresh_token,
      refresh_expires_in: refreshExpires,
    } as AuthTokensDto;
  }

  /**
   * Registers a new user (USER role only).
   * @param dto - Registration data
   * @returns Authentication tokens
   */
  async register(dto: RegisterDto): Promise<AuthTokensDto> {
    const existing = await this.accountService.findByEmail(dto.email);
    if (existing) {
      throw new ConflictException('Email already in use');
    }
    const hash = await bcrypt.hash(dto.password, 10);
    const createData: Partial<Account> = {
      email: dto.email,
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
  async validateUser(email: string, password: string): Promise<ValidatedUser | null> {
    const user = await this.accountService.findByEmail(email);
    if (!user) return null;
    const isMatch = await bcrypt.compare(password, user.passwordHash || '');
    if (!isMatch) return null;
    const { passwordHash, ...rest } = user as Account & { passwordHash?: string };
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
      throw new UnauthorizedException();
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
    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile);
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
      throw new UnauthorizedException();
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
    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile);
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
      throw new UnauthorizedException();
    }

    if (user.roleNotAllowed || userRole !== Role.HEALTH_PARTNER) {
      throw new ForbiddenException(
        'This account is not authorized for partner login.',
      );
    }

    const partnerProfile = await this.partnerService.getPartnerProfile(userId);
    if (!partnerProfile) {
      throw new ForbiddenException(
        'This account is not authorized for partner login.',
      );
    }

    this.logger.log(`Partner login: ${userId}`);
    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile, {
      verificationCompletedAt: partnerProfile.verificationCompletedAt,
      verificationStatus: partnerProfile.verificationStatus,
    });
  }



  /**
   * Refreshes authentication tokens.
   * @param refreshToken - The refresh token
   * @returns New authentication tokens
   */
  async refresh(refreshToken: string): Promise<AuthTokensDto> {
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
    const user = await this.accountService.findOneWithRefreshHash(userId);
    if (!user || !user.refreshTokenHash) {
      throw new UnauthorizedException('Refresh token revoked');
    }
    const match = await bcrypt.compare(refreshToken, user.refreshTokenHash || '');
    if (!match) {
      await this.accountService.removeRefreshToken(userId).catch(() => { });
      throw new UnauthorizedException('Refresh token does not match');
    }
    this.logger.log(`Token refreshed for user: ${userId}`);
    const tokens = await this.createTokensForUser(
      userId,
      user.email,
      user.role,
      user.userProfile,
    );
    return tokens;
  }

  /**
   * Creates default admin account if none exists.
   */
  async createDefaultAdmin(): Promise<void> {
    const adminEmail = process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.com';
    const adminPassword = process.env.DEFAULT_ADMIN_PASSWORD || 'admin@123';
    const existingAdmin = await this.accountService.findByEmail(adminEmail);
    if (!existingAdmin) {
      this.logger.log(`Creating default admin account: ${adminEmail}`);
      const hashedPassword = await bcrypt.hash(adminPassword, 10);
      await this.accountService.create({
        email: adminEmail,
        passwordHash: hashedPassword,
        role: Role.ADMIN,
        isActive: true,
      });
      this.logger.log('Default admin account created successfully.');
    } else {
      this.logger.log('Admin account already exists.');
    }
  }
}
