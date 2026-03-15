import {
  Get,
  Query,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
} from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { MapboxService } from './mapbox.service';
import { GeocodeQueryDto } from './dto/geocode-query.dto';
import { ReverseGeocodeQueryDto } from './dto/reverse-geocode-query.dto';
import { DistanceMatrixQueryDto } from './dto/distance-matrix-query.dto';
import { GeocodeResponseDto } from './dto/geocode-response.dto';
import { DistanceMatrixResponseDto } from './dto/distance-matrix-response.dto';
import { ClientKeyResponseDto } from './dto/client-key-response.dto';

/**
 * Public controller for Mapbox API proxy endpoints.
 * Keeps the server-side access token hidden from clients.
 * Route prefix: /v1/mapbox
 */
@PublicApi('mapbox')
export class MapboxController {
  constructor(private readonly mapboxService: MapboxService) {}

  @Get('geocode')
  @ApiOperation({ summary: 'Geocode an address to lat/lng' })
  @ApiOkResponse({ type: GeocodeResponseDto })
  geocode(@Query() query: GeocodeQueryDto): Promise<GeocodeResponseDto> {
    return this.mapboxService.geocode(query.address);
  }

  @Get('reverse-geocode')
  @ApiOperation({ summary: 'Reverse geocode lat/lng to address' })
  @ApiOkResponse({ type: GeocodeResponseDto })
  reverseGeocode(@Query() query: ReverseGeocodeQueryDto): Promise<GeocodeResponseDto> {
    return this.mapboxService.reverseGeocode(query.lat, query.lng);
  }

  @Get('distance-matrix')
  @ApiOperation({ summary: 'Get travel distance and duration' })
  @ApiOkResponse({ type: DistanceMatrixResponseDto })
  distanceMatrix(@Query() query: DistanceMatrixQueryDto): Promise<DistanceMatrixResponseDto> {
    return this.mapboxService.distanceMatrix(query.origins, query.destinations);
  }

  @Get('client-key')
  @ApiOperation({ summary: 'Get public access token for frontend/mobile SDKs' })
  @ApiOkResponse({ type: ClientKeyResponseDto })
  getClientKey(): ClientKeyResponseDto {
    return { apiKey: this.mapboxService.getClientApiKey() };
  }
}
