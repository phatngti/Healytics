import { Test, TestingModule } from '@nestjs/testing';
import { RedisService, REDIS_CLIENT } from './redis.service';

describe('RedisService', () => {
  let service: RedisService;
  let redisClient: { [key: string]: jest.Mock };

  beforeEach(async () => {
    redisClient = {
      set: jest.fn(),
      get: jest.fn(),
      del: jest.fn(),
      ttl: jest.fn(),
      eval: jest.fn(),
      publish: jest.fn(),
      quit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RedisService,
        { provide: REDIS_CLIENT, useValue: redisClient },
      ],
    }).compile();

    service = module.get<RedisService>(RedisService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── acquireLock ────────────────────────────────────────────

  describe('acquireLock', () => {
    it('should return token when lock acquired successfully', async () => {
      redisClient.set.mockResolvedValue('OK');

      const result = await service.acquireLock('lock:test', 600);

      expect(result).toBeTruthy();
      expect(typeof result).toBe('string');
      expect(redisClient.set).toHaveBeenCalledWith(
        'lock:test',
        expect.any(String), // UUID token
        'EX',
        600,
        'NX',
      );
    });

    it('should return null when lock is already taken', async () => {
      redisClient.set.mockResolvedValue(null);

      const result = await service.acquireLock('lock:test', 600);

      expect(result).toBeNull();
    });
  });

  // ── releaseLock ────────────────────────────────────────────

  describe('releaseLock', () => {
    it('should return true when lock released successfully', async () => {
      redisClient.eval.mockResolvedValue(1);

      const result = await service.releaseLock('lock:test', 'my-token');

      expect(result).toBe(true);
      expect(redisClient.eval).toHaveBeenCalledWith(
        expect.stringContaining('redis.call'),
        1,
        'lock:test',
        'my-token',
      );
    });

    it('should return false when token does not match', async () => {
      redisClient.eval.mockResolvedValue(0);

      const result = await service.releaseLock('lock:test', 'wrong-token');

      expect(result).toBe(false);
    });
  });

  // ── getLockTTL ─────────────────────────────────────────────

  describe('getLockTTL', () => {
    it('should return TTL from Redis', async () => {
      redisClient.ttl.mockResolvedValue(300);

      const result = await service.getLockTTL('lock:test');

      expect(result).toBe(300);
    });

    it('should return -2 when key does not exist', async () => {
      redisClient.ttl.mockResolvedValue(-2);

      const result = await service.getLockTTL('lock:nonexistent');

      expect(result).toBe(-2);
    });
  });

  // ── validateLock ───────────────────────────────────────────

  describe('validateLock', () => {
    it('should return true when token matches', async () => {
      redisClient.get.mockResolvedValue('my-token');

      const result = await service.validateLock('lock:test', 'my-token');

      expect(result).toBe(true);
    });

    it('should return false when token does not match', async () => {
      redisClient.get.mockResolvedValue('other-token');

      const result = await service.validateLock('lock:test', 'my-token');

      expect(result).toBe(false);
    });
  });

  // ── Generic operations ─────────────────────────────────────

  describe('get', () => {
    it('should return value from Redis', async () => {
      redisClient.get.mockResolvedValue('stored-value');

      const result = await service.get('key');

      expect(result).toBe('stored-value');
    });
  });

  describe('set', () => {
    it('should set value with TTL', async () => {
      await service.set('key', 'value', 3600);

      expect(redisClient.set).toHaveBeenCalledWith(
        'key',
        'value',
        'EX',
        3600,
      );
    });

    it('should set value without TTL', async () => {
      await service.set('key', 'value');

      expect(redisClient.set).toHaveBeenCalledWith('key', 'value');
    });
  });

  describe('del', () => {
    it('should delete key from Redis', async () => {
      redisClient.del.mockResolvedValue(1);

      const result = await service.del('key');

      expect(result).toBe(1);
    });
  });

  // ── Pub/Sub ────────────────────────────────────────────────

  describe('publish', () => {
    it('should publish message and return subscriber count', async () => {
      redisClient.publish.mockResolvedValue(3);

      const result = await service.publish('channel', 'message');

      expect(result).toBe(3);
      expect(redisClient.publish).toHaveBeenCalledWith('channel', 'message');
    });
  });

  // ── onModuleDestroy ────────────────────────────────────────

  describe('onModuleDestroy', () => {
    it('should close Redis connection', async () => {
      await service.onModuleDestroy();

      expect(redisClient.quit).toHaveBeenCalled();
    });
  });
});
