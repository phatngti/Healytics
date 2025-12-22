import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  HttpCode,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/request/register.dto';
import { LocalAuthGuard } from './guards/local-auth.guard';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiForbiddenResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import { AccountService } from '@/account/account.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Public } from './decorators/public.decorator';
import { ApiTags } from '@nestjs/swagger';
import { LoginDto } from './dto/request/login.dto';
import { AdminLoginDto } from './dto/request/admin-login.dto';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private accountService: AccountService,
  ) {}

  // ============================================================================
  // User Authentication (Mobile App / End Users)
  // ============================================================================

  @Public()
  @ApiBody({ type: RegisterDto })
  @ApiCreatedResponse({
    description: 'Registration returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @Post('user/register')
  async registerUser(@Body() dto: RegisterDto): Promise<AuthTokensDto> {
    return this.authService.register(dto);
  }

  @Public()
  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({
    description: 'User login returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account is not authorized for user login',
  })
  @ApiUnauthorizedResponse({
    description: 'Invalid credentials',
  })
  @HttpCode(200)
  @Post('user/login')
  async loginUser(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginUser(req.user);
  }

  // ============================================================================
  // Admin/Partner Authentication (Dashboard / Admin Portal)
  // ============================================================================

  @Public()
  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: AdminLoginDto })
  @ApiOkResponse({
    description: 'Admin/Partner login returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account is not authorized for admin login',
  })
  @ApiUnauthorizedResponse({
    description: 'Invalid credentials',
  })
  @HttpCode(200)
  @Post('admin/login')
  async loginAdmin(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginAdmin(req.user);
  }

  // ============================================================================
  // Legacy Endpoints (for backward compatibility)
  // ============================================================================

  /**
   * @deprecated Use /auth/user/register instead
   */
  @Public()
  @ApiBody({ type: RegisterDto })
  @ApiCreatedResponse({
    description: 'Registration returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @Post('register')
  async register(@Body() dto: RegisterDto): Promise<AuthTokensDto> {
    return this.authService.register(dto);
  }

  /**
   * @deprecated Use /auth/user/login or /auth/admin/login instead
   */
  @Public()
  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({
    description: 'Login returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @HttpCode(200)
  @Post('login')
  async login(@Req() req): Promise<AuthTokensDto> {
    return this.authService.login(req.user);
  }

  // ============================================================================
  // Common Authentication Endpoints
  // ============================================================================

  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @Post('logout')
  @ApiOkResponse({
    description: 'Logout confirmation',
    type: LogoutResponseDto,
  })
  async logout(@Req() req): Promise<LogoutResponseDto> {
    try {
      const uid = req.user?.id;
      if (uid) await this.accountService.removeRefreshToken(uid);
    } catch (_) {}

    return { message: 'Logged out successfully' } as LogoutResponseDto;
  }

  @Public()
  @HttpCode(200)
  @Post('refresh')
  @ApiOkResponse({
    description: 'Refresh returns new pair of tokens',
    type: AuthTokensDto,
  })
  async refresh(
    @Body('refresh_token') refresh_token: string,
  ): Promise<AuthTokensDto> {
    return this.authService.refresh(refresh_token);
  }
}
