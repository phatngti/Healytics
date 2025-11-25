import { Controller, Post, Body, UseGuards, Req, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/request/register.dto';
import { LocalAuthGuard } from './local-auth.guard';
import { ApiBody, ApiCreatedResponse, ApiOkResponse } from '@nestjs/swagger';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import { AccountService } from '../account/account.service';
import { JwtAuthGuard } from './jwt-auth.guard';
import { Public } from './public.decorator';
import { ApiTags } from '@nestjs/swagger';
import { LoginDto } from './dto/request/login.dto';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private accountService: AccountService,
  ) {}

  @Public()
  @ApiBody({ type: RegisterDto })
  @ApiCreatedResponse({ description: 'Registration returns access and refresh tokens', type: AuthTokensDto })
  @Post('register')

  async register(@Body() dto: RegisterDto): Promise<AuthTokensDto> {
    return this.authService.register(dto);
  }


  @Public()
  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({ description: 'Login returns access and refresh tokens', type: AuthTokensDto })
  @HttpCode(200)
  @Post('login')
  async login(@Req() req): Promise<AuthTokensDto> {
    // passport attaches user to req.user
    return this.authService.login(req.user);
  }

  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Post('logout')
  @ApiOkResponse({ description: 'Logout confirmation', type: LogoutResponseDto })
  async logout(@Req() req): Promise<LogoutResponseDto> {
    // revoke refresh token in DB if user present
    try {
      const uid = req.user?.id;
      if (uid) await this.accountService.removeRefreshToken(uid);
    } catch (_) {}

    //return req.logout();
    return { message: 'Logged out successfully' } as LogoutResponseDto;

    // return new Promise((resolve, reject) => {
    //     req.logout((err) => {
    //         if (err) return reject(err);
    //         req.session?.destroy((e) => (e ? reject(e) : resolve({ ok: true })));
    //     });
    // });
  }

  @HttpCode(200)
  @Post('refresh')
  @ApiOkResponse({ description: 'Refresh returns new pair of tokens', type: AuthTokensDto })
  async refresh(@Body('refresh_token') refresh_token: string): Promise<AuthTokensDto> {
    return this.authService.refresh(refresh_token);
  }
}
