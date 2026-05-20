import { Test, TestingModule } from '@nestjs/testing';
import { SlotsController } from './slots.controller';
import { BookingService } from './booking.service';

describe('SlotsController', () => {
  let controller: SlotsController;
  let bookingService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    bookingService = {
      acquireMicroLock: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [SlotsController],
      providers: [{ provide: BookingService, useValue: bookingService }],
    }).compile();

    controller = module.get<SlotsController>(SlotsController);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('microLock', () => {
    it('should call bookingService.acquireMicroLock and return response', async () => {
      const dto = { staffId: 'staff-1', startTime: '2025-10-25T14:00:00Z' };
      const expected = { locked: true, expiresIn: 120 };
      bookingService.acquireMicroLock.mockResolvedValue(expected);

      const result = await controller.microLock(dto as any);

      expect(result).toEqual(expected);
      expect(bookingService.acquireMicroLock).toHaveBeenCalledWith(dto);
    });

    it('should return lock denied response when lock unavailable', async () => {
      const dto = { staffId: 'staff-1', startTime: '2025-10-25T14:00:00Z' };
      const expected = { locked: false, expiresIn: 0 };
      bookingService.acquireMicroLock.mockResolvedValue(expected);

      const result = await controller.microLock(dto as any);

      expect(result).toEqual(expected);
    });
  });
});
