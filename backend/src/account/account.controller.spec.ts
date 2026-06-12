import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException } from '@nestjs/common';
import { AccountController } from './account.controller';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/request/survey.dto';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('AccountController', () => {
  let controller: AccountController;
  let accountService: MockType<AccountService>;

  beforeEach(async () => {
    const mockAccountService: MockType<AccountService> = {
      getMe: jest.fn(),
      updateProfile: jest.fn(),
      updateAddress: jest.fn(),
      getSurveyResponse: jest.fn(),
      createSurvey: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AccountController],
      providers: [
        {
          provide: AccountService,
          useValue: mockAccountService,
        },
      ],
    }).compile();

    controller = module.get<AccountController>(AccountController);
    accountService = module.get(AccountService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('updateProfile', () => {
    it('should delegate profile identity update to service and return response', async () => {
      const userId = 'uuid-1';
      const dto = {
        firstName: 'Test',
        lastName: 'New',
        phone: '0901234567',
      };
      const response = { id: userId, email: 'user@test.com' } as any;
      accountService.updateProfile!.mockResolvedValue(response);

      const result = await controller.updateProfile(userId, dto);

      expect(result).toEqual(response);
      expect(accountService.updateProfile).toHaveBeenCalledWith(userId, dto);
    });
  });

  describe('updateAddress', () => {
    it('should delegate address update to service and return response', async () => {
      const userId = 'uuid-1';
      const dto = {
        streetAddress: '123 Nguyen Hue Street',
        provinceId: '11111111-1111-4111-8111-111111111111',
        districtId: '22222222-2222-4222-8222-222222222222',
        wardId: '33333333-3333-4333-8333-333333333333',
      };
      const response = { id: userId, email: 'user@test.com' } as any;
      accountService.updateAddress!.mockResolvedValue(response);

      const result = await controller.updateAddress(userId, dto);

      expect(result).toEqual(response);
      expect(accountService.updateAddress).toHaveBeenCalledWith(userId, dto);
    });
  });

  describe('getSurvey', () => {
    it('should return survey data when survey exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      const response: SurveyResponseDto = {
        survey: { question1: 'answer1', question2: 'answer2' },
      };
      accountService.getSurveyResponse!.mockResolvedValue(response);

      // Act
      const result = await controller.getSurvey(userId);

      // Assert
      expect(result).toEqual(response);
      expect(accountService.getSurveyResponse).toHaveBeenCalledWith(userId);
    });

    it('should return null survey when no survey exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      const response: SurveyResponseDto = { survey: null };
      accountService.getSurveyResponse!.mockResolvedValue(response);

      // Act
      const result = await controller.getSurvey(userId);

      // Assert
      expect(result).toEqual({ survey: null });
      expect(accountService.getSurveyResponse).toHaveBeenCalledWith(userId);
    });
  });

  describe('postSurvey', () => {
    it('should delegate survey creation to service and return response', async () => {
      // Arrange
      const userId = 'uuid-1';
      const dto: SurveyDto = { survey: { question1: 'answer1' } } as SurveyDto;
      const response: SurveyResponseDto = { survey: { question1: 'answer1' } };
      accountService.createSurvey!.mockResolvedValue(response);

      // Act
      const result = await controller.postSurvey(userId, dto);

      // Assert
      expect(result).toEqual(response);
      expect(accountService.createSurvey).toHaveBeenCalledWith(
        userId,
        dto.survey,
      );
    });

    it('should propagate ConflictException from service when survey already exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      const dto: SurveyDto = { survey: { question1: 'answer1' } } as SurveyDto;
      accountService.createSurvey!.mockRejectedValue(
        new ConflictException('Survey already exists'),
      );

      // Act & Assert
      await expect(controller.postSurvey(userId, dto)).rejects.toThrow(
        ConflictException,
      );
      await expect(controller.postSurvey(userId, dto)).rejects.toThrow(
        'Survey already exists',
      );
    });
  });
});
