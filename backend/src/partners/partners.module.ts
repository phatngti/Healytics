import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnersService } from './partners.service';
import {
  PartnersController,
  PartnerSelfController,
} from './partners.controller';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { Account } from '@/common/entities/account.entity';
import { LocationsModule } from '@/locations/locations.module';
import { DocumentRequirement } from '@/common/entities/document-requirement.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { S3Module } from '@/s3/s3.module';
import { AuthModule } from '@/auth/auth.module';
import { AccountModule } from '@/account/account.module';
import { MapboxModule } from '@/mapbox/mapbox.module';
import { RegisterPartnerHandler } from './application/handlers/register-partner.handler';
import { UpdatePartnerProfileHandler } from './application/handlers/update-partner-profile.handler';
import { UpdatePartnerPublicProfileHandler } from './application/handlers/update-partner-public-profile.handler';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Account,
      Partner,
      LegalRepresentative,
      DocumentRequirement,
      PartnerDocument,
      PartnerReviewLog,
      PartnerCertification,
    ]),
    LocationsModule,
    S3Module,
    MapboxModule,
    forwardRef(() => AuthModule),
  ],
  controllers: [PartnersController, PartnerSelfController],
  providers: [
    PartnersService,
    RegisterPartnerHandler,
    UpdatePartnerProfileHandler,
    UpdatePartnerPublicProfileHandler,
  ],
  exports: [PartnersService],
})
export class PartnersModule {}
