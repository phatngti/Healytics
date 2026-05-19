import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { PartnersService } from '@/partners/partners.service';
import { AccountService } from '@/account/account.service';
import { RegisterDto } from './dto/request/register.dto';
import { RefreshTokenRequestDto } from './dto/request/refresh-token-request.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: MockType<AuthService>;

  beforeEach(async () => {
    const mockAuthService: MockType<AuthService> = {
      register: jest.fn(),
      loginUser: jest.fn(),
      loginAdmin: jest.fn(),
      refresh: jest.fn(),
      logout: jest.fn(),
      requestUserPasswordReset: jest.fn(),
      validateUserPasswordResetCode: jest.fn(),
      resetUserPassword: jest.fn(),
    };

    const mockPartnersService: MockType<PartnersService> = {
      registerPartner: jest.fn(),
    };

    const mockAccountService: MockType<AccountService> = {
      checkEmailExists: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        { provide: AuthService, useValue: mockAuthService },
        { provide: PartnersService, useValue: mockPartnersService },
        { provide: AccountService, useValue: mockAccountService },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get(AuthService);
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

  describe('forgotUserPassword', () => {
    it('should delegate to authService.requestUserPasswordReset', async () => {
      const dto = { email: 'user@test.com' };
      const expectedResponse = {
        message:
          'If the email is registered, a password reset code has been sent.',
      };
      authService.requestUserPasswordReset!.mockResolvedValue(expectedResponse);

      const result = await controller.forgotUserPassword(dto);

      expect(result).toEqual(expectedResponse);
      expect(authService.requestUserPasswordReset).toHaveBeenCalledWith(dto);
    });
  });

  describe('validateUserPasswordResetCode', () => {
    it('should delegate to authService.validateUserPasswordResetCode', async () => {
      const dto = { email: 'user@test.com', code: '123456' };
      const expectedResponse = {
        message: 'Password reset code verified.',
        resetToken: 'reset-token',
      };
      authService.validateUserPasswordResetCode!.mockResolvedValue(
        expectedResponse,
      );

      const result = await controller.validateUserPasswordResetCode(dto);

      expect(result).toEqual(expectedResponse);
      expect(authService.validateUserPasswordResetCode).toHaveBeenCalledWith(
        dto,
      );
    });
  });

  describe('resetUserPassword', () => {
    it('should delegate to authService.resetUserPassword', async () => {
      const dto = { token: 'reset-token', password: 'Password123!' };
      const expectedResponse = { message: 'Password reset successfully.' };
      authService.resetUserPassword!.mockResolvedValue(expectedResponse);

      const result = await controller.resetUserPassword(dto);

      expect(result).toEqual(expectedResponse);
      expect(authService.resetUserPassword).toHaveBeenCalledWith(dto);
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

  describe('logout', () => {
    it('should delegate to authService.logout and return success', async () => {
      // Arrange
      const mockReq = { user: { id: 'uuid-1' } };
      const expectedResponse = { message: 'Logged out successfully' };
      authService.logout!.mockResolvedValue(expectedResponse);

      // Act
      const result = await controller.logout(mockReq);

      // Assert
      expect(result).toEqual(expectedResponse);
      expect(authService.logout).toHaveBeenCalledWith('uuid-1');
    });

    it('should handle undefined user gracefully', async () => {
      // Arrange
      const mockReq = { user: undefined };
      const expectedResponse = { message: 'Logged out successfully' };
      authService.logout!.mockResolvedValue(expectedResponse);

      // Act
      const result = await controller.logout(mockReq);

      // Assert
      expect(result).toEqual(expectedResponse);
      expect(authService.logout).toHaveBeenCalledWith(undefined);
    });
  });

  describe('refresh', () => {
    it('should call authService.refresh with token and return new tokens', async () => {
      // Arrange
      const dto: RefreshTokenRequestDto = {
        refresh_token: 'old-refresh-token',
      };
      const expectedTokens = {
        access_token: 'new-access-token',
        refresh_token: 'new-refresh-token',
      };
      authService.refresh!.mockResolvedValue(expectedTokens);

      // Act
      const result = await controller.refresh(dto);

      // Assert
      expect(result).toEqual(expectedTokens);
      expect(authService.refresh).toHaveBeenCalledWith(dto.refresh_token);
    });
  });
});
