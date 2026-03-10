import {
  Get,
  Put,
  Body,
  HttpCode,
  HttpStatus,
  Controller,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { Public } from '@/common/decorators/auth/public.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnersService } from './partners.service';
import { MyProfileResponseDto } from './dto/response/my-profile-response.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';

// ============================================================================
// Public Controller — no auth required
// ============================================================================

@ApiTags('Partners')
@Controller({ path: 'partners', version: '1' })
@UseInterceptors(ClassSerializerInterceptor)
export class PartnersController {
  constructor(private readonly partnersService: PartnersService) {}

  @Get('business-services')
  @Public()
  @ApiOperation({
    summary: 'Get all business services',
    description:
      'Returns list of all business services with Vietnamese labels for dropdown selection',
  })
  @ApiOkResponse({
    description: 'List of business services retrieved successfully',
    type: BusinessServicesResponseDto,
  })
  getBusinessServices(): BusinessServicesResponseDto {
    return this.partnersService.getBusinessServices();
  }
}

// ============================================================================
// Partner Self-Management Controller — @PartnerApi composite decorator
// ============================================================================

@PartnerApi('partners')
export class PartnerSelfController {
  constructor(private readonly partnersService: PartnersService) {}

  @Get('me')
  @ApiOperation({
    summary: 'Get own business profile',
    description: 'Partner gets their own business entity information',
  })
  @ApiOkResponse({
    description: 'Profile retrieved successfully',
    type: MyProfileResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  async getMyProfile(
    @CurrentUser('id') userId: string,
  ): Promise<MyProfileResponseDto> {
    return this.partnersService.getMyProfile(userId);
  }

  @Put('me')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Update own business profile',
    description: 'Partner updates their business information (limited fields)',
  })
  @ApiOkResponse({
    description: 'Profile updated successfully',
    type: MyProfileResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  async updateMyProfile(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdatePartnerDto,
  ): Promise<MyProfileResponseDto> {
    return this.partnersService.updateMyProfile(userId, dto);
  }
}
