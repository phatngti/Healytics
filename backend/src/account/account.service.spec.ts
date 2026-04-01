import { Test, TestingModule } from '@nestjs/testing';
import { AccountService } from './account.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Account } from '@/common/entities/account.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';

describe('AccountService', () => {
  let service: AccountService;
  let repository: Record<string, jest.Mock>;
  let createAccountHandler: Record<string, jest.Mock>;
  let setSurveyHandler: Record<string, jest.Mock>;
  let setRefreshTokenHandler: Record<string, jest.Mock>;

  const mockAccountRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    findOneBy: jest.fn(),
    update: jest.fn(),
  };

  const mockCreateAccountHandler = {
    execute: jest.fn(),
  };

  const mockSetSurveyHandler = {
    execute: jest.fn(),
  };

  const mockSetRefreshTokenHandler = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AccountService,
        {
          provide: getRepositoryToken(Account),
          useValue: mockAccountRepository,
        },
        {
          provide: CreateAccountHandler,
          useValue: mockCreateAccountHandler,
        },
        {
          provide: SetSurveyHandler,
          useValue: mockSetSurveyHandler,
        },
        {
          provide: SetRefreshTokenHandler,
          useValue: mockSetRefreshTokenHandler,
        },
      ],
    }).compile();

    service = module.get<AccountService>(AccountService);
    repository = module.get(getRepositoryToken(Account));
    createAccountHandler = module.get(CreateAccountHandler);
    setSurveyHandler = module.get(SetSurveyHandler);
    setRefreshTokenHandler = module.get(SetRefreshTokenHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateAccountHandler', async () => {
      // Arrange
      const inputData = { email: 'test@example.com' };
      const expectedAccount = { id: 'uuid-1', ...inputData };
      mockCreateAccountHandler.execute.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.create(inputData);

      // Assert
      expect(result).toEqual(expectedAccount);
      expect(mockCreateAccountHandler.execute).toHaveBeenCalledWith(inputData);
    });
  });

  describe('findByEmail', () => {
    it('should return an account when found', async () => {
      // Arrange
      const expectedAccount = { id: 'uuid-1', email: 'test@example.com' };
      mockAccountRepository.findOneBy.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.findByEmail('test@example.com');

      // Assert
      expect(result).toEqual(expectedAccount);
      expect(mockAccountRepository.findOneBy).toHaveBeenCalledWith({
        email: 'test@example.com',
      });
    });

    it('should return null when not found', async () => {
      // Arrange
      mockAccountRepository.findOneBy.mockResolvedValue(null);

      // Act
      const result = await service.findByEmail('notfound@example.com');

      // Assert
      expect(result).toBeNull();
    });
  });

  describe('findOne', () => {
    it('should return an account when found', async () => {
      // Arrange
      const expectedAccount = { id: 'uuid-1', email: 'test@example.com' };
      mockAccountRepository.findOneBy.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.findOne('uuid-1');

      // Assert
      expect(result).toEqual(expectedAccount);
    });

    it('should return null when not found', async () => {
      // Arrange
      mockAccountRepository.findOneBy.mockResolvedValue(null);

      // Act
      const result = await service.findOne('missing-id');

      // Assert
      expect(result).toBeNull();
    });
  });

  describe('findAll', () => {
    it('should return an array of accounts', async () => {
      // Arrange
      const expectedAccounts = [{ id: '1' }, { id: '2' }];
      mockAccountRepository.find.mockResolvedValue(expectedAccounts);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual(expectedAccounts);
    });
  });

  describe('setSurvey', () => {
    it('should delegate to SetSurveyHandler', async () => {
      // Arrange
      const inputSurvey = { question1: 'answer1' };
      const expectedAccount = { id: 'uuid-1', survey: inputSurvey };
      mockSetSurveyHandler.execute.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.setSurvey('uuid-1', inputSurvey);

      // Assert
      expect(result).toEqual(expectedAccount);
      expect(mockSetSurveyHandler.execute).toHaveBeenCalledWith(
        'uuid-1',
        inputSurvey,
      );
    });
  });

  describe('setRefreshTokenHash', () => {
    it('should delegate to SetRefreshTokenHandler', async () => {
      // Arrange
      const expectedAccount = { id: 'uuid-1', refreshTokenHash: 'hash' };
      mockSetRefreshTokenHandler.execute.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.setRefreshTokenHash('uuid-1', 'hash');

      // Assert
      expect(result).toEqual(expectedAccount);
      expect(mockSetRefreshTokenHandler.execute).toHaveBeenCalledWith(
        'uuid-1',
        'hash',
      );
    });
  });

  describe('removeRefreshToken', () => {
    it('should remove refresh token', async () => {
      // Arrange
      mockAccountRepository.update.mockResolvedValue({ affected: 1 });

      // Act
      await service.removeRefreshToken('uuid-1');

      // Assert
      expect(mockAccountRepository.update).toHaveBeenCalledWith('uuid-1', {
        refreshTokenHash: null,
      });
    });
  });
});
