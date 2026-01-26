import { ApiProperty } from '@nestjs/swagger';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnerDocument, PartnerDocument as PDocument } from '@/partners/entities/partner-document.entity';
import { LegalRepresentative } from '@/partners/entities/legal-representative.entity';
import { IdType } from '@/partners/enum/id-type.enum';
import {
    AddressDto,
    LegalRepresentativeDto as BaseLegalRepresentativeDto,
    PartnerDocumentDto
} from '@/partners/dto/response/my-profile-response.dto';
import { PartnerDocumentStatus } from '@/partners/enum/partner-document-status.enum';

export class AdminLegalRepresentativeDto extends BaseLegalRepresentativeDto {
    @ApiProperty({ example: 'uuid-123' })
    id: string;

    static fromEntity(rep: LegalRepresentative): AdminLegalRepresentativeDto {
        const dto = new AdminLegalRepresentativeDto();
        dto.id = rep.id;
        dto.fullName = rep.fullName;
        dto.position = rep.position;
        dto.idType = rep.idType as unknown as string; // Casting if enum mismatch in DTO
        dto.idNumber = rep.idNumber;
        dto.idIssueDate = rep.idIssueDate;
        dto.idFrontImgUrl = rep.idFrontImgUrl;
        dto.idBackImgUrl = rep.idBackImgUrl;
        dto.isAuthorizedUser = rep.isAuthorizedUser;
        dto.authLetterDocUrl = rep.authLetterDocUrl;
        dto.phoneNumber = rep.phoneNumber;
        return dto;
    }
}

export class AdminPartnerDetailResponseDto {
    @ApiProperty()
    id: string;

    @ApiProperty()
    email: string;

    @ApiProperty()
    taxCode: string;

    @ApiProperty()
    legalName: string;

    @ApiProperty()
    brandName: string;

    @ApiProperty()
    businessType: string;

    @ApiProperty({ nullable: true })
    phoneNumber: string | null;

    @ApiProperty({ type: AddressDto })
    address: AddressDto;

    @ApiProperty({ enum: PartnerVerificationStatus })
    verificationStatus: PartnerVerificationStatus;

    @ApiProperty({ nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty()
    createdAt: Date;

    @ApiProperty({ type: AdminLegalRepresentativeDto, nullable: true })
    legalRepresentative: AdminLegalRepresentativeDto | null;

    @ApiProperty({ type: [PartnerDocumentDto] })
    documents: PartnerDocumentDto[];

    @ApiProperty({ type: Object, nullable: true, description: 'Field-level rejection details' })
    rejectionDetails: Record<string, string> | null;

    static fromEntity(partner: Partner, documents: PartnerDocumentDto[]): AdminPartnerDetailResponseDto {
        const dto = new AdminPartnerDetailResponseDto();
        dto.id = partner.id;
        dto.email = partner.account?.email;
        dto.taxCode = partner.taxCode;
        dto.legalName = partner.legalName;
        dto.brandName = partner.brandName;
        dto.businessType = partner.businessType;
        dto.phoneNumber = partner.phoneNumber;

        dto.address = {
            provinceId: partner.provinceId,
            province: partner.province?.name ?? '',
            districtId: partner.districtId,
            district: partner.district?.name ?? '',
            wardId: partner.wardId,
            ward: partner.ward?.name ?? '',
            streetAddress: partner.streetAddress,
        };

        dto.verificationStatus = partner.verificationStatus;
        dto.verificationCompletedAt = partner.verificationCompletedAt;
        dto.createdAt = partner.createdAt;

        dto.legalRepresentative = partner.legalRepresentative
            ? AdminLegalRepresentativeDto.fromEntity(partner.legalRepresentative)
            : null;

        dto.documents = documents;
        dto.rejectionDetails = partner.rejectionDetails;

        return dto;
    }
}

