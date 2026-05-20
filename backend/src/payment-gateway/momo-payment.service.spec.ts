import { ArgumentMetadata, ValidationPipe } from '@nestjs/common';
import {
  signHmacSha256,
  createPaymentRawSignature,
  createRefundRawSignature,
  verifyIPNSignature,
} from './utils/momo.security';
import { MoMoIPNDto } from './dto';

/**
 * Unit tests cho MoMo Security Utility.
 *
 * Kiểm tra:
 * - HMAC-SHA256 signing tạo đúng output.
 * - Raw signature string đúng thứ tự alphabetical.
 * - IPN verification chấp nhận chữ ký hợp lệ
 *   và từ chối chữ ký giả.
 */
describe('MoMo Security Utility', () => {
  const secretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz';
  const accessKey = 'F8BBA842ECF85';

  // ─── signHmacSha256 ──────────────────────

  describe('signHmacSha256', () => {
    it('should produce a 64-char hex string', () => {
      const sig = signHmacSha256('hello', secretKey);
      expect(sig).toHaveLength(64);
      expect(sig).toMatch(/^[0-9a-f]{64}$/);
    });

    it('should produce consistent output for the same input', () => {
      const sig1 = signHmacSha256('test-data', secretKey);
      const sig2 = signHmacSha256('test-data', secretKey);
      expect(sig1).toBe(sig2);
    });

    it('should produce different output for different inputs', () => {
      const sig1 = signHmacSha256('data-a', secretKey);
      const sig2 = signHmacSha256('data-b', secretKey);
      expect(sig1).not.toBe(sig2);
    });
  });

  // ─── createPaymentRawSignature ────────────

  describe('createPaymentRawSignature', () => {
    const paymentData = {
      amount: 500000,
      extraData: 'order-uuid-123',
      ipnUrl: 'http://localhost:3000/momo/ipn',
      orderId: 'ORD-12345678_abc12',
      orderInfo: 'Thanh toan don hang ORD-20260301-A1B2C',
      partnerCode: 'MOMO',
      redirectUrl: 'healytics://payment/momo/success?bookingId=uuid',
      requestId: 'ORD-12345678_abc12_def34',
      requestType: 'captureWallet',
    };

    it('should build raw string in alphabetical order', () => {
      const raw = createPaymentRawSignature(accessKey, paymentData);

      // Verify alphabetical order
      expect(raw).toContain('accessKey=');
      const keys = raw.split('&').map((pair) => pair.split('=')[0]);
      expect(keys).toEqual([
        'accessKey',
        'amount',
        'extraData',
        'ipnUrl',
        'orderId',
        'orderInfo',
        'partnerCode',
        'redirectUrl',
        'requestId',
        'requestType',
      ]);
    });

    it('should include all values correctly', () => {
      const raw = createPaymentRawSignature(accessKey, paymentData);
      expect(raw).toContain(`accessKey=${accessKey}`);
      expect(raw).toContain('amount=500000');
      expect(raw).toContain('partnerCode=MOMO');
      expect(raw).toContain('requestType=captureWallet');
    });
  });

  // ─── createRefundRawSignature ─────────────

  describe('createRefundRawSignature', () => {
    const refundData = {
      amount: 500000,
      description: 'Hoan tien don hang ORD-TEST',
      orderId: 'REFUND-12345678',
      partnerCode: 'MOMO',
      requestId: 'REFUND_1709316000000',
      transId: 987654321,
    };

    it('should build raw string in correct order', () => {
      const raw = createRefundRawSignature(accessKey, refundData);
      const keys = raw.split('&').map((pair) => pair.split('=')[0]);
      expect(keys).toEqual([
        'accessKey',
        'amount',
        'description',
        'orderId',
        'partnerCode',
        'requestId',
        'transId',
      ]);
    });
  });

  // ─── verifyIPNSignature ───────────────────

  describe('verifyIPNSignature', () => {
    /**
     * Mock IPN data — mô phỏng callback
     * MoMo gửi khi user thanh toán thành công.
     */
    const ipnBase = {
      amount: 500000,
      extraData: 'order-uuid-123',
      message: 'Successful.',
      orderId: 'ORD-12345678_abc12',
      orderInfo: 'Thanh toan don hang ORD-TEST',
      orderType: 'momo_wallet',
      partnerCode: 'MOMO',
      payType: 'qr',
      requestId: 'ORD-12345678_abc12_def34',
      responseTime: 1709316000000,
      resultCode: 0,
      transId: 987654321,
    };

    it('should return true for valid signature', () => {
      // 1. Build raw data giống MoMo
      const rawData = [
        `accessKey=${accessKey}`,
        `amount=${ipnBase.amount}`,
        `extraData=${ipnBase.extraData}`,
        `message=${ipnBase.message}`,
        `orderId=${ipnBase.orderId}`,
        `orderInfo=${ipnBase.orderInfo}`,
        `orderType=${ipnBase.orderType}`,
        `partnerCode=${ipnBase.partnerCode}`,
        `payType=${ipnBase.payType}`,
        `requestId=${ipnBase.requestId}`,
        `responseTime=${ipnBase.responseTime}`,
        `resultCode=${ipnBase.resultCode}`,
        `transId=${ipnBase.transId}`,
      ].join('&');

      // 2. Ký bằng cùng secretKey
      const validSig = signHmacSha256(rawData, secretKey);

      // 3. Verify → phải trả true
      const ipn = {
        ...ipnBase,
        signature: validSig,
      };
      expect(verifyIPNSignature(accessKey, secretKey, ipn)).toBe(true);
    });

    it('should return false for tampered signature', () => {
      const ipn = {
        ...ipnBase,
        signature: 'fake-signature-tampered',
      };
      expect(verifyIPNSignature(accessKey, secretKey, ipn)).toBe(false);
    });

    it('should return false when amount is modified', () => {
      // Build raw with original amount
      const rawData = [
        `accessKey=${accessKey}`,
        `amount=${ipnBase.amount}`,
        `extraData=${ipnBase.extraData}`,
        `message=${ipnBase.message}`,
        `orderId=${ipnBase.orderId}`,
        `orderInfo=${ipnBase.orderInfo}`,
        `orderType=${ipnBase.orderType}`,
        `partnerCode=${ipnBase.partnerCode}`,
        `payType=${ipnBase.payType}`,
        `requestId=${ipnBase.requestId}`,
        `responseTime=${ipnBase.responseTime}`,
        `resultCode=${ipnBase.resultCode}`,
        `transId=${ipnBase.transId}`,
      ].join('&');

      const validSig = signHmacSha256(rawData, secretKey);

      // Tamper amount but keep original sig
      const tamperedIPN = {
        ...ipnBase,
        amount: 999999, // ← Bị thay đổi!
        signature: validSig,
      };

      expect(verifyIPNSignature(accessKey, secretKey, tamperedIPN)).toBe(false);
    });
  });
});

describe('MoMoIPNDto validation', () => {
  it('keeps MoMo callback fields when global whitelist validation is enabled', async () => {
    const pipe = new ValidationPipe({ whitelist: true });
    const metadata: ArgumentMetadata = {
      type: 'body',
      metatype: MoMoIPNDto,
      data: '',
    };

    const result = (await pipe.transform(
      {
        partnerCode: 'MOMO',
        orderId: 'BK-46309d24_017d8',
        requestId: 'BK-46309d24_017d8_376ea',
        amount: 299000,
        orderInfo: 'Thanh toan booking 46309d24-fb95-4879-918d-c681bf4d973d',
        orderType: 'momo_wallet',
        transId: 4750512745,
        resultCode: 99,
        message: 'Lỗi không xác định.',
        payType: 'webApp',
        responseTime: 1779184850926,
        extraData: '46309d24-fb95-4879-918d-c681bf4d973d',
        signature:
          'bf733f3204fc0f1b3b361d24d112d80346c0b5c087dcf4063f7131f1ce521f6e',
        unexpectedField: 'should be stripped',
      },
      metadata,
    )) as Record<string, unknown>;

    expect(result.orderId).toBe('BK-46309d24_017d8');
    expect(result.resultCode).toBe(99);
    expect(result.signature).toBe(
      'bf733f3204fc0f1b3b361d24d112d80346c0b5c087dcf4063f7131f1ce521f6e',
    );
    expect(result.unexpectedField).toBeUndefined();
  });
});

// ─── Mock Data Export ────────────────────────

/**
 * Dữ liệu giả (mock data) cho testing.
 *
 * Dùng trong unit test, integration test,
 * hoặc Postman collection.
 */
export const MOCK_MOMO_DATA = {
  /**
   * Mock MoMo Payment Response
   * (trả về khi gọi `/create` thành công)
   */
  paymentResponse: {
    partnerCode: 'MOMO',
    requestId: 'ORD-12345678_abc12_def34',
    orderId: 'ORD-12345678_abc12',
    amount: 500000,
    responseTime: 1709316000000,
    resultCode: 0,
    message: 'Successful.',
    payUrl:
      'https://test-payment.momo.vn/v2/gateway' +
      '/pay?t=TU9NT0JLVU4yMDE4MDUyOXxNT0' +
      '1PX0FUVF8yMDIwMDkyMl8xMTExMTEx',
    deeplink:
      'momo://app?action=payWithApp' +
      '&isScanQR=false&sid=TU9NT0JLVU' +
      '4yMDE4MDUyOXxNT01PX0FUVF8yMD',
    qrCodeUrl:
      'https://test-payment.momo.vn' + '/v2/gateway/qr?sid=TU9NT0JLVU4',
    deeplinkMiniApp: null,
    signature: 'mock-signature-for-testing',
    userFee: 0,
  },

  /** Mock MoMo Payment Response (lỗi) */
  paymentResponseError: {
    partnerCode: 'MOMO',
    requestId: 'ORD-12345678_abc12_def34',
    orderId: 'ORD-12345678_abc12',
    amount: 500000,
    responseTime: 1709316000000,
    resultCode: 11,
    message: 'Access denied.',
    payUrl: null,
    deeplink: null,
    qrCodeUrl: null,
    deeplinkMiniApp: null,
    signature: 'mock-error-signature',
    userFee: 0,
  },

  /** Mock MoMo Refund Response (thành công) */
  refundResponse: {
    partnerCode: 'MOMO',
    orderId: 'REFUND-12345678',
    requestId: 'REFUND_1709316000000',
    amount: 500000,
    transId: 987654321,
    resultCode: 0,
    message: 'Successful.',
    responseTime: 1709316060000,
  },

  /** Mock IPN Request (thanh toán thành công) */
  ipnSuccess: {
    partnerCode: 'MOMO',
    orderId: 'ORD-12345678_abc12',
    requestId: 'ORD-12345678_abc12_def34',
    amount: 500000,
    orderInfo: 'Thanh toan don hang ORD-TEST',
    orderType: 'momo_wallet',
    transId: 987654321,
    resultCode: 0,
    message: 'Successful.',
    responseTime: 1709316000000,
    payType: 'qr',
    extraData: 'order-uuid-123',
    signature: 'will-be-computed-at-runtime',
  },

  /** Mock IPN Request (user từ chối) */
  ipnUserDeclined: {
    partnerCode: 'MOMO',
    orderId: 'ORD-12345678_abc12',
    requestId: 'ORD-12345678_abc12_def34',
    amount: 500000,
    orderInfo: 'Thanh toan don hang ORD-TEST',
    orderType: 'momo_wallet',
    transId: 0,
    resultCode: 1006,
    message: 'Transaction denied by user.',
    responseTime: 1709316000000,
    payType: '',
    extraData: 'order-uuid-123',
    signature: 'will-be-computed-at-runtime',
  },
};
