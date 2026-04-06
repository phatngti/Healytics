import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class AddToCartDto {
  @ApiProperty({
    description: 'UUID of the health service',
    example: '0f3a4726-2f17-4d39-9518-b5303b4a0a95',
  })
  @IsUUID()
  serviceId: string;
}
