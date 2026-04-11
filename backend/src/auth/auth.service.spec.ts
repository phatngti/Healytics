import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { AccountService } from '@/account/account.service';
import { JwtService } from '@nestjs/jwt';
import { PartnersService } from '@/partners/partners.service';
import { Role } from '@/account/enum/role.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

describe('AuthService', () => {
  let service: AuthService;

  const mockAccountService = {
    findByEmail: jest.fn(),
    create: jest.fn(),
    setRefreshTokenHash: jest.fn(),
  };

  const mockJwtService = {
    sign: jest.fn(),
  };

  const mockPartnersService = {
    getPartnerProfile: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: AccountService, useValue: mockAccountService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: PartnersService, useValue: mockPartnersService },
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
});
