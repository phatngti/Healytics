import { Injectable, ConflictException, UnauthorizedException } from '@nestjs/common';
import { AccountService } from '../account/account.service';
import * as bcrypt from 'bcryptjs';
import { JwtService } from '@nestjs/jwt';


@Injectable()
export class AuthService {
    constructor(private accountService: AccountService,
            private jwtService: JwtService

    ) {}

    async register(email: string, password: string) {
        const existing = await this.accountService.findByEmail(email);
        if (existing) {
            throw new ConflictException('Email already in use');
        }
        const hash = await bcrypt.hash(password, 10);
        const user = await this.accountService.create({ email, passwordHash: hash });
        const { passwordHash, ...rest } = user as any;
        return rest;
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
        const payload = { username: user.username, sub: user.userId };
        return {
            access_token: this.jwtService.sign(payload),
        };
    }
}