import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { AccountService } from '@/account/account.service';
import { JwtService } from '@nestjs/jwt';
import { PartnersService } from '@/partners/partners.service';

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
});
