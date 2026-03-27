import { ApiProperty } from '@nestjs/swagger';
import { ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { AccountRequestDto } from './account-request.dto';
import { PartnerRequestDto } from './partner-request.dto';
import { LegalRepresentativeRequestDto } from './legal-representative-request.dto';

export class RegisterPartnerDto {
    @ApiProperty({
        description: 'Account credentials for login',
        type: AccountRequestDto,
    })
    @ValidateNested()
    @Type(() => AccountRequestDto)
    account: AccountRequestDto;

    @ApiProperty({
        description: 'Partner (Business Entity) information',
        type: PartnerRequestDto,
    })
    @ValidateNested()
    @Type(() => PartnerRequestDto)
    partner: PartnerRequestDto;

    @ApiProperty({
        type: LegalRepresentativeRequestDto,
        description: 'Legal representative information',
    })
    @ValidateNested()
    @Type(() => LegalRepresentativeRequestDto)
    legalRepresentative: LegalRepresentativeRequestDto;
}
