import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { CartService } from '@/cart/cart.service';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ApplyCouponHandler } from '@/cart/application/handlers/apply-coupon.handler';
import { RemoveCartCouponHandler } from '@/cart/application/handlers/remove-cart-coupon.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';
import {
  MockRepository,
  MockHandler,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('CartService', () => {
  let service: CartService;
  let cartRepository: MockRepository<CartItem>;
  let addHandler: MockHandler;
  let removeHandler: MockHandler;
  let applyCouponHandler: MockHandler;
  let removeCouponHandler: MockHandler;
  let clearHandler: MockHandler;

  const createCartItemEntity = (
    overrides: Partial<CartItem> = {},
  ): CartItem => {
    const now = new Date('2026-04-01T00:00:00.000Z');

    return {
      id: 'cart-item-1',
      userId: 'user-1',
      serviceId: 'service-1',
      couponCode: null,
      couponDiscountPercent: null,
      couponDiscountAmount: null,
      createdAt: now,
      updatedAt: now,
      service: {
        id: 'service-1',
        name: 'Therapy Service',
        salePrice: null,
        basePrice: 500000,
        media: [
          {
            id: 'media-1',
            url: 'https://cdn.example.com/service.jpg',
            isThumbnail: true,
          },
        ],
        partner: {
          id: 'clinic-1',
          brandName: 'Healing Clinic',
          streetAddress: '123 Main St',
        },
      },
      ...overrides,
    } as unknown as CartItem;
  };

  beforeEach(async () => {
    cartRepository = createMockRepository<CartItem>();
    addHandler = createMockHandler();
    removeHandler = createMockHandler();
    applyCouponHandler = createMockHandler();
    removeCouponHandler = createMockHandler();
    clearHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CartService,
        {
          provide: getRepositoryToken(CartItem),
          useValue: cartRepository,
        },
        {
          provide: AddCartItemHandler,
          useValue: addHandler,
        },
        {
          provide: RemoveCartItemHandler,
          useValue: removeHandler,
        },
        {
          provide: ApplyCouponHandler,
          useValue: applyCouponHandler,
        },
        {
          provide: RemoveCartCouponHandler,
          useValue: removeCouponHandler,
        },
        {
          provide: ClearCartHandler,
          useValue: clearHandler,
        },
      ],
    }).compile();

    service = module.get<CartService>(CartService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should list cart items and map to response DTO', async () => {
    const userId = 'user-1';
    cartRepository.find.mockResolvedValue([createCartItemEntity()]);

    const result = await service.getCartItems(userId);

    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('cart-item-1');
    expect(result[0].serviceName).toBe('Therapy Service');
    expect(result[0].price).toBe('500.000đ');
    expect(result[0].clinicName).toBe('Healing Clinic');
    expect(cartRepository.find).toHaveBeenCalledWith({
      where: { userId },
      relations: ['service', 'service.partner', 'service.media'],
      order: { createdAt: 'DESC' },
    });
  });

  it('should delegate add item to handler', async () => {
    const userId = 'user-1';
    const dto = { serviceId: 'service-1' };
    addHandler.execute.mockResolvedValue(createCartItemEntity());

    const result = await service.addItem(userId, dto);

    expect(addHandler.execute).toHaveBeenCalledWith(userId, dto);
    expect(result.id).toBe('cart-item-1');
  });

  it('should delegate remove item to handler', async () => {
    const userId = 'user-1';
    const cartItemId = 'cart-item-1';
    removeHandler.execute.mockResolvedValue(undefined);

    await service.removeItem(userId, cartItemId);

    expect(removeHandler.execute).toHaveBeenCalledWith(userId, cartItemId);
  });

  it('should delegate apply coupon to handler', async () => {
    const userId = 'user-1';
    const cartItemId = 'cart-item-1';
    const dto = { couponCode: 'WELCOME10' };
    applyCouponHandler.execute.mockResolvedValue(
      createCartItemEntity({
        couponCode: 'WELCOME10',
        couponDiscountPercent: 10,
        couponDiscountAmount: 50000,
      }),
    );

    const result = await service.applyCoupon(userId, cartItemId, dto);

    expect(applyCouponHandler.execute).toHaveBeenCalledWith(userId, cartItemId, dto);
    expect(result.couponCode).toBe('WELCOME10');
    expect(result.couponDiscountAmount).toBe(50000);
  });

  it('should delegate remove coupon to handler', async () => {
    const userId = 'user-1';
    const cartItemId = 'cart-item-1';
    removeCouponHandler.execute.mockResolvedValue(createCartItemEntity());

    const result = await service.removeCoupon(userId, cartItemId);

    expect(removeCouponHandler.execute).toHaveBeenCalledWith(userId, cartItemId);
    expect(result.couponCode).toBeNull();
  });

  it('should delegate clear cart to handler', async () => {
    const userId = 'user-1';
    clearHandler.execute.mockResolvedValue(undefined);

    await service.clearCart(userId);

    expect(clearHandler.execute).toHaveBeenCalledWith(userId);
  });
});
