import { Test, TestingModule } from '@nestjs/testing';
import { PartnerHealthServiceController } from './partner-health-service.controller';
import { HealthServiceService } from './health-service.service';
import { MockType } from '../../test/mocks/mock-types';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { HealthServiceType } from './enums/health-service-type.enum';

describe('PartnerHealthServiceController', () => {
  let controller: PartnerHealthServiceController;
  let healthServiceService: MockType<HealthServiceService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for HealthServiceService
    const mockHealthServiceService: MockType<HealthServiceService> = {
      create: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PartnerHealthServiceController],
      providers: [
        {
          provide: HealthServiceService,
          useValue: mockHealthServiceService,
        },
      ],
    }).compile();

    controller = module.get<PartnerHealthServiceController>(PartnerHealthServiceController);
    healthServiceService = module.get(HealthServiceService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should call service.create with DTO and return the created product', async () => {
      // Arrange
      const createDto: CreatePartnerHealthServiceDto = {
        name: 'Thai Massage',
        slug: 'thai-massage',
        type: HealthServiceType.SERVICE,
      };
      const expectedProduct = { id: 'uuid-1', ...createDto };
      healthServiceService.create!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.create(createDto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(healthServiceService.create).toHaveBeenCalledWith(createDto);
      expect(healthServiceService.create).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should call service.update with ID and DTO and return the updated product', async () => {
      // Arrange
      const id = 'uuid-1';
      const updateDto: UpdatePartnerHealthServiceDto = { name: 'Updated Massage' };
      const expectedProduct = { id, name: 'Updated Massage' };
      healthServiceService.update!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.update(id, updateDto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(healthServiceService.update).toHaveBeenCalledWith(id, updateDto);
      expect(healthServiceService.update).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID and return void', async () => {
      // Arrange
      const id = 'uuid-1';
      healthServiceService.remove!.mockResolvedValue(undefined);

      // Act
      const result = await controller.remove(id);

      // Assert
      expect(result).toBeUndefined();
      expect(healthServiceService.remove).toHaveBeenCalledWith(id);
      expect(healthServiceService.remove).toHaveBeenCalledTimes(1);
    });
  });
});
