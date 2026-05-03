/// Predefined time periods for the admin finance dashboard.
enum AdminFinancePeriod {
  sevenDays,
  thirtyDays,
  ninetyDays,
  thisMonth,
  lastMonth,
  custom;

  String get label => switch (this) {
    AdminFinancePeriod.sevenDays => '7D',
    AdminFinancePeriod.thirtyDays => '30D',
    AdminFinancePeriod.ninetyDays => '90D',
    AdminFinancePeriod.thisMonth => 'This Month',
    AdminFinancePeriod.lastMonth => 'Last Month',
    AdminFinancePeriod.custom => 'Custom',
  };
}

/// Workspace tabs for the admin finance manager screen.
enum AdminFinanceWorkspaceTab {
  overview,
  ledger,
  payouts,
  refunds,
  reconciliation,
  partnerExposure,
  exports;

  String get label => switch (this) {
    AdminFinanceWorkspaceTab.overview => 'Overview',
    AdminFinanceWorkspaceTab.ledger => 'Ledger',
    AdminFinanceWorkspaceTab.payouts => 'Payouts',
    AdminFinanceWorkspaceTab.refunds => 'Refunds',
    AdminFinanceWorkspaceTab.reconciliation =>
      'Reconciliation',
    AdminFinanceWorkspaceTab.partnerExposure =>
      'Partner Exposure',
    AdminFinanceWorkspaceTab.exports => 'Exports',
  };
}

/// Commerce source type for a transaction.
enum AdminFinanceSourceType {
  serviceBooking,
  productOrder;

  String get label => switch (this) {
    AdminFinanceSourceType.serviceBooking =>
      'Service Booking',
    AdminFinanceSourceType.productOrder =>
      'Product Order',
  };
}

/// Ledger transaction type.
enum AdminFinanceTransactionType {
  charge,
  refund,
  adjustment,
  payout,
  fee;

  String get label => switch (this) {
    AdminFinanceTransactionType.charge => 'Charge',
    AdminFinanceTransactionType.refund => 'Refund',
    AdminFinanceTransactionType.adjustment => 'Adjustment',
    AdminFinanceTransactionType.payout => 'Payout',
    AdminFinanceTransactionType.fee => 'Fee',
  };
}

/// Payment status for a transaction.
enum AdminFinanceTransactionStatus {
  pending,
  paid,
  refunded,
  failed,
  canceled;

  String get label => switch (this) {
    AdminFinanceTransactionStatus.pending => 'Pending',
    AdminFinanceTransactionStatus.paid => 'Paid',
    AdminFinanceTransactionStatus.refunded => 'Refunded',
    AdminFinanceTransactionStatus.failed => 'Failed',
    AdminFinanceTransactionStatus.canceled => 'Canceled',
  };
}

/// Settlement status for a transaction.
enum AdminFinanceSettlementStatus {
  unsettled,
  scheduled,
  settled,
  held;

  String get label => switch (this) {
    AdminFinanceSettlementStatus.unsettled => 'Unsettled',
    AdminFinanceSettlementStatus.scheduled => 'Scheduled',
    AdminFinanceSettlementStatus.settled => 'Settled',
    AdminFinanceSettlementStatus.held => 'Held',
  };
}

/// Payout status for a payout batch.
enum AdminFinancePayoutStatus {
  notAssigned,
  inPayout,
  paidOut,
  failed,
  held;

  String get label => switch (this) {
    AdminFinancePayoutStatus.notAssigned =>
      'Not Assigned',
    AdminFinancePayoutStatus.inPayout => 'In Payout',
    AdminFinancePayoutStatus.paidOut => 'Paid Out',
    AdminFinancePayoutStatus.failed => 'Failed',
    AdminFinancePayoutStatus.held => 'Held',
  };
}

/// Status for a refund or dispute case.
enum AdminFinanceRefundCaseStatus {
  pending,
  underReview,
  approved,
  rejected;

  String get label => switch (this) {
    AdminFinanceRefundCaseStatus.pending => 'Pending',
    AdminFinanceRefundCaseStatus.underReview =>
      'Under Review',
    AdminFinanceRefundCaseStatus.approved => 'Approved',
    AdminFinanceRefundCaseStatus.rejected => 'Rejected',
  };
}

/// Type of refund case.
enum AdminFinanceRefundCaseType {
  refund,
  dispute;

  String get label => switch (this) {
    AdminFinanceRefundCaseType.refund => 'Refund',
    AdminFinanceRefundCaseType.dispute => 'Dispute',
  };
}

/// Status for a reconciliation exception.
enum AdminFinanceReconciliationStatus {
  open,
  underReview,
  resolved,
  reopened;

  String get label => switch (this) {
    AdminFinanceReconciliationStatus.open => 'Open',
    AdminFinanceReconciliationStatus.underReview =>
      'Under Review',
    AdminFinanceReconciliationStatus.resolved =>
      'Resolved',
    AdminFinanceReconciliationStatus.reopened =>
      'Reopened',
  };
}

/// Type of reconciliation exception.
enum AdminFinanceReconciliationType {
  missingProviderEvent,
  missingLedgerRecord,
  amountMismatch,
  currencyMismatch,
  duplicateProviderEvent,
  payoutMismatch,
  refundMismatch,
  stalePendingPayment;

  String get label => switch (this) {
    AdminFinanceReconciliationType.missingProviderEvent =>
      'Missing Provider Event',
    AdminFinanceReconciliationType.missingLedgerRecord =>
      'Missing Ledger Record',
    AdminFinanceReconciliationType.amountMismatch =>
      'Amount Mismatch',
    AdminFinanceReconciliationType.currencyMismatch =>
      'Currency Mismatch',
    AdminFinanceReconciliationType.duplicateProviderEvent =>
      'Duplicate Provider Event',
    AdminFinanceReconciliationType.payoutMismatch =>
      'Payout Mismatch',
    AdminFinanceReconciliationType.refundMismatch =>
      'Refund Mismatch',
    AdminFinanceReconciliationType.stalePendingPayment =>
      'Stale Pending Payment',
  };
}

/// Payment provider.
enum AdminFinanceProvider {
  stripe,
  momo,
  bankTransfer,
  manual;

  String get label => switch (this) {
    AdminFinanceProvider.stripe => 'Stripe',
    AdminFinanceProvider.momo => 'MoMo',
    AdminFinanceProvider.bankTransfer => 'Bank Transfer',
    AdminFinanceProvider.manual => 'Manual',
  };
}

/// Visual risk / severity tone used for status chips.
enum AdminFinanceRiskTone {
  neutral,
  positive,
  warning,
  critical;
}

/// Export job status.
enum AdminFinanceExportStatus {
  queued,
  processing,
  ready,
  failed,
  expired;

  String get label => switch (this) {
    AdminFinanceExportStatus.queued => 'Queued',
    AdminFinanceExportStatus.processing => 'Processing',
    AdminFinanceExportStatus.ready => 'Ready',
    AdminFinanceExportStatus.failed => 'Failed',
    AdminFinanceExportStatus.expired => 'Expired',
  };
}

/// Finance export report type.
enum AdminFinanceExportType {
  transactions,
  payouts,
  refundCases,
  reconciliation,
  partnerExposure,
  monthlySummary;

  String get label => switch (this) {
    AdminFinanceExportType.transactions => 'Transactions',
    AdminFinanceExportType.payouts => 'Payouts',
    AdminFinanceExportType.refundCases => 'Refund Cases',
    AdminFinanceExportType.reconciliation =>
      'Reconciliation',
    AdminFinanceExportType.partnerExposure =>
      'Partner Exposure',
    AdminFinanceExportType.monthlySummary =>
      'Monthly Summary',
  };
}
