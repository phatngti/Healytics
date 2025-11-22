import { Injectable, ConflictException, UnauthorizedException } from '@nestjs/common';
import { AccountService } from '../account/account.service';
import { RegisterDto } from './dto/register.dto';
import { AuthTokensDto } from './dto/auth-tokens.dto';
import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';


@Injectable()
export class AuthService {
    constructor(private accountService: AccountService,
            private jwtService: JwtService

    ) {}

    private async createTokensForUser(userId: string, email?: string): Promise<AuthTokensDto> {
        const payload = { sub: userId, email };
        const accessExpires = process.env.JWT_EXPIRES_IN || '3600s';
        const refreshExpires = process.env.JWT_REFRESH_EXPIRES_IN || '7d';

        const access_token = this.jwtService.sign(payload as any, { expiresIn: accessExpires as any });
        const refresh_token = this.jwtService.sign(payload as any, { expiresIn: refreshExpires as any });

        const refreshHash = await bcrypt.hash(refresh_token, 10);
        await this.accountService.setRefreshTokenHash(userId, refreshHash);

        return {
            access_token,
            access_expires_in: accessExpires,
            refresh_token,
            refresh_expires_in: refreshExpires,
        } as AuthTokensDto;
    }

    async register(dto: RegisterDto): Promise<AuthTokensDto> {
        const existing = await this.accountService.findByEmail(dto.email);
        if (existing) {
            throw new ConflictException('Email already in use');
        }
        const hash = await bcrypt.hash(dto.password, 10);

        const createData: any = { email: dto.email, passwordHash: hash };
                if (dto.profile) {
                    // attach profile object; Account entity has cascade on userProfile
                    const profileData: any = { ...dto.profile };
                    if (profileData.dateOfBirth) {
                        // ensure date type for the entity
                        profileData.dateOfBirth = new Date(profileData.dateOfBirth);
                    }
                    createData.userProfile = profileData;
                }

        const user = await this.accountService.create(createData);

        const tokens = await this.createTokensForUser(user.id, user.email);
        const { passwordHash, refreshTokenHash, ...rest } = user as any;
        return tokens;
    }

    async validateUser(email: string, password: string) {
        const user = await this.accountService.findByEmail(email);
        if (!user) return null;
        const isMatch = await bcrypt.compare(password, user.passwordHash || '');
        if (!isMatch) return null;
        const { passwordHash, ...rest } = user as any;
        return rest;
    }

    async login(user: any): Promise<AuthTokensDto> {
        const userId = user.id ;
        const userEmail = user.email;
        if (!userId) {
            throw new UnauthorizedException();
        }
        const tokens = await this.createTokensForUser(userId, userEmail);
        return tokens;
    }
    
    async refresh(refreshToken: string): Promise<AuthTokensDto> {
        if (!refreshToken) throw new UnauthorizedException('No refresh token provided');
        let payload: any;
        try {
            payload = this.jwtService.verify(refreshToken);
        } catch (e) {
            throw new UnauthorizedException('Invalid refresh token');
        }

        const userId = payload?.sub;
        if (!userId) throw new UnauthorizedException('Invalid token payload');

        const user = await this.accountService.findOneWithRefreshHash(userId);
        if (!user || !user.refreshTokenHash) throw new UnauthorizedException('Refresh token revoked');

        const match = await bcrypt.compare(refreshToken, user.refreshTokenHash || '');
        if (!match) {
            // possible reuse or tampering: remove stored refresh token to revoke
            await this.accountService.removeRefreshToken(userId).catch(() => {});
            throw new UnauthorizedException('Refresh token does not match');
        }

        // rotate tokens
        const tokens = await this.createTokensForUser(userId, user.email);
        return tokens;
    }
}