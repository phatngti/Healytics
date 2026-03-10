import { Test, TestingModule } from '@nestjs/testing';
import { UserEmployeesController } from './user-employees.controller';
import { EmployeesService } from './employees.service';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { MockType } from '../../test/mocks/mock-types';
import { EmployeeRole } from './enum/employee-role.enum';

describe('UserEmployeesController', () => {
  let controller: UserEmployeesController;
  let employeesService: MockType<EmployeesService>;

  beforeEach(async () => {
    const mockEmployeesService: MockType<EmployeesService> = {
      createDoctor: jest.fn(),
      createSpaTherapist: jest.fn(),
      createMassageTherapist: jest.fn(),
      findAll: jest.fn(),
      findOne: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserEmployeesController],
      providers: [
        {
          provide: EmployeesService,
          useValue: mockEmployeesService,
        },
      ],
    }).compile();

    controller = module.get<UserEmployeesController>(UserEmployeesController);
    employeesService = module.get(EmployeesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
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
});
