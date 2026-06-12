import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

// ── Simple responses ─────────────────────────────────────────────

export class BackdoorStatusResponseDto {
  @ApiProperty({ type: Boolean, example: true })
  ok: boolean;

  @ApiProperty({ type: String, example: 'healytics_test' })
  database: string;

  @ApiProperty({ type: String, example: 'test' })
  nodeEnv: string;
}

export class ResetDbResponseDto {
  @ApiProperty({ type: Boolean, example: true })
  ok: boolean;

  @ApiProperty({ type: Number, example: 12 })
  truncatedTables: number;
}

// ── Seed response ────────────────────────────────────────────────

/** A map of `{ key → uuid }` for each entity type. */
export class SeedIdsMapDto {
  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
    example: { 'user@test.healytics.vn': 'a1b2c3d4-...' },
    description: 'user key → account UUID',
  })
  users?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  categories?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  partners?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  employees?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  services?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  cartItems?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  bookings?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  coupons?: Record<string, string>;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
  })
  notifications?: Record<string, string>;
}

export class SeedResponseDto {
  @ApiProperty({ type: Boolean, example: true })
  ok: boolean;

  @ApiProperty({ type: String, example: 'inline' })
  scenario: string;

  @ApiProperty({ type: SeedIdsMapDto })
  ids: SeedIdsMapDto;
}

export class CleanupSeedDataDto {
  @ApiProperty({ type: SeedIdsMapDto })
  ids: SeedIdsMapDto;
}

export class CleanupSeedDataResponseDto {
  @ApiProperty({ type: Boolean, example: true })
  ok: boolean;

  @ApiProperty({
    type: 'object',
    additionalProperties: { type: 'number' },
    example: { users: 1, bookings: 2 },
  })
  deleted: Record<string, number>;
}
