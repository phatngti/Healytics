import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  HttpCode,
  HttpStatus,
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
  ApiBadRequestResponse,
  ApiConflictResponse,
  ApiTags,
  ApiOperation,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AuthTokensDto } from './dto/response/auth-tokens-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Public } from '../common/decorators/auth/public.decorator';
import { LoginDto } from './dto/request/login.dto';
import { AdminLoginDto } from './dto/request/admin-login.dto';
import { PartnerLoginDto } from './dto/request/partner-login.dto';
import { PartnersService } from '@/partners/partners.service';
import { RegisterPartnerDto } from '@/partners/dto/request/register-partner.dto';
import { RegisterPartnerResponseDto } from '@/partners/dto/response/register-partner-response.dto';

/**
 * Controller for authentication endpoints.
 * Handles user/admin/partner login, registration, and token management.
 *
 * Security: All endpoints are @Public() (no JWT required).
 * Rate limiting: Applied to all login/register endpoints.
 * Route prefix: /v1/auth
 */
@ApiTags('Authentication')
@Controller({ path: 'auth', version: '1' })
export class AuthController {
  constructor(
    private authService: AuthService,
    @Inject(forwardRef(() => PartnersService))
    private partnersService: PartnersService,
  ) {}

  // ============================================================================
  // User Authentication (Mobile App / End Users)
  // ============================================================================

  /**
   * Registers a new user and returns authentication tokens.
   */
  @Post('user/register')
  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @ApiOperation({ summary: 'Register a new user' })
  @ApiCreatedResponse({
    description: 'Registration returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiConflictResponse({ description: 'Email already in use.' })
  async registerUser(@Body() dto: RegisterDto): Promise<AuthTokensDto> {
    return this.authService.register(dto);
  }

  /**
   * Logs in a user and returns authentication tokens.
   */
  @Post('user/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as a user' })
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({
    description: 'User login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({ description: 'Account not authorized for user login.' })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginUser(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginUser(req.user);
  }

  // ============================================================================
  // Admin/Partner Authentication (Dashboard / Admin Portal)
  // ============================================================================

  /**
   * Registers a new business partner and returns authentication tokens.
   */
  @Post('partner/register')
  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Register a new business partner',
    description: 'Creates business entity, legal representative, and returns auth tokens immediately.',
  })
  @ApiCreatedResponse({
    description: 'Partner registration successful.',
    type: RegisterPartnerResponseDto,
  })
  @ApiBadRequestResponse({ description: 'Invalid input data or address hierarchy.' })
  @ApiConflictResponse({ description: 'Email or tax code already exists.' })
  async registerPartner(@Body() dto: RegisterPartnerDto): Promise<RegisterPartnerResponseDto> {
    return this.partnersService.registerPartner(dto);
  }

  /**
   * Logs in a partner and returns authentication tokens.
   */
  @Post('partner/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as a partner' })
  @ApiBody({ type: PartnerLoginDto })
  @ApiOkResponse({
    description: 'Partner login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({ description: 'Account not authorized for partner login.' })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginPartner(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginPartner(req.user);
  }

  /**
   * Refreshes authentication tokens for a partner, including verification info.
   */
  @Post('partner/refresh')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh partner tokens with verification info' })
  @ApiOkResponse({
    description: 'New pair of tokens with partner verification info.',
    type: AuthTokensDto,
  })
  @ApiUnauthorizedResponse({ description: 'Invalid or expired refresh token.' })
  async refreshPartner(@Body() dto: RefreshTokenRequestDto): Promise<AuthTokensDto> {
    return this.authService.refreshPartner(dto.refresh_token);
  }

  /**
   * Logs in an admin and returns authentication tokens.
   */
  @Post('admin/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as admin' })
  @ApiBody({ type: AdminLoginDto })
  @ApiOkResponse({
    description: 'Admin login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({ description: 'Account not authorized for admin login.' })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginAdmin(@Req() req): Promise<AuthTokensDto> {
    return this.authService.loginAdmin(req.user);
  }

  // ============================================================================
  // Common Authentication Endpoints
  // ============================================================================

  /**
   * Logs out the current user by invalidating their refresh token.
   */
  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Logout current user' })
  @ApiOkResponse({ description: 'Logout confirmation.', type: LogoutResponseDto })
  async logout(@Req() req): Promise<LogoutResponseDto> {
    return this.authService.logout(req.user?.id);
  }

  /**
   * Refreshes authentication tokens using a valid refresh token.
   */
  @Post('refresh')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh authentication tokens' })
  @ApiOkResponse({
    description: 'New pair of tokens.',
    type: AuthTokensDto,
  })
  @ApiUnauthorizedResponse({ description: 'Invalid or expired refresh token.' })
  async refresh(@Body() dto: RefreshTokenRequestDto): Promise<AuthTokensDto> {
    return this.authService.refresh(dto.refresh_token);
  }
}
