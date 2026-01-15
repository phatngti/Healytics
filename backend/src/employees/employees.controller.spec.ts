import { Test, TestingModule } from '@nestjs/testing';
import { EmployeesController } from './employees.controller';
import { EmployeesService } from './employees.service';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { MockType } from '../../test/mocks/mock-types';
import { EmployeeRole } from './enum/employee-role.enum';

describe('EmployeesController', () => {
  let controller: EmployeesController;
  let employeesService: MockType<EmployeesService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for EmployeesService
    const mockEmployeesService: MockType<EmployeesService> = {
      createDoctor: jest.fn(),
      createTherapist: jest.fn(),
      findAll: jest.fn(),
      findOne: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [EmployeesController],
      providers: [
        {
          provide: EmployeesService,
          useValue: mockEmployeesService,
        },
      ],
    }).compile();

    controller = module.get<EmployeesController>(EmployeesController);
    employeesService = module.get(EmployeesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createDoctor', () => {
    it('should call service.createDoctor with DTO and return created doctor', async () => {
      // Arrange
      const dto: CreateDoctorDto = {
        fullName: 'Dr. John Doe',
        email: 'john@example.com',
      } as CreateDoctorDto;
      const expectedEmployee = { id: 'uuid-1', ...dto, role: EmployeeRole.DOCTOR };
      employeesService.createDoctor!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.createDoctor(dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.createDoctor).toHaveBeenCalledWith(dto);
      expect(employeesService.createDoctor).toHaveBeenCalledTimes(1);
    });
  });

  describe('createTherapist', () => {
    it('should call service.createTherapist with DTO and return created therapist', async () => {
      // Arrange
      const dto: CreateTherapistDto = {
        fullName: 'Jane Smith',
        email: 'jane@example.com',
      } as CreateTherapistDto;
      const expectedEmployee = { id: 'uuid-2', ...dto, role: EmployeeRole.THERAPIST };
      employeesService.createTherapist!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.createTherapist(dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.createTherapist).toHaveBeenCalledWith(dto);
      expect(employeesService.createTherapist).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAll', () => {
    it('should call service.findAll with query and return employees', async () => {
      // Arrange
      const query: GetEmployeesQueryDto = { role: EmployeeRole.DOCTOR };
      const expectedEmployees = [{ id: '1' }, { id: '2' }];
      employeesService.findAll!.mockResolvedValue(expectedEmployees);

      // Act
      const result = await controller.findAll(query);

      // Assert
      expect(result).toEqual(expectedEmployees);
      expect(employeesService.findAll).toHaveBeenCalledWith(query);
    });

    it('should call service.findAll with empty query', async () => {
      // Arrange
      const query: GetEmployeesQueryDto = {};
      const expectedEmployees = [];
      employeesService.findAll!.mockResolvedValue(expectedEmployees);

      // Act
      const result = await controller.findAll(query);

      // Assert
      expect(result).toEqual(expectedEmployees);
      expect(employeesService.findAll).toHaveBeenCalledWith(query);
    });
  });

  describe('findOne', () => {
    it('should call service.findOne with ID and return employee', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedEmployee = { id, fullName: 'John Doe' };
      employeesService.findOne!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.findOne(id);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.findOne).toHaveBeenCalledWith(id);
    });
  });

  describe('update', () => {
    it('should call service.update with ID and DTO and return updated employee', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateEmployeeDto = { fullName: 'Updated Name' } as UpdateEmployeeDto;
      const expectedEmployee = { id, fullName: 'Updated Name' };
      employeesService.update!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.update(id, dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.update).toHaveBeenCalledWith(id, dto);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID', async () => {
      // Arrange
      const id = 'uuid-1';
      employeesService.remove!.mockResolvedValue(undefined);

      // Act
      await controller.remove(id);

      // Assert
      expect(employeesService.remove).toHaveBeenCalledWith(id);
      expect(employeesService.remove).toHaveBeenCalledTimes(1);
    });
  });
});
