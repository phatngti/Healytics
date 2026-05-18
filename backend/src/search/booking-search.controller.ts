import { Get, Query } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { BookingSearchQueryDto } from './dto/booking-search-query.dto';
import { BookingSearchResponseDto } from './dto/booking-search-response.dto';
import { BookingSearchService } from './services/booking-search.service';
import { LogResponse } from '@/common/interceptors/response.interceptor';

@UserApi('booking-search')
export class BookingSearchController {
  constructor(private readonly bookingSearchService: BookingSearchService) {}

  @Get()
  @LogResponse()
  @ApiOperation({ summary: 'Search booking services and specialists' })
  @ApiQuery({
    name: 'q',
    required: true,
    description: 'Search text. Minimum 2 characters.',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    description: 'Maximum results per group. Default 5, max 20.',
  })
  @ApiOkResponse({ type: BookingSearchResponseDto })
  search(
    @Query() query: BookingSearchQueryDto,
  ): Promise<BookingSearchResponseDto> {
    const limit = Number.parseInt(query.limit ?? '5', 10);
    return this.bookingSearchService.search(
      query.q,
      Number.isNaN(limit) ? 5 : limit,
    );
  }
}
