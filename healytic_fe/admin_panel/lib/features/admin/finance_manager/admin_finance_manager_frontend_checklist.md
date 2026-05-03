# Admin Finance Manager Frontend Implementation Checklist

## Summary

Create a frontend-only admin finance manager module for the whole Healytics CRM
system under:

```txt
lib/features/admin/finance_manager
```

The module must follow existing admin standards used by dashboard, partner
manager, category, and system notification features:

- feature-first folder under `lib/features/admin`
- `domain`, `datasource`, and `presentation` boundaries
- repository contract in `domain`
- repository implementation and remote data source in `datasource`
- mock-first data source switched through `StoreKey.mockFlag`
- Riverpod providers for workspace state and async data
- typed GoRouter admin routes
- paginated CRM tables and detail screens

This checklist is frontend-only. Backend implementation, database schema,
ledger migrations, and OpenAPI generation are dependencies for real-mode
integration, not part of this implementation checklist.

## 1. Target Module Structure

Create this structure when implementing the feature:

```txt
lib/features/admin/finance_manager/
  admin_finance_manager_frontend_checklist.md
  domain/
    admin_finance.entity.dart
    admin_finance_filter.dart
    admin_finance_period.dart
    admin_finance.repository.dart
  datasource/
    admin_finance_impl.repository.dart
    admin_finance_remote.datasource.dart
    data/
      admin_finance_mock_data.dart
  presentation/
    admin_finance_manager_screen.dart
    admin_finance_transaction_detail.screen.dart
    admin_finance_payout_detail.screen.dart
    admin_finance_refund_case_detail.screen.dart
    admin_finance_reconciliation_detail.screen.dart
    layouts/
      admin_finance_manager_desktop.dart
      admin_finance_manager_tablet.dart
      admin_finance_manager_mobile.dart
      admin_finance_transaction_detail_desktop.dart
      admin_finance_payout_detail_desktop.dart
      admin_finance_refund_case_detail_desktop.dart
      admin_finance_reconciliation_detail_desktop.dart
    providers/
      admin_finance.provider.dart
      admin_finance_state.dart
    widgets/
      admin_finance_header.widget.dart
      admin_finance_period_selector.widget.dart
      admin_finance_kpi_grid.widget.dart
      admin_finance_trend_panel.widget.dart
      admin_finance_alerts_panel.widget.dart
      admin_finance_filter_bar.widget.dart
      admin_finance_status_tabs.widget.dart
      admin_finance_partner_exposure_panel.widget.dart
      admin_finance_audit_timeline.widget.dart
      admin_finance_notes_panel.widget.dart
      admin_finance_action_dialogs.dart
      admin_finance_ui_helpers.dart
      table/
        admin_finance_transaction_table.dart
        admin_finance_payout_table.dart
        admin_finance_refund_case_table.dart
        admin_finance_reconciliation_table.dart
        admin_finance_export_table.dart
        table_components/
          admin_finance_table_columns.dart
          admin_finance_table_source.dart
          admin_finance_function_buttons.dart
```

## 2. Frontend Scope Checklist

Implement these admin CRM surfaces:

- [ ] Finance overview with KPI cards, trend chart, alert panel, and partner
      exposure summary.
- [ ] Ledger transactions table for all partners and all commerce sources.
- [ ] Payouts table for platform-wide partner payout monitoring.
- [ ] Refunds and disputes table for operational case review.
- [ ] Reconciliation exceptions table for provider and ledger mismatches.
- [ ] Partner exposure panel or table for ranking financial risk by partner.
- [ ] Export jobs table for finance report generation and download state.
- [ ] Transaction detail screen.
- [ ] Payout detail screen.
- [ ] Refund case detail screen.
- [ ] Reconciliation exception detail screen.

Keep backend and infrastructure work out of this frontend scope:

- [ ] Do not add backend modules or database migrations.
- [ ] Do not modify OpenAPI generated files by hand.
- [ ] Do not register `AdminFinanceApi` until backend/OpenAPI exists.
- [ ] Do not implement real payment provider actions in frontend mocks.

## 3. Domain Checklist

### 3.1 Periods And Tabs

- [ ] Add `AdminFinancePeriod` with:
  - `sevenDays`
  - `thirtyDays`
  - `ninetyDays`
  - `thisMonth`
  - `lastMonth`
  - `custom`
- [ ] Add labels:
  - `7D`
  - `30D`
  - `90D`
  - `This Month`
  - `Last Month`
  - `Custom`
- [ ] Add `AdminFinanceWorkspaceTab` with:
  - `overview`
  - `ledger`
  - `payouts`
  - `refunds`
  - `reconciliation`
  - `partnerExposure`
  - `exports`

### 3.2 Status And Type Enums

- [ ] Add source type enum:
  - `serviceBooking`
  - `productOrder`
- [ ] Add transaction type enum:
  - `charge`
  - `refund`
  - `adjustment`
  - `payout`
  - `fee`
- [ ] Add transaction status enum:
  - `pending`
  - `paid`
  - `refunded`
  - `failed`
  - `canceled`
- [ ] Add settlement status enum:
  - `unsettled`
  - `scheduled`
  - `settled`
  - `held`
- [ ] Add payout status enum:
  - `notAssigned`
  - `inPayout`
  - `paidOut`
  - `failed`
  - `held`
- [ ] Add refund case status enum:
  - `pending`
  - `underReview`
  - `approved`
  - `rejected`
- [ ] Add refund case type enum:
  - `refund`
  - `dispute`
- [ ] Add reconciliation status enum:
  - `open`
  - `underReview`
  - `resolved`
  - `reopened`
- [ ] Add reconciliation type enum:
  - `missingProviderEvent`
  - `missingLedgerRecord`
  - `amountMismatch`
  - `currencyMismatch`
  - `duplicateProviderEvent`
  - `payoutMismatch`
  - `refundMismatch`
  - `stalePendingPayment`
- [ ] Add provider enum:
  - `stripe`
  - `momo`
  - `bankTransfer`
  - `manual`
- [ ] Add risk tone enum:
  - `neutral`
  - `positive`
  - `warning`
  - `critical`
- [ ] Add export status enum:
  - `queued`
  - `processing`
  - `ready`
  - `failed`
  - `expired`
- [ ] Add export type enum:
  - `transactions`
  - `payouts`
  - `refundCases`
  - `reconciliation`
  - `partnerExposure`
  - `monthlySummary`

### 3.3 Filter Model

- [ ] Add `AdminFinanceFilter`.
- [ ] Include these fields:
  - `searchQuery`
  - `startDate`
  - `endDate`
  - `partnerId`
  - `customerId`
  - `sourceType`
  - `transactionType`
  - `transactionStatus`
  - `settlementStatus`
  - `payoutStatus`
  - `refundCaseStatus`
  - `refundCaseType`
  - `reconciliationStatus`
  - `provider`
  - `currency`
  - `minAmount`
  - `maxAmount`
  - `onlyFlagged`
  - `onlySlaBreached`
- [ ] Add `hasActiveFilters`.
- [ ] Add `copyWith` with nullable-clear support using the existing
      `_noValue` pattern from partner finance models.

### 3.4 ID Types

- [ ] Add extension-type IDs:
  - `AdminFinanceTransactionId`
  - `AdminFinancePayoutId`
  - `AdminFinanceRefundCaseId`
  - `AdminFinanceReconciliationId`
  - `AdminFinanceExportId`
  - `AdminFinanceNoteId`
  - `AdminFinanceAuditEventId`
  - `AdminFinancePartnerId`
  - `AdminFinanceCustomerId`

### 3.5 Entities

- [ ] Add `AdminFinanceOverview`.
- [ ] Add `AdminFinanceKpi`.
- [ ] Add `AdminFinanceTrendPoint`.
- [ ] Add `AdminFinanceAlert`.
- [ ] Add `AdminFinanceTransactionRecord`.
- [ ] Add `AdminFinanceTransactionDetail`.
- [ ] Add `AdminFinancePayoutRecord`.
- [ ] Add `AdminFinancePayoutDetail`.
- [ ] Add `AdminFinanceRefundCaseRecord`.
- [ ] Add `AdminFinanceRefundCaseDetail`.
- [ ] Add `AdminFinanceReconciliationException`.
- [ ] Add `AdminFinanceReconciliationDetail`.
- [ ] Add `AdminFinancePartnerExposure`.
- [ ] Add `AdminFinanceExportJob`.
- [ ] Add `AdminFinanceAuditEvent`.
- [ ] Add `AdminFinanceNote`.
- [ ] Add `AdminFinanceProviderEvent`.
- [ ] Add `AdminFinancePayoutAttempt`.

Required row-level fields:

- [ ] Transaction rows include created date, reference, partner, customer,
      source type, type, gross amount, fee amount, net amount, currency,
      transaction status, settlement status, payout status, provider, review
      flag, notes count, and optional payout ID.
- [ ] Payout rows include scheduled date, partner, period label, included
      volume, fees and adjustments, net payout, currency, method, status,
      attempt count, failure reason, hold reason, and notes count.
- [ ] Refund case rows include requested date, transaction ID, partner,
      customer, case type, amount, currency, reason, owner, status, SLA hours,
      SLA breached flag, and risk tone.
- [ ] Reconciliation rows include detected date, provider, provider event ID,
      related transaction ID, expected amount, provider amount, difference,
      currency, type, status, owner, and summary.
- [ ] Export rows include created date, type, requested by, status, row count,
      download URL, and expiry date.

### 3.6 Repository Contract

- [ ] Add `AdminFinanceRepository`.
- [ ] Include read methods for:
  - overview
  - trend
  - alerts
  - transactions total rows
  - paginated transactions
  - transaction detail
  - payouts total rows
  - paginated payouts
  - payout detail
  - refund cases total rows
  - paginated refund cases
  - refund case detail
  - reconciliation total rows
  - paginated reconciliation exceptions
  - reconciliation detail
  - partner exposure
  - exports
- [ ] Include admin action methods for:
  - mark settlement
  - flag or unflag transaction
  - approve refund case
  - reject refund case
  - retry payout
  - hold payout
  - release payout hold
  - resolve reconciliation exception
  - reopen reconciliation exception
  - add note
  - create export

## 4. Data Checklist

### 4.1 Remote Data Source

- [ ] Add `AdminFinanceRemoteDataSource`.
- [ ] Add `AdminFinanceRemoteDataSourceImpl`.
- [ ] Add `AdminFinanceRemoteDataSourceMock`.
- [ ] Add Riverpod provider:

```dart
@riverpod
AdminFinanceRemoteDataSource adminFinanceRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) return AdminFinanceRemoteDataSourceMock();

  final apiService = ref.read(apiServiceProvider);
  return AdminFinanceRemoteDataSourceImpl(apiService: apiService);
}
```

- [ ] In real mode, keep generated OpenAPI DTO imports inside this data source.
- [ ] In mock mode, return deterministic fixture data with short artificial
      delays matching existing admin mock style.
- [ ] For paginated lists, accept frontend `startingAt` and `count`.
- [ ] For future real API integration, map `startingAt` and `count` to:

```dart
final page = (startingAt ~/ count) + 1;
final limit = count;
```

### 4.2 Repository Implementation

- [ ] Add `AdminFinanceImplRepository`.
- [ ] Delegate every repository method to the data source.
- [ ] Add `adminFinanceRepositoryProvider`.
- [ ] Match naming and provider style used by admin dashboard and system
      notification repositories.

### 4.3 Mock Data

- [ ] Add at least 60 transaction records.
- [ ] Add at least 12 payout records.
- [ ] Add at least 18 refund and dispute cases.
- [ ] Add at least 10 reconciliation exceptions.
- [ ] Add at least 8 partner exposure rows.
- [ ] Add at least 8 export jobs.
- [ ] Add audit trails and notes for every detail screen.
- [ ] Use deterministic IDs:
  - `admin-txn-001`
  - `admin-payout-001`
  - `admin-refund-001`
  - `admin-recon-001`
  - `admin-export-001`
- [ ] Include rows for all primary statuses so status chips, filters, empty
      states, and action dialogs can be tested.
- [ ] Use mostly `VND`; include a small `USD` sample only for currency filter
      coverage.

### 4.4 Future Real Integration Notes

- [ ] Do not add `AdminFinanceApi` to `ApiService` until OpenAPI generation
      provides it.
- [ ] When generated API exists, add:

```dart
late AdminFinanceApi adminFinanceApi;
```

- [ ] Initialize it in `ApiService.setEndpoint()` with the backend client.
- [ ] Map generated DTOs to domain entities in private mapper functions.
- [ ] If generated list endpoints return `Future<void>` because the OpenAPI
      response body is missing, use the `WithHttpInfo` variant and decode JSON
      manually, matching the partner finance integration pattern.

## 5. Presentation Checklist

### 5.1 Screens And Routes

- [ ] Add `AdminFinanceManagerScreen`.
- [ ] Add `AdminFinanceTransactionDetailScreen`.
- [ ] Add `AdminFinancePayoutDetailScreen`.
- [ ] Add `AdminFinanceRefundCaseDetailScreen`.
- [ ] Add `AdminFinanceReconciliationDetailScreen`.
- [ ] Add typed routes in `lib/router/admin_routes.dart`:
  - `/admin/finance`
  - `/admin/finance/transactions/:transactionId`
  - `/admin/finance/payouts/:payoutId`
  - `/admin/finance/refund-cases/:caseId`
  - `/admin/finance/reconciliation/:exceptionId`
- [ ] Route names:
  - `admin-finance`
  - `admin-finance-transaction-detail`
  - `admin-finance-payout-detail`
  - `admin-finance-refund-case-detail`
  - `admin-finance-reconciliation-detail`
- [ ] After route edits, run:

```txt
dart run build_runner build --delete-conflicting-outputs
```

### 5.2 Workspace State

- [ ] Add `AdminFinanceWorkspaceState`.
- [ ] Default values:
  - `activeTab = AdminFinanceWorkspaceTab.overview`
  - `period = AdminFinancePeriod.thirtyDays`
  - `filter = const AdminFinanceFilter()`
  - `reloadToken = 0`
- [ ] Add `AdminFinanceWorkspaceNotifier`.
- [ ] Add methods:
  - `setActiveTab`
  - `setPeriod`
  - `setSearchQuery`
  - `setPartner`
  - `setCustomer`
  - `setDateRange`
  - `setSourceType`
  - `setTransactionType`
  - `setTransactionStatus`
  - `setSettlementStatus`
  - `setPayoutStatus`
  - `setRefundCaseStatus`
  - `setReconciliationStatus`
  - `setProvider`
  - `setCurrency`
  - `setAmountRange`
  - `setOnlyFlagged`
  - `setOnlySlaBreached`
  - `resetFilters`
  - `bumpReload`

### 5.3 Async Providers

- [ ] Add `adminFinanceOverviewProvider`.
- [ ] Add `adminFinanceTrendProvider`.
- [ ] Add `adminFinanceAlertsProvider`.
- [ ] Add `adminFinancePartnerExposureProvider`.
- [ ] Add `adminFinanceExportsProvider`.
- [ ] Add family providers for:
  - transaction detail
  - payout detail
  - refund case detail
  - reconciliation detail
- [ ] Watch `period`, `filter`, and `reloadToken` where applicable.
- [ ] Load only the active tab table data through table data sources, not all
      tables at once.

### 5.4 Main Layout

- [ ] Desktop layout uses existing admin spacing style:
  - `SingleChildScrollView`
  - `AppDimens.paddingAllMedium`
  - header row
  - KPI row/grid
  - tab controls
  - filter bar
  - active tab content
- [ ] Tablet layout can reuse desktop layout with tighter constraints.
- [ ] Mobile layout can stack header, period selector, filters, cards, and
      table/list content vertically.
- [ ] Keep the UI operational and dense; do not add landing-page or marketing
      sections.

### 5.5 Header And Controls

- [ ] Header title: `Finance Manager`.
- [ ] Header subtitle: `Monitor platform revenue, payouts, refunds, and reconciliation.`
- [ ] Header actions:
  - refresh
  - export
- [ ] Period selector includes:
  - `7D`
  - `30D`
  - `90D`
  - `This Month`
  - `Last Month`
  - `Custom`
- [ ] Filter bar includes:
  - search
  - partner
  - source type
  - transaction type
  - payment status
  - settlement status
  - payout status
  - refund status
  - reconciliation status
  - provider
  - currency
  - amount range
  - date range
  - flagged only
  - SLA breached only
  - reset

### 5.6 Overview Tab

- [ ] Show KPI cards:
  - gross volume
  - net revenue
  - platform fee revenue
  - refund exposure
  - failed payment amount
  - pending payout amount
  - held payout amount
  - unreconciled amount
- [ ] Show trend panel for:
  - gross volume
  - net revenue
  - refund amount
  - payout amount
- [ ] Show finance alerts panel.
- [ ] Show partner exposure panel.

### 5.7 Tables

- [ ] Ledger table columns:
  - created at
  - transaction ID
  - reference
  - partner
  - customer
  - source type
  - type
  - gross
  - fee
  - net
  - currency
  - payment status
  - settlement status
  - payout status
  - provider
  - review flag
  - actions
- [ ] Payout table columns:
  - scheduled date
  - payout ID
  - partner
  - period
  - included volume
  - fees and adjustments
  - net payout
  - currency
  - method
  - status
  - attempt count
  - failure reason
  - held reason
  - actions
- [ ] Refund case table columns:
  - requested at
  - case ID
  - type
  - transaction ID
  - partner
  - customer
  - amount
  - currency
  - reason
  - owner
  - status
  - SLA
  - risk
  - actions
- [ ] Reconciliation table columns:
  - detected at
  - exception ID
  - provider
  - provider event ID
  - related transaction
  - expected amount
  - provider amount
  - difference
  - currency
  - type
  - status
  - owner
  - actions
- [ ] Export table columns:
  - created at
  - export ID
  - type
  - requested by
  - status
  - row count
  - download URL
  - expires at

### 5.8 Detail Screens

- [ ] Transaction detail shows:
  - transaction summary
  - source summary
  - partner and customer context
  - payment provider events
  - timeline
  - related refund cases
  - payout link when available
  - notes
  - audit trail
- [ ] Payout detail shows:
  - payout summary
  - partner context
  - included transactions
  - payout attempts
  - masked destination summary
  - notes
  - audit trail
- [ ] Refund case detail shows:
  - case summary
  - source transaction
  - customer request
  - partner response
  - evidence links
  - decision note
  - notes
  - audit trail
- [ ] Reconciliation detail shows:
  - exception summary
  - provider event context
  - ledger context
  - amount comparison
  - resolution notes
  - notes
  - audit trail

### 5.9 Action Dialogs

- [ ] Mark settlement dialog.
- [ ] Flag or unflag transaction dialog.
- [ ] Approve refund case dialog.
- [ ] Reject refund case dialog.
- [ ] Retry payout dialog.
- [ ] Hold payout dialog.
- [ ] Release payout hold dialog.
- [ ] Resolve reconciliation dialog.
- [ ] Reopen reconciliation dialog.
- [ ] Create export dialog.
- [ ] Add note dialog.
- [ ] Require a note for risky actions:
  - reject refund case
  - hold payout
  - resolve reconciliation exception
  - manual settlement change
- [ ] After successful mock or real action, call `bumpReload()`.

### 5.10 UI Helpers

- [ ] Add status chip color helpers in `admin_finance_ui_helpers.dart`.
- [ ] Tone mapping:
  - neutral: pending, scheduled, not assigned, queued
  - positive: paid, settled, paid out, approved, resolved, ready
  - warning: under review, held, in payout, processing, reopened
  - critical: failed, rejected, expired, SLA breached, mismatch
- [ ] Reuse existing finance/status helper ideas where they fit, but keep
      admin finance helpers local to this module.

## 6. Navigation Checklist

- [ ] Locate the existing admin navigation/sidebar before implementation.
- [ ] Add one `Finance` navigation item using the existing navigation style.
- [ ] Route target: `/admin/finance`.
- [ ] Recommended position: after Dashboard and before Partner Manager.
- [ ] Use the existing icon library already used by the admin shell.
- [ ] Do not introduce a new navigation system.

## 7. Empty And Error State Checklist

- [ ] Empty ledger state: `No transactions match the selected filters.`
- [ ] Empty payouts state: `No payout batches match the selected filters.`
- [ ] Empty refunds state: `No refund or dispute cases match the selected filters.`
- [ ] Empty reconciliation state: `No reconciliation exceptions match the selected filters.`
- [ ] Empty exports state: `No finance exports have been created yet.`
- [ ] Empty partner exposure state: `No partner exposure data matches the selected filters.`
- [ ] Include a reset filters action where filters are active.
- [ ] For async failures, show a concise error and retry action.
- [ ] Do not show stack traces in UI.

## 8. Test Plan Checklist

### 8.1 Unit Tests

- [ ] Add mock data test for deterministic IDs.
- [ ] Add mock data test for non-empty overview metrics.
- [ ] Add mock data test for table coverage across all major statuses.
- [ ] Add mock data test for detail lookup by transaction ID.
- [ ] Add mock data test for detail lookup by payout ID.
- [ ] Add mock data test for detail lookup by refund case ID.
- [ ] Add mock data test for detail lookup by reconciliation ID.
- [ ] Add filter model tests for `hasActiveFilters`.
- [ ] Add repository delegation tests if a fake data source is introduced.

### 8.2 Provider Tests

- [ ] Tab change updates `activeTab`.
- [ ] Period change updates `period`.
- [ ] Search change updates filter and increments `reloadToken`.
- [ ] Status filter changes update filter and increment `reloadToken`.
- [ ] Reset filters restores default filter and increments `reloadToken`.
- [ ] Successful action calls increment `reloadToken`.
- [ ] Detail providers return deterministic mock detail records.

### 8.3 Widget Tests

- [ ] Main desktop screen renders header and default overview.
- [ ] Filter bar renders all expected controls.
- [ ] KPI grid renders overview values.
- [ ] Ledger table renders mock transactions.
- [ ] Payout table renders mock payouts.
- [ ] Refund case table renders mock cases.
- [ ] Reconciliation table renders mock exceptions.
- [ ] Export table renders mock export jobs.
- [ ] Empty states render when filtered data is empty.
- [ ] Error states render retry controls.
- [ ] Action dialogs enforce required notes for risky actions.

### 8.4 Route Tests

- [ ] `/admin/finance` opens the manager screen.
- [ ] `/admin/finance/transactions/:transactionId` opens transaction detail.
- [ ] `/admin/finance/payouts/:payoutId` opens payout detail.
- [ ] `/admin/finance/refund-cases/:caseId` opens refund case detail.
- [ ] `/admin/finance/reconciliation/:exceptionId` opens reconciliation detail.

## 9. Acceptance Criteria

- [ ] Checklist file exists at
      `lib/features/admin/finance_manager/admin_finance_manager_frontend_checklist.md`.
- [ ] The checklist is frontend-only and does not require backend work to begin
      mock UI implementation.
- [ ] The checklist documents the intended domain, data, presentation, route,
      navigation, empty/error state, and test work.
- [ ] The checklist explicitly keeps backend, database, and OpenAPI generation
      outside this scope.
- [ ] The checklist aligns with the existing admin CRM module style.

## 10. Implementation Order For Future Build

Use this order when the feature is implemented:

1. Add domain enums, filters, entities, and repository contract.
2. Add mock data, remote data source, and repository implementation.
3. Add workspace provider state.
4. Add main screen, layouts, header, period selector, tabs, and filter bar.
5. Add overview widgets.
6. Add ledger table.
7. Add payouts, refund cases, reconciliation, partner exposure, and exports.
8. Add detail screens.
9. Add action dialogs.
10. Add routes and navigation.
11. Add tests.
12. Integrate generated `AdminFinanceApi` only after backend/OpenAPI exists.
