import { Get, Patch, Param, Query, Body, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiBadRequestResponse,
} from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnerFinanceService } from './partner-finance.service';
import { PartnerFinanceQueryDto } from './dto/query/partner-finance-query.dto';
import { PartnerFinancePageQueryDto } from './dto/query/partner-finance-page-query.dto';
import { MarkSettlementDto } from './dto/request/mark-settlement.dto';
import { FlagReviewDto } from './dto/request/flag-review.dto';
import { PartnerFinanceSummaryDto } from './dto/response/partner-finance-summary.dto';
import { PartnerFinanceTrendPointDto } from './dto/response/partner-finance-trend-point.dto';
import { PartnerTransactionRecordDto } from './dto/response/partner-transaction-record.dto';
import { PartnerTransactionDetailDto } from './dto/response/partner-transaction-detail.dto';
import { PartnerFinancePageMetaDto } from './dto/response/partner-finance-page-meta.dto';

@PartnerApi('transactions')
export class PartnerTransactionsController {
  constructor(private readonly financeService: PartnerFinanceService) {}

  @Get('finance/summary')
  @ApiOperation({ summary: 'Get aggregated finance summary metrics' })
  @ApiOkResponse({ type: PartnerFinanceSummaryDto })
  getSummary(
    @CurrentUser('id') userId: string,
    @Query() query: PartnerFinanceQueryDto,
  ): Promise<PartnerFinanceSummaryDto> {
    return this.financeService.getSummary(userId, query);
  }

  @Get('finance/trend')
  @ApiOperation({ summary: 'Get finance trend data (daily buckets)' })
  @ApiOkResponse({ type: [PartnerFinanceTrendPointDto] })
  getTrend(
    @CurrentUser('id') userId: string,
    @Query() query: PartnerFinanceQueryDto,
  ): Promise<PartnerFinanceTrendPointDto[]> {
    return this.financeService.getTrend(userId, query);
  }

  @Get()
  @ApiOperation({
    summary: 'List partner transactions with filters and pagination',
  })
  @ApiOkResponse({ description: 'Paginated transaction list' })
  getTransactions(
    @CurrentUser('id') userId: string,
    @Query() query: PartnerFinancePageQueryDto,
  ): Promise<{
    data: PartnerTransactionRecordDto[];
    meta: PartnerFinancePageMetaDto;
  }> {
    return this.financeService.listTransactions(userId, query);
  }

  @Get(':transactionId')
  @ApiOperation({
    summary: 'Get transaction detail with payout and refund cases',
  })
  @ApiOkResponse({ type: PartnerTransactionDetailDto })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  getTransactionDetail(
    @CurrentUser('id') userId: string,
    @Param('transactionId', ParseUUIDPipe) transactionId: string,
  ): Promise<PartnerTransactionDetailDto> {
    return this.financeService.getTransactionDetail(userId, transactionId);
  }

  @Patch(':transactionId/settlement')
  @ApiOperation({ summary: 'Mark transaction settlement status' })
  @ApiOkResponse({ type: PartnerTransactionRecordDto })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  @ApiBadRequestResponse({ description: 'Invalid settlement transition' })
  markSettled(
    @CurrentUser('id') userId: string,
    @Param('transactionId', ParseUUIDPipe) transactionId: string,
    @Body() dto: MarkSettlementDto,
  ): Promise<PartnerTransactionRecordDto> {
    return this.financeService.markSettled(userId, transactionId, dto);
  }

  @Patch(':transactionId/review-flag')
  @ApiOperation({ summary: 'Flag or unflag transaction for review' })
  @ApiOkResponse({ type: PartnerTransactionRecordDto })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  flagForReview(
    @CurrentUser('id') userId: string,
    @Param('transactionId', ParseUUIDPipe) transactionId: string,
    @Body() dto: FlagReviewDto,
  ): Promise<PartnerTransactionRecordDto> {
    return this.financeService.flagReview(userId, transactionId, dto);
  }
}
