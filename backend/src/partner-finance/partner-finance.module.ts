import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnersModule } from '@/partners/partners.module';
import {
  PartnerLedgerTransaction,
  PartnerTransactionTimeline,
  PartnerPayout,
  PartnerPayoutTransaction,
  PartnerRefundCase,
} from '@/common/entities';

// Controllers
import { PartnerTransactionsController } from './partner-transactions.controller';
import { PartnerPayoutsController } from './partner-payouts.controller';
import { PartnerRefundCasesController } from './partner-refund-cases.controller';

// Service
import { PartnerFinanceService } from './partner-finance.service';

// Read handlers
import { GetFinanceSummaryHandler } from './application/handlers/get-finance-summary.handler';
import { GetFinanceTrendHandler } from './application/handlers/get-finance-trend.handler';
import { ListPartnerTransactionsHandler } from './application/handlers/list-partner-transactions.handler';
import { GetPartnerTransactionDetailHandler } from './application/handlers/get-partner-transaction-detail.handler';
import { ListPartnerPayoutsHandler } from './application/handlers/list-partner-payouts.handler';
import { ListPartnerRefundCasesHandler } from './application/handlers/list-partner-refund-cases.handler';

// Mutation handlers
import { MarkTransactionSettledHandler } from './application/handlers/mark-transaction-settled.handler';
import { FlagTransactionReviewHandler } from './application/handlers/flag-transaction-review.handler';
import { RetryPartnerPayoutHandler } from './application/handlers/retry-partner-payout.handler';
import { ApprovePartnerRefundCaseHandler } from './application/handlers/approve-partner-refund-case.handler';
import { RejectPartnerRefundCaseHandler } from './application/handlers/reject-partner-refund-case.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      PartnerLedgerTransaction,
      PartnerTransactionTimeline,
      PartnerPayout,
      PartnerPayoutTransaction,
      PartnerRefundCase,
    ]),
    PartnersModule,
  ],
  controllers: [
    PartnerTransactionsController,
    PartnerPayoutsController,
    PartnerRefundCasesController,
  ],
  providers: [
    PartnerFinanceService,
    // Read handlers
    GetFinanceSummaryHandler,
    GetFinanceTrendHandler,
    ListPartnerTransactionsHandler,
    GetPartnerTransactionDetailHandler,
    ListPartnerPayoutsHandler,
    ListPartnerRefundCasesHandler,
    // Mutation handlers
    MarkTransactionSettledHandler,
    FlagTransactionReviewHandler,
    RetryPartnerPayoutHandler,
    ApprovePartnerRefundCaseHandler,
    RejectPartnerRefundCaseHandler,
  ],
  exports: [PartnerFinanceService],
})
export class PartnerFinanceModule {}
