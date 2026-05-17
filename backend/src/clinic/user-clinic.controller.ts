import { Get, Param, Query, ParseUUIDPipe, Post, Delete } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { ClinicService } from './clinic.service';
import { ClinicInfoResponseDto } from './dto/clinic-info-response.dto';
import { ClinicProductsResponseDto } from './dto/clinic-products-response.dto';
import { ClinicReviewsResponseDto } from './dto/clinic-reviews-response.dto';
import { GetClinicProductsQueryDto } from './dto/get-clinic-products-query.dto';
import { GetClinicReviewsQueryDto } from './dto/get-clinic-reviews-query.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

@UserApi('clinics')
export class UserClinicController {
  constructor(private readonly clinicService: ClinicService) {}

  @Get(':id/info')
    @LogResponse()
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicInfo',
    summary: 'Get public clinic profile',
  })
  @ApiOkResponse({ type: ClinicInfoResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  getClinicInfo(
    @Param('id', ParseUUIDPipe) id: string,
    @CurrentUser('id') userId: string,
  ): Promise<ClinicInfoResponseDto> {
    return this.clinicService.getClinicInfo(id, userId);
  }

  @Post(':id/follow')
  @ApiOperation({
    operationId: 'userClinicControllerFollowClinic',
    summary: 'Follow a clinic',
  })
  @ApiOkResponse({ type: ClinicInfoResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  followClinic(
    @Param('id', ParseUUIDPipe) id: string,
    @CurrentUser('id') userId: string,
  ): Promise<ClinicInfoResponseDto> {
    return this.clinicService.followClinic(id, userId);
  }

  @Delete(':id/follow')
  @ApiOperation({
    operationId: 'userClinicControllerUnfollowClinic',
    summary: 'Unfollow a clinic',
  })
  @ApiOkResponse({ type: ClinicInfoResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  unfollowClinic(
    @Param('id', ParseUUIDPipe) id: string,
    @CurrentUser('id') userId: string,
  ): Promise<ClinicInfoResponseDto> {
    return this.clinicService.unfollowClinic(id, userId);
  }

  @Get(':id/products')
    @LogResponse()
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicProducts',
    summary: 'Get clinic products/services catalog',
  })
  @ApiOkResponse({ type: ClinicProductsResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  getClinicProducts(
    @Param('id', ParseUUIDPipe) id: string,
    @Query() query: GetClinicProductsQueryDto,
  ): Promise<ClinicProductsResponseDto> {
    return this.clinicService.getClinicProducts(id, query);
  }

  @Get(':id/reviews')
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicReviews',
    summary: 'Get paginated clinic reviews',
  })
  @ApiOkResponse({ type: ClinicReviewsResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  getClinicReviews(
    @Param('id', ParseUUIDPipe) id: string,
    @Query() query: GetClinicReviewsQueryDto,
  ): Promise<ClinicReviewsResponseDto> {
    return this.clinicService.getClinicReviews(id, query);
  }
}
