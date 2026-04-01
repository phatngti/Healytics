import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsOptional, ValidateNested } from 'class-validator';

class UpdatedField<T> {
  fieldKey: string;
  value: T;
}

class AddressDto {
  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'streetAddress', value: 'Street Address' },
  })
  @IsOptional()
  streetAddress?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'ward', value: { id: 'Ward ID', name: 'Ward Name' } },
  })
  @IsOptional()
  ward?: UpdatedField<{ id: string; name: string }>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: {
      fieldKey: 'district',
      value: { id: 'District ID', name: 'District Name' },
    },
  })
  @IsOptional()
  district?: UpdatedField<{ id: string; name: string }>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'city', value: { id: 'City ID', name: 'City Name' } },
  })
  @IsOptional()
  city?: UpdatedField<{ id: string; name: string }>;
}

class BusinessInfo {
  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'brandName', value: 'Brand Name' },
  })
  @IsOptional()
  brandName?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: {
      fieldKey: 'taxRegistrationCode',
      value: 'Tax Registration Code',
    },
  })
  @IsOptional()
  taxRegistrationCode?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: {
      fieldKey: 'serviceTags',
      value: ['Service Tag 1', 'Service Tag 2'],
    },
  })
  @IsOptional()
  serviceTags?: UpdatedField<string[]>;

  @ApiPropertyOptional({
    type: AddressDto,
    example: {
      fieldKey: 'address',
      value: {
        streetAddress: 'Street Address',
        ward: { id: 'Ward ID', name: 'Ward Name' },
        district: { id: 'District ID', name: 'District Name' },
        city: { id: 'City ID', name: 'City Name' },
      },
    },
  })
  @IsOptional()
  address?: AddressDto;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'username', value: 'Username' },
  })
  @IsOptional()
  username?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'email', value: 'Email' },
  })
  @IsOptional()
  email?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'phoneNumber', value: 'Phone Number' },
  })
  @IsOptional()
  phoneNumber?: UpdatedField<string>;
}

class LegalRepresentativeDto {
  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'fullName', value: 'Full Name' },
  })
  @IsOptional()
  fullName?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'position', value: 'Position' },
  })
  @IsOptional()
  position?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'phoneNumber', value: 'Phone Number' },
  })
  @IsOptional()
  phoneNumber?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'idType', value: 'ID Type' },
  })
  @IsOptional()
  idType?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'idNumber', value: 'ID Number' },
  })
  @IsOptional()
  idNumber?: UpdatedField<string>;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'idIssueDate', value: 'ID Issue Date' },
  })
  @IsOptional()
  idIssueDate?: UpdatedField<string>;
}

class KycDocumentDto {
  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'fileUrl', value: 'File URL' },
  })
  @IsOptional()
  fileUrl?: string;

  @ApiPropertyOptional({
    type: UpdatedField,
    example: { fieldKey: 'fileType', value: 'File Type' },
  })
  @IsOptional()
  fileType?: string;
}

export class UpdatePartnerDto {
  @ApiPropertyOptional({
    type: BusinessInfo,
    example: {
      brandName: { fieldKey: 'brandName', value: 'Brand Name' },
      taxRegistrationCode: {
        fieldKey: 'taxRegistrationCode',
        value: 'Tax Registration Code',
      },
      serviceTags: {
        fieldKey: 'serviceTags',
        value: ['Service Tag 1', 'Service Tag 2'],
      },
      address: {
        fieldKey: 'address',
        value: {
          streetAddress: 'Street Address',
          ward: { id: 'Ward ID', name: 'Ward Name' },
          district: { id: 'District ID', name: 'District Name' },
          city: { id: 'City ID', name: 'City Name' },
        },
      },
      username: { fieldKey: 'username', value: 'Username' },
      email: { fieldKey: 'email', value: 'Email' },
      phoneNumber: { fieldKey: 'phoneNumber', value: 'Phone Number' },
    },
  })
  @IsOptional()
  bussinessInfo: BusinessInfo;

  @ApiPropertyOptional({
    type: LegalRepresentativeDto,
    example: {
      fullName: { fieldKey: 'fullName', value: 'Full Name' },
      position: { fieldKey: 'position', value: 'Position' },
      phoneNumber: { fieldKey: 'phoneNumber', value: 'Phone Number' },
      idType: { fieldKey: 'idType', value: 'ID Type' },
      idNumber: { fieldKey: 'idNumber', value: 'ID Number' },
      idIssueDate: { fieldKey: 'idIssueDate', value: 'ID Issue Date' },
    },
  })
  @IsOptional()
  legalRepresentative: LegalRepresentativeDto;

  @ApiPropertyOptional({
    type: [KycDocumentDto],
    example: [
      {
        id: { fieldKey: 'id', value: 'ID' },
        documentKey: { fieldKey: 'documentKey', value: 'Document Key' },
        fileUrl: { fieldKey: 'fileUrl', value: 'File URL' },
        type: { fieldKey: 'type', value: 'Type' },
        fileType: { fieldKey: 'fileType', value: 'File Type' },
        status: { fieldKey: 'status', value: 'Status' },
        uploadedAt: { fieldKey: 'uploadedAt', value: 'Uploaded At' },
      },
    ],
  })
  @IsOptional()
  @Type(() => KycDocumentDto)
  @ValidateNested({ each: true })
  kycDocuments: KycDocumentDto[];
}
