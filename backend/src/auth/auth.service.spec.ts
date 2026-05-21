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
  const originalNodeEnv = process.env.NODE_ENV;
  const originalFixedResetCode = process.env.TEST_PASSWORD_RESET_CODE;
  const restoreEnv = (key: string, value: string | undefined) => {
    if (value === undefined) {
      delete process.env[key];
    } else {
      process.env[key] = value;
    }
  };

  const mockAccountService = {
    findByEmail: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    createRegisteredUser: jest.fn(),
    checkEmailExists: jest.fn(),
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
    sendPasswordResetCode: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    restoreEnv('NODE_ENV', originalNodeEnv);
    restoreEnv('TEST_PASSWORD_RESET_CODE', originalFixedResetCode);
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

  afterEach(() => {
    restoreEnv('NODE_ENV', originalNodeEnv);
    restoreEnv('TEST_PASSWORD_RESET_CODE', originalFixedResetCode);
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

  it('should register a user through the explicit account/profile creation path', async () => {
    mockAccountService.checkEmailExists.mockResolvedValue(false);
    mockAccountService.createRegisteredUser.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      userProfile: {
        id: 'profile-uuid',
        firstName: 'Test',
        lastName: 'User',
      },
    });
    mockJwtService.sign.mockReturnValueOnce('access-token').mockReturnValueOnce(
      'refresh-token',
    );
    mockAccountService.setRefreshTokenHash.mockResolvedValue(undefined);

    const result = await service.register({
      email: ' USER@Test.com ',
      password: 'Password123!',
      profile: {
        firstName: 'Test',
        lastName: 'User',
      },
    });

    expect(result.access_token).toBe('access-token');
    expect(mockAccountService.createRegisteredUser).toHaveBeenCalledWith(
      'user@test.com',
      expect.any(String),
      expect.objectContaining({ firstName: 'Test' }),
    );
  });

  it('should send reset code for active account', async () => {
    mockAccountService.findByEmail.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      isActive: true,
    });

    const result = await service.requestUserPasswordReset({
      email: 'USER@Test.com',
    });

    expect(result.message).toContain('password reset code has been sent');
    expect(mockPasswordResetMailer.sendPasswordResetCode).toHaveBeenCalledWith(
      'user@test.com',
      expect.stringMatching(/^\d{6}$/),
    );
  });

  it('should use fixed reset code only in test environment', async () => {
    process.env.NODE_ENV = 'test';
    process.env.TEST_PASSWORD_RESET_CODE = '123456';
    mockAccountService.findByEmail.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      isActive: true,
    });

    await service.requestUserPasswordReset({
      email: 'user@test.com',
    });

    expect(mockPasswordResetMailer.sendPasswordResetCode).toHaveBeenCalledWith(
      'user@test.com',
      '123456',
    );
  });

  it('should not reveal unknown reset emails', async () => {
    mockAccountService.findByEmail.mockResolvedValue(null);

    const result = await service.requestUserPasswordReset({
      email: 'missing@test.com',
    });

    expect(result.message).toContain('password reset code has been sent');
    expect(
      mockPasswordResetMailer.sendPasswordResetCode,
    ).not.toHaveBeenCalled();
  });

  it('should validate reset code and return reset token', async () => {
    mockAccountService.findByEmail.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      isActive: true,
    });
    mockJwtService.sign.mockReturnValue('reset-token');

    await service.requestUserPasswordReset({ email: 'user@test.com' });
    const code = mockPasswordResetMailer.sendPasswordResetCode.mock.calls[0][1];

    const result = await service.validateUserPasswordResetCode({
      email: 'USER@test.com',
      code,
    });

    expect(result).toEqual({
      message: 'Password reset code verified.',
      resetToken: 'reset-token',
    });
    expect(mockJwtService.sign).toHaveBeenCalledWith(
      expect.objectContaining({
        sub: 'account-uuid',
        purpose: 'password_reset',
      }),
      expect.any(Object),
    );
  });

  it('should reject an invalid reset code', async () => {
    mockAccountService.findByEmail.mockResolvedValue({
      id: 'account-uuid',
      email: 'user@test.com',
      role: Role.USER,
      isActive: true,
    });

    await service.requestUserPasswordReset({ email: 'user@test.com' });

    await expect(
      service.validateUserPasswordResetCode({
        email: 'user@test.com',
        code: '000000',
      }),
    ).rejects.toThrow('Invalid or expired password reset code');
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
