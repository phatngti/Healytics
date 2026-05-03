import { Injectable, Logger } from '@nestjs/common';
import { PartnersService } from '@/partners/partners.service';
import { PartnerFinanceQueryDto } from './dto/query/partner-finance-query.dto';
import { PartnerFinancePageQueryDto } from './dto/query/partner-finance-page-query.dto';
import { MarkSettlementDto } from './dto/request/mark-settlement.dto';
import { FlagReviewDto } from './dto/request/flag-review.dto';
import { RetryPayoutDto } from './dto/request/retry-payout.dto';
import { RefundCaseActionDto } from './dto/request/refund-case-action.dto';
import { GetFinanceSummaryHandler } from './application/handlers/get-finance-summary.handler';
import { GetFinanceTrendHandler } from './application/handlers/get-finance-trend.handler';
import { ListPartnerTransactionsHandler } from './application/handlers/list-partner-transactions.handler';
import { GetPartnerTransactionDetailHandler } from './application/handlers/get-partner-transaction-detail.handler';
import { ListPartnerPayoutsHandler } from './application/handlers/list-partner-payouts.handler';
import { ListPartnerRefundCasesHandler } from './application/handlers/list-partner-refund-cases.handler';
import { MarkTransactionSettledHandler } from './application/handlers/mark-transaction-settled.handler';
import { FlagTransactionReviewHandler } from './application/handlers/flag-transaction-review.handler';
import { RetryPartnerPayoutHandler } from './application/handlers/retry-partner-payout.handler';
import { ApprovePartnerRefundCaseHandler } from './application/handlers/approve-partner-refund-case.handler';
import { RejectPartnerRefundCaseHandler } from './application/handlers/reject-partner-refund-case.handler';

@Injectable()
export class PartnerFinanceService {
  private readonly logger = new Logger(PartnerFinanceService.name);

  constructor(
    private readonly partnersService: PartnersService,
    private readonly getFinanceSummaryHandler: GetFinanceSummaryHandler,
    private readonly getFinanceTrendHandler: GetFinanceTrendHandler,
    private readonly listTransactionsHandler: ListPartnerTransactionsHandler,
    private readonly getTransactionDetailHandler: GetPartnerTransactionDetailHandler,
    private readonly listPayoutsHandler: ListPartnerPayoutsHandler,
    private readonly listRefundCasesHandler: ListPartnerRefundCasesHandler,
    private readonly markSettledHandler: MarkTransactionSettledHandler,
    private readonly flagReviewHandler: FlagTransactionReviewHandler,
    private readonly retryPayoutHandler: RetryPartnerPayoutHandler,
    private readonly approveRefundHandler: ApprovePartnerRefundCaseHandler,
    private readonly rejectRefundHandler: RejectPartnerRefundCaseHandler,
  ) {}

  /** Resolves partner ID from the JWT account ID */
  private async resolvePartnerId(accountId: string): Promise<string> {
    const partner = await this.partnersService.getPartnerProfile(accountId);
    return partner.id;
  }

  // ── Queries ──────────────────────────────────────────────────

  async getSummary(accountId: string, query: PartnerFinanceQueryDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getFinanceSummaryHandler.execute(partnerId, query);
  }

  async getTrend(accountId: string, query: PartnerFinanceQueryDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getFinanceTrendHandler.execute(partnerId, query);
  }

  async listTransactions(accountId: string, query: PartnerFinancePageQueryDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.listTransactionsHandler.execute(partnerId, query);
  }

  async getTransactionDetail(accountId: string, transactionId: string) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getTransactionDetailHandler.execute(partnerId, transactionId);
  }

  async listPayouts(accountId: string, query: PartnerFinancePageQueryDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.listPayoutsHandler.execute(partnerId, query);
  }

  async listRefundCases(accountId: string, query: PartnerFinancePageQueryDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.listRefundCasesHandler.execute(partnerId, query);
  }

  // ── Mutations ────────────────────────────────────────────────

  async markSettled(accountId: string, transactionId: string, dto: MarkSettlementDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.markSettledHandler.execute(partnerId, transactionId, accountId, dto);
  }

  async flagReview(accountId: string, transactionId: string, dto: FlagReviewDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.flagReviewHandler.execute(partnerId, transactionId, accountId, dto);
  }

  async retryPayout(accountId: string, payoutId: string, dto: RetryPayoutDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.retryPayoutHandler.execute(partnerId, payoutId, dto);
  }

  async approveRefundCase(accountId: string, caseId: string, dto: RefundCaseActionDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.approveRefundHandler.execute(partnerId, caseId, accountId, dto);
  }

  async rejectRefundCase(accountId: string, caseId: string, dto: RefundCaseActionDto) {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.rejectRefundHandler.execute(partnerId, caseId, accountId, dto);
  }
}
