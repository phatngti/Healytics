import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { AccountService } from '@/account/account.service';
import { RegisterDto } from './dto/request/register.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: MockType<AuthService>;
  let accountService: MockType<AccountService>;

  beforeEach(async () => {
    // Arrange - Create typed mocks
    const mockAuthService: MockType<AuthService> = {
      register: jest.fn(),
      login: jest.fn(),
      loginUser: jest.fn(),
      loginAdmin: jest.fn(),
      refresh: jest.fn(),
    };

    const mockAccountService: MockType<AccountService> = {
      removeRefreshToken: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: mockAuthService,
        },
        {
          provide: AccountService,
          useValue: mockAccountService,
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get(AuthService);
    accountService = module.get(AccountService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('registerUser', () => {
    it('should call authService.register and return tokens', async () => {
      // Arrange
      const dto: RegisterDto = {
        email: 'test@example.com',
        password: 'password123',
      } as RegisterDto;
      const expectedTokens = {
        access_token: 'access-token',
        refresh_token: 'refresh-token',
      };
      authService.register!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.registerUser(dto);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.register).toHaveBeenCalledWith(dto);
    });
  });

  describe('loginUser', () => {
    it('should call authService.loginUser with validated user', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1', email: 'test@example.com' } };
      const expectedTokens = {
        access_token: 'access-token',
        refresh_token: 'refresh-token',
      };
      authService.loginUser!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.loginUser(mockReq);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.loginUser).toHaveBeenCalledWith(mockReq.user);
    });
  });

  describe('loginAdmin', () => {
    it('should call authService.loginAdmin with validated user', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1', email: 'admin@example.com' } };
      const expectedTokens = {
        access_token: 'access-token',
        refresh_token: 'refresh-token',
      };
      authService.loginAdmin!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.loginAdmin(mockReq);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.loginAdmin).toHaveBeenCalledWith(mockReq.user);
    });
  });

  describe('register (legacy)', () => {
    it('should call authService.register and return tokens', async () => {
      // Arrange
      const dto: RegisterDto = {
        email: 'test@example.com',
        password: 'password123',
      } as RegisterDto;
      const expectedTokens = {
        access_token: 'access-token',
        refresh_token: 'refresh-token',
      };
      authService.register!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.register(dto);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.register).toHaveBeenCalledWith(dto);
    });
  });

  describe('login (legacy)', () => {
    it('should call authService.login with validated user', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1', email: 'test@example.com' } };
      const expectedTokens = {
        access_token: 'access-token',
        refresh_token: 'refresh-token',
      };
      authService.login!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.login(mockReq);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.login).toHaveBeenCalledWith(mockReq.user);
    });
  });

  describe('logout', () => {
    it('should remove refresh token and return success message', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1' } };
      accountService.removeRefreshToken!.mockResolvedValue(undefined);

      // Act
      const result = await controller.logout(mockReq);

      // Assert
      expect(result).toEqual({ message: 'Logged out successfully' });
      expect(accountService.removeRefreshToken).toHaveBeenCalledWith('uuid-1');
    });

    it('should return success message even if removeRefreshToken fails', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1' } };
      accountService.removeRefreshToken!.mockRejectedValue(new Error('DB error'));

      // Act
      const result = await controller.logout(mockReq);

      // Assert
      expect(result).toEqual({ message: 'Logged out successfully' });
    });

    it('should return success message when user is undefined', async () => {
      // Arrange
      const mockReq = { user: undefined };

      // Act
      const result = await controller.logout(mockReq);

      // Assert
      expect(result).toEqual({ message: 'Logged out successfully' });
      expect(accountService.removeRefreshToken).not.toHaveBeenCalled();
    });
  });

  describe('refresh', () => {
    it('should call authService.refresh with token and return new tokens', async () => {
      // Arrange
      const refreshToken = 'old-refresh-token';
      const expectedTokens = {
        access_token: 'new-access-token',
        refresh_token: 'new-refresh-token',
      };
      authService.refresh!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.refresh(refreshToken);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.refresh).toHaveBeenCalledWith(refreshToken);
    });
  });
});
