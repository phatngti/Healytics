import { Get, Post, Param, Query, Body, ParseUUIDPipe } from '@nestjs/common';
import { ApiOperation, ApiOkResponse, ApiNotFoundResponse } from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnerFinanceService } from './partner-finance.service';
import { PartnerFinancePageQueryDto } from './dto/query/partner-finance-page-query.dto';
import { RetryPayoutDto } from './dto/request/retry-payout.dto';
import { PartnerPayoutRecordDto } from './dto/response/partner-payout-record.dto';
import { PartnerFinancePageMetaDto } from './dto/response/partner-finance-page-meta.dto';

@PartnerApi('payouts')
export class PartnerPayoutsController {
  constructor(private readonly financeService: PartnerFinanceService) {}

  @Get()
  @ApiOperation({ summary: 'List partner payouts with filters and pagination' })
  @ApiOkResponse({ description: 'Paginated payout list' })
  getPayouts(
    @CurrentUser('id') userId: string,
    @Query() query: PartnerFinancePageQueryDto,
  ): Promise<{ data: PartnerPayoutRecordDto[]; meta: PartnerFinancePageMetaDto }> {
    return this.financeService.listPayouts(userId, query);
  }

  @Post(':payoutId/retry')
  @ApiOperation({ summary: 'Retry a failed payout' })
  @ApiOkResponse({ type: PartnerPayoutRecordDto })
  @ApiNotFoundResponse({ description: 'Payout not found' })
  retryPayout(
    @CurrentUser('id') userId: string,
    @Param('payoutId', ParseUUIDPipe) payoutId: string,
    @Body() dto: RetryPayoutDto,
  ): Promise<PartnerPayoutRecordDto> {
    return this.financeService.retryPayout(userId, payoutId, dto);
  }
}
