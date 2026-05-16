export enum AdminFinancePeriod {
  SEVEN_DAYS = 'sevenDays',
  THIRTY_DAYS = 'thirtyDays',
  NINETY_DAYS = 'ninetyDays',
  THIS_MONTH = 'thisMonth',
  LAST_MONTH = 'lastMonth',
  CUSTOM = 'custom',
}

export enum AdminFinanceProvider {
  STRIPE = 'stripe',
  MOMO = 'momo',
  VNPAY = 'vnpay',
  BANK_TRANSFER = 'bankTransfer',
  MANUAL = 'manual',
}

export enum AdminFinanceRiskTone {
  NEUTRAL = 'neutral',
  POSITIVE = 'positive',
  WARNING = 'warning',
  CRITICAL = 'critical',
}

export enum AdminFinanceReconciliationStatus {
  OPEN = 'open',
  UNDER_REVIEW = 'underReview',
  RESOLVED = 'resolved',
  REOPENED = 'reopened',
}

export enum AdminFinanceReconciliationType {
  MISSING_PROVIDER_EVENT = 'missingProviderEvent',
  MISSING_LEDGER_RECORD = 'missingLedgerRecord',
  AMOUNT_MISMATCH = 'amountMismatch',
  CURRENCY_MISMATCH = 'currencyMismatch',
  DUPLICATE_PROVIDER_EVENT = 'duplicateProviderEvent',
  PAYOUT_MISMATCH = 'payoutMismatch',
  REFUND_MISMATCH = 'refundMismatch',
  STALE_PENDING_PAYMENT = 'stalePendingPayment',
}

export enum AdminFinanceExportStatus {
  QUEUED = 'queued',
  PROCESSING = 'processing',
  READY = 'ready',
  FAILED = 'failed',
  EXPIRED = 'expired',
}

export enum AdminFinanceExportType {
  TRANSACTIONS = 'transactions',
  PAYOUTS = 'payouts',
  REFUND_CASES = 'refundCases',
  RECONCILIATION = 'reconciliation',
  PARTNER_EXPOSURE = 'partnerExposure',
  MONTHLY_SUMMARY = 'monthlySummary',
}

export enum AdminFinanceNoteEntityType {
  TRANSACTION = 'transaction',
  PAYOUT = 'payout',
  REFUND_CASE = 'refundCase',
  RECONCILIATION = 'reconciliation',
}
