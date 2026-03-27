import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';

// ─── Event Types ────────────────────────────────────────────────────────────────

/**
 * SSE event types emitted during a chatbot stream.
 * - `token`                — incremental text token
 * - `ner_location`         — named-entity recognition for locations
 * - `service_recommendation` — ranked service recommendations
 * - `done`                 — stream completed successfully
 * - `error`                — stream encountered an error
 */
export type ChatEventType =
  | 'token'
  | 'ner_location'
  | 'service_recommendation'
  | 'done'
  | 'error';

// ─── Nested DTOs ────────────────────────────────────────────────────────────────

export class NerEntityDto {
  @ApiProperty({ example: 'LOCATION' })
  @Expose()
  type: string;

  @ApiProperty({ example: 'Quận 1' })
  @Expose()
  value: string;

  @ApiProperty({ example: 0.93 })
  @Expose()
  confidence: number;
}

export class PriceDto {
  @ApiProperty({ example: 800000 })
  @Expose()
  amount: number;

  @ApiProperty({ example: 'VND' })
  @Expose()
  currency: string;
}

export class RatingDto {
  @ApiProperty({ example: 4.8 })
  @Expose()
  average: number;

  @ApiProperty({ example: 124 })
  @Expose()
  total_reviews: number;
}

export class LocationDto {
  @ApiProperty({ example: '123 Nguyễn Huệ' })
  @Expose()
  address: string;

  @ApiProperty({ example: 'Quận 1' })
  @Expose()
  district: string;

  @ApiProperty({ example: 'Hồ Chí Minh' })
  @Expose()
  city: string;
}

export class ServiceRecommendationItemDto {
  @ApiProperty({ example: 'SV002' })
  @Expose()
  service_id: string;

  @ApiProperty({ example: 'Phục hồi cột sống chuyên sâu' })
  @Expose()
  name: string;

  @ApiProperty({ example: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop' })
  @Expose()
  image_url: string;

  @ApiProperty({ example: 'Premium' })
  @Expose()
  badge: string;

  @ApiProperty({ example: 1200 })
  @Expose()
  booked_count: number;

  @ApiProperty({ type: PriceDto })
  @Expose()
  @Type(() => PriceDto)
  price: PriceDto;

  @ApiProperty({ example: 'BS Nguyễn Văn A' })
  @Expose()
  staff_name: string;

  @ApiProperty({ type: RatingDto })
  @Expose()
  @Type(() => RatingDto)
  rating: RatingDto;

  @ApiProperty({ type: LocationDto })
  @Expose()
  @Type(() => LocationDto)
  location: LocationDto;

  @ApiProperty({
    type: [String],
    example: ['2026-02-21T09:00:00', '2026-02-21T14:00:00'],
  })
  @Expose()
  slots: string[];
}

// ─── Event Data DTOs ────────────────────────────────────────────────────────────

export class TokenEventDataDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  request_id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  conversation_id: string;

  @ApiProperty({ example: 'Bạn' })
  @Expose()
  text: string;

  @ApiProperty({ example: 1 })
  @Expose()
  index: number;
}

export class NerLocationEventDataDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  request_id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  conversation_id: string;

  @ApiProperty({ type: [NerEntityDto] })
  @Expose()
  @Type(() => NerEntityDto)
  entities: NerEntityDto[];
}

export class ServiceRecommendationEventDataDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  request_id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  conversation_id: string;

  @ApiProperty({ example: 2 })
  @Expose()
  total: number;

  @ApiProperty({ type: [ServiceRecommendationItemDto] })
  @Expose()
  @Type(() => ServiceRecommendationItemDto)
  recommendations: ServiceRecommendationItemDto[];
}

export class DoneEventDataDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  request_id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  conversation_id: string;

  @ApiProperty({ example: 'completed' })
  @Expose()
  status: string;
}

export class ErrorEventDataDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  request_id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  @Expose()
  conversation_id: string;

  @ApiProperty({
    example: 'MODEL_TIMEOUT',
    enum: ['MODEL_TIMEOUT', 'RETRIEVER_ERROR', 'INVALID_INPUT', 'INTERNAL_ERROR'],
  })
  @Expose()
  error_code: string;

  @ApiProperty({ example: 'Generation timeout' })
  @Expose()
  message: string;
}

// ─── Send Message Response ──────────────────────────────────────────────────────

export class SendMessageResponseDto {
  @ApiProperty({
    description: 'The conversation ID to use for the SSE stream',
    example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @Expose()
  conversationId: string;

  @ApiProperty({
    description: 'SSE stream URL to connect to',
    example: '/v1/chatbot/stream/a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @Expose()
  streamUrl: string;
}
