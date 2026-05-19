import { Injectable } from '@nestjs/common';
import { RedisService } from '@/redis/redis.service';
import { BookingStatusChangeEventDto } from '../dto/booking-status-change-event.dto';
import { BOOKING_STATUS_REDIS_CHANNEL } from '../constants/booking-realtime.constants';

@Injectable()
export class BookingStatusRealtimePublisher {
  constructor(private readonly redisService: RedisService) {}

  async publishStatusChange(
    payload: BookingStatusChangeEventDto,
  ): Promise<number> {
    return this.redisService.publish(
      BOOKING_STATUS_REDIS_CHANNEL,
      JSON.stringify(payload),
    );
  }
}
