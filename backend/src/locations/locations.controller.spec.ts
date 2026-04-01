import { Test, TestingModule } from '@nestjs/testing';
import { LocationsController } from './locations.controller';
import { LocationsService } from './locations.service';
import { NotFoundException } from '@nestjs/common';

describe('LocationsController', () => {
  let controller: LocationsController;
  let locationsService: Record<string, jest.Mock>;

  const mockLocationsService = {
    getAllProvinces: jest.fn(),
    getDistrictsByProvinceId: jest.fn(),
    getWardsByDistrictId: jest.fn(),
  };

  // Mock data (now using DTO shape)
  const mockProvinces = {
    data: [
      {
        id: 'province-1',
        code: '01',
        name: 'Hà Nội',
        fullName: 'Thành phố Hà Nội',
        level: 'PROVINCE',
      },
      {
        id: 'province-2',
        code: '79',
        name: 'Hồ Chí Minh',
        fullName: 'Thành phố Hồ Chí Minh',
        level: 'PROVINCE',
      },
    ],
    total: 2,
  };

  const mockDistricts = {
    data: [
      {
        id: 'district-1',
        code: '001',
        name: 'Quận 1',
        fullName: 'Quận 1',
        level: 'DISTRICT',
      },
      {
        id: 'district-2',
        code: '002',
        name: 'Quận 2',
        fullName: 'Quận 2',
        level: 'DISTRICT',
      },
    ],
    total: 2,
  };

  const mockWards = {
    data: [
      {
        id: 'ward-1',
        code: '00001',
        name: 'Phường 1',
        fullName: 'Phường 1',
        level: 'WARD',
      },
      {
        id: 'ward-2',
        code: '00002',
        name: 'Phường 2',
        fullName: 'Phường 2',
        level: 'WARD',
      },
    ],
    total: 2,
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      controllers: [LocationsController],
      providers: [
        {
          provide: LocationsService,
          useValue: mockLocationsService,
        },
      ],
    }).compile();

    controller = module.get<LocationsController>(LocationsController);
    locationsService = module.get(LocationsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getProvinces', () => {
    it('should return all provinces', async () => {
      // Arrange
      mockLocationsService.getAllProvinces.mockResolvedValue(mockProvinces);

      // Act
      const result = await controller.getProvinces();

      // Assert
      expect(result).toEqual(mockProvinces);
      expect(mockLocationsService.getAllProvinces).toHaveBeenCalled();
    });
  });

  describe('getDistricts', () => {
    it('should return districts for a province', async () => {
      // Arrange
      const provinceId = 'province-1';
      mockLocationsService.getDistrictsByProvinceId.mockResolvedValue(
        mockDistricts,
      );

      // Act
      const result = await controller.getDistricts(provinceId);

      // Assert
      expect(result).toEqual(mockDistricts);
      expect(
        mockLocationsService.getDistrictsByProvinceId,
      ).toHaveBeenCalledWith(provinceId);
    });

    it('should propagate NotFoundException from service', async () => {
      // Arrange
      const provinceId = 'invalid-province';
      mockLocationsService.getDistrictsByProvinceId.mockRejectedValue(
        new NotFoundException('Province not found'),
      );

      // Act & Assert
      await expect(controller.getDistricts(provinceId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('getWards', () => {
    it('should return wards for a district', async () => {
      // Arrange
      const districtId = 'district-1';
      mockLocationsService.getWardsByDistrictId.mockResolvedValue(mockWards);

      // Act
      const result = await controller.getWards(districtId);

      // Assert
      expect(result).toEqual(mockWards);
      expect(mockLocationsService.getWardsByDistrictId).toHaveBeenCalledWith(
        districtId,
      );
    });

    it('should propagate NotFoundException from service', async () => {
      // Arrange
      const districtId = 'invalid-district';
      mockLocationsService.getWardsByDistrictId.mockRejectedValue(
        new NotFoundException('District not found'),
      );

      // Act & Assert
      await expect(controller.getWards(districtId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
