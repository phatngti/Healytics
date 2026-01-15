import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException } from '@nestjs/common';
import { AccountController } from './account.controller';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/request/survey.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('AccountController', () => {
  let controller: AccountController;
  let accountService: MockType<AccountService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for AccountService
    const mockAccountService: MockType<AccountService> = {
      getSurvey: jest.fn(),
      setSurvey: jest.fn(),
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

  describe('getSurvey', () => {
    it('should return survey data when survey exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      const surveyData = { question1: 'answer1', question2: 'answer2' };
      accountService.getSurvey!.mockResolvedValue(surveyData);

      // Act
      const result = await controller.getSurvey(userId);

      // Assert
      expect(result).toEqual({ survey: surveyData });
      expect(accountService.getSurvey).toHaveBeenCalledWith(userId);
    });

    it('should return null survey when no survey exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      accountService.getSurvey!.mockResolvedValue(null);

      // Act
      const result = await controller.getSurvey(userId);

      // Assert
      expect(result).toEqual({ survey: null });
      expect(accountService.getSurvey).toHaveBeenCalledWith(userId);
    });
  });

  describe('postSurvey', () => {
    it('should create survey and return survey response', async () => {
      // Arrange
      const userId = 'uuid-1';
      const dto: SurveyDto = { survey: { question1: 'answer1' } } as SurveyDto;
      const createdSurvey = { survey: { question1: 'answer1' } };
      accountService.getSurvey!.mockResolvedValue(null);
      accountService.setSurvey!.mockResolvedValue(createdSurvey);

      // Act
      const result = await controller.postSurvey(userId, dto);

      // Assert
      expect(result).toEqual({ survey: createdSurvey.survey });
      expect(accountService.getSurvey).toHaveBeenCalledWith(userId);
      expect(accountService.setSurvey).toHaveBeenCalledWith(userId, dto.survey);
    });

    it('should throw ConflictException when survey already exists', async () => {
      // Arrange
      const userId = 'uuid-1';
      const dto: SurveyDto = { survey: { question1: 'answer1' } } as SurveyDto;
      accountService.getSurvey!.mockResolvedValue({ question1: 'existing' });

      // Act & Assert
      await expect(controller.postSurvey(userId, dto)).rejects.toThrow(ConflictException);
      await expect(controller.postSurvey(userId, dto)).rejects.toThrow('Survey already exists');
      expect(accountService.setSurvey).not.toHaveBeenCalled();
    });
  });
});
