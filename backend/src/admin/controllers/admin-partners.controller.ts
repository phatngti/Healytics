import {
  Get,
  Put,
  Body,
  Param,
  HttpCode,
  HttpStatus,
  Query,
  Req,
  UseInterceptors,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiParam,
  ApiNotFoundResponse,
  ApiBadRequestResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { AdminPartnersService } from '../services/admin-partners.service';
import { AdminPartnersQueryDto } from '../dto/admin-partners-query.dto';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto } from '../dto/review-partner-profile.dto';
import { ReviewPartnerResponseDto } from '../dto/review-partner-response.dto';
import { AdminPartnersResponseDto } from '../dto/admin-partner-list-response.dto';
import { AdminPartnerStatsResponseDto } from '../dto/admin-partner-stats-response.dto';
import { TotalPartnersResponseDto } from '../dto/total-partners-response.dto';
import { Audit } from '@/audit/decorators/audit.decorator';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * Admin controller for partner management.
 * Uses @AdminApi() composite decorator →
 * ADMIN_ROLES, /v1/admin/partners.
 *
 * Security: JwtAuthGuard → RolesGuard → ADMIN_ROLES
 * Audit: AuditInterceptor on all endpoints
 */
@AdminApi('partners')
@UseInterceptors(AuditInterceptor)
export class AdminPartnersController {
  constructor(private readonly adminPartnersService: AdminPartnersService) {}

  @Get()
  @ApiOperation({ summary: 'List all partners' })
  @ApiOkResponse({
    description: 'Paginated list of partners.',
    type: AdminPartnersResponseDto,
  })
  @LogResponse()
  async getPartners(
    @Query() query: AdminPartnersQueryDto,
  ): Promise<AdminPartnersResponseDto> {
    return this.adminPartnersService.getPartners(query);
  }

  @Get('stats')
  @ApiOperation({
    summary: 'Get partner dashboard statistics',
  })
  @ApiOkResponse({
    description: 'KPI card values.',
    type: AdminPartnerStatsResponseDto,
  })
  async getPartnerStats(
    @Query() query: AdminPartnersQueryDto,
  ): Promise<AdminPartnerStatsResponseDto> {
    return this.adminPartnersService.getPartnerStats(query);
  }

  @Get('total')
  @ApiOperation({
    summary: 'Get total number of partners',
  })
  @ApiOkResponse({
    description: 'Filtered total partner count.',
    type: TotalPartnersResponseDto,
  })
  async getTotalPartners(
    @Query() query: AdminPartnersQueryDto,
  ): Promise<TotalPartnersResponseDto> {
    return this.adminPartnersService.getTotalPartners(query);
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Get partner details including documents',
  })
  @ApiParam({ name: 'id', description: 'Partner ID' })
  @ApiOkResponse({
    description: 'Partner detail with verification data.',
    type: AdminPartnerDetailResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'Partner not found.',
  })
  async getPartnerDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AdminPartnerDetailResponseDto> {
    return this.adminPartnersService.getPartnerDetail(id);
  }

  @Put(':id/review')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @Audit('PARTNER_REVIEW', 'Partner')
  @ApiOperation({ summary: 'Review partner profile' })
  @ApiParam({ name: 'id', description: 'Partner ID' })
  @ApiOkResponse({
    description: 'Review submitted.',
    type: ReviewPartnerResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'Partner not found.',
  })
  @ApiBadRequestResponse({
    description: 'Partner is not in PENDING state.',
  })
  async reviewPartner(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReviewPartnerProfileDto,
    @Req() req,
  ): Promise<ReviewPartnerResponseDto> {
    return this.adminPartnersService.reviewPartner(id, dto, req.user.id);
  }
}
