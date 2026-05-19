import { Test, TestingModule } from '@nestjs/testing';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { BadRequestException } from '@nestjs/common';
import { of, throwError } from 'rxjs';
import { AxiosResponse } from 'axios';
import { MapboxService } from './mapbox.service';

describe('MapboxService', () => {
  let service: MapboxService;
  let httpService: HttpService;

  const mockAccessToken = 'sk.test-access-token';
  const mockPublicToken = 'pk.test-public-token';

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MapboxService,
        {
          provide: HttpService,
          useValue: { get: jest.fn() },
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue({
              accessToken: mockAccessToken,
              publicToken: mockPublicToken,
            }),
          },
        },
      ],
    }).compile();

    service = module.get(MapboxService);
    httpService = module.get(HttpService);
  });

  // ── getClientApiKey ────────────────────────────────────

  describe('getClientApiKey', () => {
    it('should return the configured public token', () => {
      expect(service.getClientApiKey()).toBe(mockPublicToken);
    });
  });

  // ── geocode ────────────────────────────────────────────

  describe('geocode', () => {
    it('should return geocode results for a valid address', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: {
          type: 'FeatureCollection',
          features: [
            {
              id: 'address.123',
              center: [106.66, 10.762],
              place_name: '227 NVC, D5, HCMC',
            },
          ],
        },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      const result = await service.geocode('227 NVC');

      expect(result.results).toHaveLength(1);
      expect(result.results[0].lat).toBe(10.762);
      expect(result.results[0].lng).toBe(106.66);
      expect(result.results[0].formattedAddress).toBe('227 NVC, D5, HCMC');
      expect(result.results[0].placeId).toBe('address.123');
    });

    it('should return empty results when no features found', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: { type: 'FeatureCollection', features: [] },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      const result = await service.geocode('unknown-place-xyz');
      expect(result.results).toHaveLength(0);
    });

    it('should throw BadRequestException on API error', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: { message: 'Not Authorized - Invalid Token' },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      await expect(service.geocode('test')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  // ── reverseGeocode ─────────────────────────────────────

  describe('reverseGeocode', () => {
    it('should return reverse geocode results', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: {
          type: 'FeatureCollection',
          features: [
            {
              id: 'address.456',
              center: [106.66, 10.762],
              place_name: 'District 5, HCMC',
            },
          ],
        },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      const result = await service.reverseGeocode(10.762, 106.66);
      expect(result.results).toHaveLength(1);
      expect(result.results[0].formattedAddress).toBe('District 5, HCMC');
    });

    it('should construct URL with lng,lat order (Mapbox convention)', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: { type: 'FeatureCollection', features: [] },
      };
      const getSpy = jest
        .spyOn(httpService, 'get')
        .mockReturnValue(of(mockResponse as any));

      await service.reverseGeocode(10.5, 106.7);
      expect(getSpy).toHaveBeenCalledWith(
        expect.stringContaining('106.7,10.5'),
        expect.objectContaining({
          params: { access_token: mockAccessToken },
        }),
      );
    });
  });

  // ── distanceMatrix ─────────────────────────────────────

  describe('distanceMatrix', () => {
    it('should return distance matrix results', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: {
          code: 'Ok',
          sources: [{ name: 'A', location: [106.66, 10.762], distance: 5 }],
          destinations: [
            { name: 'B', location: [106.629, 10.823], distance: 8 },
          ],
          durations: [[1500]],
          distances: [[12000]],
        },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      const result = await service.distanceMatrix(
        '10.762,106.66',
        '10.823,106.629',
      );

      expect(result.originAddresses).toEqual(['A']);
      expect(result.destinationAddresses).toEqual(['B']);
      expect(result.rows).toHaveLength(1);
      expect(result.rows[0].elements).toHaveLength(1);
      expect(result.rows[0].elements[0].distanceText).toBe('12.0 km');
      expect(result.rows[0].elements[0].distanceValue).toBe(12000);
      expect(result.rows[0].elements[0].durationText).toBe('25 mins');
      expect(result.rows[0].elements[0].durationValue).toBe(1500);
    });

    it('should throw BadRequestException on API error', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: { code: 'InvalidInput', message: 'Bad params' },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      await expect(service.distanceMatrix('bad', 'bad')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  // ── directions ─────────────────────────────────────────

  describe('directions', () => {
    it('should return route geometry with distance and duration', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: {
          code: 'Ok',
          routes: [
            {
              distance: 12000,
              duration: 1500,
              geometry: {
                coordinates: [
                  [106.66, 10.762],
                  [106.7, 10.8],
                ],
              },
            },
          ],
        },
      };
      const getSpy = jest
        .spyOn(httpService, 'get')
        .mockReturnValue(of(mockResponse as any));

      const result = await service.directions('10.762,106.66', '10.8,106.7');

      expect(getSpy).toHaveBeenCalledWith(
        expect.stringContaining('106.66,10.762;106.7,10.8'),
        expect.objectContaining({
          params: expect.objectContaining({
            access_token: mockAccessToken,
            geometries: 'geojson',
            overview: 'full',
          }),
        }),
      );
      expect(result.route).toEqual([
        { latitude: 10.762, longitude: 106.66 },
        { latitude: 10.8, longitude: 106.7 },
      ]);
      expect(result.distanceText).toBe('12.0 km');
      expect(result.distanceValue).toBe(12000);
      expect(result.durationText).toBe('25 mins');
      expect(result.durationValue).toBe(1500);
    });

    it('should throw BadRequestException on invalid coordinates', async () => {
      await expect(service.directions('bad', '10,106')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when no route is returned', async () => {
      const mockResponse: Partial<AxiosResponse> = {
        data: { code: 'Ok', routes: [] },
      };
      jest.spyOn(httpService, 'get').mockReturnValue(of(mockResponse as any));

      await expect(service.directions('10,106', '11,107')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should map Mapbox no-route responses to BadRequestException', async () => {
      jest.spyOn(httpService, 'get').mockReturnValue(
        throwError(() => ({
          isAxiosError: true,
          message: 'Request failed with status code 422',
          response: {
            status: 422,
            data: {
              code: 'NoRoute',
              message: 'No route found',
            },
          },
        })),
      );

      await expect(
        service.directions('37.4219983,-122.084', '10.781,106.694'),
      ).rejects.toThrow('No driving route is available');
    });
  });
});
