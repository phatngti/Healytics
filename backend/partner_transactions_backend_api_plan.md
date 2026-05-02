# Partner Transactions Backend API Implementation Plan

This plan covers the backend APIs needed by the partner transaction manager feature:

- `transaction_home.screen.dart`
- `transaction_details.screen.dart`
- `finance_models.dart`
- `transaction.provider.dart`
- `transactions_remote.datasource.dart`
- `transactions_table.widget.dart`
- `payouts_table.widget.dart`
- `refund_cases_table.widget.dart`
- `finance_filter_panel.widget.dart`
- `finance_trend_panel.widget.dart`
- `finance_overview_card.widget.dart`

The current frontend is fully mock-backed. Backend should provide partner-scoped finance APIs that let the UI load summary metrics, trend data, paginated transaction rows, paginated payout rows, paginated refund or dispute cases, detail records, and row-level operational actions.

## 1. Scope And Ownership

Build these as authenticated partner APIs only. A partner must only see financial records that belong to the partner profile linked to the authenticated account.

Recommended backend module names:

- `partner-finance`
- `partner-transactions`
- `partner-payouts`
- `partner-refunds`

If the backend already has payment, booking, order, wallet, ledger, refund, or payout modules, implement these endpoints as query and orchestration handlers over the existing source of truth. Do not duplicate financial state in a dashboard-specific table unless using a read model/materialized view.

Primary data domains:

- Ledger transactions: charges, refunds, adjustments, payouts, fees.
- Commerce source records: service bookings and product orders.
- Payment provider captures, failures, refunds, disputes, and fees.
- Settlement state: unsettled, scheduled, settled, held.
- Payout batches and payout attempts.
- Refund and dispute case workflow.

## 2. Existing Frontend Contract

The frontend model uses these enum values:

```ts
type FinancePeriod = 'sevenDays' | 'thirtyDays' | 'ninetyDays';
type FinanceMetric = 'gross' | 'net' | 'refunds';
type CommerceSourceType = 'serviceBooking' | 'productOrder';
type TransactionType = 'charge' | 'refund' | 'adjustment' | 'payout' | 'fee';
type TransactionStatus = 'pending' | 'paid' | 'refunded' | 'failed' | 'canceled';
type SettlementStatus = 'unsettled' | 'scheduled' | 'settled' | 'held';
type PayoutStatus = 'notAssigned' | 'inPayout' | 'paidOut' | 'failed';
type RefundCaseStatus = 'pending' | 'underReview' | 'approved' | 'rejected';
type RefundCaseType = 'refund' | 'dispute';
```

Use camelCase JSON field names that match Flutter domain names. If backend enum conventions are uppercase, map them at the API boundary or document the generated OpenAPI enum names clearly so frontend mapping can be deterministic.

Money fields are currently `double` in Flutter. Backend should return integer minor units if the core backend already stores money that way, but the response DTO for this feature should expose numeric major units consistently with the app's current format. For VND this means whole-number amounts.

All timestamps must be ISO 8601 strings with timezone, preferably UTC:

```txt
2026-04-08T09:15:00.000Z
```

## 3. Authentication And Partner Scoping

Follow the partner controller pattern already used by other partner dashboard APIs:

```ts
@PartnerApi('transactions')
@UseGuards(JwtAuthGuard, RolesGuard)
```

Controller methods should resolve the partner profile from the authenticated account:

```ts
@CurrentUser('id') accountId: string
const partnerId = await this.partnersService.getPartnerIdByAccountId(accountId);
```

Every query must include `partnerId` in the database predicate. Never trust a partner ID supplied by query parameters.

Required authorization behavior:

- Return `401` when access token is absent or invalid.
- Return `403` when the user is authenticated but not a partner.
- Return `404` for transaction, payout, or refund case IDs outside the partner scope.
- Do not leak whether another partner's record exists.

## 4. Query DTOs

Create a shared query DTO for list, summary, and trend endpoints.

```txt
src/partner-finance/dto/partner-finance-query.dto.ts
```

```ts
export enum PartnerFinancePeriod {
  SEVEN_DAYS = 'sevenDays',
  THIRTY_DAYS = 'thirtyDays',
  NINETY_DAYS = 'ninetyDays',
}

export enum PartnerCommerceSourceType {
  SERVICE_BOOKING = 'serviceBooking',
  PRODUCT_ORDER = 'productOrder',
}

export enum PartnerTransactionType {
  CHARGE = 'charge',
  REFUND = 'refund',
  ADJUSTMENT = 'adjustment',
  PAYOUT = 'payout',
  FEE = 'fee',
}

export enum PartnerTransactionStatus {
  PENDING = 'pending',
  PAID = 'paid',
  REFUNDED = 'refunded',
  FAILED = 'failed',
  CANCELED = 'canceled',
}

export enum PartnerSettlementStatus {
  UNSETTLED = 'unsettled',
  SCHEDULED = 'scheduled',
  SETTLED = 'settled',
  HELD = 'held',
}

export enum PartnerPayoutStatus {
  NOT_ASSIGNED = 'notAssigned',
  IN_PAYOUT = 'inPayout',
  PAID_OUT = 'paidOut',
  FAILED = 'failed',
}

export class PartnerFinanceQueryDto {
  search?: string;
  startDate?: string;
  endDate?: string;
  period?: PartnerFinancePeriod;
  sourceType?: PartnerCommerceSourceType;
  transactionType?: PartnerTransactionType;
  transactionStatus?: PartnerTransactionStatus;
  settlementStatus?: PartnerSettlementStatus;
  payoutStatus?: PartnerPayoutStatus;
  currency?: string;
}
```

Validation requirements:

- `period` defaults to `thirtyDays`.
- `startDate` and `endDate` are optional ISO dates or ISO datetimes.
- If both dates are present, `startDate <= endDate`.
- `currency` is optional and should use ISO 4217 uppercase codes, for example `VND` or `USD`.
- `search` should be trimmed and limited to 120 characters.
- Date filtering should be inclusive by local business day when the client sends date-only values.

For paginated lists add:

```ts
export class PartnerFinancePageQueryDto extends PartnerFinanceQueryDto {
  page?: number = 1;
  limit?: number = 10;
}
```

Validation:

- `page >= 1`
- `1 <= limit <= 100`

The Flutter table currently uses `startingAt` and `count`. Frontend can convert `page = startingAt / count + 1`, or backend may also accept `offset` and `limit`. Prefer `page` and `limit` if that matches existing generated OpenAPI conventions.

## 5. Response DTOs

Create response DTOs under:

```txt
src/partner-finance/dto/
```

### 5.1 Shared Page DTO

```ts
export class PartnerFinancePageMetaDto {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export class PartnerFinancePageDto<T> {
  data: T[];
  meta: PartnerFinancePageMetaDto;
}
```

### 5.2 Finance Summary

```ts
export class PartnerFinanceSummaryDto {
  grossVolume: number;
  netSettled: number;
  pendingPayout: number;
  refundExposure: number;
  availableBalance: number;
  pendingBalance: number;
  currency: string;
  nextPayoutAt?: string | null;
  payoutMethod?: string | null;
  payoutStatus?: PartnerPayoutStatus | null;
}
```

Aggregation rules:

- `grossVolume`: sum of `grossAmount` for transaction type `charge` in the filter window.
- `netSettled`: sum of `grossAmount - feeAmount` for transactions whose `settlementStatus` is `settled`.
- `pendingPayout`: sum of net amount for transactions whose `payoutStatus` is `notAssigned` or `inPayout`.
- `refundExposure`: sum of open refund/dispute case amounts where status is `pending` or `underReview`.
- `availableBalance`: `netSettled - refundExposure`, never below zero unless finance intentionally allows negative balances.
- `pendingBalance`: same base as `pendingPayout`.
- `nextPayoutAt`, `payoutMethod`, `payoutStatus`: earliest upcoming or failed payout that still needs partner attention.

### 5.3 Finance Trend Point

```ts
export class PartnerFinanceTrendPointDto {
  date: string;
  grossAmount: number;
  netAmount: number;
  refundAmount: number;
}
```

Aggregation rules:

- Return one bucket per calendar day in the selected period, sorted ascending by date.
- Include zero-value days so the chart can render stable axes.
- `grossAmount`: charges only.
- `netAmount`: sum of transaction net amount for all included ledger transaction types unless finance wants refunds represented as negative rows. If refunds are stored positive, subtract refund rows here.
- `refundAmount`: refund transaction amount, positive number for chart display.

### 5.4 Transaction Row

```ts
export class PartnerTransactionTimelineEventDto {
  title: string;
  description: string;
  occurredAt: string;
}

export class PartnerTransactionRecordDto {
  id: string;
  createdAt: string;
  type: PartnerTransactionType;
  sourceType: PartnerCommerceSourceType;
  reference: string;
  customerName: string;
  grossAmount: number;
  feeAmount: number;
  netAmount: number;
  currency: string;
  status: PartnerTransactionStatus;
  settlementStatus: PartnerSettlementStatus;
  payoutStatus: PartnerPayoutStatus;
  paymentMethod: string;
  sourceTitle: string;
  sourceSubtitle: string;
  timeline: PartnerTransactionTimelineEventDto[];
  flaggedForReview: boolean;
  notes?: string | null;
  payoutId?: string | null;
}
```

Field mapping notes:

- `reference`: display ID for the booking, order, refund, fee, or adjustment, for example `BK-240408-001`.
- `customerName`: customer display name for customer-originated transactions, or an internal label such as `Platform Fee`.
- `sourceTitle`: service name, product title, order title, fee title, or adjustment title.
- `sourceSubtitle`: concise operational description for the detail screen.
- `paymentMethod`: sanitized method label, for example `MoMo Wallet`, `Credit Card`, `Vietcombank ending 1122`.
- `timeline`: should include payment capture, authorization, failure, refund request, settlement scheduling, payout assignment, review flag, and manual finance actions when available.

### 5.5 Payout Row

```ts
export class PartnerPayoutRecordDto {
  id: string;
  periodLabel: string;
  includedVolume: number;
  feesAdjustments: number;
  netPayout: number;
  scheduledDate: string;
  method: string;
  status: PartnerPayoutStatus;
  currency: string;
  includedTransactionIds: string[];
}
```

Aggregation rules:

- `includedVolume`: sum of gross amounts included in the payout batch.
- `feesAdjustments`: total fees plus adjustment deductions in the batch. Use a positive number for display.
- `netPayout`: amount expected to transfer to partner.
- `periodLabel`: human-readable date range, for example `Apr 01 - Apr 08`. Backend may also return `periodStart` and `periodEnd` later, but the current UI needs `periodLabel`.
- `includedTransactionIds`: all transaction IDs included in the payout batch. This enables the current "View breakdown" dialog and future drilldown.

### 5.6 Refund Or Dispute Case Row

```ts
export enum PartnerRefundCaseType {
  REFUND = 'refund',
  DISPUTE = 'dispute',
}

export enum PartnerRefundCaseStatus {
  PENDING = 'pending',
  UNDER_REVIEW = 'underReview',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

export class PartnerRefundCaseRecordDto {
  id: string;
  transactionId: string;
  caseType: PartnerRefundCaseType;
  requestedAt: string;
  amount: number;
  currency: string;
  reason: string;
  owner: string;
  status: PartnerRefundCaseStatus;
  slaHours: number;
}
```

SLA rules:

- `slaHours` is remaining hours for open cases.
- For approved or rejected cases return `0`.
- If a case is overdue, return `0` and expose an additional future field like `isOverdue` only when frontend adds it. Current UI only renders the number.

### 5.7 Transaction Detail

```ts
export class PartnerTransactionDetailDto {
  record: PartnerTransactionRecordDto;
  payoutRecord?: PartnerPayoutRecordDto | null;
  relatedRefundCases: PartnerRefundCaseRecordDto[];
  sourceSummaryTitle: string;
  sourceSummarySubtitle: string;
}
```

The detail endpoint should return everything needed for the detail page in one response:

- Main transaction record.
- Linked payout record when assigned.
- Related refund/dispute cases.
- Source summary title and subtitle.

## 6. Required Endpoints

All endpoints are under the backend gateway prefix already used by the frontend, for example `/backend/v1/...` at the gateway level. Paths below are backend route paths.

### 6.1 Finance Summary

```http
GET /v1/partner/transactions/finance/summary?period=thirtyDays&startDate=2026-04-01&endDate=2026-04-30&currency=VND
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerFinanceSummaryDto
```

### 6.2 Finance Trend

```http
GET /v1/partner/transactions/finance/trend?period=thirtyDays&metric=gross
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerFinanceTrendPointDto[]
```

`metric` is optional. The current frontend asks for all three values in every point and switches metrics client-side, so the backend can ignore `metric` for now.

### 6.3 Transaction List

```http
GET /v1/partner/transactions?page=1&limit=10&search=txn_240401&transactionStatus=paid&settlementStatus=settled
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerFinancePageDto<PartnerTransactionRecordDto>
```

Sorting:

- Default sort: `createdAt DESC`.
- Stable tie-breaker: `id DESC`.
- Later optional query params: `sortBy`, `sortDirection`.

Search should match:

- Transaction ID.
- Reference.
- Customer name.
- Source title.

### 6.4 Transaction Detail

```http
GET /v1/partner/transactions/:transactionId
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerTransactionDetailDto
```

Place this route after static routes like `finance/summary` and `finance/trend` so `:transactionId` does not capture static route segments.

### 6.5 Mark Transaction Settled

```http
PATCH /v1/partner/transactions/:transactionId/settlement
Authorization: Bearer <partner-token>
Content-Type: application/json

{
  "settlementStatus": "settled",
  "note": "Finance manager confirmed manual settlement."
}
```

Response:

```ts
PartnerTransactionRecordDto
```

Rules:

- Only allow transition to `settled` for transactions belonging to the partner.
- Reject `failed`, `canceled`, and already refunded transactions unless finance policy explicitly allows manual override.
- If payout status is `notAssigned`, backend may move it to `inPayout` when the settlement creates payout eligibility.
- Add a timeline event.
- Audit who performed the action.

### 6.6 Flag Transaction For Review

```http
PATCH /v1/partner/transactions/:transactionId/review-flag
Authorization: Bearer <partner-token>
Content-Type: application/json

{
  "flaggedForReview": true,
  "note": "Partner requested finance review."
}
```

Response:

```ts
PartnerTransactionRecordDto
```

Rules:

- This is partner-initiated review flagging, not final finance approval.
- Add or update `flaggedForReview = true`.
- Preserve previous notes where possible or append a new timeline event.
- Audit actor account ID and timestamp.

### 6.7 Payout List

```http
GET /v1/partner/payouts?page=1&limit=10&payoutStatus=inPayout&currency=VND
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerFinancePageDto<PartnerPayoutRecordDto>
```

Sorting:

- Default sort: `scheduledDate DESC`.

Search should match:

- Payout ID.
- Payout method.
- Period label.

### 6.8 Retry Failed Payout

```http
POST /v1/partner/payouts/:payoutId/retry
Authorization: Bearer <partner-token>
Content-Type: application/json

{
  "note": "Retry requested from partner transaction manager."
}
```

Response:

```ts
PartnerPayoutRecordDto
```

Rules:

- Only failed payouts can be retried.
- Create a new payout attempt or move the failed payout into an `inPayout` retry state according to existing payout architecture.
- Do not duplicate ledger inclusion.
- Recalculate `scheduledDate` based on the next payout run or provider retry rules.
- Audit actor and reason.

### 6.9 Refund And Dispute Case List

```http
GET /v1/partner/refund-cases?page=1&limit=10&search=rf_240406&currency=VND
Authorization: Bearer <partner-token>
```

Response:

```ts
PartnerFinancePageDto<PartnerRefundCaseRecordDto>
```

Sorting:

- Default sort: `requestedAt DESC`.

Search should match:

- Refund/dispute case ID.
- Linked transaction ID.
- Reason.
- Owner.

Current frontend filters do not include `caseType` or `caseStatus`, but backend may add optional query fields for future use.

### 6.10 Approve Refund Case

```http
POST /v1/partner/refund-cases/:caseId/approve
Authorization: Bearer <partner-token>
Content-Type: application/json

{
  "note": "Approved from partner transaction manager."
}
```

Response:

```ts
PartnerRefundCaseRecordDto
```

Rules:

- Only `pending` or `underReview` cases can be approved.
- If the case represents a real refund, create or confirm the refund transaction and move the original transaction to `refunded` or `held` according to payment policy.
- Hold settlement or payout eligibility until the refund is resolved.
- Add timeline event to the linked transaction.
- Audit actor and note.

### 6.11 Reject Refund Case

```http
POST /v1/partner/refund-cases/:caseId/reject
Authorization: Bearer <partner-token>
Content-Type: application/json

{
  "note": "Rejected from partner transaction manager."
}
```

Response:

```ts
PartnerRefundCaseRecordDto
```

Rules:

- Only `pending` or `underReview` cases can be rejected.
- Add timeline event to the linked transaction.
- Release held settlement only when no other open refund/dispute cases remain.
- Audit actor and note.

## 7. Recommended Controller Layout

```txt
src/partner-finance/partner-transactions.controller.ts
src/partner-finance/partner-payouts.controller.ts
src/partner-finance/partner-refund-cases.controller.ts
```

Controller route sketch:

```ts
@PartnerApi('transactions')
export class PartnerTransactionsController {
  @Get('finance/summary')
  getFinanceSummary(...)

  @Get('finance/trend')
  getFinanceTrend(...)

  @Get()
  getTransactions(...)

  @Get(':transactionId')
  getTransactionDetail(...)

  @Patch(':transactionId/settlement')
  markSettled(...)

  @Patch(':transactionId/review-flag')
  flagForReview(...)
}

@PartnerApi('payouts')
export class PartnerPayoutsController {
  @Get()
  getPayouts(...)

  @Post(':payoutId/retry')
  retryPayout(...)
}

@PartnerApi('refund-cases')
export class PartnerRefundCasesController {
  @Get()
  getRefundCases(...)

  @Post(':caseId/approve')
  approve(...)

  @Post(':caseId/reject')
  reject(...)
}
```

Keep static routes before dynamic `:id` routes.

## 8. Service And Handler Plan

Recommended application handlers:

```txt
src/partner-finance/application/handlers/get-finance-summary.handler.ts
src/partner-finance/application/handlers/get-finance-trend.handler.ts
src/partner-finance/application/handlers/list-partner-transactions.handler.ts
src/partner-finance/application/handlers/get-partner-transaction-detail.handler.ts
src/partner-finance/application/handlers/mark-transaction-settled.handler.ts
src/partner-finance/application/handlers/flag-transaction-review.handler.ts
src/partner-finance/application/handlers/list-partner-payouts.handler.ts
src/partner-finance/application/handlers/retry-partner-payout.handler.ts
src/partner-finance/application/handlers/list-partner-refund-cases.handler.ts
src/partner-finance/application/handlers/approve-partner-refund-case.handler.ts
src/partner-finance/application/handlers/reject-partner-refund-case.handler.ts
```

Each handler should:

- Resolve `partnerId` from authenticated account ID.
- Validate partner owns the target record.
- Apply query filters consistently.
- Map internal domain states to frontend enum strings.
- Return DTOs, not database entities.
- Emit audit logs for mutations.

## 9. Data Model Expectations

If these tables/entities already exist, map to them. If not, the minimum read model should support:

### 9.1 Ledger Transaction

```txt
id
partner_id
created_at
type
source_type
source_id
reference
customer_id
customer_name_snapshot
gross_amount
fee_amount
currency
status
settlement_status
payout_status
payment_method_label
source_title_snapshot
source_subtitle_snapshot
flagged_for_review
notes
payout_id
```

Indexes:

```txt
(partner_id, created_at desc)
(partner_id, status, created_at desc)
(partner_id, settlement_status, created_at desc)
(partner_id, payout_status, created_at desc)
(partner_id, source_type, created_at desc)
(partner_id, reference)
```

Search can start with `ILIKE`, but if data volume is high use trigram/full-text indexes over ID, reference, customer name snapshot, and source title snapshot.

### 9.2 Transaction Timeline Event

```txt
id
transaction_id
partner_id
title
description
occurred_at
actor_account_id
metadata
```

### 9.3 Payout

```txt
id
partner_id
period_start
period_end
included_volume
fees_adjustments
net_payout
scheduled_date
method_label
status
currency
provider_payout_id
created_at
updated_at
```

Join table:

```txt
payout_transaction
payout_id
transaction_id
partner_id
```

### 9.4 Refund Or Dispute Case

```txt
id
partner_id
transaction_id
case_type
requested_at
amount
currency
reason
owner
status
sla_due_at
created_at
updated_at
```

## 10. Filter Semantics

Apply filters as follows:

- Transaction list uses `createdAt`.
- Payout list uses `scheduledDate`.
- Refund case list uses `requestedAt`.
- Summary and trend use transaction `createdAt`, plus refund case `requestedAt` for refund exposure.
- `period` applies a relative lower bound when `startDate` is absent.
- `startDate` and `endDate` override or narrow the selected period. Prefer the stricter range if both are provided.
- `currency` filters all money rows to one currency. If omitted, default to the partner settlement currency. Avoid summing multiple currencies into one total.

Supported UI filters:

```txt
search
startDate
endDate
sourceType
transactionType
transactionStatus
settlementStatus
payoutStatus
currency
```

## 11. State Transition Rules

Transaction lifecycle:

```txt
pending -> paid
pending -> failed
pending -> canceled
paid -> refunded
paid -> canceled only if payment is voided before capture
failed and canceled are terminal for partner UI actions
```

Settlement lifecycle:

```txt
unsettled -> scheduled -> settled
unsettled -> held
scheduled -> held
held -> scheduled
held -> settled only with explicit finance override
settled is terminal unless finance reversal creates an adjustment transaction
```

Payout lifecycle:

```txt
notAssigned -> inPayout -> paidOut
inPayout -> failed
failed -> inPayout on retry
paidOut is terminal
```

Refund case lifecycle:

```txt
pending -> underReview -> approved
pending -> underReview -> rejected
pending -> approved
pending -> rejected
approved and rejected are terminal
```

Every mutation must be idempotent where possible. Replaying an approve/reject/retry request should not create duplicate refund transactions, duplicate payout attempts, or duplicate timeline spam.

## 12. Error Contract

Use the backend's existing standard error body. At minimum expose:

```ts
{
  statusCode: number;
  message: string | string[];
  error?: string;
  traceId?: string;
}
```

Expected statuses:

- `400`: invalid query, invalid date range, invalid enum, invalid transition.
- `401`: unauthenticated.
- `403`: authenticated user is not a partner.
- `404`: record not found in partner scope.
- `409`: stale state or transition conflict, for example retrying a payout that is no longer failed.
- `422`: business validation failed, for example refund amount exceeds refundable balance.

## 13. OpenAPI And Frontend Integration

Backend must add Swagger decorators so `admin_openapi` generation produces typed APIs.

Expected generated frontend API groups:

- `PartnerTransactionsApi`
- `PartnerPayoutsApi`
- `PartnerRefundCasesApi`

After backend OpenAPI is updated, frontend work should:

- Add new `ApiService` fields for those generated APIs if needed.
- Replace `TransactionsRemoteDataSourceImpl` mock logic with generated API calls.
- Map page/limit response data to `startingAt`/`count` table requests.
- Use `meta.total` for table row counts instead of fetching the first 1000 rows.
- Keep the mock datasource only behind a feature flag or test override.

## 14. Example Responses

### 14.1 Summary

```json
{
  "grossVolume": 2700000,
  "netSettled": 950600,
  "pendingPayout": 2619000,
  "refundExposure": 700000,
  "availableBalance": 250600,
  "pendingBalance": 2619000,
  "currency": "VND",
  "nextPayoutAt": "2026-04-10T03:00:00.000Z",
  "payoutMethod": "Vietcombank ending 1122",
  "payoutStatus": "inPayout"
}
```

### 14.2 Transaction Page

```json
{
  "data": [
    {
      "id": "txn_240401_001",
      "createdAt": "2026-04-08T02:15:00.000Z",
      "type": "charge",
      "sourceType": "serviceBooking",
      "reference": "BK-240408-001",
      "customerName": "Nguyen Minh Anh",
      "grossAmount": 1200000,
      "feeAmount": 36000,
      "netAmount": 1164000,
      "currency": "VND",
      "status": "paid",
      "settlementStatus": "settled",
      "payoutStatus": "inPayout",
      "paymentMethod": "MoMo Wallet",
      "sourceTitle": "Dermatology consultation package",
      "sourceSubtitle": "Confirmed service booking",
      "timeline": [
        {
          "title": "Payment captured",
          "description": "Customer successfully paid through MoMo.",
          "occurredAt": "2026-04-08T02:16:00.000Z"
        }
      ],
      "flaggedForReview": false,
      "notes": null,
      "payoutId": "po_240409_001"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 42,
    "totalPages": 5
  }
}
```

## 15. Acceptance Criteria

Backend is ready for frontend integration when:

- Partner can load summary, trend, transaction list, payout list, refund case list, and transaction detail from real APIs.
- Each list endpoint returns stable pagination metadata with correct totals.
- Filtering works for all current UI filters.
- Search matches the current mock behavior.
- Transaction detail returns payout and refund/dispute associations in one call.
- Mark settled updates settlement status, payout eligibility, timeline, and audit log.
- Flag review updates the transaction and timeline.
- Retry payout only works for failed payouts and does not duplicate payout transaction links.
- Approve/reject refund case updates the case, linked transaction state, timeline, and audit log.
- Partner scoping is enforced in every read and mutation.
- OpenAPI generation succeeds and exposes typed DTOs for Flutter.
- Unit tests cover aggregations, filtering, and state transitions.
- E2E tests cover happy path, cross-partner access denial, invalid transition, and pagination totals.

## 16. Backend Test Plan

Unit tests:

- `getFinanceSummary` calculates gross, net settled, pending payout, refund exposure, available balance, and next payout.
- `getFinanceTrend` returns one sorted daily bucket per day with zero-filled missing days.
- Transaction filters combine search, dates, source, type, status, settlement, payout, and currency.
- Payout filters combine search, dates, payout status, and currency.
- Refund case filters combine search, dates, and currency.
- State transition handlers reject invalid terminal-state operations.

Integration tests:

- Seed two partners and confirm partner A cannot access partner B finance records.
- Seed transactions across several dates and verify pagination totals.
- Approve refund case and verify linked transaction becomes held/refunded as expected.
- Reject refund case and verify held settlement release behavior when applicable.
- Retry failed payout and verify idempotency on repeated request.

E2E tests:

- `GET /v1/partner/transactions/finance/summary`
- `GET /v1/partner/transactions/finance/trend`
- `GET /v1/partner/transactions`
- `GET /v1/partner/transactions/:transactionId`
- `PATCH /v1/partner/transactions/:transactionId/settlement`
- `PATCH /v1/partner/transactions/:transactionId/review-flag`
- `GET /v1/partner/payouts`
- `POST /v1/partner/payouts/:payoutId/retry`
- `GET /v1/partner/refund-cases`
- `POST /v1/partner/refund-cases/:caseId/approve`
- `POST /v1/partner/refund-cases/:caseId/reject`

## 17. Implementation Sequence

1. Add DTOs and Swagger decorators.
2. Add read-only list/detail/summary/trend handlers using existing finance data.
3. Add database indexes or read-model optimization for partner/date/status filters.
4. Add mutation handlers for settle, review flag, retry payout, approve refund, and reject refund.
5. Add unit and integration tests.
6. Regenerate OpenAPI client.
7. Wire Flutter datasource to generated APIs.
8. Run frontend table, detail, filter, and CSV export smoke tests.

## 18. Open Questions For Backend

- What is the canonical ledger table/entity for partner finance records?
- Are product order payments already represented in the same ledger as service booking payments?
- Should partner users be allowed to approve/reject refunds directly, or should these actions request finance review only?
- Is `mark settled` a real partner permission, or should this be admin/finance-only in production?
- Should multi-currency partners be supported in one summary, or should the API require a single currency?
- Which timezone defines partner business days for daily trend buckets?
- Does payout retry create a new payout attempt record or mutate the existing payout row?

Until these are decided, implement read endpoints first and protect mutation endpoints behind the backend's existing permission policy.
