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
  ApiForbiddenResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { Public } from '@/common/decorators/auth/public.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnersService } from './partners.service';
import { MyProfileResponseDto } from './dto/response/my-profile-response.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';
import { MyProfileCompletionResponseDto } from './dto/response/my-profile-completion-response.dto';
import { UpdatePartnerProfileCompletionDto } from './dto/request/update-partner-profile-completion.dto';
import { PartnerPublicProfileResponseDto } from './dto/response/partner-public-profile-response.dto';
import { UpdatePartnerPublicProfileDto } from './dto/request/update-partner-public-profile.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

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

  @Get('me/completion')
  @ApiOperation({
    summary: 'Get partner clinic profile completion data',
    description:
      'Returns verified clinic identity data and editable post-verification profile fields.',
  })
  @ApiOkResponse({
    description: 'Profile completion data retrieved successfully',
    type: MyProfileCompletionResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  async getMyProfileCompletion(
    @CurrentUser('id') userId: string,
  ): Promise<MyProfileCompletionResponseDto> {
    return this.partnersService.getMyProfileCompletion(userId);
  }

  @Put('me/completion')
  @LogResponse()
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Update partner clinic profile completion data',
    description:
      'Immediately publishes post-verification clinic profile fields without entering admin review again.',
  })
  @ApiOkResponse({
    description: 'Profile completion data updated successfully',
    type: MyProfileCompletionResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  async updateMyProfileCompletion(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdatePartnerProfileCompletionDto,
  ): Promise<MyProfileCompletionResponseDto> {
    return this.partnersService.updateMyProfileCompletion(userId, dto);
  }

  // ==========================================================================
  // Public Profile — post-completion edits (storefront only)
  // ==========================================================================

  @Get('public-profile')
  @ApiOperation({
    summary: 'Get partner public profile edit aggregate',
    description:
      'Returns the full partner profile with read-only business context and editable storefront fields. Only available after profile completion.',
  })
  @ApiOkResponse({
    description: 'Public profile aggregate retrieved successfully',
    type: PartnerPublicProfileResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  @ApiForbiddenResponse({
    description: 'Profile not completed or not approved.',
  })
  async getPublicProfile(
    @CurrentUser('id') userId: string,
  ): Promise<PartnerPublicProfileResponseDto> {
    return this.partnersService.getPartnerPublicProfile(userId);
  }

  @Put('public-profile')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Update partner public profile (storefront only)',
    description:
      'Updates public-facing clinic profile fields (cover image, logo, description, gallery, certifications). Does not affect admin-verified business data.',
  })
  @ApiOkResponse({
    description: 'Public profile updated successfully',
    type: PartnerPublicProfileResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Partner not found.' })
  @ApiForbiddenResponse({
    description: 'Profile not completed or not approved.',
  })
  async updatePublicProfile(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdatePartnerPublicProfileDto,
  ): Promise<PartnerPublicProfileResponseDto> {
    return this.partnersService.updatePartnerPublicProfile(userId, dto);
  }
}
