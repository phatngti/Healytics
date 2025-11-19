import { Injectable, ConflictException, UnauthorizedException } from '@nestjs/common';
import { AccountService } from '../account/account.service';
import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';


@Injectable()
export class AuthService {
    constructor(private accountService: AccountService,
            private jwtService: JwtService

    ) {}

    private async createTokensForUser(userId: string, email?: string) {
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
        };
    }

    async register(email: string, password: string) {
        const existing = await this.accountService.findByEmail(email);
        if (existing) {
            throw new ConflictException('Email already in use');
        }
        const hash = await bcrypt.hash(password, 10);
        const user = await this.accountService.create({ email, passwordHash: hash });

        const tokens = await this.createTokensForUser(user.id, user.email);
        const { passwordHash, refreshTokenHash, ...rest } = user as any;
        return {
            //user: rest,
            ...tokens,
        };
    }

    async validateUser(email: string, password: string) {
        const user = await this.accountService.findByEmail(email);
        if (!user) return null;
        const isMatch = await bcrypt.compare(password, user.passwordHash || '');
        if (!isMatch) return null;
        const { passwordHash, ...rest } = user as any;
        return rest;
    }

    async login(user: any) {
        const userId = (user && (user.id || user.userId || user.sub)) as string;
        const userEmail = (user && (user.email || user.username)) as string | undefined;
        if (!userId) {
            throw new UnauthorizedException();
        }
        const tokens = await this.createTokensForUser(userId, userEmail);
        const { passwordHash, refreshTokenHash, ...rest } = user as any;
        return {
            //user: rest,
            ...tokens,
        };
    }
}