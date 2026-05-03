/**
 * Action types for payment transaction logs.
 *
 * These represent every gateway interaction that gets
 * recorded in the payment_transaction_logs table.
 */
export enum TransactionAction {
  /** Payment link created via gateway */
  CREATE_PAYMENT = 'CREATE_PAYMENT',

  /** IPN callback received from gateway (before verification) */
  IPN_RECEIVED = 'IPN_RECEIVED',

  /** IPN signature verified successfully */
  IPN_VERIFIED = 'IPN_VERIFIED',

  /** IPN signature verification failed */
  IPN_REJECTED = 'IPN_REJECTED',

  /** Refund request sent to gateway */
  REFUND_REQUESTED = 'REFUND_REQUESTED',

  /** Refund confirmed by gateway */
  REFUND_CONFIRMED = 'REFUND_CONFIRMED',

  /** Webhook event received from gateway (e.g., Stripe) */
  WEBHOOK_RECEIVED = 'WEBHOOK_RECEIVED',

  /** Webhook signature verified successfully */
  WEBHOOK_VERIFIED = 'WEBHOOK_VERIFIED',

  /** Webhook signature verification failed */
  WEBHOOK_REJECTED = 'WEBHOOK_REJECTED',
}
