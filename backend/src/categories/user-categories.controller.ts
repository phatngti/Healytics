import { Get, Param, Query, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CategoriesService } from './categories.service';
import { BookingSpecialistResponseDto } from './dto/booking-specialist-response.dto';
import { BookingServiceResponseDto } from '@/employees/dto/booking-service-response.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';
import { PublicServiceListQueryDto } from '@/health-service/dto/public/service-list-query.dto';

/**
 * User controller for category-related booking endpoints.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/categories
 */
@UserApi('categories')
export class UserCategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  /**
   * Retrieves all services (products) within a category.
   * Used by the Book Appointment flow Step 1 after selecting a category.
   */
  @Get(':categoryId/services')
  @ApiOperation({ summary: 'Get services for a category' })
  @ApiOkResponse({
    description: 'Return list of services for the given category.',
    type: [BookingServiceResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  @ApiQuery({
    name: 'lat',
    required: false,
    type: Number,
    description: 'User latitude for distance calc',
  })
  @ApiQuery({
    name: 'lng',
    required: false,
    type: Number,
    description: 'User longitude for distance calc',
  })
  findServicesByCategory(
    @Param('categoryId', ParseUUIDPipe) categoryId: string,
    @Query() query: PublicServiceListQueryDto,
  ): Promise<BookingServiceResponseDto[]> {
    return this.categoriesService.findServicesByCategory(categoryId, query);
  }

  /**
   * Retrieves all specialists (employees) assigned to a category.
   * Used by the Book Appointment flow Step 2 after selecting a service.
   */
  @Get(':categoryId/specialists')
  @ApiOperation({ summary: 'Get specialists for a category' })
  @ApiOkResponse({
    description: 'Return list of specialists for the given category.',
    type: [BookingSpecialistResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findSpecialistsByCategory(
    @Param('categoryId', ParseUUIDPipe) categoryId: string,
  ): Promise<BookingSpecialistResponseDto[]> {
    return this.categoriesService.findSpecialistsByCategory(categoryId);
  }
}
