import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { UserProfileSummaryResponseDto } from './dto/user-profile-summary-response.dto';

@Injectable()
export class UserProfileSummaryService {
  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(UserWishlistItem)
    private readonly wishlistRepo: Repository<UserWishlistItem>,
  ) {}

  async getSummary(userId: string): Promise<UserProfileSummaryResponseDto> {
    const [ordersCount, wishlistCount] = await Promise.all([
      this.bookingRepo.count({
        where: { userId, status: Not(BookingStatus.CANCELLED) },
      }),
      this.wishlistRepo.count({ where: { userId } }),
    ]);

    return {
      ordersCount,
      wishlistCount,
      points: 0,
      pointsLabel: '0',
    };
  }
}
