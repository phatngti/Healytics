import { Get, Param, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { LocationsService } from './locations.service';
import { LocationListResponseDto } from './dto/response/location-response.dto';

/**
 * Public controller for Vietnam administrative location endpoints.
 * All endpoints are publicly accessible (read-only reference data).
 * Route prefix: /v1/locations
 */
@PublicApi('locations')
export class LocationsController {
  constructor(private readonly locationsService: LocationsService) {}

  @Get('provinces')
  @ApiOperation({ summary: 'Get all provinces in Vietnam' })
  @ApiOkResponse({
    description: 'List of all provinces',
    type: LocationListResponseDto,
  })
  getProvinces(): Promise<LocationListResponseDto> {
    return this.locationsService.getAllProvinces();
  }

  @Get('provinces/:provinceId/districts')
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
