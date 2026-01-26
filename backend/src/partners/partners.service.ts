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
import { RegisterPartnerDto } from './dto/request/register-partner.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { GetPartnersQueryDto } from './dto/request/get-partners-query.dto';
import { RegisterPartnerResponseDto } from './dto/response/register-partner-response.dto';
import { MyProfileResponseDto } from './dto/response/my-profile-response.dto';
import { PartnersResponseDto } from './dto/response/partners-response.dto';
import { PartnerDetailResponseDto } from './dto/response/partner-detail-response.dto';
import { BusinessTypesResponseDto } from './dto/response/business-types-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from './enum/business-type.enum';
import { DocumentType } from './enum/document-type.enum';
import { PartnerDocument } from './entities/partner-document.entity';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { PartnerDocumentStatus } from './enum/partner-document-status.enum';
import { DocumentRequirement } from './entities/document-requirement.entity';
import { LocationsService } from '@/locations/locations.service';
import { AuthService } from '@/auth/auth.service';

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

            // Create Legal Representative
            const legalRep = queryRunner.manager.create(LegalRepresentative, {
                fullName: dto.legalRepresentative.fullName,
                position: dto.legalRepresentative.position,
                idType: dto.legalRepresentative.idType,
                idNumber: dto.legalRepresentative.idNumber,
                idIssueDate: new Date(dto.legalRepresentative.idIssueDate),
                idFrontImgUrl: dto.legalRepresentative.images.frontImgUrl,
                idBackImgUrl: dto.legalRepresentative.images.backImgUrl,
                isAuthorizedUser:
                    dto.legalRepresentative.authorization.isAuthorizedUser,
                authLetterDocUrl:
                    dto.legalRepresentative.authorization.authLetterDocUrl,
                partnerId: savedPartner.id,
            });
            await queryRunner.manager.save(legalRep);

            // Note: Identity documents (IDENTITY_FRONT, IDENTITY_BACK, AUTHORIZATION_LETTER)
            // are stored directly in LegalRepresentative entity and not tracked as PartnerDocuments.
            // Only business-specific documents (uploaded later) are tracked in PartnerDocument table.

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
     * Get partner's own profile with rejection details and document statuses
     */
    async getMyProfile(accountId: string): Promise<MyProfileResponseDto> {
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Fetch document requirements for this business type
        const requirements = await this.docRequirementRepository.find({
            where: { businessType: partner.businessType },
        });

        // Map uploaded documents by type for easy lookup
        const uploadedDocsMap = new Map<DocumentType, PartnerDocument>();
        if (partner.documents) {
            partner.documents.forEach((doc) => {
                uploadedDocsMap.set(doc.documentType, doc);
            });
        }

        // Merge requirements with uploaded documents
        const documentDtos: any[] = requirements.map((req) => {
            const uploadedDoc = uploadedDocsMap.get(req.documentType);
            let status = PartnerDocumentStatus.MISSING;
            let documentUrl: string | null = null;
            let documentKey: string | null = null;
            let id: string | null = null;
            let isReviewed = false;
            let isValid = false;
            let adminFeedback: string | null = null;
            let verificationNotes: string | null = null;
            let uploadedAt: Date | null = null;

            if (uploadedDoc) {
                id = uploadedDoc.id;
                documentUrl = uploadedDoc.documentUrl;
                documentKey = uploadedDoc.documentKey;
                isReviewed = uploadedDoc.isReviewed;
                isValid = uploadedDoc.isValid;
                adminFeedback = uploadedDoc.adminFeedback;
                verificationNotes = uploadedDoc.verificationNotes;
                uploadedAt = uploadedDoc.uploadedAt;

                if (uploadedDoc.isReviewed) {
                    status = uploadedDoc.isValid
                        ? PartnerDocumentStatus.APPROVED
                        : PartnerDocumentStatus.REJECTED;
                } else {
                    status = PartnerDocumentStatus.PENDING;
                }
            }

            return {
                id,
                documentType: req.documentType,
                documentUrl,
                documentKey,
                status,
                isRequired: req.isRequired,
                description: req.description,
                isReviewed,
                isValid,
                adminFeedback,
                verificationNotes,
                uploadedAt,
            };
        });

        // Also include any uploaded documents that might not be in the current requirements (edge case)
        if (partner.documents) {
            partner.documents.forEach((doc) => {
                const reqExists = requirements.find(r => r.documentType === doc.documentType);
                if (!reqExists) {
                    let status = PartnerDocumentStatus.PENDING;
                    if (doc.isReviewed) {
                        status = doc.isValid ? PartnerDocumentStatus.APPROVED : PartnerDocumentStatus.REJECTED;
                    }
                    documentDtos.push({
                        id: doc.id,
                        documentType: doc.documentType,
                        documentUrl: doc.documentUrl,
                        documentKey: doc.documentKey,
                        status,
                        isRequired: false, // Not in current requirements
                        description: null,
                        isReviewed: doc.isReviewed,
                        isValid: doc.isValid,
                        adminFeedback: doc.adminFeedback,
                        verificationNotes: doc.verificationNotes,
                        uploadedAt: doc.uploadedAt,
                    });
                }
            });
        }

        return {
            id: partner.id,
            taxCode: partner.taxCode,
            legalName: partner.legalName,
            brandName: partner.brandName,
            businessType: partner.businessType,
            phoneNumber: partner.phoneNumber || null,
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
                isAuthorizedUser: partner.legalRepresentative.isAuthorizedUser,
                authLetterDocUrl: partner.legalRepresentative.authLetterDocUrl,
                phoneNumber: partner.legalRepresentative.phoneNumber,
            },
            verificationStatus: partner.verificationStatus,
            rejectionDetails: partner.rejectionDetails || null,
            documents: documentDtos,
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

                    if (repDto.images) {
                        updateRep('idFrontImgUrl', repDto.images.frontImgUrl, 'legalRep.idFrontImgUrl', true);
                        updateRep('idBackImgUrl', repDto.images.backImgUrl, 'legalRep.idBackImgUrl', true);
                    }
                    if (repDto.authorization) {
                        updateRep('isAuthorizedUser', repDto.authorization.isAuthorizedUser, 'legalRep.isAuthorizedUser', true);
                        updateRep('authLetterDocUrl', repDto.authorization.authLetterDocUrl, 'legalRep.authLetterDocUrl', true);
                    }

                    if (repModified) {
                        await queryRunner.manager.save(legalRep);
                        isModified = true;
                    }
                }
            }

            // --- E. CẬP NHẬT DOCUMENT (File) ---
            if (dto.documents && dto.documents.length > 0) {
                for (const docDto of dto.documents) {
                    let existingDoc = await queryRunner.manager.findOne(PartnerDocument, {
                        where: { partnerId: partner.id, documentType: docDto.documentType },
                    });

                    // Luôn coi là mới nếu chưa có hoặc URL khác
                    const isNewUpload = !existingDoc || existingDoc.documentUrl !== docDto.documentUrl;

                    if (isNewUpload) {
                        if (existingDoc) {
                            // Update cái cũ
                            existingDoc.documentUrl = docDto.documentUrl;
                            existingDoc.isReviewed = false; // [QUAN TRỌNG] Reset flag để Admin biết đường check
                            existingDoc.isValid = true;     // Tạm coi là Valid cho đến khi Admin soi
                            existingDoc.adminFeedback = null;
                            existingDoc.uploadedAt = new Date();
                        } else {
                            // Tạo cái mới
                            existingDoc = queryRunner.manager.create(PartnerDocument, {
                                partnerId: partner.id,
                                documentType: docDto.documentType,
                                documentUrl: docDto.documentUrl,
                                isReviewed: false,
                                isValid: true,
                                uploadedAt: new Date(),
                            });
                        }
                        await queryRunner.manager.save(existingDoc);
                        isModified = true;
                        hasCriticalChange = true; // Upload lại giấy tờ là việc lớn

                        // [CLEANUP] Xóa lỗi cũ của loại document này
                        const docKey = `document_${docDto.documentType}`;
                        if (currentRejection[docKey]) delete currentRejection[docKey];
                    }
                }
            }

            // --- F. TÍNH TOÁN TRẠNG THÁI (Recalculate Status) ---
            if (isModified) {
                // 1. Cập nhật map lỗi vào DB
                const hasFieldErrors = Object.keys(currentRejection).length > 0;
                partner.rejectionDetails = hasFieldErrors ? currentRejection : null;

                // 2. Check lại toàn bộ Document (để xem có cái nào đang INVALID ko)
                const allDocs = await queryRunner.manager.find(PartnerDocument, { where: { partnerId: partner.id } });

                const hasRejectedDocs = allDocs.some(d => d.isReviewed && !d.isValid);

                const requirements = await this.docRequirementRepository.find({
                    where: { businessType: partner.businessType, isRequired: true },
                });
                const docMap = new Map(allDocs.map(d => [d.documentType, d]));
                const isMissingDocs = requirements.some(req => {
                    const doc = docMap.get(req.documentType);
                    return !doc || !doc.documentUrl;
                });

                // 3. Logic chuyển đổi trạng thái
                const isClean = !hasFieldErrors && !hasRejectedDocs;
                const isComplete = !isMissingDocs;

                if (isClean && isComplete) {
                    partner.verificationStatus = PartnerVerificationStatus.PENDING;
                    partner.verificationCompletedAt = null;
                } else {
                    if (partner.verificationStatus === PartnerVerificationStatus.APPROVED && hasCriticalChange) {
                        partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                    }
                }



                await queryRunner.manager.save(partner);
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
            ],
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

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
                isAuthorizedUser: partner.legalRepresentative.isAuthorizedUser,
                authLetterDocUrl: partner.legalRepresentative.authLetterDocUrl,
                phoneNumber: partner.legalRepresentative.phoneNumber,
            },
            verificationStatus: partner.verificationStatus,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }
}
