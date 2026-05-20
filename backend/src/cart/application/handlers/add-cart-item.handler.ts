import {
  BadRequestException,
  ConflictException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { DataSource, QueryFailedError } from 'typeorm';
import { AddToCartDto } from '@/cart/dto/add-to-cart.dto';
import { CartItem } from '@/cart/entities/cart-item.entity';
import {
  CART_ERROR_CODES,
  POSTGRES_UNIQUE_VIOLATION,
} from '@/cart/constants/cart-error-codes';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';

/** Employee roles allowed to be assigned to a cart item. */
const ALLOWED_EMPLOYEE_ROLES: EmployeeRole[] = [
  EmployeeRole.DOCTOR,
  EmployeeRole.THERAPIST,
];

@Injectable()
export class AddCartItemHandler {
  private readonly logger = new Logger(AddCartItemHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(userId: string, dto: AddToCartDto): Promise<CartItem> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Validate service exists and is active
      const service = await queryRunner.manager.findOne(Product, {
        where: {
          id: dto.serviceId,
          type: HealthServiceType.SERVICE,
          status: HealthServiceStatus.ACTIVE,
          isVisibleOnline: true,
        },
      });

      if (!service) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.INVALID_SERVICE,
          message: 'Service ID does not exist or is inactive',
        });
      }

      // 2. Validate employee exists and has allowed role
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { id: dto.employeeId },
      });

      if (!employee) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.INVALID_EMPLOYEE,
          message: 'Employee not found',
        });
      }

      if (!ALLOWED_EMPLOYEE_ROLES.includes(employee.role)) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.INVALID_EMPLOYEE,
          message: `Employee must be a DOCTOR or THERAPIST, got ${employee.role}`,
        });
      }

      // 3. Validate employee is eligible for this service
      const eligibility = await queryRunner.manager.findOne(
        ProductEmployeeEligibility,
        {
          where: {
            productId: dto.serviceId,
            employeeId: dto.employeeId,
          },
        },
      );

      if (!eligibility) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.EMPLOYEE_NOT_ELIGIBLE,
          message: 'Employee is not eligible to perform this service',
        });
      }

      // 4. Create cart item
      const cartItem = queryRunner.manager.create(CartItem, {
        userId,
        serviceId: dto.serviceId,
        employeeId: dto.employeeId,
        timeSlot: new Date(dto.timeSlot),
      });

      const savedCartItem = await queryRunner.manager.save(CartItem, cartItem);

      await queryRunner.commitTransaction();

      return this.loadCartItem(savedCartItem.id, userId);
    } catch (error) {
      await queryRunner.rollbackTransaction();

      if (error instanceof BadRequestException) {
        throw error;
      }

      if (
        error instanceof QueryFailedError &&
        (error as QueryFailedError & { code?: string }).code ===
          POSTGRES_UNIQUE_VIOLATION
      ) {
        throw new ConflictException({
          code: CART_ERROR_CODES.ITEM_ALREADY_EXISTS,
          message:
            'This service with the same employee and time slot is already in cart',
        });
      }

      this.logger.error(
        `Failed to add item to cart: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException('Failed to add item to cart');
    } finally {
      await queryRunner.release();
    }
  }

  private async loadCartItem(
    cartItemId: string,
    userId: string,
  ): Promise<CartItem> {
    const item = await this.dataSource.manager.findOne(CartItem, {
      where: { id: cartItemId, userId },
      relations: ['service', 'service.partner', 'service.media', 'employee'],
    });

    if (!item) {
      throw new InternalServerErrorException('Created cart item was not found');
    }

    return item;
  }
}
