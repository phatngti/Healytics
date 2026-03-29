import { IsOptional, IsString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

// ═══════════════════════════════════════════════
//  1. INPUT DTO — Flutter/Web gửi lên Backend
// ═══════════════════════════════════════════════

/**
 * Client gửi khi user nhấn "Thanh toán MoMo".
 *
 * `POST /v1/user/payments/momo/:bookingId`
 */
export class CreateMoMoPaymentDto {
  /**
   * Loại thanh toán MoMo:
   *
   * - `captureWallet` → Mở ví MoMo (mobile)
   * - `payWithATM`    → Thẻ ATM nội địa
   * - `payWithCC`     → Thẻ quốc tế Visa/MC
   *
   * Mặc định: `captureWallet`
   */
  @ApiPropertyOptional({
    example: 'captureWallet',
    description: 'MoMo request type: captureWallet | payWithATM | payWithCC',
  })
  @IsOptional()
  @IsString()
  requestType?: string;
}

// ═══════════════════════════════════════════════
//  2. REQUEST DTO — Backend gửi lên MoMo API
// ═══════════════════════════════════════════════

/**
 * Body gửi lên MoMo `POST /v2/gateway/api/create`.
 *
 * Backend tự build — client KHÔNG truyền trực tiếp.
 * Sau khi build xong → ký HMAC-SHA256 → gán vào
 * `signature` → rồi mới POST lên MoMo.
 */
export class MoMoPaymentRequestDto {
  /** Mã đối tác MoMo (từ .env) */
  partnerCode: string;

  /** ID duy nhất cho request này (trace/debug) */
  requestId: string;

  /** Số tiền (VND, integer — vd: 500000) */
  amount: number;

  /** Mã booking gửi lên MoMo (không phải DB id) */
  orderId: string;

  /** Mô tả booking hiển thị cho user */
  orderInfo: string;

  /** URL user sẽ quay về sau khi thanh toán */
  redirectUrl: string;

  /** URL MoMo sẽ gọi callback (server-to-server) */
  ipnUrl: string;

  /** Dữ liệu thêm (chứa DB bookingId để truy xuất) */
  extraData: string;

  /** Loại thanh toán: captureWallet / payWithATM / payWithCC */
  requestType: string;

  /** Ngôn ngữ: 'vi' hoặc 'en' */
  lang: string;

  /** Chữ ký HMAC-SHA256 (backend tự tạo) */
  signature?: string;
}

// ═══════════════════════════════════════════════
//  3. RESPONSE DTO — MoMo trả về → Backend →
//     Flutter/Web
// ═══════════════════════════════════════════════

/**
 * Response từ MoMo sau khi tạo payment.
 *
 * Kiểm tra `resultCode`:
 * - `0`   → Thành công, có payUrl/deeplink
 * - khác  → Lỗi, hiển thị `message` cho user
 *
 * Cách dùng trong Flutter/Web:
 * - Mobile    → `deeplink` (mở app MoMo)
 *                  hoặc `payUrl` (WebView)
 * - Web       → redirect `payUrl`
 * - Desktop   → hiển thị `qrCodeUrl` (QR code)
 */
export class MoMoPaymentResponseDto {
  // ── Thông tin chung ──────────────────────

  /** Mã đối tác MoMo */
  partnerCode: string;

  /** ID request (dùng trace/debug) */
  requestId: string;

  /** Mã booking đã gửi */
  orderId: string;

  /** Số tiền thanh toán (VND) */
  amount: number;

  /** Thời gian phản hồi (epoch milliseconds) */
  responseTime: number;

  // ── Kết quả ──────────────────────────────

  /**
   * 0 = thành công, khác = lỗi.
   * Xem chi tiết tại MoMo docs → Result Codes.
   */
  resultCode: number;

  /** Mô tả kết quả (tiếng Anh) */
  message: string;

  // ── URLs thanh toán (chỉ có khi resultCode == 0) ─

  /**
   * URL trang thanh toán MoMo.
   *
   * Mobile: mở trong WebView.
   * Web: redirect trực tiếp.
   */
  payUrl?: string;

  /**
   * Deep link mở app MoMo trên điện thoại.
   *
   * Ưu tiên dùng trên mobile (UX tốt hơn WebView).
   * Chỉ có khi `requestType = captureWallet`.
   */
  deeplink?: string;

  /**
   * URL hình QR code.
   *
   * Dùng cho tablet/desktop: hiển thị QR để
   * user quét bằng app MoMo trên điện thoại.
   */
  qrCodeUrl?: string;

  /** Deep link MoMo Mini App (ít dùng) */
  deeplinkMiniApp?: string;

  // ── Metadata ─────────────────────────────

  /** Chữ ký xác thực từ MoMo */
  signature?: string;

  /** Phí user phải trả thêm (thường = 0) */
  userFee?: number;
}
