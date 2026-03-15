import { ApiProperty } from '@nestjs/swagger';

export class MicroLockResponseDto {
  @ApiProperty({ description: 'Whether the lock was acquired', example: true })
  locked: boolean;

  @ApiProperty({ description: 'Lock TTL in seconds', example: 120 })
  expiresIn: number;

  constructor(locked: boolean, expiresIn: number) {
    this.locked = locked;
    this.expiresIn = expiresIn;
  }
}
