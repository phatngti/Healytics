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

            // Automatically create PartnerDocument records for registration documents
            // This ensures they are tracked in the verification system from the start
            // Note: TAX_CODE is now strictly a data field on Partner, not tracked as a document
            const regDocs = [
                {
                    partnerId: savedPartner.id,
                    documentType: DocumentType.IDENTITY_FRONT,
                    documentUrl: dto.legalRepresentative.images.frontImgUrl,
                    documentKey: null,
                    isReviewed: false,
                    isValid: true, // Optimistic validation
                },
                {
                    partnerId: savedPartner.id,
                    documentType: DocumentType.IDENTITY_BACK,
                    documentUrl: dto.legalRepresentative.images.backImgUrl,
                    documentKey: null,
                    isReviewed: false,
                    isValid: true, // Optimistic validation
                },
            ];

            // Add authorization letter if provided
            if (dto.legalRepresentative.authorization.authLetterDocUrl) {
                regDocs.push({
                    partnerId: savedPartner.id,
                    documentType: DocumentType.AUTHORIZATION_LETTER,
                    documentUrl: dto.legalRepresentative.authorization.authLetterDocUrl,
                    documentKey: null,
                    isReviewed: false,
                    isValid: true, // Optimistic validation
                });
            }

            const partnerDocs = regDocs.map(d => queryRunner.manager.create(PartnerDocument, d));
            await queryRunner.manager.save(PartnerDocument, partnerDocs);

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

        return {
            id: partner.id,
            taxCode: partner.taxCode,
            legalName: partner.legalName,
            brandName: partner.brandName,
            businessType: partner.businessType,
            phoneNumber: partner.phoneNumber || null,
            address: {
                province: partner.province?.name ?? '',
                district: partner.district?.name ?? '',
                ward: partner.ward?.name ?? '',
                streetAddress: partner.streetAddress,
            },
            legalRepresentative: {
                fullName: partner.legalRepresentative.fullName,
                position: partner.legalRepresentative.position,
                idType: partner.legalRepresentative.idType,
                idNumber: partner.legalRepresentative.idNumber,
            },
            verificationStatus: partner.verificationStatus,
            rejectionDetails: partner.rejectionDetails || null,
            documents: (partner as any).documents?.map((doc: any) => ({
                id: doc.id,
                documentType: doc.documentType,
                documentUrl: doc.documentUrl,
                isReviewed: doc.isReviewed,
                isValid: doc.isValid,
                adminFeedback: doc.adminFeedback,
            })) || [],
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }

    /**
     * Update partner's profile - with document sync and verification reset
     * 
     * IMPORTANT FIXES:
     * 1. Syncs CCCD/Authorization images to PartnerDocument table
     * 2. Resets verificationStatus to PENDING when important fields change
     */
    async updateMyProfile(accountId: string, dto: UpdatePartnerDto): Promise<MyProfileResponseDto> {
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        const queryRunner = this.dataSource.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            let shouldResetVerification = false; // Flag to check if we need to reset to PENDING

            // 1. Validate and update address if any address field is provided
            const addressFieldsProvided = dto.provinceId || dto.districtId || dto.wardId;
            if (addressFieldsProvided) {
                const provinceId = dto.provinceId || partner.provinceId;
                const districtId = dto.districtId || partner.districtId;
                const wardId = dto.wardId || partner.wardId;

                if (provinceId && districtId && wardId) {
                    try {
                        await this.locationsService.validateAddress(
                            provinceId as string,
                            districtId as string,
                            wardId as string,
                        );
                    } catch (error) {
                        throw new BadRequestException(
                            `Invalid address: ${error.message}`,
                        );
                    }

                    // Check if address actually changed
                    if (partner.provinceId !== provinceId ||
                        partner.districtId !== districtId ||
                        partner.wardId !== wardId) {
                        partner.provinceId = provinceId as string;
                        partner.districtId = districtId as string;
                        partner.wardId = wardId as string;
                        shouldResetVerification = true; // Address change -> needs re-verification
                    }
                }
            }

            // 2. Update partner fields with change detection for important fields
            if (dto.legalName && dto.legalName !== partner.legalName) {
                partner.legalName = dto.legalName;
                shouldResetVerification = true; // Legal name change -> needs re-verification
            }
            if (dto.brandName) partner.brandName = dto.brandName;
            if (dto.phoneNumber) partner.phoneNumber = dto.phoneNumber;
            if (dto.streetAddress && dto.streetAddress !== partner.streetAddress) {
                partner.streetAddress = dto.streetAddress;
                shouldResetVerification = true; // Address change -> needs re-verification
            }

            // Auto-clear rejection details when partner updates a rejected field
            if (partner.rejectionDetails) {
                const fieldsToCheck = ['legalName', 'brandName', 'phoneNumber', 'streetAddress', 'provinceId', 'districtId', 'wardId'];
                for (const field of fieldsToCheck) {
                    if (dto[field as keyof UpdatePartnerDto] !== undefined && partner.rejectionDetails[field]) {
                        delete partner.rejectionDetails[field];
                    }
                }
                if (Object.keys(partner.rejectionDetails).length === 0) {
                    partner.rejectionDetails = null;
                }
            }

            // 3. Reset verification status if important fields changed
            if (shouldResetVerification && partner.verificationStatus !== PartnerVerificationStatus.PENDING) {
                partner.verificationStatus = PartnerVerificationStatus.PENDING;
                partner.verificationCompletedAt = null;
            }

            await queryRunner.manager.save(partner);

            // 4. Update legal representative and SYNC to PartnerDocument
            if (dto.legalRepresentative) {
                const legalRep = await queryRunner.manager.findOne(LegalRepresentative, {
                    where: { partnerId: partner.id },
                });

                if (legalRep) {
                    // Update basic fields
                    if (dto.legalRepresentative.fullName && dto.legalRepresentative.fullName !== legalRep.fullName) {
                        legalRep.fullName = dto.legalRepresentative.fullName;
                        shouldResetVerification = true;
                    }
                    if (dto.legalRepresentative.position) {
                        legalRep.position = dto.legalRepresentative.position;
                    }
                    if (dto.legalRepresentative.phoneNumber) {
                        legalRep.phoneNumber = dto.legalRepresentative.phoneNumber;
                    }
                    if (dto.legalRepresentative.idType) {
                        legalRep.idType = dto.legalRepresentative.idType;
                    }
                    if (dto.legalRepresentative.idNumber && dto.legalRepresentative.idNumber !== legalRep.idNumber) {
                        legalRep.idNumber = dto.legalRepresentative.idNumber;
                        shouldResetVerification = true; // ID number change -> needs re-verification
                    }
                    if (dto.legalRepresentative.idIssueDate) {
                        legalRep.idIssueDate = new Date(dto.legalRepresentative.idIssueDate);
                    }

                    // [CRITICAL FIX] Handle images and SYNC to PartnerDocument
                    if (dto.legalRepresentative.images) {
                        // A. ID Front Image
                        if (dto.legalRepresentative.images.frontImgUrl &&
                            dto.legalRepresentative.images.frontImgUrl !== legalRep.idFrontImgUrl) {
                            legalRep.idFrontImgUrl = dto.legalRepresentative.images.frontImgUrl;

                            // Sync to PartnerDocument
                            const frontDoc = await queryRunner.manager.findOne(PartnerDocument, {
                                where: { partnerId: partner.id, documentType: DocumentType.IDENTITY_FRONT }
                            });
                            if (frontDoc) {
                                frontDoc.documentUrl = dto.legalRepresentative.images.frontImgUrl;
                                frontDoc.isReviewed = false; // Reset review status
                                frontDoc.isValid = true;     // Reset to optimistic
                                frontDoc.adminFeedback = null;
                                await queryRunner.manager.save(frontDoc);
                            }
                            shouldResetVerification = true;
                        }

                        // B. ID Back Image
                        if (dto.legalRepresentative.images.backImgUrl &&
                            dto.legalRepresentative.images.backImgUrl !== legalRep.idBackImgUrl) {
                            legalRep.idBackImgUrl = dto.legalRepresentative.images.backImgUrl;

                            // Sync to PartnerDocument
                            const backDoc = await queryRunner.manager.findOne(PartnerDocument, {
                                where: { partnerId: partner.id, documentType: DocumentType.IDENTITY_BACK }
                            });
                            if (backDoc) {
                                backDoc.documentUrl = dto.legalRepresentative.images.backImgUrl;
                                backDoc.isReviewed = false;
                                backDoc.isValid = true;
                                backDoc.adminFeedback = null;
                                await queryRunner.manager.save(backDoc);
                            }
                            shouldResetVerification = true;
                        }
                    }

                    // Handle authorization
                    if (dto.legalRepresentative.authorization) {
                        if (dto.legalRepresentative.authorization.isAuthorizedUser !== undefined) {
                            legalRep.isAuthorizedUser = dto.legalRepresentative.authorization.isAuthorizedUser;
                        }
                        if (dto.legalRepresentative.authorization.authLetterDocUrl &&
                            dto.legalRepresentative.authorization.authLetterDocUrl !== legalRep.authLetterDocUrl) {
                            legalRep.authLetterDocUrl = dto.legalRepresentative.authorization.authLetterDocUrl;

                            // Sync to PartnerDocument
                            const authDoc = await queryRunner.manager.findOne(PartnerDocument, {
                                where: { partnerId: partner.id, documentType: DocumentType.AUTHORIZATION_LETTER }
                            });
                            if (authDoc) {
                                authDoc.documentUrl = dto.legalRepresentative.authorization.authLetterDocUrl;
                                authDoc.isReviewed = false;
                                authDoc.isValid = true;
                                authDoc.adminFeedback = null;
                                await queryRunner.manager.save(authDoc);
                            }
                            shouldResetVerification = true;
                        }
                    }

                    await queryRunner.manager.save(legalRep);
                }
            }

            // 5. Final check: Reset verification if any important change occurred in step 4
            if (shouldResetVerification && partner.verificationStatus !== PartnerVerificationStatus.PENDING) {
                partner.verificationStatus = PartnerVerificationStatus.PENDING;
                partner.verificationCompletedAt = null;
                await queryRunner.manager.save(partner);
            }

            await queryRunner.commitTransaction();
            return this.getMyProfile(accountId);
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
                province: partner.province?.name ?? '',
                district: partner.district?.name ?? '',
                ward: partner.ward?.name ?? '',
                streetAddress: partner.streetAddress,
            },
            legalRepresentative: {
                fullName: partner.legalRepresentative.fullName,
                position: partner.legalRepresentative.position,
                idType: partner.legalRepresentative.idType,
                idNumber: partner.legalRepresentative.idNumber,
                idIssueDate: partner.legalRepresentative.idIssueDate,
                isAuthorizedUser:
                    partner.legalRepresentative.isAuthorizedUser,
            },
            verificationStatus: partner.verificationStatus,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }
}
