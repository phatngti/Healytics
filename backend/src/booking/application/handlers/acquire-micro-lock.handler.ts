import { Injectable, Logger } from '@nestjs/common';
import { RedisService } from '@/redis/redis.service';
import { MicroLockDto } from '../../dto/micro-lock.dto';
import { MicroLockResponseDto } from '../../dto/micro-lock-response.dto';

const MICRO_LOCK_TTL_SECONDS = 120;

@Injectable()
export class AcquireMicroLockHandler {
  private readonly logger = new Logger(AcquireMicroLockHandler.name);

  constructor(private readonly redisService: RedisService) {}

  async execute(dto: MicroLockDto): Promise<MicroLockResponseDto> {
    const dateStr = this.formatSlotKey(dto.startTime);
    const key = `lock:intent:${dto.staffId}_${dateStr}`;

    this.logger.log(`Attempting micro-lock: ${key}`);
    const token = await this.redisService.acquireLock(
      key,
      MICRO_LOCK_TTL_SECONDS,
    );

    const locked = token !== null;
    this.logger.log(`Micro-lock ${locked ? 'acquired' : 'denied'}: ${key}`);

    return new MicroLockResponseDto(
      locked,
      locked ? MICRO_LOCK_TTL_SECONDS : 0,
    );
  }

  /**
   * Format ISO date string to a redis-key-safe format: YYYY-MM-DD_HHmm
   */
  private formatSlotKey(isoDate: string): string {
    const d = new Date(isoDate);
    const yyyy = d.getUTCFullYear();
    const mm = String(d.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(d.getUTCDate()).padStart(2, '0');
    const hh = String(d.getUTCHours()).padStart(2, '0');
    const min = String(d.getUTCMinutes()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}_${hh}${min}`;
  }
}
