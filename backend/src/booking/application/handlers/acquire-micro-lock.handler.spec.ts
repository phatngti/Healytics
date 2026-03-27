import { Test, TestingModule } from '@nestjs/testing';
import { AcquireMicroLockHandler } from './acquire-micro-lock.handler';
import { RedisService } from '@/redis/redis.service';
import { MicroLockResponseDto } from '../../dto/micro-lock-response.dto';

describe('AcquireMicroLockHandler', () => {
  let handler: AcquireMicroLockHandler;
  let redisService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    redisService = {
      acquireLock: jest.fn(),
      releaseLock: jest.fn(),
      getLockTTL: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AcquireMicroLockHandler,
        { provide: RedisService, useValue: redisService },
      ],
    }).compile();

    handler = module.get<AcquireMicroLockHandler>(AcquireMicroLockHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return locked=true with expiresIn=120 when lock is acquired', async () => {
    // Arrange
    redisService.acquireLock.mockResolvedValue('some-token');
    const dto = { staffId: 'staff-1', startTime: '2025-10-25T14:00:00Z' };

    // Act
    const result = await handler.execute(dto as any);

    // Assert
    expect(result).toBeInstanceOf(MicroLockResponseDto);
    expect(result.locked).toBe(true);
    expect(result.expiresIn).toBe(120);
    expect(redisService.acquireLock).toHaveBeenCalledWith(
      'lock:intent:staff-1_2025-10-25_1400',
      120,
    );
  });

  it('should return locked=false with expiresIn=0 when lock is denied', async () => {
    // Arrange
    redisService.acquireLock.mockResolvedValue(null);
    const dto = { staffId: 'staff-1', startTime: '2025-10-25T14:00:00Z' };

    // Act
    const result = await handler.execute(dto as any);

    // Assert
    expect(result).toBeInstanceOf(MicroLockResponseDto);
    expect(result.locked).toBe(false);
    expect(result.expiresIn).toBe(0);
  });

  it('should format slot key correctly from ISO date string', async () => {
    // Arrange
    redisService.acquireLock.mockResolvedValue('token');
    const dto = { staffId: 'abc-123', startTime: '2025-03-15T09:30:00Z' };

    // Act
    await handler.execute(dto as any);

    // Assert — verify key is formatted as YYYY-MM-DD_HHmm
    expect(redisService.acquireLock).toHaveBeenCalledWith(
      'lock:intent:abc-123_2025-03-15_0930',
      120,
    );
  });
});
