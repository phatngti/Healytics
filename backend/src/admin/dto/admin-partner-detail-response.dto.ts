import { ApiProperty } from '@nestjs/swagger';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnerDocument } from '@/partners/entities/partner-document.entity';

export class AdminPartnerDocumentDto {
    @ApiProperty()
    id: string;

    @ApiProperty()
    documentType: string;

    @ApiProperty({ nullable: true })
    documentUrl: string | null;

    @ApiProperty({ nullable: true })
    documentKey: string | null;

    @ApiProperty({ description: 'Whether the document has been reviewed by admin' })
    isReviewed: boolean;

    @ApiProperty({ description: 'Whether the document is valid' })
    isValid: boolean;

    @ApiProperty({ nullable: true })
    verificationNotes: string | null;

    @ApiProperty({ nullable: true })
    adminFeedback: string | null;

    @ApiProperty()
    uploadedAt: Date;
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
    phone: string | null;

    @ApiProperty()
    address: string;

    @ApiProperty({ enum: PartnerVerificationStatus })
    verificationStatus: PartnerVerificationStatus;

    @ApiProperty({ nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty()
    createdAt: Date;

    @ApiProperty({ type: [AdminPartnerDocumentDto] })
    documents: AdminPartnerDocumentDto[];

    constructor(partner: Partner, documents: PartnerDocument[]) {
        this.id = partner.id;
        this.email = partner.account?.email;
        this.taxCode = partner.taxCode;
        this.legalName = partner.legalName;
        this.brandName = partner.brandName;
        this.businessType = partner.businessType;
        this.phone = partner.phoneNumber;
        // Construct address string if location relations exist
        const parts = [partner.streetAddress];
        if (partner.ward) parts.push(partner.ward.name);
        if (partner.district) parts.push(partner.district.name);
        if (partner.province) parts.push(partner.province.name);
        this.address = parts.filter(Boolean).join(', ');

        this.verificationStatus = partner.verificationStatus;
        this.verificationCompletedAt = partner.verificationCompletedAt;
        this.createdAt = partner.createdAt;

        this.documents = documents.map(doc => ({
            id: doc.id,
            documentType: doc.documentType,
            documentUrl: doc.documentUrl,
            documentKey: doc.documentKey,
            isReviewed: doc.isReviewed,
            isValid: doc.isValid,
            verificationNotes: doc.verificationNotes,
            adminFeedback: doc.adminFeedback,
            uploadedAt: doc.uploadedAt,
        }));
    }
}
