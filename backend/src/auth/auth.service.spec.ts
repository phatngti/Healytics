import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { AccountService } from '@/account/account.service';
import { JwtService } from '@nestjs/jwt';
import { Role } from '@/account/enum/role.enum';
import * as bcrypt from 'bcryptjs';

describe('AuthService', () => {
  let service: AuthService;
  let accountService: AccountService;

  const mockAccountService = {
    findByEmail: jest.fn(),
    create: jest.fn(),
  };

  const mockJwtService = {
    sign: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: AccountService, useValue: mockAccountService },
        { provide: JwtService, useValue: mockJwtService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    accountService = module.get<AccountService>(AccountService);
  });

  describe('createDefaultAdmin', () => {
    it('should create an admin if not exists', async () => {
      mockAccountService.findByEmail.mockResolvedValue(null);
      mockAccountService.create.mockResolvedValue({ id: '1', email: 'admin@healytics.com', role: Role.ADMIN });

      await service.createDefaultAdmin();

      expect(mockAccountService.findByEmail).toHaveBeenCalledWith('admin@healytics.com');
      expect(mockAccountService.create).toHaveBeenCalledWith(
        expect.objectContaining({
          email: 'admin@healytics.com',
          role: Role.ADMIN,
        }),
      );
    });

    it('should not create an admin if it already exists', async () => {
      mockAccountService.findByEmail.mockResolvedValue({ id: '1', email: 'admin@healytics.com' });

      await service.createDefaultAdmin();

      expect(mockAccountService.findByEmail).toHaveBeenCalled();
      expect(mockAccountService.create).not.toHaveBeenCalled();
    });
  });
});
