import { Test, TestingModule } from '@nestjs/testing';
import { EmployeesService } from './employees.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Booking } from '@/common/entities/booking.entity';
import { NotFoundException } from '@nestjs/common';
import { EmployeeRole } from './enum/employee-role.enum';
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
  };

  const mockBookingRepository = {
    find: jest.fn(),
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
