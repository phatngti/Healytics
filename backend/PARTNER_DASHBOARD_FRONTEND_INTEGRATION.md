# Partner Dashboard — Frontend Integration Guide

> **Audience**: Frontend team (`admin_panel`)
> **Backend Status**: ✅ Implemented and deployed
> **Base URL**: `GET /v1/partner/dashboard/...`
> **Auth**: JWT Bearer token with `HEALTH_PARTNER` role

---

## Table of Contents

1. [API Endpoints Overview](#1-api-endpoints-overview)
2. [Authentication](#2-authentication)
3. [Request/Response Contracts](#3-requestresponse-contracts)
4. [OpenAPI Codegen](#4-openapi-codegen)
5. [Data Source Integration](#5-data-source-integration)
6. [Error Handling](#6-error-handling)
7. [Enums & Constants](#7-enums--constants)

---

## 1. API Endpoints Overview

| # | Method | Path | Query Params | Response Type | Description |
|---|--------|------|-------------|---------------|-------------|
| 1 | `GET` | `/v1/partner/dashboard/stats` | `period?` | `DashboardStatsResponseDto` | Aggregated KPI stats |
| 2 | `GET` | `/v1/partner/dashboard/revenue` | `period?` | `RevenueDataPointDto[]` | Revenue time-series for chart |
| 3 | `GET` | `/v1/partner/dashboard/appointments/upcoming` | `limit?` | `UpcomingAppointmentDto[]` | Next N upcoming appointments |
| 4 | `GET` | `/v1/partner/dashboard/services/performance` | — | `ServicePerformanceDto[]` | Per-service metrics |
| 5 | `GET` | `/v1/partner/dashboard/employees/distribution` | — | `EmployeeDistributionDto[]` | Employee role/status breakdown |
| 6 | `GET` | `/v1/partner/dashboard/reviews/recent` | `limit?` | `DashboardReviewDto[]` | Latest customer reviews |
| 7 | `GET` | `/v1/partner/dashboard/staff/schedule` | `date` (required) | `StaffScheduleEntryDto[]` | Staff schedule for a date |
| 8 | `GET` | `/v1/partner/dashboard/notifications` | `limit?` | `DashboardNotificationDto[]` | Dashboard notifications |
| 9 | `GET` | `/v1/partner/dashboard/inventory/alerts` | — | `InventoryAlertDto[]` | Inventory alerts (empty for now) |

---

## 2. Authentication

All endpoints require a valid JWT token with `HEALTH_PARTNER` role.

```http
GET /v1/partner/dashboard/stats HTTP/1.1
Host: api.healytics.vn
Authorization: Bearer <jwt_token>
```

The backend automatically resolves the partner from `accountId` in the JWT payload — **no need to send `partnerId`** in the request.

---

## 3. Request/Response Contracts

### 3.1 Query Parameters

#### `period` (used by `/stats` and `/revenue`)

| Value | Description | Revenue Granularity |
|-------|-------------|-------------------|
| `today` | Current day only | Hourly buckets |
| `this_week` | Monday → Sunday | Daily buckets |
| `this_month` | 1st → last day (**default**) | Daily buckets |
| `this_quarter` | Quarter start → end | Weekly buckets |
| `this_year` | Jan 1 → Dec 31 | Monthly buckets |

```
GET /v1/partner/dashboard/stats?period=this_week
GET /v1/partner/dashboard/revenue?period=this_quarter
```

If omitted, defaults to `this_month`.

#### `limit` (used by `/appointments/upcoming`, `/reviews/recent`, `/notifications`)

| Param | Type | Range | Default |
|-------|------|-------|---------|
| `limit` | `int` | 1–50 | 5 (appointments/reviews), 10 (notifications) |

```
GET /v1/partner/dashboard/appointments/upcoming?limit=10
```

#### `date` (used by `/staff/schedule` — **required**)

| Param | Type | Format | Example |
|-------|------|--------|---------|
| `date` | `string` | ISO 8601 date | `2026-04-09` |

```
GET /v1/partner/dashboard/staff/schedule?date=2026-04-09
```

---

### 3.2 Response Shapes

#### `GET /stats` → `DashboardStatsResponseDto`

```json
{
  "totalAppointments": 342,
  "completedAppointments": 285,
  "cancelledAppointments": 18,
  "pendingAppointments": 39,
  "totalRevenue": 48750000,
  "revenueGrowthPercent": 12.5,
  "totalServices": 24,
  "activeServices": 18,
  "totalEmployees": 15,
  "activeEmployees": 12,
  "averageRating": 4.7,
  "totalReviews": 156
}
```

**Field notes:**
- `totalRevenue` — in VND (integer or decimal)
- `revenueGrowthPercent` — percentage change vs previous period of equal duration. `0` if no previous data.
- `pendingAppointments` — includes both `PENDING_PAYMENT` and `CONFIRMED` bookings
- `cancelledAppointments` — includes both `CANCELLED` and `NO_SHOW` bookings

---

#### `GET /revenue` → `RevenueDataPointDto[]`

```json
[
  { "date": "2026-04-01T00:00:00.000Z", "revenue": 1500000 },
  { "date": "2026-04-02T00:00:00.000Z", "revenue": 2300000 },
  { "date": "2026-04-03T00:00:00.000Z", "revenue": 0 },
  ...
]
```

**Key behavior:**
- ✅ **Zero-filled** — Missing time buckets are filled with `revenue: 0` so the chart renders continuously
- The `date` granularity depends on `period` (see table in §3.1)
- Times are in UTC ISO 8601 format

---

#### `GET /appointments/upcoming` → `UpcomingAppointmentDto[]`

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "patientName": "Nguyễn Văn An",
    "serviceName": "Full Body Massage",
    "employeeName": "Dr. Trần Minh",
    "scheduledAt": "2026-04-09T09:00:00.000Z",
    "status": "confirmed"
  }
]
```

**Status mapping:**
| Backend `BookingStatus` | Response `status` |
|------------------------|-------------------|
| `CONFIRMED` | `"confirmed"` |
| `PENDING_PAYMENT` | `"pending"` |

> Only future bookings are returned, ordered by `scheduledAt` ascending.

---

#### `GET /services/performance` → `ServicePerformanceDto[]`

```json
[
  {
    "serviceName": "Full Body Massage",
    "bookingCount": 85,
    "revenue": 12750000,
    "averageRating": 4.8
  }
]
```

- Only **active** services are included
- Ordered by `bookingCount` descending (most popular first)
- `averageRating` is from treatment reviews only

---

#### `GET /employees/distribution` → `EmployeeDistributionDto[]`

```json
[
  { "role": "Doctor", "count": 4, "status": "active" },
  { "role": "Spa Therapist", "count": 3, "status": "active" },
  { "role": "Receptionist", "count": 2, "status": "active" },
  { "role": "Manager", "count": 1, "status": "active" },
  { "role": "On Leave", "count": 2, "status": "on_leave" }
]
```

**Chart logic:**
- Active employees are grouped by **role** with human-readable labels
- All on-leave employees are collapsed into a single **"On Leave"** segment
- **Inactive** employees are excluded from the donut chart entirely

---

#### `GET /reviews/recent` → `DashboardReviewDto[]`

```json
[
  {
    "reviewerName": "Nguyễn Văn Hùng",
    "avatarUrl": null,
    "rating": 5,
    "status": "published",
    "date": "2026-04-09T12:00:00.000Z",
    "text": "Dịch vụ tuyệt vời! Nhân viên rất chuyên nghiệp.",
    "imageUrls": []
  }
]
```

- Combines **treatment reviews** AND **specialist reviews** sorted by date DESC
- `avatarUrl` may be `null` — show a fallback avatar
- `imageUrls` may be empty `[]`

---

#### `GET /staff/schedule` → `StaffScheduleEntryDto[]`

```json
[
  {
    "employeeId": "550e8400-e29b-41d4-a716-446655440000",
    "employeeName": "Dr. Trần Minh",
    "role": "Doctor",
    "startTime": "2026-04-09T08:00:00.000Z",
    "endTime": "2026-04-09T09:00:00.000Z",
    "serviceName": "General Consultation",
    "patientName": "Nguyễn Văn An"
  }
]
```

- Ordered by `employeeName ASC`, then `startTime ASC`
- Only `CONFIRMED` and `COMPLETED` bookings are included
- `patientName` may be `null` if user profile is missing
- `endTime` falls back to `startTime` if booking has no end time

---

#### `GET /notifications` → `DashboardNotificationDto[]`

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "New Appointment",
    "message": "Nguyễn Văn An booked a Full Body Massage.",
    "type": "appointment",
    "createdAt": "2026-04-09T08:45:00.000Z",
    "isRead": false
  }
]
```

**Type mapping from backend `NotificationType`:**

| Backend Types | Dashboard `type` |
|--------------|-----------------|
| `booking_confirmed`, `booking_cancelled`, `booking_completed`, `appointment_reminder`, `appointment_updated` | `"appointment"` |
| `payment_success`, `payment_failed`, `new_chat_message`, `system_broadcast`, `system_maintenance` | `"system"` |
| `partner_verified`, `partner_rejected` | `"alert"` |

- Includes both **targeted** and **broadcast** notifications
- `isRead` correctly handles per-user read tracking for broadcasts

---

#### `GET /inventory/alerts` → `InventoryAlertDto[]`

```json
[]
```

> ⚠️ **Currently returns an empty array.** The inventory feature is planned but the database table doesn't exist yet. The frontend should handle this gracefully (show "No alerts" state).

When implemented, the shape will be:
```json
[
  {
    "id": "uuid",
    "productName": "Essential Oil — Lavender",
    "alertType": "low_stock",
    "message": "Only 3 units remaining. Reorder threshold: 10.",
    "createdAt": "2026-04-09T06:00:00.000Z",
    "severity": "warning"
  }
]
```

| `alertType` | Description |
|------------|-------------|
| `low_stock` | Stock below reorder threshold |
| `expiring` | Expires within 7 days |
| `out_of_stock` | Zero units remaining |

| `severity` | UI Treatment |
|-----------|-------------|
| `info` | Blue/neutral |
| `warning` | Yellow/orange |
| `critical` | Red |

---

## 4. OpenAPI Codegen

After the backend is running, regenerate the OpenAPI client:

```bash
# From the admin_panel directory
# The spec is auto-generated at http://localhost:8080/api/docs-json

# Step 1: Export the spec
curl http://localhost:8080/api/docs-json > openapi/openapi.json

# Step 2: Run the OpenAPI generator
# (Use your project's existing codegen script)
```

### Generated API Class

The codegen will produce a `PartnerDashboardApi` class with methods matching the controller's `@ApiOperation` names:

| Controller Method | Generated Dart Method |
|------------------|----------------------|
| `getStats` | `partnerDashboardControllerGetStats(period?)` |
| `getRevenue` | `partnerDashboardControllerGetRevenue(period?)` |
| `getUpcomingAppointments` | `partnerDashboardControllerGetUpcomingAppointments(limit?)` |
| `getServicePerformance` | `partnerDashboardControllerGetServicePerformance()` |
| `getEmployeeDistribution` | `partnerDashboardControllerGetEmployeeDistribution()` |
| `getRecentReviews` | `partnerDashboardControllerGetRecentReviews(limit?)` |
| `getStaffSchedule` | `partnerDashboardControllerGetStaffSchedule(date)` |
| `getNotifications` | `partnerDashboardControllerGetNotifications(limit?)` |
| `getInventoryAlerts` | `partnerDashboardControllerGetInventoryAlerts()` |

---

## 5. Data Source Integration

### Remote Data Source Pattern

Follow the project's **3-Part Data Source** pattern:

```dart
// 1. Interface
abstract class DashboardRemoteDataSource {
  Future<DashboardStats> getDashboardStats({String? period});
  Future<List<RevenueDataPoint>> getRevenueData({String? period});
  Future<List<UpcomingAppointment>> getUpcomingAppointments({int? limit});
  Future<List<ServicePerformance>> getServicePerformance();
  Future<List<EmployeeDistribution>> getEmployeeDistribution();
  Future<List<DashboardReview>> getRecentReviews({int? limit});
  Future<List<StaffScheduleEntry>> getStaffSchedule({required String date});
  Future<List<DashboardNotification>> getNotifications({int? limit});
  Future<List<InventoryAlert>> getInventoryAlerts();
}

// 2. Implementation (uses generated OpenAPI client)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final PartnerDashboardApi _api;

  DashboardRemoteDataSourceImpl(this._api);

  @override
  Future<DashboardStats> getDashboardStats({String? period}) async {
    final dto = await _api.partnerDashboardControllerGetStats(period: period);
    return _mapStatsDto(dto);
  }

  @override
  Future<List<RevenueDataPoint>> getRevenueData({String? period}) async {
    final dtos = await _api.partnerDashboardControllerGetRevenue(period: period);
    return dtos.map(_mapRevenueDto).toList();
  }

  // ... other methods follow the same pattern
}

// 3. Mock (for development before backend is ready)
class DashboardMockDataSourceImpl implements DashboardRemoteDataSource {
  // Return hardcoded test data
}
```

### Defensive DTO-to-Entity Mapping

Always use null-coalescing for every field:

```dart
DashboardStats _mapStatsDto(DashboardStatsResponseDto dto) {
  return DashboardStats(
    totalAppointments: dto.totalAppointments ?? 0,
    completedAppointments: dto.completedAppointments ?? 0,
    cancelledAppointments: dto.cancelledAppointments ?? 0,
    pendingAppointments: dto.pendingAppointments ?? 0,
    totalRevenue: (dto.totalRevenue ?? 0).toDouble(),
    revenueGrowthPercent: (dto.revenueGrowthPercent ?? 0).toDouble(),
    totalServices: dto.totalServices ?? 0,
    activeServices: dto.activeServices ?? 0,
    totalEmployees: dto.totalEmployees ?? 0,
    activeEmployees: dto.activeEmployees ?? 0,
    averageRating: (dto.averageRating ?? 0).toDouble(),
    totalReviews: dto.totalReviews ?? 0,
  );
}

RevenueDataPoint _mapRevenueDto(RevenueDataPointDto dto) {
  return RevenueDataPoint(
    date: DateTime.tryParse(dto.date ?? '') ?? DateTime.now(),
    revenue: (dto.revenue ?? 0).toDouble(),
  );
}

UpcomingAppointment _mapAppointmentDto(UpcomingAppointmentDto dto) {
  return UpcomingAppointment(
    id: dto.id ?? '',
    patientName: dto.patientName ?? 'Unknown',
    serviceName: dto.serviceName ?? 'Unknown Service',
    employeeName: dto.employeeName ?? 'Unknown',
    scheduledAt: DateTime.tryParse(dto.scheduledAt ?? '') ?? DateTime.now(),
    status: dto.status ?? 'pending',
  );
}
```

---

## 6. Error Handling

| HTTP Status | Meaning | Frontend Action |
|------------|---------|----------------|
| `200` | Success | Parse response body |
| `401` | JWT expired / invalid | Redirect to login |
| `403` | Wrong role (not HEALTH_PARTNER) | Show access denied |
| `404` | Partner profile not found | Show "Complete your profile" |
| `422` | Validation error (bad query params) | Show validation message |
| `500` | Server error | Show generic error + retry |

### Common 404 Scenario

If the authenticated user has a `HEALTH_PARTNER` role but hasn't completed partner registration, the `getPartnerProfile()` call will throw `404 Partner profile not found`. The frontend should handle this and redirect to the registration/onboarding flow.

---

## 7. Enums & Constants

### DashboardTimePeriod

```dart
enum DashboardTimePeriod {
  today('today'),
  thisWeek('this_week'),
  thisMonth('this_month'),
  thisQuarter('this_quarter'),
  thisYear('this_year');

  final String value;
  const DashboardTimePeriod(this.value);
}
```

### Appointment Status

```dart
enum AppointmentDisplayStatus {
  confirmed('confirmed'),
  pending('pending');

  final String value;
  const AppointmentDisplayStatus(this.value);
}
```

### Notification Type

```dart
enum DashboardNotificationType {
  appointment('appointment'),
  review('review'),
  system('system'),
  alert('alert');

  final String value;
  const DashboardNotificationType(this.value);
}
```

### Inventory Alert Severity

```dart
enum AlertSeverity {
  info('info'),
  warning('warning'),
  critical('critical');

  final String value;
  const AlertSeverity(this.value);
}
```

---

## Appendix: Quick cURL Tests

```bash
# Set your JWT token
TOKEN="your_jwt_token_here"

# Stats
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/v1/partner/dashboard/stats

# Revenue (quarterly)
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/partner/dashboard/revenue?period=this_quarter"

# Upcoming appointments (top 10)
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/partner/dashboard/appointments/upcoming?limit=10"

# Service performance
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/v1/partner/dashboard/services/performance

# Employee distribution
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/v1/partner/dashboard/employees/distribution

# Recent reviews
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/partner/dashboard/reviews/recent?limit=5"

# Staff schedule (specific date)
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/partner/dashboard/staff/schedule?date=2026-04-09"

# Notifications
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/partner/dashboard/notifications?limit=10"

# Inventory alerts
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/v1/partner/dashboard/inventory/alerts
```
