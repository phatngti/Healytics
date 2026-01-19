import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnersService } from './partners.service';
import { PartnersController } from './partners.controller';
import { DocumentsService } from './documents.service';
import { DocumentsController } from './documents.controller';
import { Partner } from './entities/partner.entity';
import { LegalRepresentative } from './entities/legal-representative.entity';
import { Account } from '@/account/entities/account.entity';
import { LocationsModule } from '@/locations/locations.module';
import { DocumentRequirement } from './entities/document-requirement.entity';
import { PartnerDocument } from './entities/partner-document.entity';
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
        ]),
        LocationsModule,
        S3Module,
        forwardRef(() => AuthModule),
    ],
    controllers: [PartnersController, DocumentsController],
    providers: [PartnersService, DocumentsService],
    exports: [PartnersService, DocumentsService],
})
export class PartnersModule { }
