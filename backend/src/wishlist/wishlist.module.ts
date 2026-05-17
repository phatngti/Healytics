import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from '@/common/entities/product.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import { UserWishlistController } from './user-wishlist.controller';
import { WishlistService } from './wishlist.service';

@Module({
  imports: [TypeOrmModule.forFeature([UserWishlistItem, Product])],
  controllers: [UserWishlistController],
  providers: [WishlistService],
  exports: [WishlistService],
})
export class WishlistModule {}
