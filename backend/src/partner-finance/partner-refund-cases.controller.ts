import { Get, Post, Param, Query, Body, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnerFinanceService } from './partner-finance.service';
import { PartnerFinancePageQueryDto } from './dto/query/partner-finance-page-query.dto';
import { RefundCaseActionDto } from './dto/request/refund-case-action.dto';
import { PartnerRefundCaseRecordDto } from './dto/response/partner-refund-case-record.dto';
import { PartnerFinancePageMetaDto } from './dto/response/partner-finance-page-meta.dto';

@PartnerApi('refund-cases')
export class PartnerRefundCasesController {
  constructor(private readonly financeService: PartnerFinanceService) {}

  @Get()
  @ApiOperation({ summary: 'List refund and dispute cases' })
  @ApiOkResponse({ description: 'Paginated refund case list' })
  getRefundCases(
    @CurrentUser('id') userId: string,
    @Query() query: PartnerFinancePageQueryDto,
  ): Promise<{
    data: PartnerRefundCaseRecordDto[];
    meta: PartnerFinancePageMetaDto;
  }> {
    return this.financeService.listRefundCases(userId, query);
  }

  @Post(':caseId/approve')
  @ApiOperation({ summary: 'Approve a refund or dispute case' })
  @ApiOkResponse({ type: PartnerRefundCaseRecordDto })
  @ApiNotFoundResponse({ description: 'Case not found' })
  approve(
    @CurrentUser('id') userId: string,
    @Param('caseId', ParseUUIDPipe) caseId: string,
    @Body() dto: RefundCaseActionDto,
  ): Promise<PartnerRefundCaseRecordDto> {
    return this.financeService.approveRefundCase(userId, caseId, dto);
  }

  @Post(':caseId/reject')
  @ApiOperation({ summary: 'Reject a refund or dispute case' })
  @ApiOkResponse({ type: PartnerRefundCaseRecordDto })
  @ApiNotFoundResponse({ description: 'Case not found' })
  reject(
    @CurrentUser('id') userId: string,
    @Param('caseId', ParseUUIDPipe) caseId: string,
    @Body() dto: RefundCaseActionDto,
  ): Promise<PartnerRefundCaseRecordDto> {
    return this.financeService.rejectRefundCase(userId, caseId, dto);
  }
}
