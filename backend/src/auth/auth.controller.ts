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
import { CheckEmailDto } from './dto/request/check-email.dto';
import { ForgotPasswordDto } from './dto/request/forgot-password.dto';
import { ResetPasswordDto } from './dto/request/reset-password.dto';
import { ValidatePasswordResetCodeDto } from './dto/request/validate-password-reset-code.dto';
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
import { CheckEmailResponseDto } from './dto/response/check-email-response.dto';
import { LogoutResponseDto } from './dto/response/logout-response.dto';
import { PasswordResetResponseDto } from './dto/response/password-reset-response.dto';
import { ValidatePasswordResetCodeResponseDto } from './dto/response/validate-password-reset-code-response.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Public } from '../common/decorators/auth/public.decorator';
import { LoginDto } from './dto/request/login.dto';
import { AdminLoginDto } from './dto/request/admin-login.dto';
import { PartnerLoginDto } from './dto/request/partner-login.dto';
import { EmployeeLoginDto } from './dto/request/employee-login.dto';
import { PartnersService } from '@/partners/partners.service';
import { RegisterPartnerDto } from '@/partners/dto/request/register-partner.dto';
import { RegisterPartnerResponseDto } from '@/partners/dto/response/register-partner-response.dto';
import { AccountService } from '@/account/account.service';
import { ObservabilityMetricsService } from '@/observability/observability-metrics.service';

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
    private readonly accountService: AccountService,
    private readonly observabilityMetrics: ObservabilityMetricsService,
  ) {}

  // ============================================================================
  // Pre-Registration Validation
  // ============================================================================

  /**
   * Checks whether an email is already registered.
   * Used by the sign-up form to validate before submission.
   */
  @Post('check-email')
  @Public()
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Check if email is already registered',
    description:
      'Public endpoint for pre-registration email uniqueness validation.',
  })
  @ApiOkResponse({
    description: 'Email existence check result.',
    type: CheckEmailResponseDto,
  })
  @ApiBadRequestResponse({ description: 'Invalid email format.' })
  async checkEmail(@Body() dto: CheckEmailDto): Promise<CheckEmailResponseDto> {
    const exists = await this.accountService.checkEmailExists(dto.email);
    const response = new CheckEmailResponseDto();
    response.exists = exists;
    return response;
  }

  // ============================================================================
  // User Authentication (Mobile App / End Users)
  // ============================================================================

  /**
   * Registers a new user and returns authentication tokens.
   */
  @Post('user/register')
  @Public()
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
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
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as a user' })
  @ApiBody({ type: LoginDto })
  @ApiOkResponse({
    description: 'User login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account not authorized for user login.',
  })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginUser(@Req() req): Promise<AuthTokensDto> {
    const tokens = await this.authService.loginUser(req.user);
    await this.observabilityMetrics.recordLoginCcu(
      req.user?.role,
      req.user?.id,
    );
    return tokens;
  }

  /**
   * Sends a password reset code to a user account email.
   */
  @Post('user/forgot-password')
  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Request a user password reset code',
    description:
      'Returns a generic success response to avoid exposing whether an email is registered.',
  })
  @ApiOkResponse({
    description: 'Password reset request accepted.',
    type: PasswordResetResponseDto,
  })
  @ApiBadRequestResponse({ description: 'Invalid email format.' })
  async forgotUserPassword(
    @Body() dto: ForgotPasswordDto,
  ): Promise<PasswordResetResponseDto> {
    return this.authService.requestUserPasswordReset(dto);
  }

  /**
   * Validates a password reset code and returns a reset token.
   */
  @Post('user/validate-reset-code')
  @Public()
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Validate a user password reset code' })
  @ApiOkResponse({
    description: 'Password reset code verified.',
    type: ValidatePasswordResetCodeResponseDto,
  })
  @ApiBadRequestResponse({ description: 'Invalid or expired code.' })
  async validateUserPasswordResetCode(
    @Body() dto: ValidatePasswordResetCodeDto,
  ): Promise<ValidatePasswordResetCodeResponseDto> {
    return this.authService.validateUserPasswordResetCode(dto);
  }

  /**
   * Resets a user password using the token returned after OTP validation.
   */
  @Post('user/reset-password')
  @Public()
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reset a user password with validated reset token' })
  @ApiOkResponse({
    description: 'Password reset successfully.',
    type: PasswordResetResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Invalid or expired token, or invalid password.',
  })
  async resetUserPassword(
    @Body() dto: ResetPasswordDto,
  ): Promise<PasswordResetResponseDto> {
    return this.authService.resetUserPassword(dto);
  }

  // ============================================================================
  // Admin/Partner Authentication (Dashboard / Admin Portal)
  // ============================================================================

  /**
   * Registers a new business partner and returns authentication tokens.
   */
  @Post('partner/register')
  @Public()
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Register a new business partner',
    description:
      'Creates business entity, legal representative, and returns auth tokens immediately.',
  })
  @ApiCreatedResponse({
    description: 'Partner registration successful.',
    type: RegisterPartnerResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Invalid input data or address hierarchy.',
  })
  @ApiConflictResponse({ description: 'Email or tax code already exists.' })
  async registerPartner(
    @Body() dto: RegisterPartnerDto,
  ): Promise<RegisterPartnerResponseDto> {
    return this.partnersService.registerPartner(dto);
  }

  /**
   * Logs in a partner and returns authentication tokens.
   */
  @Post('partner/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as a partner' })
  @ApiBody({ type: PartnerLoginDto })
  @ApiOkResponse({
    description: 'Partner login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account not authorized for partner login.',
  })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginPartner(@Req() req): Promise<AuthTokensDto> {
    const tokens = await this.authService.loginPartner(req.user);
    await this.observabilityMetrics.recordLoginCcu(
      req.user?.role,
      req.user?.id,
    );
    return tokens;
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
  async refreshPartner(
    @Body() dto: RefreshTokenRequestDto,
  ): Promise<AuthTokensDto> {
    return this.authService.refreshPartner(dto.refresh_token);
  }

  /**
   * Logs in an admin and returns authentication tokens.
   */
  @Post('admin/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as admin' })
  @ApiBody({ type: AdminLoginDto })
  @ApiOkResponse({
    description: 'Admin login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account not authorized for admin login.',
  })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginAdmin(@Req() req): Promise<AuthTokensDto> {
    const tokens = await this.authService.loginAdmin(req.user);
    await this.observabilityMetrics.recordLoginCcu(
      req.user?.role,
      req.user?.id,
    );
    return tokens;
  }

  // ============================================================================
  // Employee Authentication (Employee App)
  // ============================================================================

  /**
   * Logs in an employee and returns authentication tokens.
   */
  @Post('employee/login')
  @Public()
  @UseGuards(LocalAuthGuard)
  @Throttle({ default: { limit: 1000, ttl: 60000 } })
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login as an employee' })
  @ApiBody({ type: EmployeeLoginDto })
  @ApiOkResponse({
    description: 'Employee login returns access and refresh tokens.',
    type: AuthTokensDto,
  })
  @ApiForbiddenResponse({
    description: 'Account not authorized for employee login.',
  })
  @ApiUnauthorizedResponse({ description: 'Invalid credentials.' })
  async loginEmployee(@Req() req): Promise<AuthTokensDto> {
    const tokens = await this.authService.loginEmployee(req.user);
    await this.observabilityMetrics.recordLoginCcu(
      req.user?.role,
      req.user?.id,
    );
    return tokens;
  }

  /**
   * Refreshes authentication tokens for an employee.
   */
  @Post('employee/refresh')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh employee tokens' })
  @ApiOkResponse({
    description: 'New pair of tokens.',
    type: AuthTokensDto,
  })
  @ApiUnauthorizedResponse({ description: 'Invalid or expired refresh token.' })
  async refreshEmployee(
    @Body() dto: RefreshTokenRequestDto,
  ): Promise<AuthTokensDto> {
    return this.authService.refresh(dto.refresh_token);
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
  @ApiOkResponse({
    description: 'Logout confirmation.',
    type: LogoutResponseDto,
  })
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
