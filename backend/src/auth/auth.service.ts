import {
  Injectable,
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

// Roles allowed for admin/partner login
const ADMIN_ROLES: Role[] = [Role.ADMIN, Role.HEALTH_PARTNER, Role.EMPLOYEE];

// Roles allowed for user login
const USER_ROLES: Role[] = [Role.USER];

@Injectable()
export class AuthService {
  constructor(
    private accountService: AccountService,
    private jwtService: JwtService,
  ) {}

  private async createTokensForUser(
    userId: string,
    email?: string,
    role?: Role,
    profile?: UserProfile,
  ): Promise<AuthTokensDto> {
    const payload: any = { sub: userId, email, role };
    
    if (profile) {
      payload.firstName = profile.firstName;
      payload.lastName = profile.lastName;
      payload.profileCompleted = profile.profileCompleted;
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
   * Register a new user (USER role only)
   */
  async register(dto: RegisterDto): Promise<AuthTokensDto> {
    const existing = await this.accountService.findByEmail(dto.email);
    if (existing) {
      throw new ConflictException('Email already in use');
    }
    const hash = await bcrypt.hash(dto.password, 10);

    const createData: any = {
      email: dto.email,
      passwordHash: hash,
      role: Role.USER, // Always set to USER for public registration
    };

    if (dto.profile) {
      const profileData: any = { ...dto.profile };
      if (profileData.dateOfBirth) {
        profileData.dateOfBirth = new Date(profileData.dateOfBirth);
      }
      createData.userProfile = profileData;
    }

    const user = await this.accountService.create(createData);
    const tokens = await this.createTokensForUser(
      user.id,
      user.email,
      user.role,
      user.userProfile,
    );
    return tokens;
  }

  /**
   * Validate user credentials
   */
  async validateUser(email: string, password: string) {
    const user = await this.accountService.findByEmail(email);
    if (!user) return null;
    const isMatch = await bcrypt.compare(password, user.passwordHash || '');
    if (!isMatch) return null;
    const { passwordHash, ...rest } = user as any;
    return rest;
  }

  /**
   * Validate user credentials and check role
   */
  async validateUserWithRole(
    email: string,
    password: string,
    allowedRoles: Role[],
  ) {
    const user = await this.validateUser(email, password);
    if (!user) return null;

    if (!allowedRoles.includes(user.role)) {
      return { ...user, roleNotAllowed: true };
    }

    return user;
  }

  /**
   * Login for regular users (USER role)
   */
  async loginUser(user: any): Promise<AuthTokensDto> {
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

    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile);
  }

  /**
   * Login for admin/partner users (ADMIN, HEALTH_PARTNER, EMPLOYEE roles)
   */
  async loginAdmin(user: any): Promise<AuthTokensDto> {
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

    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile);
  }

  /**
   * Legacy login (for backward compatibility, validates any role)
   * @deprecated Use loginUser or loginAdmin instead
   */
  async login(user: any): Promise<AuthTokensDto> {
    const userId = user.id;
    const userEmail = user.email;
    const userRole = user.role;

    if (!userId) {
      throw new UnauthorizedException();
    }

    return this.createTokensForUser(userId, userEmail, userRole, user.userProfile);
  }

  /**
   * Refresh tokens
   */
  async refresh(refreshToken: string): Promise<AuthTokensDto> {
    if (!refreshToken)
      throw new UnauthorizedException('No refresh token provided');

    let payload: any;
    try {
      payload = this.jwtService.verify(refreshToken);
    } catch (e) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const userId = payload?.sub;
    if (!userId) throw new UnauthorizedException('Invalid token payload');

    const user = await this.accountService.findOneWithRefreshHash(userId);
    if (!user || !user.refreshTokenHash)
      throw new UnauthorizedException('Refresh token revoked');

    const match = await bcrypt.compare(
      refreshToken,
      user.refreshTokenHash || '',
    );
    if (!match) {
      await this.accountService.removeRefreshToken(userId).catch(() => {});
      throw new UnauthorizedException('Refresh token does not match');
    }

    // Rotate tokens
    const tokens = await this.createTokensForUser(
      userId,
      user.email,
      user.role,
      user.userProfile,
    );
    return tokens;
  }

  /**
   * Create default admin account if none exists
   */
  async createDefaultAdmin() {
    const adminEmail = process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.com';
    const adminPassword = process.env.DEFAULT_ADMIN_PASSWORD || 'admin@123';

    const existingAdmin = await this.accountService.findByEmail(adminEmail);

    if (!existingAdmin) {
      console.log(`Creating default admin account: ${adminEmail}`);
      const hashedPassword = await bcrypt.hash(adminPassword, 10);
      await this.accountService.create({
        email: adminEmail,
        passwordHash: hashedPassword,
        role: Role.ADMIN,
        isActive: true,
      });
      console.log('Default admin account created successfully.');
    } else {
      console.log('Admin account already exists.');
    }
  }
}
