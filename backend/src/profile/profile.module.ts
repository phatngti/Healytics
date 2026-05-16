import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import { UserProfileController } from './user-profile.controller';
import { UserProfileSummaryService } from './user-profile-summary.service';

@Module({
  imports: [TypeOrmModule.forFeature([Booking, UserWishlistItem])],
  controllers: [UserProfileController],
  providers: [UserProfileSummaryService],
})
export class ProfileModule {}
