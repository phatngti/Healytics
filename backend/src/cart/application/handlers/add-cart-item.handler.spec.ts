import { BadRequestException } from '@nestjs/common';
import { AddCartItemHandler } from './add-cart-item.handler';
import { AutoStaffAssignmentService } from '@/booking/services/auto-staff-assignment.service';
import { CART_ERROR_CODES } from '@/cart/constants/cart-error-codes';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import {
  MockQueryRunner,
  createMockQueryRunner,
} from '../../../../test/mocks/mock-types';

describe('AddCartItemHandler', () => {
  let handler: AddCartItemHandler;
  let queryRunner: MockQueryRunner;
  let dataSource: {
    createQueryRunner: jest.Mock;
    manager: { findOne: jest.Mock };
  };
  let autoStaffAssignmentService: { resolveBestStaff: jest.Mock };

  const userId = 'user-1';
  const serviceId = 'service-1';
  const timeSlot = '2026-04-06T09:00:00.000Z';
  const autoAssignedEmployeeId = 'employee-auto';

  beforeEach(() => {
    queryRunner = createMockQueryRunner();
    dataSource = {
      createQueryRunner: jest.fn().mockReturnValue(queryRunner),
      manager: {
        findOne: jest.fn(),
      },
    };
    autoStaffAssignmentService = {
      resolveBestStaff: jest.fn(),
    };

    handler = new AddCartItemHandler(
      dataSource as never,
      autoStaffAssignmentService as unknown as AutoStaffAssignmentService,
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should resolve and save the best available specialist for auto-assigned cart items', async () => {
    autoStaffAssignmentService.resolveBestStaff.mockResolvedValue({
      staffId: autoAssignedEmployeeId,
      available: true,
    });
    queryRunner.manager.findOne.mockImplementation(async (entity) => {
      if (entity === Product) {
        return { id: serviceId };
      }
      if (entity === Employee) {
        return { id: autoAssignedEmployeeId, role: EmployeeRole.DOCTOR };
      }
      if (entity === ProductEmployeeEligibility) {
        return { productId: serviceId, employeeId: autoAssignedEmployeeId };
      }
      return null;
    });
    queryRunner.manager.create.mockReturnValue({
      userId,
      serviceId,
      employeeId: autoAssignedEmployeeId,
      timeSlot: new Date(timeSlot),
    });
    queryRunner.manager.save.mockResolvedValue({ id: 'cart-item-1' });

    const loadedCartItem = {
      id: 'cart-item-1',
      userId,
      serviceId,
      employeeId: autoAssignedEmployeeId,
    } as CartItem;
    dataSource.manager.findOne.mockResolvedValue(loadedCartItem);

    const result = await handler.execute(userId, {
      serviceId,
      timeSlot,
      autoAssignStaff: true,
    });

    expect(result).toBe(loadedCartItem);
    expect(autoStaffAssignmentService.resolveBestStaff).toHaveBeenCalledWith(
      serviceId,
      new Date(timeSlot),
    );
    expect(queryRunner.manager.findOne).toHaveBeenCalledWith(Employee, {
      where: { id: autoAssignedEmployeeId },
    });
    expect(queryRunner.manager.create).toHaveBeenCalledWith(CartItem, {
      userId,
      serviceId,
      employeeId: autoAssignedEmployeeId,
      timeSlot: new Date(timeSlot),
    });
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.rollbackTransaction).not.toHaveBeenCalled();
  });

  it('should reject auto-assigned cart items when no specialist is available', async () => {
    autoStaffAssignmentService.resolveBestStaff.mockResolvedValue({
      staffId: autoAssignedEmployeeId,
      available: false,
    });

    await expect(
      handler.execute(userId, {
        serviceId,
        timeSlot,
        autoAssignStaff: true,
      }),
    ).rejects.toMatchObject<Partial<BadRequestException>>({
      response: {
        code: CART_ERROR_CODES.INVALID_EMPLOYEE,
        message: 'No specialist is available for this time slot',
      },
    });

    expect(dataSource.createQueryRunner).not.toHaveBeenCalled();
  });
});
