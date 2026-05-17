import { Test, TestingModule } from '@nestjs/testing';
import { EmployeesService } from './employees.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Booking } from '@/common/entities/booking.entity';
import { SkillCatalog } from '@/common/entities/skill-catalog.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { NotFoundException } from '@nestjs/common';
import { EmployeeRole } from './enum/employee-role.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';
import { GetEmployeeOverviewAnalyticsHandler } from './application/handlers/get-employee-overview-analytics.handler';
import { GetEmployeeDetailAnalyticsHandler } from './application/handlers/get-employee-detail-analytics.handler';

describe('EmployeesService', () => {
  let service: EmployeesService;
  let employeeRepository: Record<string, jest.Mock>;
  let partnerRepository: Record<string, jest.Mock>;
  let createDoctorHandler: Record<string, jest.Mock>;
  let createTherapistHandler: Record<string, jest.Mock>;
  let updateEmployeeHandler: Record<string, jest.Mock>;
  let removeEmployeeHandler: Record<string, jest.Mock>;
  let specialistReviewRepository: Record<string, jest.Mock>;

  const mockEmployeeRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
  };

  const mockPartnerRepository = {
    findOne: jest.fn(),
  };

  const mockCreateDoctorHandler = {
    execute: jest.fn(),
  };

  const mockCreateTherapistHandler = {
    execute: jest.fn(),
  };

  const mockUpdateEmployeeHandler = {
    execute: jest.fn(),
  };

  const mockRemoveEmployeeHandler = {
    execute: jest.fn(),
  };

  const mockGetOverviewAnalyticsHandler = {
    execute: jest.fn(),
  };

  const mockGetDetailAnalyticsHandler = {
    execute: jest.fn(),
  };

  const mockEligibilityRepository = {
    find: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockBookingRepository = {
    find: jest.fn(),
  };

  const mockSpecialistReviewRepository = {
    createQueryBuilder: jest.fn(),
  };

  const mockSkillCatalogRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockPartnersService = {
    getFirstHealthPartner: jest.fn().mockResolvedValue(null),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EmployeesService,
        {
          provide: getRepositoryToken(Employee),
          useValue: mockEmployeeRepository,
        },
        {
          provide: getRepositoryToken(Partner),
          useValue: mockPartnerRepository,
        },
        {
          provide: getRepositoryToken(ProductEmployeeEligibility),
          useValue: mockEligibilityRepository,
        },
        {
          provide: getRepositoryToken(Booking),
          useValue: mockBookingRepository,
        },
        {
          provide: getRepositoryToken(SpecialistReview),
          useValue: mockSpecialistReviewRepository,
        },
        {
          provide: getRepositoryToken(SkillCatalog),
          useValue: mockSkillCatalogRepository,
        },
        {
          provide: PartnersService,
          useValue: mockPartnersService,
        },
        {
          provide: CreateDoctorHandler,
          useValue: mockCreateDoctorHandler,
        },
        {
          provide: CreateTherapistHandler,
          useValue: mockCreateTherapistHandler,
        },
        {
          provide: UpdateEmployeeHandler,
          useValue: mockUpdateEmployeeHandler,
        },
        {
          provide: RemoveEmployeeHandler,
          useValue: mockRemoveEmployeeHandler,
        },
        {
          provide: GetEmployeeOverviewAnalyticsHandler,
          useValue: mockGetOverviewAnalyticsHandler,
        },
        {
          provide: GetEmployeeDetailAnalyticsHandler,
          useValue: mockGetDetailAnalyticsHandler,
        },
      ],
    }).compile();

    service = module.get<EmployeesService>(EmployeesService);
    employeeRepository = module.get(getRepositoryToken(Employee));
    partnerRepository = module.get(getRepositoryToken(Partner));
    createDoctorHandler = module.get(CreateDoctorHandler);
    createTherapistHandler = module.get(CreateTherapistHandler);
    updateEmployeeHandler = module.get(UpdateEmployeeHandler);
    removeEmployeeHandler = module.get(RemoveEmployeeHandler);
    specialistReviewRepository = module.get(
      getRepositoryToken(SpecialistReview),
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ──────────────────────────────────────────────────────────────
  // Partner resolution
  // ──────────────────────────────────────────────────────────────

  describe('getPartnerIdByAccountId', () => {
    it('should return partner ID when partner exists', async () => {
      // Arrange
      const accountId = 'account-uuid';
      const partnerId = 'partner-uuid';
      mockPartnerRepository.findOne.mockResolvedValue({ id: partnerId });

      // Act
      const result = await service.getPartnerIdByAccountId(accountId);

      // Assert
      expect(result).toBe(partnerId);
      expect(mockPartnerRepository.findOne).toHaveBeenCalledWith({
        where: { accountId },
        select: ['id'],
      });
    });

    it('should throw NotFoundException when partner not found', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.getPartnerIdByAccountId('missing-account'),
      ).rejects.toThrow(NotFoundException);
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Create operations
  // ──────────────────────────────────────────────────────────────

  describe('createDoctor', () => {
    it('should delegate to CreateDoctorHandler', async () => {
      // Arrange
      const inputDto = {
        firstName: 'Nguyen',
        lastName: 'Van A',
        email: 'doctor@example.com',
        employeeId: 'DOC-001',
      };
      const expectedEmployee = {
        id: 'uuid-1',
        ...inputDto,
        role: EmployeeRole.DOCTOR,
      };
      mockCreateDoctorHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.createDoctor(inputDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockCreateDoctorHandler.execute).toHaveBeenCalledWith(inputDto);
    });

    it('should assign partnerId when provided', async () => {
      // Arrange
      const inputDto = {
        email: 'doctor@example.com',
        firstName: 'Nguyen',
        lastName: 'Van A',
        employeeId: 'DOC-001',
      } as any;
      const partnerId = 'partner-uuid';
      mockCreateDoctorHandler.execute.mockResolvedValue({ id: 'uuid-1' });

      // Act
      await service.createDoctor(inputDto, partnerId);

      // Assert
      expect(mockCreateDoctorHandler.execute).toHaveBeenCalledWith(
        expect.objectContaining({ email: 'doctor@example.com', partnerId }),
      );
    });
  });

  describe('createSpaTherapist', () => {
    it('should delegate to CreateTherapistHandler with SPA type', async () => {
      // Arrange
      const inputDto = {
        firstName: 'Le',
        lastName: 'Thi C',
        email: 'spa@example.com',
        employeeId: 'SPA-001',
      };
      const expectedEmployee = {
        id: 'uuid-2',
        ...inputDto,
        role: EmployeeRole.THERAPIST,
      };
      mockCreateTherapistHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.createSpaTherapist(inputDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockCreateTherapistHandler.execute).toHaveBeenCalledWith(
        inputDto,
        'SPA',
      );
    });

    it('should assign partnerId when provided', async () => {
      // Arrange
      const inputDto = {
        email: 'spa@example.com',
        firstName: 'Le',
        lastName: 'Thi C',
        employeeId: 'SPA-001',
      } as any;
      const partnerId = 'partner-uuid';
      mockCreateTherapistHandler.execute.mockResolvedValue({ id: 'uuid-2' });

      // Act
      await service.createSpaTherapist(inputDto, partnerId);

      // Assert
      expect(mockCreateTherapistHandler.execute).toHaveBeenCalledWith(
        expect.objectContaining({ email: 'spa@example.com', partnerId }),
        'SPA',
      );
    });
  });

  describe('createMassageTherapist', () => {
    it('should delegate to CreateTherapistHandler with MASSAGE type', async () => {
      // Arrange
      const inputDto = {
        firstName: 'Hoang',
        lastName: 'Van E',
        email: 'massage@example.com',
        employeeId: 'MSG-001',
      };
      const expectedEmployee = {
        id: 'uuid-3',
        ...inputDto,
        role: EmployeeRole.THERAPIST,
      };
      mockCreateTherapistHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.createMassageTherapist(inputDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockCreateTherapistHandler.execute).toHaveBeenCalledWith(
        inputDto,
        'MASSAGE',
      );
    });

    it('should assign partnerId when provided', async () => {
      // Arrange
      const inputDto = {
        email: 'massage@example.com',
        firstName: 'Hoang',
        lastName: 'Van E',
        employeeId: 'MSG-001',
      } as any;
      const partnerId = 'partner-uuid';
      mockCreateTherapistHandler.execute.mockResolvedValue({ id: 'uuid-3' });

      // Act
      await service.createMassageTherapist(inputDto, partnerId);

      // Assert
      expect(mockCreateTherapistHandler.execute).toHaveBeenCalledWith(
        expect.objectContaining({ email: 'massage@example.com', partnerId }),
        'MASSAGE',
      );
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Read operations
  // ──────────────────────────────────────────────────────────────

  describe('findAll', () => {
    it('should return all employees', async () => {
      // Arrange
      const expectedEmployees = [{ id: '1' }, { id: '2' }];
      mockEmployeeRepository.find.mockResolvedValue(expectedEmployees);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual(expectedEmployees);
    });

    it('should filter by role when provided', async () => {
      // Arrange
      mockEmployeeRepository.find.mockResolvedValue([]);

      // Act
      await service.findAll({ role: EmployeeRole.DOCTOR });

      // Assert
      expect(mockEmployeeRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { role: EmployeeRole.DOCTOR },
        }),
      );
    });

    it('should scope to partnerId when provided', async () => {
      // Arrange
      const partnerId = 'partner-uuid';
      mockEmployeeRepository.find.mockResolvedValue([]);

      // Act
      await service.findAll({ role: EmployeeRole.DOCTOR }, partnerId);

      // Assert
      expect(mockEmployeeRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { role: EmployeeRole.DOCTOR, partnerId },
        }),
      );
    });
  });

  describe('findOne', () => {
    it('should return an employee when found', async () => {
      // Arrange
      const expectedEmployee = { id: 'uuid-1', firstName: 'John' };
      mockEmployeeRepository.findOne.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.findOne('uuid-1');

      // Assert
      expect(result).toEqual(expectedEmployee);
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne('missing-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findReviewsByEmployee', () => {
    const createReviewQueryBuilder = (result: any[]) => ({
      innerJoinAndSelect: jest.fn().mockReturnThis(),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue(result),
    });

    it('should throw NotFoundException when employee is missing', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findReviewsByEmployee('missing-id')).rejects.toThrow(
        NotFoundException,
      );
      expect(
        specialistReviewRepository.createQueryBuilder,
      ).not.toHaveBeenCalled();
    });

    it('should return an empty list for an employee with no reviews', async () => {
      // Arrange
      const queryBuilder = createReviewQueryBuilder([]);
      mockEmployeeRepository.findOne.mockResolvedValue({ id: 'emp-uuid' });
      specialistReviewRepository.createQueryBuilder.mockReturnValue(
        queryBuilder,
      );

      // Act
      const result = await service.findReviewsByEmployee('emp-uuid');

      // Assert
      expect(result).toEqual([]);
      expect(queryBuilder.where).toHaveBeenCalledWith(
        'review.specialist_id = :id',
        { id: 'emp-uuid' },
      );
      expect(queryBuilder.orderBy).toHaveBeenCalledWith(
        'review.createdAt',
        'DESC',
      );
    });

    it('should return newest-first public employee reviews', async () => {
      // Arrange
      const newer = {
        id: 'review-new',
        rating: 5,
        comment: 'Excellent',
        tags: ['Professional'],
        wouldRecommend: true,
        createdAt: new Date('2026-03-30T10:00:00.000Z'),
        user: {
          userProfile: {
            firstName: 'Jane',
            lastName: 'Doe',
          },
        },
      };
      const older = {
        id: 'review-old',
        rating: 4,
        comment: null,
        tags: [],
        wouldRecommend: true,
        createdAt: new Date('2026-03-29T10:00:00.000Z'),
        user: {
          userProfile: {
            firstName: 'John',
            lastName: 'Smith',
          },
        },
      };
      const queryBuilder = createReviewQueryBuilder([newer, older]);
      mockEmployeeRepository.findOne.mockResolvedValue({ id: 'emp-uuid' });
      specialistReviewRepository.createQueryBuilder.mockReturnValue(
        queryBuilder,
      );

      // Act
      const result = await service.findReviewsByEmployee('emp-uuid');

      // Assert
      expect(result).toEqual([
        expect.objectContaining({
          id: 'review-new',
          reviewerName: 'Jane Doe',
          rating: 5,
          createdAt: '2026-03-30T10:00:00.000Z',
        }),
        expect.objectContaining({
          id: 'review-old',
          reviewerName: 'John Smith',
          rating: 4,
          createdAt: '2026-03-29T10:00:00.000Z',
        }),
      ]);
    });

    it('should map missing reviewer profile to Anonymous', async () => {
      // Arrange
      const queryBuilder = createReviewQueryBuilder([
        {
          id: 'review-anon',
          rating: 3,
          comment: 'Okay',
          tags: null,
          wouldRecommend: false,
          createdAt: new Date('2026-03-30T10:00:00.000Z'),
          user: {},
        },
      ]);
      mockEmployeeRepository.findOne.mockResolvedValue({ id: 'emp-uuid' });
      specialistReviewRepository.createQueryBuilder.mockReturnValue(
        queryBuilder,
      );

      // Act
      const result = await service.findReviewsByEmployee('emp-uuid');

      // Assert
      expect(result).toEqual([
        expect.objectContaining({
          id: 'review-anon',
          reviewerName: 'Anonymous',
          tags: [],
        }),
      ]);
    });
  });

  describe('findOneForPartner', () => {
    it('should return employee when found for partner', async () => {
      // Arrange
      const employee = { id: 'emp-uuid', partnerId: 'partner-uuid' };
      mockEmployeeRepository.findOne.mockResolvedValue(employee);

      // Act
      const result = await service.findOneForPartner(
        'emp-uuid',
        'partner-uuid',
      );

      // Assert
      expect(result).toEqual(employee);
      expect(mockEmployeeRepository.findOne).toHaveBeenCalledWith({
        where: { id: 'emp-uuid', partnerId: 'partner-uuid' },
        relations: ['doctorProfile', 'therapistProfile'],
      });
    });

    it('should throw NotFoundException when employee not owned by partner', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.findOneForPartner('emp-uuid', 'other-partner'),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('findAssignedServicesForPartner', () => {
    const createQueryBuilder = (result: any[]) => ({
      innerJoinAndSelect: jest.fn().mockReturnThis(),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      addOrderBy: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue(result),
    });

    it('should return assigned services for a partner-owned employee', async () => {
      // Arrange
      const queryBuilder = createQueryBuilder([
        {
          isPrimary: true,
          product: {
            id: 'service-uuid',
            name: 'Skin Consultation',
            status: HealthServiceStatus.ACTIVE,
            basePrice: '500000.00',
            salePrice: '450000.00',
            currency: 'VND',
            category: { name: 'Dermatology' },
            productDefinition: { durationMinutes: 45 },
            media: [
              {
                url: 'https://cdn.example.com/other.jpg',
                isThumbnail: false,
                sortOrder: 2,
              },
              {
                url: 'https://cdn.example.com/thumb.jpg',
                isThumbnail: true,
                sortOrder: 1,
              },
            ],
          },
        },
      ]);
      mockEmployeeRepository.findOne.mockResolvedValue({
        id: 'emp-uuid',
        partnerId: 'partner-uuid',
      });
      mockEligibilityRepository.createQueryBuilder.mockReturnValue(
        queryBuilder,
      );

      // Act
      const result = await service.findAssignedServicesForPartner(
        'emp-uuid',
        'partner-uuid',
      );

      // Assert
      expect(result).toEqual([
        {
          id: 'service-uuid',
          name: 'Skin Consultation',
          status: HealthServiceStatus.ACTIVE,
          basePrice: 500000,
          salePrice: 450000,
          currency: 'VND',
          durationMinutes: 45,
          categoryName: 'Dermatology',
          imageUrl: 'https://cdn.example.com/thumb.jpg',
          isPrimary: true,
        },
      ]);
      expect(queryBuilder.innerJoinAndSelect).toHaveBeenCalledWith(
        'eligibility.product',
        'product',
        'product.partner_id = :partnerId AND product.deleted_at IS NULL',
        { partnerId: 'partner-uuid' },
      );
      expect(queryBuilder.where).toHaveBeenCalledWith(
        'eligibility.employee_id = :employeeId',
        { employeeId: 'emp-uuid' },
      );
    });

    it('should return an empty list when the employee has no assignments', async () => {
      // Arrange
      const queryBuilder = createQueryBuilder([]);
      mockEmployeeRepository.findOne.mockResolvedValue({
        id: 'emp-uuid',
        partnerId: 'partner-uuid',
      });
      mockEligibilityRepository.createQueryBuilder.mockReturnValue(
        queryBuilder,
      );

      // Act
      const result = await service.findAssignedServicesForPartner(
        'emp-uuid',
        'partner-uuid',
      );

      // Assert
      expect(result).toEqual([]);
    });

    it('should throw NotFoundException when employee is not owned by partner', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.findAssignedServicesForPartner('emp-uuid', 'other-partner'),
      ).rejects.toThrow(NotFoundException);
      expect(
        mockEligibilityRepository.createQueryBuilder,
      ).not.toHaveBeenCalled();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Mutation operations
  // ──────────────────────────────────────────────────────────────

  describe('update', () => {
    it('should delegate to UpdateEmployeeHandler', async () => {
      // Arrange
      const updateDto = { firstName: 'Updated' };
      const expectedEmployee = { id: 'uuid-1', firstName: 'Updated' };
      mockUpdateEmployeeHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.update('uuid-1', updateDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockUpdateEmployeeHandler.execute).toHaveBeenCalledWith(
        'uuid-1',
        updateDto,
      );
    });
  });

  describe('updateForPartner', () => {
    it('should verify ownership then delegate to handler', async () => {
      // Arrange
      const employee = { id: 'emp-uuid', partnerId: 'partner-uuid' };
      const updateDto = { fullName: 'Updated' } as any;
      mockEmployeeRepository.findOne.mockResolvedValue(employee);
      mockUpdateEmployeeHandler.execute.mockResolvedValue({
        ...employee,
        ...updateDto,
      });

      // Act
      const result = await service.updateForPartner(
        'emp-uuid',
        'partner-uuid',
        updateDto,
      );

      // Assert
      expect(result).toEqual({ ...employee, ...updateDto });
      expect(mockEmployeeRepository.findOne).toHaveBeenCalledWith({
        where: { id: 'emp-uuid', partnerId: 'partner-uuid' },
        relations: ['doctorProfile', 'therapistProfile'],
      });
      expect(mockUpdateEmployeeHandler.execute).toHaveBeenCalledWith(
        'emp-uuid',
        updateDto,
      );
    });

    it('should throw NotFoundException if not owned', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.updateForPartner('emp-uuid', 'other-partner', {} as any),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveEmployeeHandler', async () => {
      // Arrange
      mockRemoveEmployeeHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove('uuid-1');

      // Assert
      expect(mockRemoveEmployeeHandler.execute).toHaveBeenCalledWith('uuid-1');
    });
  });

  describe('removeForPartner', () => {
    it('should verify ownership then delegate to handler', async () => {
      // Arrange
      const employee = { id: 'emp-uuid', partnerId: 'partner-uuid' };
      mockEmployeeRepository.findOne.mockResolvedValue(employee);
      mockRemoveEmployeeHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.removeForPartner('emp-uuid', 'partner-uuid');

      // Assert
      expect(mockEmployeeRepository.findOne).toHaveBeenCalledWith({
        where: { id: 'emp-uuid', partnerId: 'partner-uuid' },
        relations: ['doctorProfile', 'therapistProfile'],
      });
      expect(mockRemoveEmployeeHandler.execute).toHaveBeenCalledWith(
        'emp-uuid',
      );
    });

    it('should throw NotFoundException if not owned', async () => {
      // Arrange
      mockEmployeeRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.removeForPartner('emp-uuid', 'other-partner'),
      ).rejects.toThrow(NotFoundException);
    });
  });
});
