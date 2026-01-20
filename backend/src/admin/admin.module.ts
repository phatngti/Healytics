import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminPartnersController } from './controllers/admin-partners.controller';
import { AdminPartnersService } from './services/admin-partners.service';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument } from '@/partners/entities/partner-document.entity';
import { Account } from '@/account/entities/account.entity';
import { AuditModule } from '@/audit/audit.module';
import { PartnersModule } from '@/partners/partners.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Partner, PartnerDocument, Account]),
        AuditModule,
        PartnersModule,
    ],
    controllers: [AdminPartnersController],
    providers: [AdminPartnersService],
    exports: [AdminPartnersService],
})
export class AdminModule { }
