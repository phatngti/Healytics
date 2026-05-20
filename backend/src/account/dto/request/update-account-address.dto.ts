import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class UpdateAccountAddressDto {
  @ApiProperty({ example: '123 Nguyen Hue Street' })
  @IsString()
  @IsNotEmpty()
  streetAddress: string;

  @ApiProperty({
    example: '0f0d876f-92f1-4fcb-8a40-1fd3dd115d6b',
    description: 'Province/city Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  provinceId: string;

  @ApiProperty({
    example: '7c4020d4-343d-4a63-b017-6df5f82d8814',
    description: 'District Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  districtId: string;

  @ApiProperty({
    example: 'aa3a7de4-4d1d-4bb5-a3c1-79ac1350c743',
    description: 'Ward/commune Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  wardId: string;
}
