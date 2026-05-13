import {
  Body,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
} from '@nestjs/swagger';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import {
  AdminFinanceService,
  AdminFinanceActor,
} from './admin-finance.service';
import { AdminFinanceApi } from './decorators/admin-finance-api.decorator';
import {
  AdminFinanceCreateExportDto,
  AdminFinanceCreateNoteDto,
  AdminFinanceNoteActionDto,
  AdminFinanceRequiredNoteActionDto,
  AdminFinanceReviewFlagActionDto,
  AdminFinanceSettlementActionDto,
} from './dto/admin-finance-action.dto';
import { AdminFinanceQueryDto } from './dto/admin-finance-query.dto';
import {
  AdminFinanceAlertDto,
  AdminFinanceExportJobDto,
  AdminFinanceOverviewDto,
  AdminFinancePartnerExposureDto,
  AdminFinancePayoutDetailDto,
  AdminFinancePayoutPageDto,
  AdminFinanceReconciliationDetailDto,
  AdminFinanceReconciliationPageDto,
  AdminFinanceRefundCaseDetailDto,
  AdminFinanceRefundCasePageDto,
  AdminFinanceTransactionDetailDto,
  AdminFinanceTransactionPageDto,
  AdminFinanceTransactionRecordDto,
  AdminFinanceTrendPointDto,
  AdminFinanceNoteDto,
} from './dto/admin-finance-response.dto';

@AdminFinanceApi()
export class AdminFinanceController {
  constructor(private readonly service: AdminFinanceService) {}

  @Get('summary')
  @ApiOperation({ summary: 'Get platform-wide admin finance summary metrics' })
  @ApiOkResponse({ type: AdminFinanceOverviewDto })
  getSummary(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceOverviewDto> {
    return this.service.getSummary(query);
  }

  @Get('trend')
  @ApiOperation({ summary: 'Get platform-wide finance trend data' })
  @ApiOkResponse({ type: [AdminFinanceTrendPointDto] })
  getTrend(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceTrendPointDto[]> {
    return this.service.getTrend(query);
  }

  @Get('alerts')
  @ApiOperation({ summary: 'Get derived operational finance alerts' })
  @ApiOkResponse({ type: [AdminFinanceAlertDto] })
  getAlerts(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceAlertDto[]> {
    return this.service.getAlerts(query);
  }

  @Get('transactions')
  @ApiOperation({ summary: 'List platform ledger transactions' })
  @ApiOkResponse({ type: AdminFinanceTransactionPageDto })
  getTransactions(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceTransactionPageDto> {
    return this.service.listTransactions(query);
  }

  @Get('transactions/:id')
  @ApiOperation({ summary: 'Get platform ledger transaction detail' })
  @ApiOkResponse({ type: AdminFinanceTransactionDetailDto })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  getTransactionDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AdminFinanceTransactionDetailDto> {
    return this.service.getTransactionDetail(id);
  }

  @Patch('transactions/:id/settlement')
  @ApiOperation({
    summary: 'Mark transaction settlement status with an admin note',
  })
  @ApiOkResponse({ type: AdminFinanceTransactionRecordDto })
  @ApiBadRequestResponse({
    description: 'Invalid settlement transition or missing note',
  })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  markSettlement(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceSettlementActionDto,
  ): Promise<AdminFinanceTransactionRecordDto> {
    return this.service.markSettlement(actor, id, dto);
  }

  @Patch('transactions/:id/review-flag')
  @ApiOperation({ summary: 'Flag or unflag a transaction for finance review' })
  @ApiOkResponse({ type: AdminFinanceTransactionRecordDto })
  @ApiNotFoundResponse({ description: 'Transaction not found' })
  flagTransaction(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceReviewFlagActionDto,
  ): Promise<AdminFinanceTransactionRecordDto> {
    return this.service.flagTransaction(actor, id, dto);
  }

  @Get('payouts')
  @ApiOperation({ summary: 'List platform payouts' })
  @ApiOkResponse({ type: AdminFinancePayoutPageDto })
  getPayouts(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinancePayoutPageDto> {
    return this.service.listPayouts(query);
  }

  @Get('payouts/:id')
  @ApiOperation({ summary: 'Get payout detail' })
  @ApiOkResponse({ type: AdminFinancePayoutDetailDto })
  @ApiNotFoundResponse({ description: 'Payout not found' })
  getPayoutDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AdminFinancePayoutDetailDto> {
    return this.service.getPayoutDetail(id);
  }

  @Post('payouts/:id/retry')
  @ApiOperation({ summary: 'Retry a failed or held payout' })
  @ApiOkResponse({ type: AdminFinancePayoutDetailDto })
  retryPayout(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    return this.service.retryPayout(actor, id, dto);
  }

  @Post('payouts/:id/hold')
  @ApiOperation({ summary: 'Place an admin hold on a payout' })
  @ApiOkResponse({ type: AdminFinancePayoutDetailDto })
  holdPayout(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    return this.service.holdPayout(actor, id, dto);
  }

  @Post('payouts/:id/release-hold')
  @ApiOperation({ summary: 'Release an admin hold from a payout' })
  @ApiOkResponse({ type: AdminFinancePayoutDetailDto })
  releasePayoutHold(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinancePayoutDetailDto> {
    return this.service.releasePayoutHold(actor, id, dto);
  }

  @Get('refund-cases')
  @ApiOperation({ summary: 'List platform refund and dispute cases' })
  @ApiOkResponse({ type: AdminFinanceRefundCasePageDto })
  getRefundCases(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceRefundCasePageDto> {
    return this.service.listRefundCases(query);
  }

  @Get('refund-cases/:id')
  @ApiOperation({ summary: 'Get refund or dispute case detail' })
  @ApiOkResponse({ type: AdminFinanceRefundCaseDetailDto })
  @ApiNotFoundResponse({ description: 'Refund case not found' })
  getRefundCaseDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    return this.service.getRefundCaseDetail(id);
  }

  @Post('refund-cases/:id/approve')
  @ApiOperation({ summary: 'Approve a refund or dispute case' })
  @ApiOkResponse({ type: AdminFinanceRefundCaseDetailDto })
  approveRefundCase(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    return this.service.approveRefundCase(actor, id, dto);
  }

  @Post('refund-cases/:id/reject')
  @ApiOperation({ summary: 'Reject a refund or dispute case' })
  @ApiOkResponse({ type: AdminFinanceRefundCaseDetailDto })
  rejectRefundCase(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinanceRefundCaseDetailDto> {
    return this.service.rejectRefundCase(actor, id, dto);
  }

  @Get('reconciliation')
  @ApiOperation({ summary: 'List reconciliation exceptions' })
  @ApiOkResponse({ type: AdminFinanceReconciliationPageDto })
  getReconciliation(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinanceReconciliationPageDto> {
    return this.service.listReconciliation(query);
  }

  @Get('reconciliation/:id')
  @ApiOperation({ summary: 'Get reconciliation exception detail' })
  @ApiOkResponse({ type: AdminFinanceReconciliationDetailDto })
  @ApiNotFoundResponse({ description: 'Reconciliation exception not found' })
  getReconciliationDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    return this.service.getReconciliationDetail(id);
  }

  @Post('reconciliation/:id/resolve')
  @ApiOperation({ summary: 'Resolve a reconciliation exception' })
  @ApiOkResponse({ type: AdminFinanceReconciliationDetailDto })
  resolveReconciliation(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceRequiredNoteActionDto,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    return this.service.resolveReconciliation(actor, id, dto);
  }

  @Post('reconciliation/:id/reopen')
  @ApiOperation({ summary: 'Reopen a reconciliation exception' })
  @ApiOkResponse({ type: AdminFinanceReconciliationDetailDto })
  reopenReconciliation(
    @CurrentUser() actor: AdminFinanceActor,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AdminFinanceNoteActionDto,
  ): Promise<AdminFinanceReconciliationDetailDto> {
    return this.service.reopenReconciliation(actor, id, dto);
  }

  @Get('partner-exposure')
  @ApiOperation({ summary: 'Rank partner financial exposure' })
  @ApiOkResponse({ type: [AdminFinancePartnerExposureDto] })
  getPartnerExposure(
    @Query() query: AdminFinanceQueryDto,
  ): Promise<AdminFinancePartnerExposureDto[]> {
    return this.service.getPartnerExposure(query);
  }

  @Get('exports')
  @ApiOperation({ summary: 'List finance export jobs' })
  @ApiOkResponse({ type: [AdminFinanceExportJobDto] })
  getExports(): Promise<AdminFinanceExportJobDto[]> {
    return this.service.getExports();
  }

  @Post('exports')
  @ApiOperation({ summary: 'Create a finance export job' })
  @ApiCreatedResponse({ type: AdminFinanceExportJobDto })
  createExport(
    @CurrentUser() actor: AdminFinanceActor,
    @Body() dto: AdminFinanceCreateExportDto,
  ): Promise<AdminFinanceExportJobDto> {
    return this.service.createExport(actor, dto);
  }

  @Post('notes')
  @ApiOperation({ summary: 'Add a note to a finance entity' })
  @ApiCreatedResponse({ type: AdminFinanceNoteDto })
  addNote(
    @CurrentUser() actor: AdminFinanceActor,
    @Body() dto: AdminFinanceCreateNoteDto,
  ): Promise<AdminFinanceNoteDto> {
    return this.service.addNote(actor, dto);
  }
}
