import {
  Body,
  HttpCode,
  HttpStatus,
  Logger,
  Post,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { Public } from '@/common/decorators/auth/public.decorator';
import { MoMoPaymentService } from './momo-payment.service';
import { MoMoIPNDto } from './dto';

/**
 * Public MoMo IPN endpoint.
 *
 * - Public endpoint (không yêu cầu JWT).
 * - Luôn trả 204 No Content (ACK).
 * - Server-to-server, Flutter KHÔNG gọi.
 *
 * MoMo sẽ POST dữ liệu đến đây khi
 * giao dịch hoàn tất (thành công/thất bại).
 */
@PublicApi('momo')
export class MoMoController {
  private readonly logger = new Logger(MoMoController.name);

  constructor(
    private readonly momoService: MoMoPaymentService,
  ) {}

  @Public()
  @Post('ipn')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'MoMo IPN callback (server-to-server)' })
  @ApiNoContentResponse({ description: 'IPN acknowledged' })
  async handleMoMoIPN(
    @Body() ipn: MoMoIPNDto,
  ): Promise<void> {
    this.logger.log(`MoMo IPN received: ${ipn.orderId}`);
    await this.momoService.handleIPN(ipn);
    // Luôn trả 204 — KHÔNG throw exception
  }
}
