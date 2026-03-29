/**
 * Trạng thái thanh toán của đơn hàng.
 *
 * UNPAID     → Chưa thanh toán.
 * DEPOSITED  → Đã đặt cọc (booking thường có cọc trước).
 * PAID       → Đã thanh toán đầy đủ.
 * REFUND     → Đã hoàn tiền.
 */
export enum PaymentStatus {
  UNPAID = 'UNPAID',
  DEPOSITED = 'DEPOSITED',
  PAID = 'PAID',
  REFUND = 'REFUND',
}
