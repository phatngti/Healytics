import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { PartnersService } from '@/partners/partners.service';
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
    };

    const mockPartnersService: MockType<PartnersService> = {
      registerPartner: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        { provide: AuthService, useValue: mockAuthService },
        { provide: PartnersService, useValue: mockPartnersService },
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
      const dto: RefreshTokenRequestDto = { refresh_token: 'old-refresh-token' };
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
