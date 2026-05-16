import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Not } from 'typeorm';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { Booking } from '@/common/entities/booking.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';
import { UserProfileSummaryService } from './user-profile-summary.service';

describe('UserProfileSummaryService', () => {
  let service: UserProfileSummaryService;
  let bookingRepo: MockRepository<Booking>;
  let wishlistRepo: MockRepository<UserWishlistItem>;

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();
    wishlistRepo = createMockRepository<UserWishlistItem>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserProfileSummaryService,
        { provide: getRepositoryToken(Booking), useValue: bookingRepo },
        {
          provide: getRepositoryToken(UserWishlistItem),
          useValue: wishlistRepo,
        },
      ],
    }).compile();

    service = module.get(UserProfileSummaryService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('returns booking and wishlist counts with stable points fields', async () => {
    bookingRepo.count.mockResolvedValue(12);
    wishlistRepo.count.mockResolvedValue(48);

    const result = await service.getSummary('user-1');

    expect(bookingRepo.count).toHaveBeenCalledWith({
      where: {
        userId: 'user-1',
        status: Not(BookingStatus.CANCELLED),
      },
    });
    expect(wishlistRepo.count).toHaveBeenCalledWith({
      where: { userId: 'user-1' },
    });
    expect(result).toEqual({
      ordersCount: 12,
      wishlistCount: 48,
      points: 0,
      pointsLabel: '0',
    });
  });
});
