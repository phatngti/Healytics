import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { AdminPartnersController } from './controllers/admin-partners.controller';
import { AdminDashboardController } from './dashboard/admin-dashboard.controller';
import { AdminDashboardService } from './dashboard/admin-dashboard.service';
import { AdminFinanceController } from './finance/admin-finance.controller';
import { AdminFinanceService } from './finance/admin-finance.service';
import { ReconciliationJobService } from './finance/reconciliation-job.service';
import { AdminPartnersService } from './services/admin-partners.service';
import { ReviewPartnerHandler } from './application/handlers/review-partner.handler';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { Account } from '@/common/entities/account.entity';
import { AuditModule } from '@/audit/audit.module';
import { PartnersModule } from '@/partners/partners.module';
import { DocumentRequirement } from '@/common/entities/document-requirement.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { AdminFinanceExportJob } from '@/common/entities/admin-finance-export-job.entity';
import { AdminFinanceNote } from '@/common/entities/admin-finance-note.entity';
import { AdminFinanceReconciliationException } from '@/common/entities/admin-finance-reconciliation-exception.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayoutAttempt } from '@/common/entities/partner-payout-attempt.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    TypeOrmModule.forFeature([
      Partner,
      PartnerDocument,
      Account,
      PartnerReviewLog,
      DocumentRequirement,
      PartnerLedgerTransaction,
      PartnerPayout,
      PartnerPayoutTransaction,
      PartnerPayoutAttempt,
      PartnerRefundCase,
      PartnerTransactionTimeline,
      AdminFinanceNote,
      AdminFinanceReconciliationException,
      AdminFinanceExportJob,
    ]),
    AuditModule,
    PartnersModule,
  ],
  controllers: [
    AdminPartnersController,
    AdminDashboardController,
    AdminFinanceController,
  ],
  providers: [
    AdminPartnersService,
    AdminDashboardService,
    AdminFinanceService,
    ReconciliationJobService,
    ReviewPartnerHandler, // ← handler registered
  ],
  exports: [AdminPartnersService],
})
export class AdminModule {}
