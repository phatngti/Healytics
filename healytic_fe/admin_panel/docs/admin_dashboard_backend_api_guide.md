# Admin Dashboard Backend API Guide

## Purpose

This document defines the independent backend API contract for the admin dashboard feature at:

- Frontend feature: `lib/features/admin/dashboard`
- Frontend mode today: mock-first
- Future integration target: dedicated `AdminDashboardApi`

The dashboard must not hydrate itself from existing admin partner/category/notification APIs. It needs a standalone analytics surface so the backend can refactor independently without leaking other admin modules into the dashboard contract.

## Base Contract

- Namespace: `/admin/dashboard`
- Auth: bearer JWT
- Role: admin only
- Content type: `application/json`
- Time zone for aggregation:
  - store and compute in UTC on the backend
  - return ISO timestamps in UTC
  - frontend will render in local time

## Period Enum

All period-bound endpoints use the same query param:

- `period=7d`
- `period=30d`
- `period=90d`

If omitted, backend should default to `30d`.

## Endpoints

### 1. `GET /admin/dashboard/overview?period=`

Top-level KPI payload for the dashboard cards and finance summary.

Example response:

```json
{
  "grossRevenue": 1642000000,
  "netRevenue": 1514800000,
  "refundAmount": 38400000,
  "failedPaymentAmount": 19100000,
  "averageBookingValue": 307400,
  "successfulTransactions": 5541,
  "pendingTransactions": 121,
  "refundedTransactions": 132,
  "failedTransactions": 74,
  "canceledTransactions": 150,
  "totalPartners": 428,
  "pendingPartnerReviews": 24,
  "bookingSuccessRate": 91.47,
  "bookingFailedRate": 2.50,
  "bookingCanceledRate": 6.03,
  "notificationVolume": 18
}
```

### 2. `GET /admin/dashboard/revenue-trend?period=`

Daily trend data for the revenue chart.

Example response:

```json
[
  {
    "date": "2026-04-01T00:00:00.000Z",
    "grossRevenue": 52200000,
    "netRevenue": 47900000,
    "refundAmount": 1100000,
    "transactionCount": 162,
    "successfulBookingCount": 149
  }
]
```

Rules:

- Sorted ascending by `date`
- One row per day
- Missing days must be zero-filled

### 3. `GET /admin/dashboard/booking-outcomes?period=`

Booking outcome distribution used by the outcome panel.

Example response:

```json
{
  "totalBookings": 5840,
  "success": {
    "count": 5342,
    "rate": 91.47
  },
  "failed": {
    "count": 146,
    "rate": 2.50
  },
  "canceled": {
    "count": 352,
    "rate": 6.03
  }
}
```

### 4. `GET /admin/dashboard/transaction-health?period=`

Transaction/payment state distribution.

Example response:

```json
{
  "totalTransactions": 6018,
  "paid": 5541,
  "pending": 121,
  "refunded": 132,
  "failed": 74,
  "canceled": 150,
  "grossRevenue": 1642000000,
  "refundAmount": 38400000,
  "failedAmount": 19100000
}
```

### 5. `GET /admin/dashboard/top-partners?period=&limit=&sortBy=`

Partner leaderboard.

Allowed values:

- `limit`: integer, default `5`
- `sortBy`: `revenue` or `bookings`, default `revenue`

Example response:

```json
[
  {
    "partnerId": "partner-calm-lotus",
    "partnerName": "Calm Lotus Clinic",
    "rank": 1,
    "grossRevenue": 248000000,
    "bookingCount": 812,
    "successfulBookingRate": 94.3,
    "verificationStatus": "APPROVED"
  }
]
```

### 6. `GET /admin/dashboard/top-services?period=&limit=&sortBy=`

Service leaderboard.

Allowed values:

- `limit`: integer, default `5`
- `sortBy`: `revenue` or `bookings`, default `revenue`

Example response:

```json
[
  {
    "serviceId": "service-deep-relief",
    "serviceName": "Deep Relief Massage",
    "categoryName": "Massage Therapy",
    "partnerName": "Calm Lotus Clinic",
    "rank": 1,
    "grossRevenue": 115000000,
    "bookingCount": 372
  }
]
```

### 7. `GET /admin/dashboard/notifications?limit=`

Recent dashboard notification summary.

Example response:

```json
[
  {
    "id": "notif-1",
    "title": "Payment failures trending above baseline",
    "body": "Card and bank transfer retries spiked 18% in the last 24 hours.",
    "createdAt": "2026-04-11T09:12:00.000Z",
    "type": "PAYMENT",
    "priority": "HIGH",
    "isRead": false,
    "isBroadcast": true
  }
]
```

Allowed enum values:

- `type`: `BROADCAST`, `PAYMENT`, `REVIEW`, `CATEGORY`, `OPERATIONS`
- `priority`: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`

### 8. `GET /admin/dashboard/category-health`

Category cleanup and coverage summary.

Example response:

```json
{
  "totalCategories": 32,
  "activeCategories": 27,
  "inactiveCategories": 5,
  "emptyCategories": 3,
  "totalMappedServices": 186,
  "topCategories": [
    {
      "id": "cat-massage",
      "name": "Massage Therapy",
      "serviceCount": 28,
      "isActive": true
    }
  ]
}
```

## Recommended DTOs

Recommended OpenAPI DTO names:

- `AdminDashboardOverviewDto`
- `AdminRevenueTrendPointDto`
- `AdminBookingOutcomeSummaryDto`
- `AdminOutcomeMetricDto`
- `AdminTransactionHealthDto`
- `AdminPartnerRankingItemDto`
- `AdminServiceRankingItemDto`
- `AdminDashboardNotificationDto`
- `AdminCategoryHealthDto`
- `AdminCategorySnapshotDto`

## Aggregation Rules

These rules must be documented in backend code comments and OpenAPI descriptions. The frontend depends on the semantics being stable.

### Booking outcome mapping

Backend must explicitly define which booking statuses map into:

- `success`
- `failed`
- `canceled`

Recommended approach:

- `success`: successfully completed or operationally successful bookings
- `failed`: payment, checkout, or booking flow failure states
- `canceled`: user-, provider-, or admin-canceled bookings

Do not mix `failed` and `canceled`.

### Transaction health mapping

Backend must explicitly define which payment/ledger statuses map into:

- `paid`
- `pending`
- `refunded`
- `failed`
- `canceled`

### Revenue semantics

These fields must remain consistent across every endpoint:

- `grossRevenue`: pre-refund, pre-deduction gross captured value
- `netRevenue`: post-refund/post-adjustment net recognized value
- `refundAmount`: total refunded value
- `failedPaymentAmount`: attempted value tied to failed payment states

### Ranking semantics

Partner and service ranking must declare whether `grossRevenue` is based on:

- all captured transactions
- only completed bookings
- net settled amounts

Recommended default:

- ranking metric uses gross revenue from successful/captured marketplace transactions in the selected period

## Backend Implementation Notes

- Use database-side aggregation, not N+1 application loops.
- Trend endpoint must zero-fill dates.
- Ranking endpoints must support `limit`.
- Every period-bound query should share the same date-range helper.
- Endpoint behavior on no data:
  - return zeroed payloads or empty lists
  - do not return 500 for empty windows

## Error Handling

- Invalid `period` or `sortBy`: `400`
- Unauthorized: `401`
- Forbidden non-admin: `403`
- Unknown internal failure: `500`

## OpenAPI Integration Steps

1. Add the new `/admin/dashboard/*` endpoints to the backend OpenAPI spec.
2. Generate the frontend client in `admin_panel/openapi`.
3. Add `AdminDashboardApi` to `lib/core/services/api.service.dart`.
4. Replace `UnimplementedError('Admin dashboard API not integrated yet')` in:
   - `lib/features/admin/dashboard/datasource/admin_dashboard_remote.datasource.dart`
5. Keep all domain entities and presentation widgets unchanged unless the API contract intentionally changes.

## Frontend Files Depending on This Contract

- `lib/features/admin/dashboard/datasource/admin_dashboard_remote.datasource.dart`
- `lib/features/admin/dashboard/domain/`
- `lib/features/admin/dashboard/presentation/providers/admin_dashboard.provider.dart`
- `lib/features/admin/dashboard/presentation/widgets/`

The frontend is already structured so only the real datasource implementation should change during integration.
