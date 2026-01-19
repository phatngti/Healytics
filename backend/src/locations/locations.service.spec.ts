import { Test, TestingModule } from '@nestjs/testing';
import { LocationsService } from './locations.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Location } from './entities/location.entity';
import { LocationLevel } from './entities/location-level.enum';
import { NotFoundException } from '@nestjs/common';

describe('LocationsService', () => {
    let service: LocationsService;
    let repository: Record<string, jest.Mock>;

    const mockLocationRepository = {
        findRoots: jest.fn(),
        find: jest.fn(),
        findOne: jest.fn(),
    };

    // Mock data
    const mockProvinces = [
        { id: 'province-1', name: 'Hà Nội', level: LocationLevel.PROVINCE },
        { id: 'province-2', name: 'Hồ Chí Minh', level: LocationLevel.PROVINCE },
    ];

    const mockDistricts = [
        { id: 'district-1', name: 'Quận 1', level: LocationLevel.DISTRICT },
        { id: 'district-2', name: 'Quận 2', level: LocationLevel.DISTRICT },
    ];

    const mockWards = [
        { id: 'ward-1', name: 'Phường 1', level: LocationLevel.WARD },
        { id: 'ward-2', name: 'Phường 2', level: LocationLevel.WARD },
    ];

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                LocationsService,
                {
                    provide: getRepositoryToken(Location),
                    useValue: mockLocationRepository,
                },
            ],
        }).compile();

        service = module.get<LocationsService>(LocationsService);
        repository = module.get(getRepositoryToken(Location));
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('getAllProvinces', () => {
        it('should return all provinces with total count', async () => {
            // Arrange
            mockLocationRepository.findRoots.mockResolvedValue(mockProvinces);

            // Act
            const result = await service.getAllProvinces();

            // Assert
            expect(result).toEqual({
                data: mockProvinces,
                total: 2,
            });
            expect(mockLocationRepository.findRoots).toHaveBeenCalled();
        });

        it('should return empty array when no provinces exist', async () => {
            // Arrange
            mockLocationRepository.findRoots.mockResolvedValue([]);

            // Act
            const result = await service.getAllProvinces();

            // Assert
            expect(result).toEqual({
                data: [],
                total: 0,
            });
        });
    });

    describe('getDistrictsByProvinceId', () => {
        it('should return districts for a valid province', async () => {
            // Arrange
            const provinceId = 'province-1';
            mockLocationRepository.findOne.mockResolvedValue({
                id: provinceId,
                level: LocationLevel.PROVINCE,
            });
            mockLocationRepository.find.mockResolvedValue(mockDistricts);

            // Act
            const result = await service.getDistrictsByProvinceId(provinceId);

            // Assert
            expect(result).toEqual({
                data: mockDistricts,
                total: 2,
            });
            expect(mockLocationRepository.findOne).toHaveBeenCalledWith({
                where: { id: provinceId, level: LocationLevel.PROVINCE },
            });
        });

        it('should throw NotFoundException when province not found', async () => {
            // Arrange
            const invalidProvinceId = 'invalid-province';
            mockLocationRepository.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.getDistrictsByProvinceId(invalidProvinceId),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.getDistrictsByProvinceId(invalidProvinceId),
            ).rejects.toThrow(`Province with ID ${invalidProvinceId} not found`);
        });
    });

    describe('getWardsByDistrictId', () => {
        it('should return wards for a valid district', async () => {
            // Arrange
            const districtId = 'district-1';
            mockLocationRepository.findOne.mockResolvedValue({
                id: districtId,
                level: LocationLevel.DISTRICT,
            });
            mockLocationRepository.find.mockResolvedValue(mockWards);

            // Act
            const result = await service.getWardsByDistrictId(districtId);

            // Assert
            expect(result).toEqual({
                data: mockWards,
                total: 2,
            });
            expect(mockLocationRepository.findOne).toHaveBeenCalledWith({
                where: { id: districtId, level: LocationLevel.DISTRICT },
            });
        });

        it('should throw NotFoundException when district not found', async () => {
            // Arrange
            const invalidDistrictId = 'invalid-district';
            mockLocationRepository.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.getWardsByDistrictId(invalidDistrictId),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.getWardsByDistrictId(invalidDistrictId),
            ).rejects.toThrow(`District with ID ${invalidDistrictId} not found`);
        });
    });

    describe('validateAddress', () => {
        const provinceId = 'province-1';
        const districtId = 'district-1';
        const wardId = 'ward-1';

        it('should return true for valid address hierarchy', async () => {
            // Arrange
            const mockWard = {
                id: wardId,
                level: LocationLevel.WARD,
                parent: {
                    id: districtId,
                    parent: {
                        id: provinceId,
                    },
                },
            };
            mockLocationRepository.findOne.mockResolvedValue(mockWard);

            // Act
            const result = await service.validateAddress(
                provinceId,
                districtId,
                wardId,
            );

            // Assert
            expect(result).toBe(true);
            expect(mockLocationRepository.findOne).toHaveBeenCalledWith({
                where: { id: wardId, level: LocationLevel.WARD },
                relations: ['parent', 'parent.parent'],
            });
        });

        it('should throw NotFoundException when ward not found', async () => {
            // Arrange
            mockLocationRepository.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(`Ward with ID ${wardId} not found`);
        });

        it('should throw NotFoundException when ward does not belong to district', async () => {
            // Arrange
            const mockWard = {
                id: wardId,
                level: LocationLevel.WARD,
                parent: {
                    id: 'different-district',
                    parent: {
                        id: provinceId,
                    },
                },
            };
            mockLocationRepository.findOne.mockResolvedValue(mockWard);

            // Act & Assert
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(
                `Ward ${wardId} does not belong to district ${districtId}`,
            );
        });

        it('should throw NotFoundException when district does not belong to province', async () => {
            // Arrange
            const mockWard = {
                id: wardId,
                level: LocationLevel.WARD,
                parent: {
                    id: districtId,
                    parent: {
                        id: 'different-province',
                    },
                },
            };
            mockLocationRepository.findOne.mockResolvedValue(mockWard);

            // Act & Assert
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(
                `District ${districtId} does not belong to province ${provinceId}`,
            );
        });

        it('should throw NotFoundException when ward has no parent', async () => {
            // Arrange
            const mockWard = {
                id: wardId,
                level: LocationLevel.WARD,
                parent: null,
            };
            mockLocationRepository.findOne.mockResolvedValue(mockWard);

            // Act & Assert
            await expect(
                service.validateAddress(provinceId, districtId, wardId),
            ).rejects.toThrow(NotFoundException);
        });
    });
});
