/**
 * Phương thức thanh toán.
 *
 * MOMO   → Thanh toán qua ví MoMo.
 * VNPAY  → Thanh toán qua VNPay.
 * CASH   → Thanh toán tiền mặt tại quầy.
 * STRIPE → Thanh toán qua thẻ quốc tế (Visa/MC) via Stripe.
 */
export enum PaymentMethod {
  MOMO = 'MOMO',
  VNPAY = 'VNPAY',
  CASH = 'CASH',
  STRIPE = 'STRIPE',
}
