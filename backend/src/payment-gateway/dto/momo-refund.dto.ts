import { IsNotEmpty, IsNumber } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Client gửi khi yêu cầu hoàn tiền MoMo.
 *
 * `POST /v1/user/payments/momo/:bookingId/refund`
 */
export class CreateMoMoRefundDto {
  @ApiProperty({
    example: 987654321,
    description: 'MoMo transaction ID from the original payment (required for refund)',
  })
  @IsNumber()
  @IsNotEmpty()
  transId: number;
}

/**
 * Request body gửi lên MoMo `/v2/gateway/api/refund`.
 *
 * Backend tự build, client KHÔNG gửi object này.
 */
export class MoMoRefundRequestDto {
  partnerCode: string;
  requestId: string;
  amount: number;
  orderId: string;
  transId: number;
  description: string;
  lang: string;
  signature?: string;
}

/**
 * Response từ MoMo sau khi gửi yêu cầu hoàn tiền.
 *
 * Endpoint: POST /v1/user/payments/momo/:bookingId/refund
 *
 * Luồng hoàn tiền:
 * 1. Client gọi endpoint trên (cần JWT auth).
 * 2. Backend lấy Booking từ DB và nhận
 *    transId từ request body.
 * 3. Backend ký HMAC-SHA256 rồi gọi MoMo
 *    /v2/gateway/api/refund.
 * 4. MoMo xử lý và trả về response này.
 * 5. Nếu resultCode == 0 → backend tự cập nhật
 *    Payment status + log TransactionAction.REFUND_CONFIRMED.
 *
 * Kết quả (resultCode):
 * - 0    → Hoàn tiền thành công.
 * - 11   → Giao dịch gốc không tồn tại.
 * - 1002 → Giao dịch đã được hoàn trước đó.
 * - 1001 → Giao dịch chưa hoàn tất.
 */
export class MoMoRefundResponseDto {
  /** Mã đối tác MoMo */
  partnerCode: string;

  /** Mã đơn hàng refund */
  orderId: string;

  /** ID request refund — dùng để trace */
  requestId: string;

  /** Số tiền đã hoàn (VND) */
  amount: number;

  /**
   * Mã giao dịch MoMo gốc.
   * Dùng để reference giao dịch đã thanh toán.
   */
  transId: number;

  /**
   * Mã kết quả:
   * - `0` = Hoàn tiền thành công
   * - Khác = Lỗi (xem `message`)
   */
  resultCode: number;

  /** Mô tả kết quả */
  message: string;

  /** Timestamp phản hồi (epoch ms) */
  responseTime: number;
}
