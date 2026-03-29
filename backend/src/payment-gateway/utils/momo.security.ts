import { createHmac } from 'crypto';

/**
 * MoMo Security Utility.
 *
 * Chuyển đổi từ Java `MoMoSecurity.java`.
 * Cung cấp hàm tạo chữ ký HMAC-SHA256 và xác thực
 * IPN callback từ MoMo.
 *
 * ## Cách hoạt động:
 * 1. Ghép các field theo thứ tự A-Z thành raw string.
 * 2. Ký raw string bằng HMAC-SHA256 với secretKey.
 * 3. So sánh chữ ký tạo ra với chữ ký MoMo gửi về.
 */

// ─── Interfaces cho tham số ký ───────────────

/** Dữ liệu cần ký cho Payment request */
export interface PaymentSignatureData {
  readonly amount: number;
  readonly extraData: string;
  readonly ipnUrl: string;
  readonly orderId: string;
  readonly orderInfo: string;
  readonly partnerCode: string;
  readonly redirectUrl: string;
  readonly requestId: string;
  readonly requestType: string;
}

/** Dữ liệu cần ký cho Refund request */
export interface RefundSignatureData {
  readonly amount: number;
  readonly description: string;
  readonly orderId: string;
  readonly partnerCode: string;
  readonly requestId: string;
  readonly transId: number;
}

/** Dữ liệu IPN callback từ MoMo */
export interface IPNSignatureData {
  readonly amount: number;
  readonly extraData: string;
  readonly message: string;
  readonly orderId: string;
  readonly orderInfo: string;
  readonly orderType: string;
  readonly partnerCode: string;
  readonly payType: string;
  readonly requestId: string;
  readonly responseTime: number;
  readonly resultCode: number;
  readonly transId: number;
  readonly signature: string;
}

// ─── Core Functions ──────────────────────────

/**
 * Tạo chữ ký HMAC-SHA256.
 *
 * @param rawSignature - Chuỗi raw data đã ghép
 *   theo thứ tự alphabetical.
 * @param secretKey - Secret Key của MoMo Merchant.
 * @returns Chuỗi chữ ký dạng hex (lowercase).
 *
 * @example
 * ```ts
 * const sig = signHmacSha256(
 *   'accessKey=abc&amount=100000',
 *   'my-secret-key',
 * );
 * // → "3a1f2b..."
 * ```
 */
export function signHmacSha256(
  rawSignature: string,
  secretKey: string,
): string {
  return createHmac('sha256', secretKey)
    .update(rawSignature)
    .digest('hex');
}

/**
 * Tạo raw signature cho Payment request.
 *
 * Thứ tự field (alphabetical): accessKey, amount,
 * extraData, ipnUrl, orderId, orderInfo,
 * partnerCode, redirectUrl, requestId, requestType.
 *
 * @param accessKey - MoMo Merchant Access Key.
 * @param data - Dữ liệu payment request.
 * @returns Raw signature string.
 */
export function createPaymentRawSignature(
  accessKey: string,
  data: PaymentSignatureData,
): string {
  return [
    `accessKey=${accessKey}`,
    `amount=${data.amount}`,
    `extraData=${data.extraData}`,
    `ipnUrl=${data.ipnUrl}`,
    `orderId=${data.orderId}`,
    `orderInfo=${data.orderInfo}`,
    `partnerCode=${data.partnerCode}`,
    `redirectUrl=${data.redirectUrl}`,
    `requestId=${data.requestId}`,
    `requestType=${data.requestType}`,
  ].join('&');
}

/**
 * Tạo raw signature cho Refund request.
 *
 * Thứ tự field (alphabetical): accessKey, amount,
 * description, orderId, partnerCode, requestId,
 * transId.
 *
 * @param accessKey - MoMo Merchant Access Key.
 * @param data - Dữ liệu refund request.
 * @returns Raw signature string.
 */
export function createRefundRawSignature(
  accessKey: string,
  data: RefundSignatureData,
): string {
  return [
    `accessKey=${accessKey}`,
    `amount=${data.amount}`,
    `description=${data.description}`,
    `orderId=${data.orderId}`,
    `partnerCode=${data.partnerCode}`,
    `requestId=${data.requestId}`,
    `transId=${data.transId}`,
  ].join('&');
}

/**
 * Xác thực chữ ký IPN callback từ MoMo.
 *
 * MoMo gửi IPN (server-to-server) khi giao dịch
 * hoàn tất. Backend PHẢI xác thực signature trước
 * khi cập nhật trạng thái đơn hàng.
 *
 * Thứ tự field IPN (alphabetical): accessKey,
 * amount, extraData, message, orderId, orderInfo,
 * orderType, partnerCode, payType, requestId,
 * responseTime, resultCode, transId.
 *
 * @param accessKey - MoMo Merchant Access Key.
 * @param secretKey - MoMo Merchant Secret Key.
 * @param ipn - Dữ liệu IPN từ MoMo.
 * @returns `true` nếu signature hợp lệ.
 */
export function verifyIPNSignature(
  accessKey: string,
  secretKey: string,
  ipn: IPNSignatureData,
): boolean {
  const rawData = [
    `accessKey=${accessKey}`,
    `amount=${ipn.amount}`,
    `extraData=${ipn.extraData}`,
    `message=${ipn.message}`,
    `orderId=${ipn.orderId}`,
    `orderInfo=${ipn.orderInfo}`,
    `orderType=${ipn.orderType}`,
    `partnerCode=${ipn.partnerCode}`,
    `payType=${ipn.payType}`,
    `requestId=${ipn.requestId}`,
    `responseTime=${ipn.responseTime}`,
    `resultCode=${ipn.resultCode}`,
    `transId=${ipn.transId}`,
  ].join('&');

  const generated = signHmacSha256(rawData, secretKey);
  return generated === ipn.signature;
}
