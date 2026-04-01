import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminPartnersController } from './controllers/admin-partners.controller';
import { AdminPartnersService } from './services/admin-partners.service';
import { ReviewPartnerHandler } from './application/handlers/review-partner.handler';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { Account } from '@/common/entities/account.entity';
import { AuditModule } from '@/audit/audit.module';
import { PartnersModule } from '@/partners/partners.module';
import { DocumentRequirement } from '@/common/entities/document-requirement.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Partner,
      PartnerDocument,
      Account,
      PartnerReviewLog,
      DocumentRequirement,
    ]),
    AuditModule,
    PartnersModule,
  ],
  controllers: [AdminPartnersController],
  providers: [
    AdminPartnersService,
    ReviewPartnerHandler, // ← handler registered
  ],
  exports: [AdminPartnersService],
})
export class AdminModule {}
