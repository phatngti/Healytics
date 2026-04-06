import { Test, TestingModule } from '@nestjs/testing';
import { CartController } from '@/cart/cart.controller';
import { CartService } from '@/cart/cart.service';
import { MockType } from '../../test/mocks/mock-types';
import { AddToCartDto } from '@/cart/dto/add-to-cart.dto';
import { ApplyCouponDto } from '@/cart/dto/apply-coupon.dto';

describe('CartController', () => {
  let controller: CartController;
  let cartService: MockType<CartService>;

  beforeEach(async () => {
    const mockCartService: MockType<CartService> = {
      getCartItems: jest.fn(),
      addItem: jest.fn(),
      removeItem: jest.fn(),
      applyCoupon: jest.fn(),
      removeCoupon: jest.fn(),
      clearCart: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [CartController],
      providers: [
        {
          provide: CartService,
          useValue: mockCartService,
        },
      ],
    }).compile();

    controller = module.get<CartController>(CartController);
    cartService = module.get(CartService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return current user cart items', async () => {
    const userId = 'user-1';
    const expected = [{ id: 'cart-1' }];
    cartService.getCartItems!.mockResolvedValue(expected);

    const result = await controller.getItems(userId);

    expect(result).toEqual(expected);
    expect(cartService.getCartItems).toHaveBeenCalledWith(userId);
  });

  it('should add a service to cart', async () => {
    const userId = 'user-1';
    const dto: AddToCartDto = {
      serviceId: 'eb286357-c1fa-4ffd-9d3e-f9a26ef4a783',
    };
    const expected = { id: 'cart-1', serviceId: dto.serviceId };
    cartService.addItem!.mockResolvedValue(expected);

    const result = await controller.addItem(userId, dto);

    expect(result).toEqual(expected);
    expect(cartService.addItem).toHaveBeenCalledWith(userId, dto);
  });

  it('should remove a cart item', async () => {
    const userId = 'user-1';
    const cartItemId = 'b4687717-a2d4-4c92-8091-6e8e729ad9b7';
    cartService.removeItem!.mockResolvedValue(undefined);

    await controller.removeItem(userId, cartItemId);

    expect(cartService.removeItem).toHaveBeenCalledWith(userId, cartItemId);
  });

  it('should apply coupon to cart item', async () => {
    const userId = 'user-1';
    const cartItemId = 'b4687717-a2d4-4c92-8091-6e8e729ad9b7';
    const dto: ApplyCouponDto = { couponCode: 'WELCOME10' };
    const expected = { id: cartItemId, couponCode: 'WELCOME10' };
    cartService.applyCoupon!.mockResolvedValue(expected);

    const result = await controller.applyCoupon(userId, cartItemId, dto);

    expect(result).toEqual(expected);
    expect(cartService.applyCoupon).toHaveBeenCalledWith(userId, cartItemId, dto);
  });

  it('should remove coupon from cart item', async () => {
    const userId = 'user-1';
    const cartItemId = 'b4687717-a2d4-4c92-8091-6e8e729ad9b7';
    const expected = { id: cartItemId, couponCode: null };
    cartService.removeCoupon!.mockResolvedValue(expected);

    const result = await controller.removeCoupon(userId, cartItemId);

    expect(result).toEqual(expected);
    expect(cartService.removeCoupon).toHaveBeenCalledWith(userId, cartItemId);
  });

  it('should clear all cart items', async () => {
    const userId = 'user-1';
    cartService.clearCart!.mockResolvedValue(undefined);

    await controller.clearCart(userId);

    expect(cartService.clearCart).toHaveBeenCalledWith(userId);
  });
});
