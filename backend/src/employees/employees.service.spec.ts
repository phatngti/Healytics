import { Test, TestingModule } from '@nestjs/testing';
import { EmployeesService } from './employees.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Employee } from './entities/employee.entity';
import { NotFoundException } from '@nestjs/common';
import { EmployeeRole } from './enum/employee-role.enum';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';

describe('EmployeesService', () => {
  let service: EmployeesService;
  let employeeRepository: Record<string, jest.Mock>;
  let createDoctorHandler: Record<string, jest.Mock>;
  let createTherapistHandler: Record<string, jest.Mock>;
  let updateEmployeeHandler: Record<string, jest.Mock>;
  let removeEmployeeHandler: Record<string, jest.Mock>;

  const mockEmployeeRepository = {
    find: jest.fn(),
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

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EmployeesService,
        {
          provide: getRepositoryToken(Employee),
          useValue: mockEmployeeRepository,
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
      ],
    }).compile();

    service = module.get<EmployeesService>(EmployeesService);
    employeeRepository = module.get(getRepositoryToken(Employee));
    createDoctorHandler = module.get(CreateDoctorHandler);
    createTherapistHandler = module.get(CreateTherapistHandler);
    updateEmployeeHandler = module.get(UpdateEmployeeHandler);
    removeEmployeeHandler = module.get(RemoveEmployeeHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createDoctor', () => {
    it('should delegate to CreateDoctorHandler', async () => {
      // Arrange
      const inputDto = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        profile: { specialization: 'Cardiology' },
      };
      const expectedEmployee = { id: 'uuid-1', ...inputDto, role: EmployeeRole.DOCTOR };
      mockCreateDoctorHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.createDoctor(inputDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockCreateDoctorHandler.execute).toHaveBeenCalledWith(inputDto);
    });
  });

  describe('createTherapist', () => {
    it('should delegate to CreateTherapistHandler', async () => {
      // Arrange
      const inputDto = {
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        profile: { certifications: ['Massage'] },
      };
      const expectedEmployee = { id: 'uuid-2', ...inputDto, role: EmployeeRole.THERAPIST };
      mockCreateTherapistHandler.execute.mockResolvedValue(expectedEmployee);

      // Act
      const result = await service.createTherapist(inputDto as any);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(mockCreateTherapistHandler.execute).toHaveBeenCalledWith(inputDto);
    });
  });

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
      await expect(service.findOne('missing-id')).rejects.toThrow(NotFoundException);
    });
  });

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
      expect(mockUpdateEmployeeHandler.execute).toHaveBeenCalledWith('uuid-1', updateDto);
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
});
