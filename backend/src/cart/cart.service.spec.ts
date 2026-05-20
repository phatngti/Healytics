import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { CartService } from '@/cart/cart.service';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  MockRepository,
  MockHandler,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('CartService', () => {
  let service: CartService;
  let cartRepository: MockRepository<CartItem>;
  let bookingRepository: MockRepository<Booking>;
  let checkoutTicketRepository: MockRepository<CheckoutTicket>;
  let addHandler: MockHandler;
  let removeHandler: MockHandler;
  let clearHandler: MockHandler;

  /** Monday 09:00 UTC — falls within the schedule below. */
  const mondaySlot = new Date('2026-04-06T09:00:00.000Z');

  const createCartItemEntity = (
    overrides: Partial<CartItem> = {},
  ): CartItem => {
    const now = new Date('2026-04-01T00:00:00.000Z');

    return {
      id: 'cart-item-1',
      userId: 'user-1',
      serviceId: 'service-1',
      employeeId: 'employee-1',
      timeSlot: mondaySlot,
      status: CartItemStatus.ACTIVE,
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
      employee: {
        id: 'employee-1',
        fullName: 'Dr. Anna Nguyen',
        role: 'DOCTOR',
        avatarUrl: 'https://cdn.example.com/avatar.jpg',
        schedule: [
          { day: 'Monday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Tuesday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Sunday', start: '', end: '', isWorking: false },
        ],
      },
      ...overrides,
    } as unknown as CartItem;
  };

  beforeEach(async () => {
    cartRepository = createMockRepository<CartItem>();
    bookingRepository = createMockRepository<Booking>();
    checkoutTicketRepository = createMockRepository<CheckoutTicket>();
    addHandler = createMockHandler();
    removeHandler = createMockHandler();
    clearHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CartService,
        {
          provide: getRepositoryToken(CartItem),
          useValue: cartRepository,
        },
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepository,
        },
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: checkoutTicketRepository,
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

  it('should list ACTIVE cart items with employee info', async () => {
    const userId = 'user-1';
    cartRepository.find.mockResolvedValue([createCartItemEntity()]);
    bookingRepository.find.mockResolvedValue([]);
    checkoutTicketRepository.find.mockResolvedValue([]);

    const result = await service.getCartItems(userId);

    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('cart-item-1');
    expect(result[0].serviceName).toBe('Therapy Service');
    expect(result[0].price).toBe('500.000đ');
    expect(result[0].clinicName).toBe('Healing Clinic');
    expect(result[0].employeeId).toBe('employee-1');
    expect(result[0].employeeName).toBe('Dr. Anna Nguyen');
    expect(result[0].employeeRole).toBe('DOCTOR');
    expect(result[0].timeSlot).toBe(mondaySlot.toISOString());
    expect(result[0].isTimeSlotAvailable).toBe(true);
    expect(result[0].status).toBe(CartItemStatus.ACTIVE);
    expect(cartRepository.find).toHaveBeenCalledWith({
      where: { userId, status: CartItemStatus.ACTIVE },
      relations: ['service', 'service.partner', 'service.media', 'employee'],
      order: { createdAt: 'DESC' },
    });
  });

  it('should flag time slot as unavailable when a booking conflict exists', async () => {
    const userId = 'user-1';
    cartRepository.find.mockResolvedValue([createCartItemEntity()]);
    bookingRepository.find.mockResolvedValue([
      {
        staffId: 'employee-1',
        startTime: mondaySlot,
        status: BookingStatus.CONFIRMED,
      },
    ]);
    checkoutTicketRepository.find.mockResolvedValue([]);

    const result = await service.getCartItems(userId);

    expect(result).toHaveLength(1);
    expect(result[0].isTimeSlotAvailable).toBe(false);
  });

  it('should flag time slot as unavailable when outside employee schedule', async () => {
    const userId = 'user-1';
    // Sunday — employee does not work Sundays
    const sundaySlot = new Date('2026-04-05T09:00:00.000Z');
    cartRepository.find.mockResolvedValue([
      createCartItemEntity({ timeSlot: sundaySlot }),
    ]);
    bookingRepository.find.mockResolvedValue([]);
    checkoutTicketRepository.find.mockResolvedValue([]);

    const result = await service.getCartItems(userId);

    expect(result).toHaveLength(1);
    expect(result[0].isTimeSlotAvailable).toBe(false);
  });

  it('should return empty array when cart is empty', async () => {
    cartRepository.find.mockResolvedValue([]);

    const result = await service.getCartItems('user-1');

    expect(result).toEqual([]);
    expect(bookingRepository.find).not.toHaveBeenCalled();
  });

  it('should delegate add item to handler', async () => {
    const userId = 'user-1';
    const dto = {
      serviceId: 'service-1',
      employeeId: 'employee-1',
      timeSlot: '2026-04-06T09:00:00.000Z',
    };
    addHandler.execute.mockResolvedValue(createCartItemEntity());

    const result = await service.addItem(userId, dto);

    expect(addHandler.execute).toHaveBeenCalledWith(userId, dto);
    expect(result.id).toBe('cart-item-1');
    expect(result.employeeId).toBe('employee-1');
  });

  it('should delegate remove item to handler', async () => {
    const userId = 'user-1';
    const cartItemId = 'cart-item-1';
    removeHandler.execute.mockResolvedValue(undefined);

    await service.removeItem(userId, cartItemId);

    expect(removeHandler.execute).toHaveBeenCalledWith(userId, cartItemId);
  });

  it('should delegate clear cart to handler', async () => {
    const userId = 'user-1';
    clearHandler.execute.mockResolvedValue(undefined);

    await service.clearCart(userId);

    expect(clearHandler.execute).toHaveBeenCalledWith(userId);
  });
});
