import { Test, TestingModule } from '@nestjs/testing';
import { MapboxController } from './mapbox.controller';
import { MapboxService } from './mapbox.service';

describe('MapboxController', () => {
  let controller: MapboxController;
  let service: MapboxService;

  const mockService = {
    geocode: jest.fn(),
    reverseGeocode: jest.fn(),
    distanceMatrix: jest.fn(),
    getClientApiKey: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MapboxController],
      providers: [
        { provide: MapboxService, useValue: mockService },
      ],
    }).compile();

    controller = module.get(MapboxController);
    service = module.get(MapboxService);
  });

  afterEach(() => jest.clearAllMocks());

  it('geocode should delegate to service', async () => {
    const expected = { results: [{ lat: 10, lng: 106, formattedAddress: 'A', placeId: 'address.1' }] };
    mockService.geocode.mockResolvedValue(expected);

    const result = await controller.geocode({ address: 'test' });
    expect(service.geocode).toHaveBeenCalledWith('test');
    expect(result).toBe(expected);
  });

  it('reverseGeocode should delegate to service', async () => {
    const expected = { results: [] };
    mockService.reverseGeocode.mockResolvedValue(expected);

    const result = await controller.reverseGeocode({ lat: 10, lng: 106 });
    expect(service.reverseGeocode).toHaveBeenCalledWith(10, 106);
    expect(result).toBe(expected);
  });

  it('distanceMatrix should delegate to service', async () => {
    const expected = { originAddresses: [], destinationAddresses: [], rows: [] };
    mockService.distanceMatrix.mockResolvedValue(expected);

    const result = await controller.distanceMatrix({ origins: 'A', destinations: 'B' });
    expect(service.distanceMatrix).toHaveBeenCalledWith('A', 'B');
    expect(result).toBe(expected);
  });

  it('getClientKey should return API key from service', () => {
    mockService.getClientApiKey.mockReturnValue('pk.test-key');

    const result = controller.getClientKey();
    expect(service.getClientApiKey).toHaveBeenCalled();
    expect(result).toEqual({ apiKey: 'pk.test-key' });
  });
});
