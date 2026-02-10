import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnersService } from './partners.service';
import { PartnersController } from './partners.controller';
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

@Module({
    imports: [
        TypeOrmModule.forFeature([
            Account,
            Partner,
            LegalRepresentative,
            DocumentRequirement,
            PartnerDocument,
            PartnerReviewLog,
        ]),
        LocationsModule,
        S3Module,
        forwardRef(() => AuthModule),
    ],
    controllers: [PartnersController],
    providers: [PartnersService],
    exports: [PartnersService],
})
export class PartnersModule { }
