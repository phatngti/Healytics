import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import {
  GeocodeResultDto,
  GeocodeResponseDto,
} from './dto/geocode-response.dto';
import {
  DistanceMatrixResponseDto,
  DistanceMatrixRowDto,
  DistanceMatrixElementDto,
} from './dto/distance-matrix-response.dto';

const GEOCODING_BASE = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
const MATRIX_BASE =
  'https://api.mapbox.com/directions-matrix/v1/mapbox/driving';

@Injectable()
export class MapboxService {
  private readonly logger = new Logger(MapboxService.name);
  private readonly accessToken: string;
  private readonly publicToken: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly httpService: HttpService,
  ) {
    const cfg = this.configService.get<{
      accessToken: string;
      publicToken: string;
    }>('mapbox');
    this.accessToken = cfg?.accessToken || '';
    this.publicToken = cfg?.publicToken || '';

    if (!this.accessToken) {
      this.logger.warn(
        'MAPBOX_ACCESS_TOKEN is not set — server-side geocoding/matrix will fail',
      );
    }
  }

  // ── Geocoding ────────────────────────────────────────────

  /**
   * Forward geocode: address → lat/lng.
   * Uses Mapbox Geocoding v5 API.
   */
  async geocode(address: string): Promise<GeocodeResponseDto> {
    this.logger.log(`Geocoding address: ${address}`);

    const url = `${GEOCODING_BASE}/${encodeURIComponent(address)}.json`;

    const { data } = await firstValueFrom(
      this.httpService.get(url, {
        params: { access_token: this.accessToken, limit: 5 },
      }),
    );

    if (data.message) {
      this.logger.error(`Geocoding failed: ${data.message}`);
      throw new BadRequestException(`Geocoding failed: ${data.message}`);
    }

    const results: GeocodeResultDto[] = (data.features || []).map((f: any) => ({
      lat: f.center[1],
      lng: f.center[0],
      formattedAddress: f.place_name || '',
      placeId: f.id || undefined,
    }));

    return { results };
  }

  /**
   * Reverse geocode: lat/lng → address.
   * Uses Mapbox Geocoding v5 API with coordinates.
   */
  async reverseGeocode(lat: number, lng: number): Promise<GeocodeResponseDto> {
    this.logger.log(`Reverse geocoding: ${lat}, ${lng}`);

    const url = `${GEOCODING_BASE}/${lng},${lat}.json`;

    const { data } = await firstValueFrom(
      this.httpService.get(url, {
        params: { access_token: this.accessToken },
      }),
    );

    if (data.message) {
      this.logger.error(`Reverse geocoding failed: ${data.message}`);
      throw new BadRequestException(
        `Reverse geocoding failed: ${data.message}`,
      );
    }

    const results: GeocodeResultDto[] = (data.features || []).map((f: any) => ({
      lat: f.center[1],
      lng: f.center[0],
      formattedAddress: f.place_name || '',
      placeId: f.id || undefined,
    }));

    return { results };
  }

  // ── Distance Matrix ──────────────────────────────────────

  /**
   * Get travel distance and duration between origins and destinations.
   * Uses Mapbox Matrix API.
   *
   * @param origins Pipe-separated coordinates (lat,lng format from Google)
   * @param destinations Pipe-separated coordinates (lat,lng format from Google)
   *
   * Internally converts to Mapbox's semicolon-separated lng,lat format.
   */
  async distanceMatrix(
    origins: string,
    destinations: string,
  ): Promise<DistanceMatrixResponseDto> {
    this.logger.log(`Distance matrix: ${origins} → ${destinations}`);

    // Convert pipe-separated "lat,lng" pairs to Mapbox's "lng,lat" format
    const originCoords = this.parseCoordinates(origins);
    const destCoords = this.parseCoordinates(destinations);

    const allCoords = [...originCoords, ...destCoords];
    const coordString = allCoords.map((c) => `${c.lng},${c.lat}`).join(';');

    // Build source/destination indices
    const sourceIndices = originCoords.map((_, i) => i).join(';');
    const destIndices = destCoords
      .map((_, i) => i + originCoords.length)
      .join(';');

    const url = `${MATRIX_BASE}/${coordString}`;

    const { data } = await firstValueFrom(
      this.httpService.get(url, {
        params: {
          access_token: this.accessToken,
          sources: sourceIndices,
          destinations: destIndices,
          annotations: 'duration,distance',
        },
      }),
    );

    if (data.code !== 'Ok') {
      this.logger.error(
        `Distance matrix failed: ${data.code} — ${data.message || ''}`,
      );
      throw new BadRequestException(`Distance matrix failed: ${data.code}`);
    }

    // Map Mapbox response to our DTO shape
    const originAddresses = (data.sources || []).map((s: any) => s.name || '');
    const destinationAddresses = (data.destinations || []).map(
      (d: any) => d.name || '',
    );

    const rows: DistanceMatrixRowDto[] = (data.durations || []).map(
      (durationRow: number[], rowIdx: number) => ({
        elements: durationRow.map(
          (duration: number, colIdx: number): DistanceMatrixElementDto => {
            const distance = data.distances?.[rowIdx]?.[colIdx] ?? 0;
            return {
              distanceText: this.formatDistance(distance),
              distanceValue: Math.round(distance),
              durationText: this.formatDuration(duration),
              durationValue: Math.round(duration),
              status: duration === null ? 'NOT_FOUND' : 'OK',
            };
          },
        ),
      }),
    );

    return { originAddresses, destinationAddresses, rows };
  }

  // ── Client Key ───────────────────────────────────────────

  /**
   * Return the public access token for frontend/mobile SDKs.
   */
  getClientApiKey(): string {
    return this.publicToken;
  }

  // ── Private Helpers ──────────────────────────────────────

  /**
   * Parse pipe-separated coordinate string ("lat,lng|lat,lng") into objects.
   */
  private parseCoordinates(input: string): { lat: number; lng: number }[] {
    return input.split('|').map((pair) => {
      const [lat, lng] = pair.split(',').map(Number);
      return { lat, lng };
    });
  }

  /**
   * Format meters into human-readable distance string.
   */
  private formatDistance(meters: number): string {
    if (meters == null) return '';
    if (meters < 1000) return `${Math.round(meters)} m`;
    return `${(meters / 1000).toFixed(1)} km`;
  }

  /**
   * Format seconds into human-readable duration string.
   */
  private formatDuration(seconds: number): string {
    if (seconds == null) return '';
    if (seconds < 60) return `${Math.round(seconds)} secs`;
    const mins = Math.round(seconds / 60);
    if (mins < 60) return `${mins} mins`;
    const hrs = Math.floor(mins / 60);
    const remainMins = mins % 60;
    return remainMins > 0 ? `${hrs} hr ${remainMins} mins` : `${hrs} hr`;
  }
}
