import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { AccountService } from '@/account/account.service';
import { JwtService } from '@nestjs/jwt';
import { PartnersService } from '@/partners/partners.service';
import { Role } from '@/account/enum/role.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PasswordResetMailerService } from './password-reset-mailer.service';

describe('AuthService', () => {
  let service: AuthService;

  const mockAccountService = {
    findByEmail: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    setRefreshTokenHash: jest.fn(),
    updatePasswordHash: jest.fn(),
  };

  const mockJwtService = {
    sign: jest.fn(),
    verify: jest.fn(),
  };

  const mockPartnersService = {
    getPartnerProfile: jest.fn(),
  };

  const mockPasswordResetMailer = {
    sendPasswordResetEmail: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: AccountService, useValue: mockAccountService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: PartnersService, useValue: mockPartnersService },
        {
          provide: PasswordResetMailerService,
          useValue: mockPasswordResetMailer,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should include partnerProfileCompleted in partner tokens', async () => {
    mockJwtService.sign.mockReturnValue('signed-token');
    mockAccountService.setRefreshTokenHash.mockResolvedValue(undefined);

    await service.createTokensForUser(
      'account-uuid',
      'partner@test.com',
      Role.HEALTH_PARTNER,
      undefined,
      {
        verificationStatus: PartnerVerificationStatus.APPROVED,
        verificationCompletedAt: new Date('2026-04-10T00:00:00.000Z'),
        partnerProfileCompleted: true,
      },
    );

    expect(mockJwtService.sign).toHaveBeenCalledWith(
      expect.objectContaining({
        verificationStatus: PartnerVerificationStatus.APPROVED,
        partnerProfileCompleted: true,
      }),
      expect.any(Object),
    );
  });

  it('should send reset email for active account', async () => {
    mockJwtService.sign.mockReturnValue('reset-token');
    mockAccountService.findByEmail.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      isActive: true,
    });

    const result = await service.requestUserPasswordReset({
      email: 'USER@Test.com',
    });

    expect(result.message).toContain('password reset link has been sent');
    expect(mockPasswordResetMailer.sendPasswordResetEmail).toHaveBeenCalledWith(
      'user@test.com',
      'reset-token',
    );
  });

  it('should not reveal unknown reset emails', async () => {
    mockAccountService.findByEmail.mockResolvedValue(null);

    const result = await service.requestUserPasswordReset({
      email: 'missing@test.com',
    });

    expect(result.message).toContain('password reset link has been sent');
    expect(
      mockPasswordResetMailer.sendPasswordResetEmail,
    ).not.toHaveBeenCalled();
  });

  it('should reset password with valid reset token', async () => {
    mockJwtService.verify.mockReturnValue({
      sub: 'account-uuid',
      purpose: 'password_reset',
      nonce: 'nonce',
    });
    mockAccountService.findOne.mockResolvedValue({
      id: 'account-uuid',
      isActive: true,
    });
    mockAccountService.updatePasswordHash.mockResolvedValue(undefined);

    const result = await service.resetUserPassword({
      token: 'reset-token',
      password: 'Password123!',
    });

    expect(result.message).toBe('Password reset successfully.');
    expect(mockAccountService.updatePasswordHash).toHaveBeenCalledWith(
      'account-uuid',
      expect.any(String),
    );
  });
});
