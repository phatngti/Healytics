import {
    Injectable,
    ConflictException,
    BadRequestException,
    NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Account } from '@/account/entities/account.entity';
import { Partner } from './entities/partner.entity';
import { LegalRepresentative } from './entities/legal-representative.entity';
import { PartnerReviewLog } from '../admin/entities/partner-review-log.entity';
import { RegisterPartnerDto } from './dto/request/register-partner.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { GetPartnersQueryDto } from './dto/request/get-partners-query.dto';
import { RegisterPartnerResponseDto } from './dto/response/register-partner-response.dto';
import { MyProfileResponseDto, DocumentStatusDto } from './dto/response/my-profile-response.dto';
import { PartnersResponseDto } from './dto/response/partners-response.dto';
import { PartnerDetailResponseDto } from './dto/response/partner-detail-response.dto';
import { BusinessTypesResponseDto } from './dto/response/business-types-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from './enum/business-type.enum';
import { PartnerDocument, PartnerDocumentStatuses, DocumentTypes, DocumentFileTypes } from './entities/partner-document.entity';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { DocumentRequirement } from './entities/document-requirement.entity';
import { LocationsService } from '@/locations/locations.service';
import { AuthService } from '@/auth/auth.service';

// Helper types for field feedback from review log
interface FieldFeedback {
    isVerified: boolean;
    feedback?: string;
}

type FieldFeedbackMap = Record<string, FieldFeedback>;

@Injectable()
export class PartnersService {
    constructor(
        @InjectRepository(Account)
        private readonly accountRepository: Repository<Account>,
        @InjectRepository(Partner)
        private readonly partnerRepository: Repository<Partner>,
        @InjectRepository(LegalRepresentative)
        private readonly legalRepRepository: Repository<LegalRepresentative>,
        @InjectRepository(DocumentRequirement)
        private readonly docRequirementRepository: Repository<DocumentRequirement>,
        @InjectRepository(PartnerReviewLog)
        private readonly reviewLogRepository: Repository<PartnerReviewLog>,
        private readonly dataSource: DataSource,
        private readonly locationsService: LocationsService,
        private readonly authService: AuthService,
    ) { }

    /**
     * Get all available business types with Vietnamese labels
     */
    getBusinessTypes(): BusinessTypesResponseDto {
        return {
            data: [
                { value: BusinessType.MASSAGE_THERAPY, label: 'Massage Thư giãn' },
                { value: BusinessType.MASSAGE_REHABILITATION, label: 'Massage Trị liệu' },
                { value: BusinessType.SPA_BEAUTY, label: 'Spa & Làm đẹp' },
                { value: BusinessType.FITNESS, label: 'Thể hình (Gym/Yoga)' },
                { value: BusinessType.PHARMACY, label: 'Dược phẩm' },
                { value: BusinessType.DENTAL, label: 'Nha khoa' },
                { value: BusinessType.TRADITIONAL_MEDICINE, label: 'Đông y' },
                { value: BusinessType.PSYCHOLOGY, label: 'Tâm lý & Trị liệu' },
                { value: BusinessType.DERMATOLOGY, label: 'Da liễu & Thẩm mỹ' },
                { value: BusinessType.NUTRITION, label: 'Dinh dưỡng' },
                { value: BusinessType.PSYCHIATRY, label: 'Tâm thần học' },
            ],
        };
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
                businessType: dto.partner.businessType,
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
                    status: PartnerDocumentStatuses.PENDING,
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
     * Get partner's own profile with verification fields including requiresUpdate, adminFeedback, and isVerified
     */
    async getMyProfile(accountId: string): Promise<MyProfileResponseDto> {
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        const rejectionDetails = partner.rejectionDetails || {};
        const legalRep = partner.legalRepresentative;

        // Fetch the latest review log for feedback and isVerified data
        const latestReviewLog = await this.reviewLogRepository.findOne({
            where: { partnerId: partner.id },
            order: { createdAt: 'DESC' },
        });

        // Build feedback maps from review log
        const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);
        const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

        // Helper function to create VerificationStringField with feedback from review log
        const createStringField = (
            value: string,
            displayValue: string,
            fieldKey: string,
        ) => {
            const fieldFeedback = fieldFeedbackMap[fieldKey];
            return {
                value,
                displayValue,
                requiresUpdate: !!rejectionDetails[fieldKey] || (fieldFeedback?.isVerified === false),
                adminFeedback: fieldFeedback?.feedback || rejectionDetails[fieldKey] || null,
                isVerified: fieldFeedback?.isVerified ?? null,
            };
        };

        // Helper function to create VerificationOptionalStringField with feedback from review log
        const createOptionalStringField = (
            value: string | null,
            displayValue: string | null,
            fieldKey: string,
        ) => {
            const fieldFeedback = fieldFeedbackMap[fieldKey];
            return {
                value,
                displayValue,
                requiresUpdate: !!rejectionDetails[fieldKey] || (fieldFeedback?.isVerified === false),
                adminFeedback: fieldFeedback?.feedback || rejectionDetails[fieldKey] || null,
                isVerified: fieldFeedback?.isVerified ?? null,
            };
        };

        // Helper function to create VerificationDocument from PartnerDocument with feedback from review log
        const createDocumentFromPartnerDoc = (
            doc: PartnerDocument | undefined,
            id: string,
            label: string,
            fieldKey: string,
        ) => {
            const fileUrl = doc?.fileUrl || null;
            const hasUrl = !!fileUrl;
            
            // Check document feedback from review log using document ID
            const docFeedback = doc ? documentFeedbackMap[doc.id] : undefined;
            const isRejected = !!rejectionDetails[fieldKey] || (docFeedback?.isVerified === false);
            
            return {
                id,
                label,
                fileUrl,
                fileName: fileUrl ? fileUrl.split('/').pop() : null,
                status: isRejected ? DocumentStatusDto.REVISION_REQUIRED : (hasUrl ? DocumentStatusDto.APPROVED : DocumentStatusDto.MISSING),
                requiresUpdate: isRejected || !hasUrl,
                adminFeedback: docFeedback?.feedback || rejectionDetails[fieldKey] || null,
                isVerified: docFeedback?.isVerified ?? null,
            };
        };

        // Fetch partner documents
        const documents = partner.documents || [];

        // Get business type display value
        const businessTypeLabels: Record<BusinessType, string> = {
            [BusinessType.MASSAGE_THERAPY]: 'Massage Thư giãn',
            [BusinessType.MASSAGE_REHABILITATION]: 'Massage Trị liệu',
            [BusinessType.SPA_BEAUTY]: 'Spa & Làm đẹp',
            [BusinessType.FITNESS]: 'Thể hình (Gym/Yoga)',
            [BusinessType.PHARMACY]: 'Dược phẩm',
            [BusinessType.DENTAL]: 'Nha khoa',
            [BusinessType.TRADITIONAL_MEDICINE]: 'Đông y',
            [BusinessType.PSYCHOLOGY]: 'Tâm lý & Trị liệu',
            [BusinessType.DERMATOLOGY]: 'Da liễu & Thẩm mỹ',
            [BusinessType.NUTRITION]: 'Dinh dưỡng',
            [BusinessType.PSYCHIATRY]: 'Tâm thần học',
        };

        // Get ID type display value
        const idTypeLabels: Record<string, string> = {
            CITIZEN_ID: 'Căn cước công dân',
            ID_CARD: 'Chứng minh nhân dân',
            PASSPORT: 'Hộ chiếu',
        };

        return {
            id: partner.id,
            partnerInfo: {
                taxCode: createStringField(partner.taxCode, partner.taxCode, 'taxCode'),
                legalName: createStringField(partner.legalName, partner.legalName, 'legalName'),
                brandName: createStringField(partner.brandName, partner.brandName, 'brandName'),
                businessType: createStringField(
                    partner.businessType,
                    businessTypeLabels[partner.businessType] || partner.businessType,
                    'businessType',
                ),
                phoneNumber: createOptionalStringField(
                    partner.phoneNumber,
                    partner.phoneNumber,
                    'phoneNumber',
                ),
            },
            locationDetails: {
                provinceId: createStringField(
                    partner.provinceId || '',
                    partner.province?.name ?? '',
                    'provinceId',
                ),
                districtId: createStringField(
                    partner.districtId || '',
                    partner.district?.name ?? '',
                    'districtId',
                ),
                wardId: createStringField(
                    partner.wardId || '',
                    partner.ward?.name ?? '',
                    'wardId',
                ),
                streetAddress: createStringField(
                    partner.streetAddress,
                    partner.streetAddress,
                    'streetAddress',
                ),
            },
            legalRepresentative: {
                fullName: partner.legalRepresentative.fullName,
                position: partner.legalRepresentative.position,
                idType: partner.legalRepresentative.idType,
                idNumber: partner.legalRepresentative.idNumber,
                idIssueDate: partner.legalRepresentative.idIssueDate,
                idFrontImgUrl: partner.legalRepresentative.idFrontImgUrl,
                idBackImgUrl: partner.legalRepresentative.idBackImgUrl,
                isAuthorizedUser: partner.legalRepresentative.isAuthorizedUser,
                authLetterDocUrl: partner.legalRepresentative.authLetterDocUrl,
                phoneNumber: partner.legalRepresentative.phoneNumber,
            },
            verificationStatus: partner.verificationStatus,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }

    /**
     * Update partner's profile - with "Smart Update" logic
     * 
     * Logic:
     * 1. Check current vs new value
     * 2. If changed -> Update value & Clear specific rejection detail
     * 3. If all rejection details cleared -> Reset status to PENDING
     */
    async updateMyProfile(accountId: string, dto: UpdatePartnerDto): Promise<MyProfileResponseDto> {
        // 1. Lấy thông tin Partner
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) throw new NotFoundException('Partner not found');

        const queryRunner = this.dataSource.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            // Clone map lỗi hiện tại để xử lý (tránh mutate trực tiếp object cũ)
            const currentRejection = partner.rejectionDetails ? { ...partner.rejectionDetails } : {};
            let isModified = false;

            // Cờ đánh dấu xem có sửa thông tin nhạy cảm không (để revoke APPROVED)
            let hasCriticalChange = false;

            // --- A. XỬ LÝ CHECK TRÙNG LẶP (TaxCode) ---
            if (dto.taxCode && dto.taxCode !== partner.taxCode) {
                const existing = await queryRunner.manager.findOne(Partner, { where: { taxCode: dto.taxCode } });
                if (existing) throw new BadRequestException('Tax code already exists');
            }

            // --- B. CẬP NHẬT FIELD CƠ BẢN (Text) ---
            // Danh sách các field ánh xạ trực tiếp
            const directFields: (keyof UpdatePartnerDto & keyof Partner)[] = [
                'legalName', 'brandName', 'phoneNumber', 'streetAddress', 'taxCode', 'businessType'
            ];
            // Danh sách field nhạy cảm (Sửa phát là mất APPROVED ngay)
            const criticalFields = ['legalName', 'streetAddress', 'taxCode', 'businessType'];

            directFields.forEach(key => {
                const newValue = dto[key];
                const oldValue = partner[key]; // Lưu ý: Cần ép kiểu nếu TS báo lỗi

                if (newValue !== undefined && newValue !== oldValue) {
                    (partner as any)[key] = newValue;
                    isModified = true;

                    if (criticalFields.includes(key)) hasCriticalChange = true;

                    // [CLEANUP] Sửa rồi thì xóa lỗi cũ đi
                    if (currentRejection[key]) delete currentRejection[key];
                }
            });

            // --- C. CẬP NHẬT ĐỊA CHỈ (Address Logic) ---
            if (dto.provinceId || dto.districtId || dto.wardId) {
                const newProvince = dto.provinceId || partner.provinceId;
                const newDistrict = dto.districtId || partner.districtId;
                const newWard = dto.wardId || partner.wardId;

                // Chỉ validate khi có đủ 3 cấp
                if (newProvince && newDistrict && newWard) {
                    const isAddressChanged =
                        newProvince !== partner.provinceId ||
                        newDistrict !== partner.districtId ||
                        newWard !== partner.wardId;

                    if (isAddressChanged) {
                        // Gọi service validate địa chỉ có tồn tại không
                        await this.locationsService.validateAddress(newProvince, newDistrict, newWard);

                        partner.provinceId = newProvince;
                        partner.districtId = newDistrict;
                        partner.wardId = newWard;

                        isModified = true;
                        hasCriticalChange = true; // Đổi địa chỉ luôn là critical

                        // [CLEANUP] Xóa lỗi liên quan đến địa chỉ
                        ['provinceId', 'districtId', 'wardId', 'address'].forEach(k => {
                            if (currentRejection[k]) delete currentRejection[k];
                        });
                    }
                }
            }

            // --- D. CẬP NHẬT NGƯỜI ĐẠI DIỆN (Legal Rep) ---
            if (dto.legalRepresentative) {
                const legalRep = await queryRunner.manager.findOne(LegalRepresentative, {
                    where: { partnerId: partner.id },
                });
                if (legalRep) {
                    let repModified = false;
                    const repDto = dto.legalRepresentative;

                    // Hàm helper update field con
                    const updateRep = (field: keyof LegalRepresentative, val: any, rejKey: string, isCritical: boolean) => {
                        if (val !== undefined && val !== legalRep[field]) {
                            (legalRep as any)[field] = val;
                            repModified = true;
                            if (isCritical) hasCriticalChange = true;
                            if (currentRejection[rejKey]) delete currentRejection[rejKey];
                        }
                    };

                    updateRep('fullName', repDto.fullName, 'legalRep.fullName', true);
                    updateRep('idNumber', repDto.idNumber, 'legalRep.idNumber', true);
                    updateRep('idType', repDto.idType, 'legalRep.idType', true);
                    updateRep('phoneNumber', repDto.phoneNumber, 'legalRep.phoneNumber', false);
                    updateRep('position', repDto.position, 'legalRep.position', false);

                    if (repDto.idIssueDate) {
                        const newDate = new Date(repDto.idIssueDate);
                        const currentIssueDate = new Date(legalRep.idIssueDate);
                        if (newDate.getTime() !== currentIssueDate.getTime()) {
                            legalRep.idIssueDate = newDate;
                            repModified = true;
                            hasCriticalChange = true;
                            if (currentRejection['legalRep.idIssueDate']) delete currentRejection['legalRep.idIssueDate'];
                        }
                    }

                    // Note: Document URL updates (idFrontImgUrl, idBackImgUrl, businessLicenseUrl, etc.) 
                    // are now handled through the PartnerDocument table, not LegalRepresentative fields
                    // See: updateDocumentImage method for updating document images

                    if (repModified) {
                        await queryRunner.manager.save(legalRep);
                        isModified = true;
                    }
                }
            }

            // --- E. CẬP NHẬT DOCUMENT (File) ---
            // Note: With simplified schema, documents are just stored with type/fileUrl/status
            // Document updates through this endpoint are currently not supported
            // as the new schema focuses on KYC document uploads

            // --- F. TÍNH TOÁN TRẠNG THÁI (Recalculate Status) ---
            if (isModified) {
                // 1. Cập nhật map lỗi vào DB
                const hasFieldErrors = Object.keys(currentRejection).length > 0;
                partner.rejectionDetails = hasFieldErrors ? currentRejection : null;

                // 2. Check lại toàn bộ Document (để xem có cái nào đang rejected ko)
                const allDocs = await queryRunner.manager.find(PartnerDocument, { where: { partnerId: partner.id } });

                const hasRejectedDocs = allDocs.some(d => d.status === PartnerDocumentStatuses.REJECTED);

                // 3. Logic chuyển đổi trạng thái
                const isClean = !hasFieldErrors && !hasRejectedDocs;

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

                // 1. Use Destructuring to separate relations from data.
                // We extract 'documents' and 'legalRepresentative' into their own variables (which we ignore),
                // and collect everything else into 'updateData'.
                const { documents, legalRepresentative, ...updateData } = partner;

                // 2. Pass only the 'updateData' to TypeORM
                await queryRunner.manager.update(Partner, partner.id, updateData);
            }
            await queryRunner.commitTransaction();
            return this.getMyProfile(accountId); // Trả về data mới nhất

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

    /**
     * Get partner detail (Admin)
     */
    async getPartnerDetail(partnerId: string): Promise<PartnerDetailResponseDto> {
        const partner = await this.partnerRepository.findOne({
            where: { id: partnerId },
            relations: [
                'account',
                'province',
                'district',
                'ward',
                'legalRepresentative',
                'documents',
            ],
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Helper to get document URL by type
        const getDocUrl = (type: string): string | null => {
            const doc = partner.documents?.find(d => d.type === type);
            return doc?.fileUrl || null;
        };

        return {
            account: {
                id: partner.account.id,
                email: partner.account.email,
                isActive: partner.account.isActive,
            },
            id: partner.id,
            taxCode: partner.taxCode,
            legalName: partner.legalName,
            brandName: partner.brandName,
            businessType: partner.businessType,
            address: {
                provinceId: partner.provinceId,
                province: partner.province?.name ?? '',
                districtId: partner.districtId,
                district: partner.district?.name ?? '',
                wardId: partner.wardId,
                ward: partner.ward?.name ?? '',
                streetAddress: partner.streetAddress,
            },
            legalRepresentative: {
                fullName: partner.legalRepresentative.fullName,
                position: partner.legalRepresentative.position,
                idType: partner.legalRepresentative.idType,
                idNumber: partner.legalRepresentative.idNumber,
                idIssueDate: partner.legalRepresentative.idIssueDate,
                idFrontImgUrl: partner.legalRepresentative.idFrontImgUrl,
                idBackImgUrl: partner.legalRepresentative.idBackImgUrl,
                authLetterDocUrl: partner.legalRepresentative.authLetterDocUrl,
                phoneNumber: partner.legalRepresentative.phoneNumber,
            },
            verificationStatus: partner.verificationStatus,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
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
                isVerified: review.isValid,
                feedback: review.reason,
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
                isVerified: review.isValid,
                feedback: review.feedback,
            };
        }

        return feedbackMap;
    }
}
