import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  HttpCode,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/request/register.dto';
import { RefreshTokenRequestDto } from './dto/request/refresh-token-request.dto';
import { LocalAuthGuard } from './guards/local-auth.guard';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiForbiddenResponse,
  ApiUnauthorizedResponse,
  ApiTags,
  ApiOperation,
  ApiResponse,
} from '@nestjs/swagger';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import { AccountService } from '@/account/account.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Public } from './decorators/public.decorator';
import { LoginDto } from './dto/request/login.dto';
import { AdminLoginDto } from './dto/request/admin-login.dto';
import { PartnerLoginDto } from './dto/request/partner-login.dto';
import { PartnersService } from '@/partners/partners.service';
import { RegisterPartnerDto } from '@/partners/dto/request/register-partner.dto';
import { RegisterPartnerResponseDto } from '@/partners/dto/response/register-partner-response.dto';

/**
 * Controller for authentication endpoints.
 * Handles user/admin/partner login, registration, and token management.
 */
@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private accountService: AccountService,
    @Inject(forwardRef(() => PartnersService))
    private partnersService: PartnersService,
  ) { }

  // ============================================================================
  // User Authentication (Mobile App / End Users)
  // ============================================================================

  /**
   * Registers a new user and returns authentication tokens.
   */
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

  /**
   * Logs in a user and returns authentication tokens.
   */
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

  /**
   * Registers a new business partner and returns authentication tokens.
   */
  @Public()
  @HttpCode(201)
  @ApiOperation({
    summary: 'Register a new business partner',
    description: 'Creates business entity, legal representative, and returns auth tokens immediately',
  })
  @ApiCreatedResponse({
    description: 'Partner registration successful - returns tokens and business data',
    type: RegisterPartnerResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid input data or address hierarchy',
  })
  @ApiResponse({
    status: 409,
    description: 'Email or tax code already exists',
  })
  @Post('partner/register')
  async registerPartner(@Body() dto: RegisterPartnerDto): Promise<RegisterPartnerResponseDto> {
    return this.partnersService.registerPartner(dto);
  }

  /**
   * Logs in a partner and returns authentication tokens.
   */
  @Public()
  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: PartnerLoginDto })
  @ApiOkResponse({
    description: 'Partner login returns access and refresh tokens',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account is not authorized for partner login',
  })
  @ApiUnauthorizedResponse({
    description: 'Invalid credentials',
  })
  @HttpCode(200)
  @Post('partner/login')
  async loginPartner(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginPartner(req.user);
  }

  /**
   * Logs in an admin and returns authentication tokens.
   */
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

  /**
   * Logs out the current user by invalidating their refresh token.
   */
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
    } catch (_) { }

    return { message: 'Logged out successfully' };
  }

  /**
   * Refreshes authentication tokens using a valid refresh token.
   */
  @Public()
  @HttpCode(200)
  @Post('refresh')
  @ApiBody({ type: RefreshTokenRequestDto })
  @ApiOkResponse({
    description: 'Refresh returns new pair of tokens',
    type: AuthTokensDto,
  })
  async refresh(@Body() dto: RefreshTokenRequestDto): Promise<AuthTokensDto> {
    return this.authService.refresh(dto.refresh_token);
  }
}
