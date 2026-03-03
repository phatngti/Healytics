import {
    Injectable,
    ConflictException,
    BadRequestException,
    NotFoundException,
    Inject,
    forwardRef,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { RegisterPartnerDto } from './dto/request/register-partner.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { GetPartnersQueryDto } from './dto/request/get-partners-query.dto';
import { RegisterPartnerResponseDto } from './dto/response/register-partner-response.dto';
import { MyProfileResponseDto, FieldFeedbackMap } from './dto/response/my-profile-response.dto';
import { PartnersResponseDto } from './dto/response/partners-response.dto';
import { Role } from '@/account/enum/role.enum';
import { PartnerDocument, PartnerDocumentStatuses, DocumentTypes, DocumentFileTypes, DocumentFileType } from '@/common/entities/partner-document.entity';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { LocationsService } from '@/locations/locations.service';
import { AuthService } from '@/auth/auth.service';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';
import { BusinessType, bussinessServices } from './enum/business-type.enum';

@Injectable()
export class PartnersService {

    constructor(
        @InjectRepository(Account)
        private readonly accountRepository: Repository<Account>,
        @InjectRepository(Partner)
        private readonly partnerRepository: Repository<Partner>,
        @InjectRepository(PartnerReviewLog)
        private readonly reviewLogRepository: Repository<PartnerReviewLog>,
        private readonly dataSource: DataSource,
        private readonly locationsService: LocationsService,
        @Inject(forwardRef(() => AuthService))
        private readonly authService: AuthService,
    ) { }

    /**bussinessServices
     * Get all available business types with Vietnamese labels
     */
    getBusinessServices(): BusinessServicesResponseDto {
        return {
            data: Array.from(bussinessServices.values())
        }
    }

    async getPartnerProfile(userId: string): Promise<Partner> {
        
        const partner = await this.partnerRepository.findOne({
            where: { accountId: userId },
        });

        if (!partner) {
            throw new NotFoundException('Partner profile not found');
        }
        return partner;
    }

    async registerPartner(
        dto: RegisterPartnerDto,
    ): Promise<RegisterPartnerResponseDto> {
        // 1. Check if email or username already exists
        const existingAccount = await this.accountRepository.findOne({
            where: [
                { email: dto.account.email },
                // Username check if you add username field to Account entity
            ],
        });

        if (existingAccount) {
            throw new ConflictException(
                'An account with this email already exists',
            );
        }

        // 2. Check if tax code already exists
        const existingPartner = await this.partnerRepository.findOne({
            where: { taxCode: dto.partner.taxCode },
        });

        if (existingPartner) {
            throw new ConflictException(
                'A business with this tax code is already registered',
            );
        }

        // 3. Validate address hierarchy (province -> district -> ward)
        try {
            await this.locationsService.validateAddress(
                dto.partner.provinceId,
                dto.partner.districtId,
                dto.partner.wardId,
            );
        } catch (error) {
            throw new BadRequestException(
                `Invalid address: ${error.message}`,
            );
        }

        // 4. Create entities in a transaction
        const queryRunner = this.dataSource.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            // Create Account INSIDE transaction to ensure atomicity
            const passwordHash = await bcrypt.hash(dto.account.password, 10);
            const account = queryRunner.manager.create(Account, {
                email: dto.account.email,
                passwordHash,
                role: Role.HEALTH_PARTNER,
                isActive: true,
            });
            const savedAccount = await queryRunner.manager.save(account);

            // Create Partner
            const partner = queryRunner.manager.create(Partner, {
                taxCode: dto.partner.taxCode,
                legalName: dto.partner.legalName,
                brandName: dto.partner.brandName,
                businessType: dto.partner.businessType as BusinessType[],
                provinceId: dto.partner.provinceId,
                districtId: dto.partner.districtId,
                wardId: dto.partner.wardId,
                streetAddress: dto.partner.streetAddress,
                phoneNumber: dto.partner.phoneNumber || null,
                accountId: savedAccount.id,
            });
            const savedPartner =
                await queryRunner.manager.save(partner);

            // Create Legal Representative (without document URLs - moved to PartnerDocument)
            const legalRep = queryRunner.manager.create(LegalRepresentative, {
                fullName: dto.legalRepresentative.fullName,
                position: dto.legalRepresentative.position,
                idType: dto.legalRepresentative.idType,
                idNumber: dto.legalRepresentative.idNumber,
                idIssueDate: new Date(dto.legalRepresentative.idIssueDate),
                partnerId: savedPartner.id,
            });
            await queryRunner.manager.save(legalRep);

            // Create PartnerDocuments for identity images
            const documentsToCreate: Partial<PartnerDocument>[] = [];

            dto.legalRepresentative.documents.forEach(doc => {
                documentsToCreate.push(...doc.urls.map(url => ({
                    partnerId: savedPartner.id,
                    fileUrl: url,
                    type: doc.type,
                    fileType: doc.fileType,
                    documentKey: doc.documentKey,
                    status: PartnerDocumentStatuses.ACCEPTED,
                })));
            });

            // Save all documents in batch
            if (documentsToCreate.length > 0) {
                const documents = documentsToCreate.map(doc => 
                    queryRunner.manager.create(PartnerDocument, doc)
                );
                await queryRunner.manager.save(documents);
            }

            // Commit transaction
            await queryRunner.commitTransaction();

            // Generate authentication tokens AFTER successful transaction
            const tokens = await this.authService.createTokensForUser(
                savedAccount.id,
                savedAccount.email,
                savedAccount.role,
            );

            // Return with tokens from AuthService
            return {
                accountId: savedAccount.id,
                businessEntityId: savedPartner.id,
                status: 'success',
                message: 'Partner registration successful',
                ...tokens,
            };
        } catch (error) {
            // Rollback on error
            await queryRunner.rollbackTransaction();
            throw error;
        } finally {
            // Release query runner
            await queryRunner.release();
        }
    }

    async getPartnerByAccountId(
        accountId: string,
    ): Promise<Partner | null> {
        return this.partnerRepository.findOne({
            where: { accountId },
            relations: ['province', 'district', 'ward', 'legalRepresentative', 'documents'],
        });
    }

    /**
     * Returns the first health partner profile with location relations.
     * Used to populate clinic/location info on public product detail screens.
     */
    async getFirstHealthPartner(): Promise<Partner | null> {
        const account = await this.accountRepository.findOne({
            where: { role: Role.HEALTH_PARTNER },
        });

        if (!account) return null;

        return this.partnerRepository.findOne({
            where: { accountId: account.id },
            relations: ['province', 'district', 'ward'],
        });
    }

    /**
     * Get partner's own profile with verification fields including requiresUpdate, adminFeedback, and isVerified
     */
    async getMyProfile(accountId: string): Promise<MyProfileResponseDto> {
        const partner = await this.partnerRepository.findOne({
            where: { accountId },
            relations: ['province', 'district', 'ward', 'legalRepresentative', 'documents', 'account'],
        });
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Fetch the latest review log for feedback and isVerified data
        const latestReviewLog = await this.reviewLogRepository.findOne({
            where: { partnerId: partner.id },
            order: { createdAt: 'DESC' },
        });

        // Build feedback maps from review log
        const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);
        const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

        return MyProfileResponseDto.fromPartner(partner, fieldFeedbackMap, documentFeedbackMap);
    }

    /**
     * Update partner's profile - with "Smart Update" logic
     * 
     * Logic:
     * 1. Check current vs new value using UpdatedField wrapper
     * 2. If changed -> Update value & Clear specific rejection detail
     * 3. If all rejection details cleared -> Reset status to PENDING
     * 
     * DTO Structure:
     * - bussinessInfo: { brandName, taxRegistrationCode, serviceTags, address, username, email, phoneNumber }
     * - legalRepresentative: { fullName, position, phoneNumber, idType, idNumber, idIssueDate }
     * - kycDocuments: [{ fileUrl, fileType }]
     * 
     * Each field is wrapped in UpdatedField<T> with { fieldKey, value } structure
     */
    async updateMyProfile(accountId: string, dto: UpdatePartnerDto): Promise<MyProfileResponseDto> {
        // 1. Get Partner information
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) throw new NotFoundException('Partner not found');

        const queryRunner = this.dataSource.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            let isModified = false;

            // Flag to track if sensitive information is modified (to revoke APPROVED)
            let hasCriticalChange = false;

            // Helper function to extract value from UpdatedField wrapper
            const getValue = <T>(field: { fieldKey: string; value: T } | undefined): T | undefined => {
                return field?.value;
            };

            // --- A. PROCESS BUSINESS INFO ---
            if (dto.bussinessInfo) {
                const bizInfo = dto.bussinessInfo;

                // A.1 Check for duplicate TaxCode
                const newTaxCode = getValue(bizInfo.taxRegistrationCode);
                if (newTaxCode && newTaxCode !== partner.taxCode) {
                    const existing = await queryRunner.manager.findOne(Partner, { where: { taxCode: newTaxCode } });
                    if (existing) throw new BadRequestException('Tax code already exists');
                    partner.taxCode = newTaxCode;
                    isModified = true;
                    hasCriticalChange = true;
                }

                // A.2 Update brand name
                const newBrandName = getValue(bizInfo.brandName);
                if (newBrandName !== undefined && newBrandName !== partner.brandName) {
                    partner.brandName = newBrandName;
                    isModified = true;
                }

                // A.3 Update phone number
                const newPhoneNumber = getValue(bizInfo.phoneNumber);
                if (newPhoneNumber !== undefined && newPhoneNumber !== partner.phoneNumber) {
                    partner.phoneNumber = newPhoneNumber;
                    isModified = true;
                }

                // A.4 Update address
                if (bizInfo.address) {
                    const addressDto = bizInfo.address;
                    
                    // Extract address values
                    const newStreetAddress = getValue(addressDto.streetAddress);
                    const newCity = getValue(addressDto.city);
                    const newDistrict = getValue(addressDto.district);
                    const newWard = getValue(addressDto.ward);

                    // Update street address
                    if (newStreetAddress !== undefined && newStreetAddress !== partner.streetAddress) {
                        partner.streetAddress = newStreetAddress;
                        isModified = true;
                        hasCriticalChange = true;
                    }

                    // Update province/district/ward (city = province in this context)
                    const newProvinceId = newCity?.id || partner.provinceId;
                    const newDistrictId = newDistrict?.id || partner.districtId;
                    const newWardId = newWard?.id || partner.wardId;

                    // Only validate when we have all 3 levels
                    if (newProvinceId && newDistrictId && newWardId) {
                        const isAddressChanged =
                            newProvinceId !== partner.provinceId ||
                            newDistrictId !== partner.districtId ||
                            newWardId !== partner.wardId;

                        if (isAddressChanged) {
                            // Validate address exists
                            await this.locationsService.validateAddress(newProvinceId, newDistrictId, newWardId);

                            partner.provinceId = newProvinceId;
                            partner.districtId = newDistrictId;
                            partner.wardId = newWardId;

                            isModified = true;
                            hasCriticalChange = true;
                        }
                    }
                }
            }

            // --- B. UPDATE LEGAL REPRESENTATIVE ---
            if (dto.legalRepresentative) {
                const legalRep = await queryRunner.manager.findOne(LegalRepresentative, {
                    where: { partnerId: partner.id },
                });
                if (legalRep) {
                    let repModified = false;
                    const repDto = dto.legalRepresentative;

                    // Helper function to update legal representative field
                    const updateRepField = <T>(
                        field: keyof LegalRepresentative,
                        updatedField: { fieldKey: string; value: T } | undefined,
                        isCritical: boolean
                    ) => {
                        const newValue = getValue(updatedField);
                        if (newValue !== undefined && newValue !== legalRep[field]) {
                            (legalRep as any)[field] = newValue;
                            repModified = true;
                            if (isCritical) hasCriticalChange = true;
                        }
                    };

                    updateRepField('fullName', repDto.fullName, true);
                    updateRepField('idNumber', repDto.idNumber, true);
                    updateRepField('idType', repDto.idType, true);
                    updateRepField('phoneNumber', repDto.phoneNumber, false);
                    updateRepField('position', repDto.position, false);

                    // Handle idIssueDate separately (needs Date parsing)
                    const newIdIssueDate = getValue(repDto.idIssueDate);
                    if (newIdIssueDate) {
                        const newDate = new Date(newIdIssueDate);
                        const currentIssueDate = new Date(legalRep.idIssueDate);
                        if (newDate.getTime() !== currentIssueDate.getTime()) {
                            legalRep.idIssueDate = newDate;
                            repModified = true;
                            hasCriticalChange = true;
                        }
                    }

                    if (repModified) {
                        await queryRunner.manager.save(legalRep);
                        isModified = true;
                    }
                }
            }

            // --- C. UPDATE KYC DOCUMENTS ---
            if (dto.kycDocuments && dto.kycDocuments.length > 0) {
                for (const docUpdate of dto.kycDocuments) {
                    const docValue = docUpdate.value;
                    if (docValue?.fileUrl) {
                        // Create or update document based on fileType
                        const existingDoc = await queryRunner.manager.findOne(PartnerDocument, {
                            where: { partnerId: partner.id, fileUrl: docValue.fileUrl },
                        });

                        if (!existingDoc) {
                            // Create new document
                            const newDoc = queryRunner.manager.create(PartnerDocument, {
                                partnerId: partner.id,
                                fileUrl: docValue.fileUrl,
                                fileType: (docValue.fileType as DocumentFileType) || DocumentFileTypes.IMAGE,
                                documentKey: docUpdate.fieldKey || 'OTHER_DOCUMENTS',
                                type: DocumentTypes.OTHER_DOCUMENTS,
                                status: PartnerDocumentStatuses.ACCEPTED,
                            });
                            await queryRunner.manager.save(newDoc);
                            isModified = true;
                        }
                    }
                }
            }

            // --- D. RECALCULATE STATUS ---
            if (isModified) {
                // Check all documents for rejected status
                const allDocs = await queryRunner.manager.find(PartnerDocument, { where: { partnerId: partner.id } });

                const hasRejectedDocs = allDocs.some(d => d.status === PartnerDocumentStatuses.REJECTED);

                // Status transition logic
                const isClean = !hasRejectedDocs;
                // Check if partner has completed all required fields for verification
                const isComplete = !!partner.taxCode && !!partner.legalName && !!partner.brandName;

                if (isClean && isComplete) {
                    // Only transition to PENDING if currently ONBOARDING or REQUIRED_RESUBMIT
                    if (partner.verificationStatus === PartnerVerificationStatus.ONBOARDING ||
                        partner.verificationStatus === PartnerVerificationStatus.REQUIRED_RESUBMIT) {
                        partner.verificationStatus = PartnerVerificationStatus.PENDING;
                        partner.verificationCompletedAt = null;
                    }
                } else {
                    if (partner.verificationStatus === PartnerVerificationStatus.APPROVED && hasCriticalChange) {
                        partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                    }
                }

                // Use destructuring to separate relations from data
                const { documents, legalRepresentative, ...updateData } = partner;

                // Pass only the updateData to TypeORM
                await queryRunner.manager.update(Partner, partner.id, updateData);
            }
            await queryRunner.commitTransaction();
            return this.getMyProfile(accountId); // Return latest data

        } catch (error) {
            await queryRunner.rollbackTransaction();
            throw error;
        } finally {
            await queryRunner.release();
        }
    }

    /**
     * Get list of partners (Admin)
     */
    async getPartners(query: GetPartnersQueryDto): Promise<PartnersResponseDto> {
        const { page = 1, limit = 10, verificationStatus, search } = query;
        const skip = (page - 1) * limit;

        const queryBuilder = this.partnerRepository
            .createQueryBuilder('partner')
            .leftJoinAndSelect('partner.account', 'account')
            .select([
                'partner.id',
                'partner.taxCode',
                'partner.legalName',
                'partner.brandName',
                'partner.businessType',
                'partner.verificationStatus',
                'partner.createdAt',
                'account.email',
            ]);

        // Filter by verification status
        if (query.verificationStatus) {
            queryBuilder.andWhere('partner.verificationStatus = :verificationStatus', {
                verificationStatus: query.verificationStatus,
            });
        }

        // Search filter
        if (search) {
            queryBuilder.andWhere(
                '(partner.taxCode ILIKE :search OR partner.brandName ILIKE :search OR partner.legalName ILIKE :search OR account.email ILIKE :search)',
                { search: `%${search}%` },
            );
        }

        const [data, total] = await queryBuilder
            .orderBy('partner.createdAt', 'DESC')
            .skip(skip)
            .take(limit)
            .getManyAndCount();

        return {
            data: data.map((b) => ({
                id: b.id,
                taxCode: b.taxCode,
                legalName: b.legalName,
                brandName: b.brandName,
                email: b.account.email,
                businessType: b.businessType,
                verificationStatus: b.verificationStatus,
                createdAt: b.createdAt,
            })),
            total,
            page,
            limit,
        };
    }


    // ============================================================================
    // Helper Methods for Review Log Feedback
    // ============================================================================

    /**
     * Build field feedback map from the latest review log
     */
    private buildFieldFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
        const feedbackMap: FieldFeedbackMap = {};

        if (!reviewLog?.fieldReviews) {
            return feedbackMap;
        }

        for (const [fieldName, review] of Object.entries(reviewLog.fieldReviews)) {
            feedbackMap[fieldName] = {
                feedback: review.feedback,
            };
        }

        return feedbackMap;
    }

    /**
     * Build document feedback map from the latest review log
     */
    private buildDocumentFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
        const feedbackMap: FieldFeedbackMap = {};

        if (!reviewLog?.documentReviews) {
            return feedbackMap;
        }

        for (const [docId, review] of Object.entries(reviewLog.documentReviews)) {
            feedbackMap[docId] = {
                feedback: review.feedback,
            };
        }

        return feedbackMap;
    }
}
