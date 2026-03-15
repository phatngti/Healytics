import { ApiProperty } from '@nestjs/swagger';

export class ClientKeyResponseDto {
  @ApiProperty({
    description: 'Mapbox public access token for frontend/mobile SDKs',
    example: 'pk.eyJ1Ijoi...',
  })
  apiKey: string;
}
