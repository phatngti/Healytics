import { Controller, Post, Body, UseGuards, Req } from '@nestjs/common';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { LocalAuthGuard } from './local-auth.guard';
import { AccountService } from '../account/account.service';

@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService, private accountService: AccountService) {}

    @Post('register')
    async register(@Body() dto: RegisterDto) {
        return this.authService.register(dto.email, dto.password);
    }

    @UseGuards(LocalAuthGuard)
    @Post('login')
    async login(@Req() req) {
        // passport attaches user to req.user
        return this.authService.login(req.user);

    }

    @UseGuards(LocalAuthGuard)
    @Post('logout')
    async logout(@Req() req) {
        // revoke refresh token in DB if user present
        try {
            const uid = req.user?.id as string | undefined;
            if (uid) await this.accountService.removeRefreshToken(uid);
        } catch (_) {}

        return new Promise((resolve, reject) => {
            req.logout((err) => {
                if (err) return reject(err);
                req.session?.destroy((e) => (e ? reject(e) : resolve({ ok: true })));
            });
        });
    }


}