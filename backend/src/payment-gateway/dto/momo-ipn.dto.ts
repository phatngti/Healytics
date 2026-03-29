/**
 * DTO cho Instant Payment Notification (IPN)
 * — callback server-to-server từ MoMo.
 *
 * ## Flow IPN:
 * 1. User thanh toán xong trên MoMo.
 * 2. MoMo POST dữ liệu này đến
 *    `POST /v1/momo/ipn` (backend).
 * 3. Backend xác thực `signature` bằng
 *    HMAC-SHA256.
 * 4. Nếu `resultCode == 0` → cập nhật Payment
 *    thành PAID + lưu `transId`.
 * 5. Trả về HTTP 204 No Content (ACK).
 *
 * ## Lưu ý quan trọng:
 * - IPN endpoint PHẢI là public (không auth).
 * - LUÔN trả 204 để MoMo không retry.
 * - PHẢI verify signature trước khi xử lý.
 * - `transId` là ID giao dịch MoMo, cần lưu
 *   vào Payment entity để dùng cho refund.
 *
 * ## Flutter/Web KHÔNG nhận trực tiếp:
 * IPN là server-to-server, client không thấy.
 * Client kiểm tra trạng thái bằng cách:
 *
 * ```dart
 * // Polling sau khi redirect về
 * Timer.periodic(Duration(seconds: 3), (_) async {
 *   final booking = await api.get('/bookings/$bookingId');
 *   if (booking.status == 'CONFIRMED') {
 *     // Thanh toán thành công
 *     stopPolling();
 *     showSuccessScreen();
 *   }
 * });
 * ```
 */
export class MoMoIPNDto {
  // ─── Required fields (signature) ───────────

  /** Mã đối tác MoMo */
  partnerCode: string;

  /** Mã đơn hàng (được gửi trong payment request) */
  orderId: string;

  /** ID request gốc */
  requestId: string;

  /** Số tiền đã thanh toán (VND) */
  amount: number;

  /** Thông tin đơn hàng (đã gửi trong request) */
  orderInfo: string;

  /** Loại đơn hàng (MoMo tự gán) */
  orderType: string;

  /**
   * Mã giao dịch MoMo.
   *
   * → LƯU vào Payment.gatewayTransId.
   * → Cần cho hoàn tiền (refund) sau này.
   */
  transId: number;

  /**
   * Mã kết quả giao dịch:
   * - `0` = Thành công
   * - `1006` = User từ chối thanh toán
   * - `1005` = URL hết hạn
   * - Xem thêm: MoMo Result Code docs
   */
  resultCode: number;

  /** Mô tả kết quả */
  message: string;

  /** Timestamp phản hồi (epoch ms) */
  responseTime: number;

  /** Phương thức thanh toán (vd: `qr`, `napas`) */
  payType: string;

  /** Dữ liệu bổ sung (base64, thường rỗng) */
  extraData: string;

  /** Chữ ký HMAC-SHA256 — backend PHẢI verify */
  signature: string;

  // ─── Optional fields ───────────────────────

  /** ID user MoMo (nếu MoMo cung cấp) */
  partnerUserId?: string;

  /** ID cửa hàng (nếu có multi-store) */
  storeId?: string;

  /** Mô tả kết quả bằng tiếng Việt */
  localMessage?: string;

  /** Option thanh toán chi tiết */
  paymentOption?: string;

  /** Phí user phải trả (thường = 0) */
  userFee?: number;

  /** Thông tin khuyến mãi (nếu có) */
  promotionInfo?: unknown;
}
