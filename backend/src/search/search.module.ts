import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { SearchIndexOutbox } from './entities/search-index-outbox.entity';
import { BookingSearchController } from './booking-search.controller';
import { BookingSearchIndexerService } from './services/booking-search-indexer.service';
import { BookingSearchService } from './services/booking-search.service';
import { ElasticsearchBookingService } from './services/elasticsearch-booking.service';
import { SearchIndexOutboxService } from './services/search-index-outbox.service';
import { SearchIndexWorkerService } from './services/search-index-worker.service';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([
      SearchIndexOutbox,
      Product,
      Employee,
      ProductEmployeeEligibility,
    ]),
  ],
  controllers: [BookingSearchController],
  providers: [
    ElasticsearchBookingService,
    BookingSearchService,
    BookingSearchIndexerService,
    SearchIndexOutboxService,
    SearchIndexWorkerService,
  ],
  exports: [SearchIndexOutboxService, SearchIndexWorkerService],
})
export class SearchModule {}
