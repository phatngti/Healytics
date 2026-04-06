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
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';

@Injectable()
export class AddCartItemHandler {
  private readonly logger = new Logger(AddCartItemHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(userId: string, dto: AddToCartDto): Promise<CartItem> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
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

      const cartItem = queryRunner.manager.create(CartItem, {
        userId,
        serviceId: dto.serviceId,
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
          message: 'Service is already in cart',
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

  private async loadCartItem(cartItemId: string, userId: string): Promise<CartItem> {
    const item = await this.dataSource.manager.findOne(CartItem, {
      where: { id: cartItemId, userId },
      relations: ['service', 'service.partner', 'service.media'],
    });

    if (!item) {
      throw new InternalServerErrorException('Created cart item was not found');
    }

    return item;
  }
}
