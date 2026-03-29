import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from '@/common/entities/category.entity';
import { AppointmentCategoryResponseDto } from '../../dto/appointment-category-response.dto';

@Injectable()
export class ListAppointmentCategoriesHandler {
  private readonly logger = new Logger(ListAppointmentCategoriesHandler.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async execute(userId: string): Promise<AppointmentCategoryResponseDto[]> {
    this.logger.log(`Listing appointment categories for user: ${userId}`);

    // Single query: join Category → Product → Booking to get distinct
    // categories that the user has booked, avoiding multiple DB round-trips.
    const categories = await this.categoryRepository
      .createQueryBuilder('category')
      .innerJoin('category.products', 'product')
      .innerJoin(
        'bookings',
        'booking',
        'booking.product_id = product.id AND booking.user_id = :userId',
        { userId },
      )
      .where('category.is_active = :isActive', { isActive: true })
      .orderBy('category.sort_order', 'ASC')
      .addOrderBy('category.name', 'ASC')
      .distinct(true)
      .getMany();

    this.logger.log(`Found ${categories.length} categories for user ${userId}`);
    return AppointmentCategoryResponseDto.fromEntities(categories);
  }
}
