import { Test, TestingModule } from '@nestjs/testing';
import { AccountService } from './account.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';
import { LocationsService } from '@/locations/locations.service';
import { MapboxService } from '@/mapbox/mapbox.service';

describe('AccountService', () => {
  let service: AccountService;
  let repository: Record<string, jest.Mock>;
  let createAccountHandler: Record<string, jest.Mock>;
  let setSurveyHandler: Record<string, jest.Mock>;
  let setRefreshTokenHandler: Record<string, jest.Mock>;
  let dataSource: Record<string, jest.Mock>;
  let locationsService: Record<string, jest.Mock>;
  let mapboxService: Record<string, jest.Mock>;

  const mockAccountRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    findOneBy: jest.fn(),
    exist: jest.fn(),
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

  const mockLocationRows = {
    province: {
      id: '11111111-1111-4111-8111-111111111111',
      name: 'Ho Chi Minh City',
      fullName: 'Ho Chi Minh City',
    },
    district: {
      id: '22222222-2222-4222-8222-222222222222',
      name: 'District 1',
      fullName: 'District 1',
    },
    ward: {
      id: '33333333-3333-4333-8333-333333333333',
      name: 'Ben Nghe Ward',
      fullName: 'Ben Nghe Ward',
    },
  };

  const mockDataSource = {
    transaction: jest.fn(),
    getRepository: jest.fn(),
  };

  const mockLocationsService = {
    validateAddress: jest.fn(),
  };

  const mockMapboxService = {
    geocode: jest.fn(),
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
          provide: DataSource,
          useValue: mockDataSource,
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
        {
          provide: LocationsService,
          useValue: mockLocationsService,
        },
        {
          provide: MapboxService,
          useValue: mockMapboxService,
        },
      ],
    }).compile();

    service = module.get<AccountService>(AccountService);
    repository = module.get(getRepositoryToken(Account));
    createAccountHandler = module.get(CreateAccountHandler);
    setSurveyHandler = module.get(SetSurveyHandler);
    setRefreshTokenHandler = module.get(SetRefreshTokenHandler);
    dataSource = module.get(DataSource);
    locationsService = module.get(LocationsService);
    mapboxService = module.get(MapboxService);

    mockDataSource.getRepository.mockReturnValue({
      findOne: jest.fn(({ where }: { where: { id: string } }) => {
        if (where.id === mockLocationRows.province.id) {
          return Promise.resolve(mockLocationRows.province);
        }
        if (where.id === mockLocationRows.district.id) {
          return Promise.resolve(mockLocationRows.district);
        }
        if (where.id === mockLocationRows.ward.id) {
          return Promise.resolve(mockLocationRows.ward);
        }
        return Promise.resolve(null);
      }),
    });
    mockLocationsService.validateAddress.mockResolvedValue(true);
    mockMapboxService.geocode.mockResolvedValue({
      results: [{ lat: 10.7769, lng: 106.7009 }],
    });
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
      mockAccountRepository.findOne.mockResolvedValue(expectedAccount);

      // Act
      const result = await service.findByEmail('test@example.com');

      // Assert
      expect(result).toEqual(expectedAccount);
      expect(mockAccountRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({
            email: expect.any(Object),
          }),
        }),
      );
    });

    it('should return null when not found', async () => {
      // Arrange
      mockAccountRepository.findOne.mockResolvedValue(null);

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

  describe('updateProfile', () => {
    it('updates profile identity fields and returns refreshed account data', async () => {
      const manager = {
        findOne: jest.fn().mockResolvedValue({
          id: 'account-uuid',
          userProfile: {
            id: 'profile-uuid',
            firstName: 'Old',
            lastName: 'Name',
            phone: '0900000000',
          },
        }),
        create: jest.fn((_: unknown, value?: unknown) => value ?? {}),
        save: jest.fn((_: unknown, value: unknown) => Promise.resolve(value)),
      };
      dataSource.transaction.mockImplementation((callback) =>
        callback(manager),
      );
      jest
        .spyOn(service, 'getMe')
        .mockResolvedValue({ id: 'account-uuid' } as any);

      const result = await service.updateProfile('account-uuid', {
        firstName: ' Test ',
        lastName: ' New ',
        phone: '0901234567',
        dateOfBirth: '1990-01-15',
        profileCompleted: true,
      });

      expect(result).toEqual({ id: 'account-uuid' });
      expect(manager.save).toHaveBeenCalledWith(
        expect.any(Function),
        expect.objectContaining({
          id: 'profile-uuid',
          firstName: 'Test',
          lastName: 'New',
          phone: '0901234567',
          dateOfBirth: new Date('1990-01-15'),
          profileCompleted: true,
        }),
      );
    });

    it('creates a user profile when the account does not have one yet', async () => {
      const manager = {
        findOne: jest.fn().mockResolvedValue({
          id: 'account-uuid',
          userProfile: null,
        }),
        create: jest.fn((_: unknown, value?: unknown) => value ?? {}),
        save: jest.fn((_: unknown, value: unknown) => Promise.resolve(value)),
      };
      dataSource.transaction.mockImplementation((callback) =>
        callback(manager),
      );
      jest
        .spyOn(service, 'getMe')
        .mockResolvedValue({ id: 'account-uuid' } as any);

      await service.updateProfile('account-uuid', {
        firstName: 'Test',
        lastName: null,
        phone: null,
      });

      expect(manager.create).toHaveBeenCalledWith(
        expect.any(Function),
        expect.objectContaining({ accountId: 'account-uuid' }),
      );
      expect(manager.save).toHaveBeenCalledWith(
        expect.any(Function),
        expect.objectContaining({
          accountId: 'account-uuid',
          firstName: 'Test',
          lastName: null,
          phone: null,
        }),
      );
    });
  });

  describe('updateAddress', () => {
    const dto = {
      streetAddress: '123 Nguyen Hue Street',
      provinceId: mockLocationRows.province.id,
      districtId: mockLocationRows.district.id,
      wardId: mockLocationRows.ward.id,
    };

    it('updates the existing address and writes coordinates', async () => {
      const manager = {
        findOne: jest.fn().mockResolvedValue({
          id: 'account-uuid',
          userProfile: {
            id: 'profile-uuid',
            addressId: 'address-uuid',
            address: { id: 'address-uuid' },
          },
        }),
        create: jest.fn((_: unknown, value?: unknown) => value ?? {}),
        save: jest.fn((_: unknown, value: any) =>
          Promise.resolve({ id: value.id ?? 'address-uuid', ...value }),
        ),
        query: jest.fn().mockResolvedValue(undefined),
      };
      dataSource.transaction.mockImplementation((callback) =>
        callback(manager),
      );
      jest
        .spyOn(service, 'getMe')
        .mockResolvedValue({ id: 'account-uuid' } as any);

      const result = await service.updateAddress('account-uuid', dto);

      expect(result).toEqual({ id: 'account-uuid' });
      expect(locationsService.validateAddress).toHaveBeenCalledWith(
        dto.provinceId,
        dto.districtId,
        dto.wardId,
      );
      expect(mapboxService.geocode).toHaveBeenCalledWith(
        '123 Nguyen Hue Street, Ben Nghe Ward, District 1, Ho Chi Minh City, Vietnam',
      );
      expect(manager.save).toHaveBeenCalledWith(
        expect.any(Function),
        expect.objectContaining({
          id: 'address-uuid',
          street: '123 Nguyen Hue Street',
          provinceId: dto.provinceId,
          districtId: dto.districtId,
          wardId: dto.wardId,
          coordinates: '10.7769,106.7009',
        }),
      );
      expect(manager.query).toHaveBeenCalledWith(
        expect.stringContaining('ST_SetSRID(ST_MakePoint($1, $2), 4326)'),
        [106.7009, 10.7769, 'address-uuid'],
      );
    });

    it('keeps address update non-blocking when geocoding fails', async () => {
      mapboxService.geocode.mockRejectedValueOnce(new Error('mapbox down'));
      const manager = {
        findOne: jest.fn().mockResolvedValue({
          id: 'account-uuid',
          userProfile: {
            id: 'profile-uuid',
            addressId: 'address-uuid',
            address: { id: 'address-uuid' },
          },
        }),
        create: jest.fn((_: unknown, value?: unknown) => value ?? {}),
        save: jest.fn((_: unknown, value: any) =>
          Promise.resolve({ id: value.id ?? 'address-uuid', ...value }),
        ),
        query: jest.fn().mockResolvedValue(undefined),
      };
      dataSource.transaction.mockImplementation((callback) =>
        callback(manager),
      );
      jest
        .spyOn(service, 'getMe')
        .mockResolvedValue({ id: 'account-uuid' } as any);

      await service.updateAddress('account-uuid', dto);

      expect(manager.save).toHaveBeenCalledWith(
        expect.any(Function),
        expect.objectContaining({ coordinates: null }),
      );
      expect(manager.query).toHaveBeenCalledWith(
        'UPDATE address SET location = NULL WHERE id = $1',
        ['address-uuid'],
      );
    });

    it('rejects invalid location hierarchy before opening a transaction', async () => {
      locationsService.validateAddress.mockRejectedValueOnce(
        new Error('Ward does not belong to district'),
      );

      await expect(service.updateAddress('account-uuid', dto)).rejects.toThrow(
        'Invalid address',
      );
      expect(dataSource.transaction).not.toHaveBeenCalled();
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
