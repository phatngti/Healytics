import {
  Injectable,
  Logger,
  ConflictException,
  BadRequestException,
  InternalServerErrorException,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import {
  PartnerDocument,
  PartnerDocumentStatuses,
} from '@/common/entities/partner-document.entity';
import { Location } from '@/common/entities/location.entity';
import { RegisterPartnerDto } from '../../dto/request/register-partner.dto';
import { RegisterPartnerResponseDto } from '../../dto/response/register-partner-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from '../../enum/business-type.enum';
import { LocationsService } from '@/locations/locations.service';
import { AuthService } from '@/auth/auth.service';
import { MapboxService } from '@/mapbox/mapbox.service';

/**
 * Handler for partner registration.
 * Follows the domain handler pattern with transactional boundaries.
 *
 * Flow:
 * 1. Invariant checks (duplicate email, tax code, address validation)
 * 2. Geocode facility address via Mapbox API (non-blocking)
 * 3. Create Account, Partner, LegalRepresentative, PartnerDocuments
 * 4. Commit transaction
 * 5. Post-commit: generate auth tokens
 */
@Injectable()
export class RegisterPartnerHandler {
  private readonly logger = new Logger(RegisterPartnerHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly locationsService: LocationsService,
    private readonly mapboxService: MapboxService,
    @Inject(forwardRef(() => AuthService))
    private readonly authService: AuthService,
  ) {}

  async execute(dto: RegisterPartnerDto): Promise<RegisterPartnerResponseDto> {
    this.logger.log(`Registering partner with email: ${dto.account.email}`);

    // 1. Pre-transaction invariant checks (read-only, no lock needed)
    const accountRepo = this.dataSource.getRepository(Account);
    const partnerRepo = this.dataSource.getRepository(Partner);

    const existingAccount = await accountRepo.findOne({
      where: [{ email: dto.account.email }],
    });

    if (existingAccount) {
      throw new ConflictException('An account with this email already exists');
    }

    const existingPartner = await partnerRepo.findOne({
      where: { taxCode: dto.partner.taxCode },
    });

    if (existingPartner) {
      throw new ConflictException(
        'A business with this tax code is already registered',
      );
    }

    try {
      await this.locationsService.validateAddress(
        dto.partner.provinceId,
        dto.partner.districtId,
        dto.partner.wardId,
      );
    } catch (error) {
      throw new BadRequestException(`Invalid address: ${error.message}`);
    }

    // 2. Geocode facility address (non-blocking — failure does NOT stop registration)
    let coordinates: string | null = null;
    let locationSql: string | null = null;

    try {
      const fullAddress = await this.buildFullAddress(dto);
      this.logger.log(`Geocoding partner address: ${fullAddress}`);

      const geoResult = await this.mapboxService.geocode(fullAddress);

      if (geoResult.results.length > 0) {
        const lat = geoResult.results[0].lat;
        const lng = geoResult.results[0].lng;
        coordinates = `${lat},${lng}`;
        locationSql = `ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)::geography`;
        this.logger.log(`Geocoded: ${coordinates}`);
      } else {
        this.logger.warn(`Geocoding returned no results for: ${fullAddress}`);
      }
    } catch (error) {
      this.logger.warn(`Geocoding failed (non-blocking): ${error.message}`);
      // Continue registration without geo — coordinates will be null
    }

    // 3. Transaction: create all entities
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Create Account
      const passwordHash = await bcrypt.hash(dto.account.password, 10);
      const account = queryRunner.manager.create(Account, {
        email: dto.account.email,
        passwordHash,
        role: Role.HEALTH_PARTNER,
        isActive: true,
      });
      const savedAccount = await queryRunner.manager.save(account);

      // Create Partner (with geocoded coordinates)
      const partner = queryRunner.manager.create(Partner, {
        taxCode: dto.partner.taxCode,
        legalName: dto.partner.legalName,
        brandName: dto.partner.brandName,
        businessType: dto.partner.businessType,
        provinceId: dto.partner.provinceId,
        districtId: dto.partner.districtId,
        wardId: dto.partner.wardId,
        streetAddress: dto.partner.streetAddress,
        coordinates,
        phoneNumber: dto.partner.phoneNumber || null,
        accountId: savedAccount.id,
      });
      const savedPartner = await queryRunner.manager.save(partner);

      // Set PostGIS location column via raw SQL (TypeORM doesn't support geography writes natively)
      if (locationSql) {
        await queryRunner.query(
          `UPDATE health_partner_profile SET location = ${locationSql} WHERE id = $1`,
          [savedPartner.id],
        );
      }

      // Create Legal Representative
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
      dto.legalRepresentative.documents.forEach((doc) => {
        documentsToCreate.push(
          ...doc.urls.map((url) => ({
            partnerId: savedPartner.id,
            fileUrl: url,
            type: doc.type,
            fileType: doc.fileType,
            documentKey: doc.documentKey,
            status: PartnerDocumentStatuses.ACCEPTED,
          })),
        );
      });

      if (documentsToCreate.length > 0) {
        const documents = documentsToCreate.map((doc) =>
          queryRunner.manager.create(PartnerDocument, doc),
        );
        await queryRunner.manager.save(documents);
      }

      // 4. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Partner registered successfully: ${savedPartner.id}`);

      // 5. Post-commit: generate auth tokens
      const tokens = await this.authService.createTokensForUser(
        savedAccount.id,
        savedAccount.email,
        savedAccount.role,
      );

      return {
        accountId: savedAccount.id,
        businessEntityId: savedPartner.id,
        status: 'success',
        message: 'Partner registration successful',
        ...tokens,
      };
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Partner registration failed: ${error.message}`,
        error.stack,
      );

      if (
        error instanceof ConflictException ||
        error instanceof BadRequestException
      ) {
        throw error;
      }
      throw new InternalServerErrorException(
        'Transaction failed during partner registration',
      );
    } finally {
      await queryRunner.release();
    }
  }

  /**
   * Compose full address from location tree + street address for geocoding.
   * Format: "{streetAddress}, {ward.fullName}, {district.fullName}, {province.fullName}, Vietnam"
   */
  private async buildFullAddress(dto: RegisterPartnerDto): Promise<string> {
    const locationRepo = this.dataSource.getRepository(Location);

    const [ward, district, province] = await Promise.all([
      locationRepo.findOne({ where: { id: dto.partner.wardId } }),
      locationRepo.findOne({ where: { id: dto.partner.districtId } }),
      locationRepo.findOne({ where: { id: dto.partner.provinceId } }),
    ]);

    const parts = [
      dto.partner.streetAddress,
      ward?.fullName,
      district?.fullName,
      province?.fullName,
      'Vietnam',
    ].filter(Boolean);

    return parts.join(', ');
  }
}
