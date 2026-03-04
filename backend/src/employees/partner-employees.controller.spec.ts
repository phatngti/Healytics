import { Test, TestingModule } from '@nestjs/testing';
import { PartnerEmployeesController } from './partner-employees.controller';
import { EmployeesService } from './employees.service';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { MockType } from '../../test/mocks/mock-types';
import { EmployeeRole } from './enum/employee-role.enum';

describe('PartnerEmployeesController', () => {
  let controller: PartnerEmployeesController;
  let employeesService: MockType<EmployeesService>;

  const mockAccountId = 'account-uuid';
  const mockPartnerId = 'partner-uuid';
  const mockReq = { user: { id: mockAccountId } };

  beforeEach(async () => {
    const mockEmployeesService: MockType<EmployeesService> = {
      getPartnerIdByAccountId: jest.fn().mockResolvedValue(mockPartnerId),
      createDoctor: jest.fn(),
      createTherapist: jest.fn(),
      findAll: jest.fn(),
      findOneForPartner: jest.fn(),
      updateForPartner: jest.fn(),
      removeForPartner: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PartnerEmployeesController],
      providers: [
        {
          provide: EmployeesService,
          useValue: mockEmployeesService,
        },
      ],
    }).compile();

    controller = module.get<PartnerEmployeesController>(PartnerEmployeesController);
    employeesService = module.get(EmployeesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createDoctor', () => {
    it('should resolve partnerId and call service.createDoctor', async () => {
      // Arrange
      const dto: CreateDoctorDto = {
        fullName: 'Dr. John Doe',
        email: 'john@example.com',
      } as CreateDoctorDto;
      const expectedEmployee = { id: 'uuid-1', ...dto, role: EmployeeRole.DOCTOR };
      employeesService.createDoctor!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.createDoctor(mockReq, dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.createDoctor).toHaveBeenCalledWith(dto, mockPartnerId);
    });
  });

  describe('createTherapist', () => {
    it('should resolve partnerId and call service.createTherapist', async () => {
      // Arrange
      const dto: CreateTherapistDto = {
        fullName: 'Jane Smith',
        email: 'jane@example.com',
      } as CreateTherapistDto;
      const expectedEmployee = { id: 'uuid-2', ...dto, role: EmployeeRole.THERAPIST };
      employeesService.createTherapist!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.createTherapist(mockReq, dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.createTherapist).toHaveBeenCalledWith(dto, mockPartnerId);
    });
  });

  describe('findAll', () => {
    it('should resolve partnerId and call service.findAll with query and partnerId', async () => {
      // Arrange
      const query: GetEmployeesQueryDto = { role: EmployeeRole.DOCTOR };
      const expectedEmployees = [{ id: '1' }, { id: '2' }];
      employeesService.findAll!.mockResolvedValue(expectedEmployees);

      // Act
      const result = await controller.findAll(mockReq, query);

      // Assert
      expect(result).toEqual(expectedEmployees);
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.findAll).toHaveBeenCalledWith(query, mockPartnerId);
    });

    it('should work with empty query', async () => {
      // Arrange
      const query: GetEmployeesQueryDto = {};
      const expectedEmployees = [];
      employeesService.findAll!.mockResolvedValue(expectedEmployees);

      // Act
      const result = await controller.findAll(mockReq, query);

      // Assert
      expect(result).toEqual(expectedEmployees);
      expect(employeesService.findAll).toHaveBeenCalledWith(query, mockPartnerId);
    });
  });

  describe('findOne', () => {
    it('should resolve partnerId and call service.findOneForPartner', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedEmployee = { id, fullName: 'John Doe' };
      employeesService.findOneForPartner!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.findOne(mockReq, id);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.findOneForPartner).toHaveBeenCalledWith(id, mockPartnerId);
    });
  });

  describe('update', () => {
    it('should resolve partnerId and call service.updateForPartner', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateEmployeeDto = { fullName: 'Updated Name' } as UpdateEmployeeDto;
      const expectedEmployee = { id, fullName: 'Updated Name' };
      employeesService.updateForPartner!.mockResolvedValue(expectedEmployee);

      // Act
      const result = await controller.update(mockReq, id, dto);

      // Assert
      expect(result).toEqual(expectedEmployee);
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.updateForPartner).toHaveBeenCalledWith(id, mockPartnerId, dto);
    });
  });

  describe('remove', () => {
    it('should resolve partnerId and call service.removeForPartner', async () => {
      // Arrange
      const id = 'uuid-1';
      employeesService.removeForPartner!.mockResolvedValue(undefined);

      // Act
      await controller.remove(mockReq, id);

      // Assert
      expect(employeesService.getPartnerIdByAccountId).toHaveBeenCalledWith(mockAccountId);
      expect(employeesService.removeForPartner).toHaveBeenCalledWith(id, mockPartnerId);
    });
  });
});
