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
import { GetMyProfileResponseDto } from './dto/response/get-my-profile-response.dto';
import { GetPartnersResponseDto } from './dto/response/get-partners-response.dto';
import { GetPartnerDetailResponseDto } from './dto/response/get-partner-detail-response.dto';
import { GetBusinessTypesResponseDto } from './dto/response/get-business-types-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from './enum/business-type.enum';
import { DocumentType } from './enum/document-type.enum';
import { PartnerDocument } from './entities/partner-document.entity';
import { DocumentStatus } from './enum/document-status.enum';
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
    getBusinessTypes(): GetBusinessTypesResponseDto {
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
                businessEntityId: savedPartner.id,
            });
            await queryRunner.manager.save(legalRep);

            // Automatically create PartnerDocument records for registration documents
            // This ensures they are tracked in the verification system from the start
            const regDocs = [
                {
                    businessEntityId: savedPartner.id,
                    documentType: DocumentType.TAX_CODE,
                    documentKey: dto.partner.taxCode, // Using the tax code string as "key" for verification
                    status: DocumentStatus.PENDING,
                },
                {
                    businessEntityId: savedPartner.id,
                    documentType: DocumentType.IDENTITY_FRONT,
                    documentKey: dto.legalRepresentative.images.frontImgUrl,
                    status: DocumentStatus.PENDING,
                },
                {
                    businessEntityId: savedPartner.id,
                    documentType: DocumentType.IDENTITY_BACK,
                    documentKey: dto.legalRepresentative.images.backImgUrl,
                    status: DocumentStatus.PENDING,
                },
            ];

            // Add authorization letter if provided
            if (dto.legalRepresentative.authorization.authLetterDocUrl) {
                regDocs.push({
                    businessEntityId: savedPartner.id,
                    documentType: DocumentType.AUTHORIZATION_LETTER,
                    documentKey: dto.legalRepresentative.authorization.authLetterDocUrl,
                    status: DocumentStatus.PENDING,
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
            relations: ['province', 'district', 'ward', 'legalRepresentative'],
        });
    }

    /**
     * Get partner's own profile
     */
    async getMyProfile(accountId: string): Promise<GetMyProfileResponseDto> {
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
            address: {
                province: partner.province.name,
                district: partner.district.name,
                ward: partner.ward.name,
                streetAddress: partner.streetAddress,
            },
            legalRepresentative: {
                fullName: partner.legalRepresentative.fullName,
                position: partner.legalRepresentative.position,
                idType: partner.legalRepresentative.idType,
                idNumber: partner.legalRepresentative.idNumber,
            },
            isVerified: partner.isVerified,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }

    /**
     * Update partner's profile
     */
    async updateMyProfile(accountId: string, dto: UpdatePartnerDto): Promise<GetMyProfileResponseDto> {
        const partner = await this.getPartnerByAccountId(accountId);
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Only allow updating street address if not verified
        if (dto.streetAddress && partner.isVerified) {
            throw new BadRequestException(
                'Cannot update address after verification',
            );
        }

        if (dto.brandName) partner.brandName = dto.brandName;
        if (dto.streetAddress) partner.streetAddress = dto.streetAddress;

        await this.partnerRepository.save(partner);
        return this.getMyProfile(accountId);
    }

    /**
     * Get list of partners (Admin)
     */
    async getPartners(query: GetPartnersQueryDto): Promise<GetPartnersResponseDto> {
        const { page = 1, limit = 10, isVerified, search } = query;
        const skip = (page - 1) * limit;

        const queryBuilder = this.partnerRepository
            .createQueryBuilder('partner')
            .leftJoinAndSelect('partner.account', 'account')
            .select([
                'partner.id',
                'partner.taxCode',
                'partner.brandName',
                'partner.businessType',
                'partner.isVerified',
                'partner.createdAt',
                'account.email',
            ]);

        // Filter by verification status
        if (typeof isVerified === 'boolean') {
            queryBuilder.andWhere('partner.isVerified = :isVerified', {
                isVerified,
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
                brandName: b.brandName,
                email: b.account.email,
                businessType: b.businessType,
                isVerified: b.isVerified,
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
    async getPartnerDetail(partnerId: string): Promise<GetPartnerDetailResponseDto> {
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
                province: partner.province.name,
                district: partner.district.name,
                ward: partner.ward.name,
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
            isVerified: partner.isVerified,
            verificationCompletedAt: partner.verificationCompletedAt,
            createdAt: partner.createdAt,
        };
    }
}
