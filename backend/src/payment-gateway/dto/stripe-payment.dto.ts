import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

// ═══════════════════════════════════════════════
//  1. INPUT DTO — Flutter/Web gửi lên Backend
// ═══════════════════════════════════════════════

/**
 * Client gửi khi user nhấn "Thanh toán thẻ".
 *
 * `POST /v1/user/payments/stripe/:bookingId`
 *
 * Hiện tại không yêu cầu thêm dữ liệu.
 * Stripe PaymentIntent sẽ được tạo server-side,
 * client nhận `clientSecret` để confirm on-device.
 */
export class CreateStripePaymentDto {
  // Intentionally empty — server derives everything from bookingId.
  // Keep class for future extensibility (e.g., save card for later).
}

// ═══════════════════════════════════════════════
//  2. RESPONSE DTO — Backend trả về Flutter/Web
// ═══════════════════════════════════════════════

/**
 * Response sau khi tạo Stripe PaymentIntent.
 *
 * Flutter dùng `clientSecret` với Stripe SDK
 * để xác nhận thanh toán trực tiếp trên device.
 *
 * ```dart
 * // Flutter usage:
 * final response = await api.post('/payments/stripe/$bookingId');
 * await Stripe.instance.confirmPayment(
 *   paymentIntentClientSecret: response.clientSecret,
 *   data: PaymentMethodParams.card(...),
 * );
 * ```
 */
export class StripePaymentResponseDto {
  @ApiProperty({ type: String, description: 'Stripe PaymentIntent ID' })
  @Expose()
  paymentIntentId: string;

  /**
   * Client secret dùng để confirm payment trên device.
   *
   * KHÔNG được lưu vào DB — chỉ trả về 1 lần.
   * Flutter/Web dùng secret này với Stripe SDK.
   */
  @ApiProperty({
    type: String,
    description: 'Client secret for on-device payment confirmation',
  })
  @Expose()
  clientSecret: string;

  @ApiProperty({
    type: Number,
    description: 'Payment amount in smallest currency unit (VND)',
  })
  @Expose()
  amount: number;

  @ApiProperty({ type: String, description: 'ISO currency code (e.g., vnd)' })
  @Expose()
  currency: string;

  @ApiProperty({
    type: String,
    description: 'Stripe PaymentIntent status',
    example: 'requires_payment_method',
  })
  @Expose()
  status: string;

  static create(params: {
    paymentIntentId: string;
    clientSecret: string;
    amount: number;
    currency: string;
    status: string;
  }): StripePaymentResponseDto {
    const dto = new StripePaymentResponseDto();
    dto.paymentIntentId = params.paymentIntentId;
    dto.clientSecret = params.clientSecret;
    dto.amount = params.amount;
    dto.currency = params.currency;
    dto.status = params.status;
    return dto;
  }
}

// ═══════════════════════════════════════════════
//  3. REFUND RESPONSE DTO
// ═══════════════════════════════════════════════

/**
 * Response sau khi yêu cầu refund qua Stripe.
 */
export class StripeRefundResponseDto {
  @ApiProperty({ type: String, description: 'Stripe Refund ID' })
  @Expose()
  refundId: string;

  @ApiProperty({ type: Number, description: 'Refunded amount (VND)' })
  @Expose()
  amount: number;

  @ApiProperty({ type: String, description: 'ISO currency code' })
  @Expose()
  currency: string;

  @ApiProperty({
    type: String,
    description: 'Refund status',
    example: 'succeeded',
  })
  @Expose()
  status: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Stripe PaymentIntent ID that was refunded',
  })
  @Expose()
  paymentIntentId: string | null;

  static create(params: {
    refundId: string;
    amount: number;
    currency: string;
    status: string;
    paymentIntentId: string | null;
  }): StripeRefundResponseDto {
    const dto = new StripeRefundResponseDto();
    dto.refundId = params.refundId;
    dto.amount = params.amount;
    dto.currency = params.currency;
    dto.status = params.status;
    dto.paymentIntentId = params.paymentIntentId;
    return dto;
  }
}
