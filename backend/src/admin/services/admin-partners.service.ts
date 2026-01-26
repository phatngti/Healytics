import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument } from '@/partners/entities/partner-document.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto, ReviewDecision, ReviewItemType } from '../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';

@Injectable()
export class AdminPartnersService {
    constructor(
        @InjectRepository(Partner)
        private readonly partnerRepo: Repository<Partner>,
        @InjectRepository(PartnerDocument)
        private readonly documentRepo: Repository<PartnerDocument>,
        private readonly dataSource: DataSource,
        private readonly partnersService: PartnersService,
    ) { }

    async getPartnerDetail(id: string): Promise<AdminPartnerDetailResponseDto> {
        const partner = await this.partnerRepo.findOne({
            where: { id },
            relations: ['account', 'province', 'district', 'ward', 'legalRepresentative'],
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        const documents = await this.documentRepo.find({
            where: { partnerId: id },
            order: { uploadedAt: 'DESC' },
        });

        return new AdminPartnerDetailResponseDto(partner, documents);
    }

    async reviewPartner(id: string, dto: ReviewPartnerProfileDto, adminId: string): Promise<void> {
        const partner = await this.partnerRepo.findOne({ where: { id } });
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        await this.dataSource.transaction(async (manager) => {
            if (dto.decision === ReviewDecision.APPROVED) {
                // Partner Approved
                partner.verificationStatus = PartnerVerificationStatus.APPROVED;
                partner.verificationCompletedAt = new Date();
                partner.rejectionDetails = null; // Clear any previous errors
                await manager.save(partner);

                // Mark all unreviewed documents as valid
                await manager.update(
                    PartnerDocument,
                    { partnerId: id, isReviewed: false },
                    {
                        isReviewed: true,
                        isValid: true,
                        verifiedBy: adminId,
                        verificationNotes: dto.generalComment
                    }
                );
            } else {
                // REJECTED - partner verification failed
                partner.verificationStatus = PartnerVerificationStatus.REJECTED;

                // Initialize field rejection map: { fieldName: reason }
                const fieldRejections: Record<string, string> = {};

                // Process review items if provided
                if (dto.items && dto.items.length > 0) {
                    for (const item of dto.items) {
                        // Handle DOCUMENTS
                        if (item.type === ReviewItemType.DOCUMENT && item.documentId) {
                            await manager.update(
                                PartnerDocument,
                                { id: item.documentId, partnerId: id },
                                {
                                    isReviewed: true,
                                    isValid: item.isValid,
                                    adminFeedback: item.reason || null,
                                    verifiedBy: adminId
                                }
                            );
                        }
                        // Handle Partner FIELDS
                        else if (item.type === ReviewItemType.FIELD && item.fieldName) {
                            if (!item.isValid && item.reason) {
                                fieldRejections[item.fieldName] = item.reason;
                            }
                        }
                        // Handle Legal Representative FIELDS
                        else if (item.type === ReviewItemType.LEGAL_REP_FIELD && item.fieldName) {
                            if (!item.isValid && item.reason) {
                                fieldRejections[`legalRep.${item.fieldName}`] = item.reason;
                            }
                        }
                        // Handle Account FIELDS
                        else if (item.type === ReviewItemType.ACCOUNT_FIELD && item.fieldName) {
                            if (!item.isValid && item.reason) {
                                fieldRejections[`account.${item.fieldName}`] = item.reason;
                            }
                        }
                    }
                }

                // Save field rejections if any
                partner.rejectionDetails = Object.keys(fieldRejections).length > 0
                    ? fieldRejections
                    : null;

                await manager.save(partner);
            }
        });
    }

    async getPartners(query: GetPartnersQueryDto): Promise<any> {
        return this.partnersService.getPartners(query);
    }
}
