import {
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { LocationsService } from './locations.service';
import { LocationListResponseDto } from './dto/response/location-response.dto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';

/**
 * Controller for Vietnam administrative location endpoints.
 * All endpoints are public (read-only reference data).
 * API Version 1.
 */
@ApiTags('Locations')
@ApiBearerAuth()
@Controller({ path: 'locations', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class LocationsController {
  constructor(private readonly locationsService: LocationsService) {}

  @Get('provinces')
  @Public()
  @ApiOperation({ summary: 'Get all provinces in Vietnam' })
  @ApiOkResponse({
    description: 'List of all provinces',
    type: LocationListResponseDto,
  })
  getProvinces(): Promise<LocationListResponseDto> {
    return this.locationsService.getAllProvinces();
  }

  @Get('provinces/:provinceId/districts')
  @Public()
  @ApiOperation({ summary: 'Get all districts in a province' })
  @ApiOkResponse({
    description: 'List of districts in the province',
    type: LocationListResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Province not found' })
  getDistricts(
    @Param('provinceId', ParseUUIDPipe) provinceId: string,
  ): Promise<LocationListResponseDto> {
    return this.locationsService.getDistrictsByProvinceId(provinceId);
  }

  @Get('districts/:districtId/wards')
  @Public()
  @ApiOperation({ summary: 'Get all wards in a district' })
  @ApiOkResponse({
    description: 'List of wards in the district',
    type: LocationListResponseDto,
  })
  @ApiNotFoundResponse({ description: 'District not found' })
  getWards(
    @Param('districtId', ParseUUIDPipe) districtId: string,
  ): Promise<LocationListResponseDto> {
    return this.locationsService.getWardsByDistrictId(districtId);
  }
}
