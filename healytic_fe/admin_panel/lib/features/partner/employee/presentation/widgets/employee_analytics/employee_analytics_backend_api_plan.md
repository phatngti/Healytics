# Employee Analytics Backend API Implementation Plan

This plan covers the backend APIs needed by:

- `employee_overview_analytics.widget.dart`
- `employee_detail_analytics.widget.dart`
- `employee_analytics.entity.dart`
- `employee_analytics.provider.dart`
- `employee_analytics_remote.datasource.dart`

The current frontend builds employee analytics locally from employee records. The backend should provide first-class partner-scoped analytics endpoints, following the existing NestJS architecture used by `health-service` analytics.

## 1. Existing Backend Pattern To Follow

Use the same structure already implemented for partner health service analytics:

- Controller pattern: `src/health-service/partner-health-service.controller.ts`
- Query DTO pattern: `src/health-service/dto/partner/health-service-analytics-query.dto.ts`
- Handler pattern:
  - `src/health-service/application/handlers/get-overview-analytics.handler.ts`
  - `src/health-service/application/handlers/get-detail-analytics.handler.ts`
- Date range helpers:
  - `src/dashboard-partner/helpers/date-range.helper.ts`
  - `src/dashboard-partner/dto/query/dashboard-period-query.dto.ts`
- Auth scoping:
  - `@PartnerApi('employees')`
  - `@CurrentUser('id') userId`
  - `EmployeesService.getPartnerIdByAccountId(userId)`

Do not create public or admin endpoints for this first version. These are partner dashboard APIs only.

## 2. Required Endpoints

### 2.1 Employee Overview Analytics

Add this endpoint before `@Get(':id')` in `PartnerEmployeesController` so the `analytics/overview` route is not captured by the `:id` route.

```ts
GET /v1/partner/employees/analytics/overview?period=this_month
Authorization: Bearer <partner-token>
```

Controller method:

```ts
@Get('analytics/overview')
@ApiOperation({ summary: 'Get employee overview analytics' })
@ApiOkResponse({ type: EmployeeOverviewAnalyticsResponseDto })
getOverviewAnalytics(
  @CurrentUser('id') userId: string,
  @Query() query: EmployeeAnalyticsQueryDto,
): Promise<EmployeeOverviewAnalyticsResponseDto> {
  return this.employeesService.getOverviewAnalytics(
    userId,
    query.period ?? DashboardTimePeriod.THIS_MONTH,
  );
}
```

### 2.2 Employee Detail Analytics

Add this endpoint before `@Get(':id')`.

```ts
GET /v1/partner/employees/analytics/:employeeId?period=this_month
Authorization: Bearer <partner-token>
```

Controller method:

```ts
@Get('analytics/:employeeId')
@ApiOperation({ summary: 'Get per-employee detail analytics' })
@ApiOkResponse({ type: EmployeeDetailAnalyticsResponseDto })
@ApiNotFoundResponse({ description: 'Employee not found.' })
getDetailAnalytics(
  @CurrentUser('id') userId: string,
  @Param('employeeId', ParseUUIDPipe) employeeId: string,
  @Query() query: EmployeeAnalyticsQueryDto,
): Promise<EmployeeDetailAnalyticsResponseDto> {
  return this.employeesService.getDetailAnalytics(
    userId,
    employeeId,
    query.period ?? DashboardTimePeriod.THIS_MONTH,
  );
}
```

## 3. Query DTO

Create:

```txt
src/employees/dto/analytics/employee-analytics-query.dto.ts
```

Use the same enum as partner dashboard and health-service analytics.

```ts
import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';

export class EmployeeAnalyticsQueryDto {
  @ApiPropertyOptional({
    enum: DashboardTimePeriod,
    default: DashboardTimePeriod.THIS_MONTH,
    description: 'Time period for employee analytics aggregation',
  })
  @IsOptional()
  @IsEnum(DashboardTimePeriod)
  period?: DashboardTimePeriod = DashboardTimePeriod.THIS_MONTH;
}
```

Supported values must match Flutter `DashboardTimePeriod.value`:

- `today`
- `this_week`
- `this_month`
- `this_quarter`
- `this_year`

## 4. Response DTOs

Create a new folder:

```txt
src/employees/dto/analytics/
```

Use `@ApiProperty`, `@Expose`, and `@Type` like `src/health-service/dto/partner/analytics/*.ts`.

### 4.1 Shared DTOs

Create:

```txt
employee-trend-point.dto.ts
employee-role-distribution.dto.ts
employee-performance-summary.dto.ts
employee-compliance-item.dto.ts
employee-mix-metric.dto.ts
employee-schedule-load.dto.ts
employee-quality-metric.dto.ts
```

DTO fields must match the frontend domain names exactly.

```ts
export class EmployeeTrendPointDto {
  label: string;
  sessions: number;
  contributionValue: number;
}

export class EmployeeRoleDistributionDto {
  role: string;
  count: number;
}

export class EmployeePerformanceSummaryDto {
  employeeName: string;
  roleLabel: string;
  rating: number;
  utilizationRate: number;
  contributionValue: number;
}

export class EmployeeComplianceItemDto {
  title: string;
  detail: string;
  tone: 'neutral' | 'positive' | 'warning' | 'critical';
}

export class EmployeeMixMetricDto {
  label: string;
  value: number;
  share: number;
}

export class EmployeeScheduleLoadDto {
  label: string;
  availableHours: number;
  bookedHours: number;
}

export class EmployeeQualityMetricDto {
  label: string;
  value: string;
  detail: string;
  tone: 'neutral' | 'positive' | 'warning' | 'critical';
}
```

### 4.2 Overview Response DTO

Create:

```txt
employee-overview-analytics.dto.ts
```

```ts
export class EmployeeOverviewAnalyticsResponseDto {
  totalEmployees: number;
  activeEmployees: number;
  onLeaveEmployees: number;
  inactiveEmployees: number;
  utilizationRate: number;
  utilizationDelta: number;
  averageRating: number;
  ratingDelta: number;
  reviewCount: number;
  trendPoints: EmployeeTrendPointDto[];
  roleDistribution: EmployeeRoleDistributionDto[];
  topPerformers: EmployeePerformanceSummaryDto[];
  complianceItems: EmployeeComplianceItemDto[];
}
```

### 4.3 Detail Response DTO

Create:

```txt
employee-detail-analytics.dto.ts
```

```ts
export class EmployeeDetailAnalyticsResponseDto {
  employeeId: string;
  completedSessions: number;
  sessionsDelta: number;
  contributionValue: number;
  contributionDelta: number;
  utilizationRate: number;
  utilizationDelta: number;
  averageRating: number;
  reviewCount: number;
  trendPoints: EmployeeTrendPointDto[];
  mixMetrics: EmployeeMixMetricDto[];
  scheduleLoad: EmployeeScheduleLoadDto[];
  qualityMetrics: EmployeeQualityMetricDto[];
  complianceItems: EmployeeComplianceItemDto[];
}
```

## 5. Backend Files To Add Or Change

Add:

```txt
src/employees/application/handlers/get-employee-overview-analytics.handler.ts
src/employees/application/handlers/get-employee-detail-analytics.handler.ts
src/employees/dto/analytics/employee-analytics-query.dto.ts
src/employees/dto/analytics/employee-overview-analytics.dto.ts
src/employees/dto/analytics/employee-detail-analytics.dto.ts
src/employees/dto/analytics/employee-trend-point.dto.ts
src/employees/dto/analytics/employee-role-distribution.dto.ts
src/employees/dto/analytics/employee-performance-summary.dto.ts
src/employees/dto/analytics/employee-compliance-item.dto.ts
src/employees/dto/analytics/employee-mix-metric.dto.ts
src/employees/dto/analytics/employee-schedule-load.dto.ts
src/employees/dto/analytics/employee-quality-metric.dto.ts
```

Change:

```txt
src/employees/partner-employees.controller.ts
src/employees/employees.service.ts
src/employees/employees.module.ts
```

Optional tests:

```txt
src/employees/application/handlers/get-employee-overview-analytics.handler.spec.ts
src/employees/application/handlers/get-employee-detail-analytics.handler.spec.ts
src/employees/partner-employees.controller.spec.ts
```

## 6. Module Wiring

Update `EmployeesModule`:

- Import `Payment` if handlers use repository injection, or use `DataSource` only.
- Import `SpecialistReview` if using repository injection, or use `DataSource` only.
- Register handlers in `providers`.

Recommended implementation is `DataSource` raw SQL, consistent with health-service analytics handlers, because these endpoints aggregate across bookings, payments, reviews, products, and JSONB fields.

```ts
providers: [
  EmployeesService,
  CreateDoctorHandler,
  CreateTherapistHandler,
  UpdateEmployeeHandler,
  RemoveEmployeeHandler,
  GetEmployeeOverviewAnalyticsHandler,
  GetEmployeeDetailAnalyticsHandler,
]
```

## 7. Service Facades

Update `EmployeesService` constructor:

```ts
private readonly getEmployeeOverviewAnalyticsHandler: GetEmployeeOverviewAnalyticsHandler,
private readonly getEmployeeDetailAnalyticsHandler: GetEmployeeDetailAnalyticsHandler,
```

Add methods:

```ts
async getOverviewAnalytics(
  accountId: string,
  period: DashboardTimePeriod,
): Promise<EmployeeOverviewAnalyticsResponseDto> {
  const partnerId = await this.getPartnerIdByAccountId(accountId);
  return this.getEmployeeOverviewAnalyticsHandler.execute(partnerId, period);
}

async getDetailAnalytics(
  accountId: string,
  employeeId: string,
  period: DashboardTimePeriod,
): Promise<EmployeeDetailAnalyticsResponseDto> {
  const partnerId = await this.getPartnerIdByAccountId(accountId);
  return this.getEmployeeDetailAnalyticsHandler.execute(
    partnerId,
    employeeId,
    period,
  );
}
```

## 8. Database Tables And Fields

Use these tables from `healytics_database_erd.md`:

- `employees`
  - `id`, `full_name`, `role`, `status`, `rating`, `review_count`, `partner_id`
  - `schedule`, `verification_documents`
  - `emergency_contact_phone`
  - `deleted_at`
- `doctor_profiles`
  - `employee_id`, `consultation_fee`, `specializations`
- `therapist_profiles`
  - `employee_id`, `type`, `commission_rate`, `skills`, `device_proficiency`, `health_check_date`
- `bookings`
  - `id`, `staff_id`, `product_id`, `start_time`, `end_time`, `status`, `deleted_at`
- `payments`
  - `booking_id`, `amount`, `payment_status`, `paid_at`, `deleted_at`
- `specialist_reviews`
  - `appointment_id`, `specialist_id`, `rating`, `would_recommend`, `created_at`
- `products`
  - `id`, `partner_id`, `name`, `category_id`, `base_price`, `sale_price`, `deleted_at`
- `categories`
  - `id`, `name`
- `product_employee_eligibility`
  - `product_id`, `employee_id`, `is_primary`

Always filter:

```sql
e.partner_id = $1
AND e.deleted_at IS NULL
```

For booking/revenue analytics, always also enforce partner ownership through employees and/or products:

```sql
b.staff_id = e.id
AND e.partner_id = $1
```

If joining products, also enforce:

```sql
p.partner_id = $1
AND p.deleted_at IS NULL
```

## 9. Date Range Rules

Use:

```ts
const { startDate, endDate, prevStartDate, prevEndDate } = resolveDateRange(period);
const granularity = resolveGranularity(period);
```

Current period:

```sql
b.start_time BETWEEN $2 AND $3
```

Previous period:

```sql
b.start_time BETWEEN $4 AND $5
```

Delta formula should match health-service analytics:

```ts
private delta(current: number, previous: number): number {
  if (previous === 0) {
    return current > 0 ? 100 : 0;
  }
  return Math.round(((current - previous) / previous) * 1000) / 10;
}
```

Round rates to one decimal place:

```ts
private round1(value: number): number {
  return Math.round(value * 10) / 10;
}
```

## 10. Business Definitions

### 10.1 Completed Sessions

For employee analytics, a session is a booking assigned to an employee.

Use completed bookings:

```sql
b.status = 'COMPLETED'
```

### 10.2 Contribution Value

Preferred definition:

- Sum paid/deposited payment amount for bookings completed by the employee during the selected period.
- Payment status must be `PAID` or `DEPOSITED`.
- Use `payments.paid_at` for payment period if analyzing cash collection.
- Use `bookings.start_time` for employee workload period.

For these widgets, use workload period based on `bookings.start_time`, because the charts compare sessions and contribution for employee work delivered in the same bucket.

SQL rule:

```sql
COALESCE(SUM(
  CASE
    WHEN pay.payment_status IN ('PAID', 'DEPOSITED')
    THEN pay.amount
    ELSE 0
  END
), 0)
```

If a booking can have multiple paid payment rows, aggregate payments per booking first to avoid duplicates.

### 10.3 Utilization Rate

Definition:

```txt
utilizationRate = bookedHours / availableHours * 100
```

Booked hours:

- Use completed and confirmed workload in the selected period.
- Include statuses: `COMPLETED`, `CONFIRMED`, `PENDING_PAYMENT`.
- Duration is `bookings.end_time - bookings.start_time` when `end_time` exists.
- If `end_time` is null, fallback to product definition duration if joined, else 30 minutes.

Available hours:

- Source: `employees.schedule` JSONB.
- Each schedule item has `{ day, start, end, isWorking }`.
- Convert `start` and `end` strings into decimal hours.
- Weekly available hours = sum working slot durations.
- Period capacity:
  - `today`: available hours for today's weekday only.
  - `this_week`: weekly available hours.
  - `this_month`: weekly available hours * number of calendar weeks touched by period.
  - `this_quarter`: weekly available hours * number of calendar weeks touched by period.
  - `this_year`: weekly available hours * number of calendar weeks touched by period.

Implementation detail:

- It is acceptable to compute available hours in TypeScript after loading employees because schedule is JSONB.
- Do not hardcode the frontend mock scale values.

### 10.4 Average Rating

Overview:

- Prefer period specialist reviews from `specialist_reviews`.
- Fallback to cached employee ratings only if there are no period specialist reviews.

```sql
SELECT COALESCE(AVG(sr.rating), 0) AS avg_rating, COUNT(*) AS review_count
FROM specialist_reviews sr
JOIN employees e ON e.id = sr.specialist_id
WHERE e.partner_id = $1
  AND e.deleted_at IS NULL
  AND sr.created_at BETWEEN $2 AND $3
```

Detail:

```sql
WHERE sr.specialist_id = $employeeId
```

### 10.5 Role Distribution

Use employee roles and map to UI labels.

Backend enum values:

- `DOCTOR`
- `THERAPIST`
- `RECEPTIONIST`
- `MANAGER`

Recommended labels:

- `DOCTOR` -> `Doctor`
- `THERAPIST` with `therapist_profiles.type = 'SPA'` -> `Spa therapist`
- `THERAPIST` with `therapist_profiles.type = 'MASSAGE'` -> `Massage therapist`
- `THERAPIST` with missing type -> `Therapist`
- `RECEPTIONIST` -> `Receptionist`
- `MANAGER` -> `Manager`

### 10.6 Top Performers

Return top 4 employees sorted by a composite score:

```txt
score = ratingScore * 0.45 + utilizationScore * 0.30 + contributionScore * 0.25
```

Where:

- `ratingScore = averageRating / 5`
- `utilizationScore = min(utilizationRate, 100) / 100`
- `contributionScore = employeeContribution / maxContributionInRoster`

Return:

- `employeeName`
- `roleLabel`
- `rating`
- `utilizationRate`
- `contributionValue`

If there are no bookings yet, sort by cached `employees.rating` and `employees.review_count`.

### 10.7 Compliance Items

Overview compliance items should be simple and actionable:

1. Verification coverage
   - Count employees where `verification_documents` is null or empty.
   - Positive if 0 missing.
   - Warning if 1 or more missing.
2. Emergency readiness
   - Count employees where `emergency_contact_phone` is null or blank.
   - Positive if 0 missing.
   - Critical if 1 or more missing.
3. Active roster readiness
   - Count active employees vs total employees.
   - Positive if at least 80% active.
   - Warning if 50%-79%.
   - Critical if below 50%.

Detail compliance items:

1. Profile status
   - Positive if `status = 'ACTIVE'`.
   - Warning otherwise.
2. Verification posture
   - Positive if verification docs exist.
   - Critical if missing.
3. Emergency readiness
   - Positive if emergency contact exists.
   - Warning if missing.

### 10.8 Detail Mix Metrics

The detail widget shows role-specific delivered work mix.

Preferred source:

- Completed bookings grouped by product/category for this employee during the period.

SQL:

```sql
SELECT
  COALESCE(c.name, p.name, 'Uncategorized') AS label,
  COUNT(*) AS value
FROM bookings b
LEFT JOIN products p ON p.id = b.product_id
LEFT JOIN categories c ON c.id = p.category_id
WHERE b.staff_id = $1
  AND b.start_time BETWEEN $2 AND $3
  AND b.status = 'COMPLETED'
  AND b.deleted_at IS NULL
GROUP BY label
ORDER BY value DESC
LIMIT 6
```

Then compute:

```txt
share = value / totalCompletedSessions
```

Fallback when there are no bookings:

- Doctor: use `doctor_profiles.specializations`.
- Spa therapist: use `therapist_profiles.skills`.
- Massage therapist: use `therapist_profiles.skills`.
- Basic employee: return empty list or `Support tasks` with value 0.

### 10.9 Schedule Load

Return one row per weekday label used by the frontend:

- `Mon`
- `Tue`
- `Wed`
- `Thu`
- `Fri`
- `Sat`
- `Sun`

For each weekday in the selected period:

- `availableHours`: sum scheduled working hours for that day across matching dates in period.
- `bookedHours`: sum booking durations for bookings on that weekday.

This is better than returning only the static schedule because the widget title is "Booked vs available hours".

### 10.10 Quality Metrics

Detail quality metrics:

1. Client sentiment
   - `value`: average rating, formatted as a string like `4.8`
   - `detail`: `<reviewCount> reviews across recent services`
   - Positive when rating >= 4.5
   - Warning when rating < 4.5
2. Recommendation rate
   - Source: `specialist_reviews.would_recommend`
   - `value`: percentage string like `92%`
   - Positive when >= 85%
   - Warning when 70%-84%
   - Critical when < 70%
3. Documentation
   - Positive if verification docs exist
   - Critical if missing

## 11. Overview Handler Query Plan

Create:

```txt
src/employees/application/handlers/get-employee-overview-analytics.handler.ts
```

Constructor:

```ts
constructor(private readonly dataSource: DataSource) {}
```

Main method:

```ts
async execute(
  partnerId: string,
  period: DashboardTimePeriod,
): Promise<EmployeeOverviewAnalyticsResponseDto>
```

Parallel queries:

1. `getRosterStats(partnerId)`
2. `getCurrentWorkload(partnerId, startDate, endDate)`
3. `getPreviousWorkload(partnerId, prevStartDate, prevEndDate)`
4. `getCurrentReviewStats(partnerId, startDate, endDate)`
5. `getPreviousReviewStats(partnerId, prevStartDate, prevEndDate)`
6. `getTrendData(partnerId, period, startDate, endDate)`
7. `getRoleDistribution(partnerId)`
8. `getTopPerformers(partnerId, startDate, endDate)`
9. `getComplianceStats(partnerId)`

### 11.1 Roster Stats

```sql
SELECT
  COUNT(*) AS total,
  COUNT(*) FILTER (WHERE status = 'ACTIVE') AS active,
  COUNT(*) FILTER (WHERE status = 'ON_LEAVE') AS on_leave,
  COUNT(*) FILTER (WHERE status = 'INACTIVE') AS inactive
FROM employees
WHERE partner_id = $1
  AND deleted_at IS NULL
```

### 11.2 Workload And Contribution

```sql
SELECT
  COUNT(*) FILTER (WHERE b.status = 'COMPLETED') AS completed_sessions,
  COALESCE(SUM(
    CASE
      WHEN pay.payment_status IN ('PAID', 'DEPOSITED') THEN pay.amount
      ELSE 0
    END
  ), 0) AS contribution_value,
  COALESCE(SUM(
    EXTRACT(EPOCH FROM (
      COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
    )) / 3600
  ), 0) AS booked_hours
FROM employees e
LEFT JOIN bookings b
  ON b.staff_id = e.id
  AND b.start_time BETWEEN $2 AND $3
  AND b.deleted_at IS NULL
  AND b.status IN ('COMPLETED', 'CONFIRMED', 'PENDING_PAYMENT')
LEFT JOIN payments pay
  ON pay.booking_id = b.id
  AND pay.deleted_at IS NULL
WHERE e.partner_id = $1
  AND e.deleted_at IS NULL
```

Note: if payment joins can duplicate booking rows, aggregate payments by `booking_id` in a subquery first.

### 11.3 Trend Points

Use `resolveGranularity(period)`. Map SQL rows to frontend fields:

- SQL `completed_sessions` -> DTO `sessions`
- SQL `contribution_value` -> DTO `contributionValue`

For `this_month`, it is acceptable to follow health-service and aggregate into `Wk 1` to `Wk 4`. For other periods, use helper formatting logic similar to the health-service handler.

### 11.4 Role Distribution

```sql
SELECT
  e.role,
  tp.type AS therapist_type,
  COUNT(*) AS count
FROM employees e
LEFT JOIN therapist_profiles tp ON tp.employee_id = e.id
WHERE e.partner_id = $1
  AND e.deleted_at IS NULL
GROUP BY e.role, tp.type
ORDER BY count DESC
```

Map to labels in TypeScript.

### 11.5 Compliance Stats

```sql
SELECT
  COUNT(*) FILTER (
    WHERE verification_documents IS NULL
       OR jsonb_array_length(COALESCE(verification_documents, '[]'::jsonb)) = 0
  ) AS missing_docs,
  COUNT(*) FILTER (
    WHERE emergency_contact_phone IS NULL
       OR btrim(emergency_contact_phone) = ''
  ) AS missing_emergency,
  COUNT(*) FILTER (WHERE status = 'ACTIVE') AS active,
  COUNT(*) AS total
FROM employees
WHERE partner_id = $1
  AND deleted_at IS NULL
```

## 12. Detail Handler Query Plan

Create:

```txt
src/employees/application/handlers/get-employee-detail-analytics.handler.ts
```

Main method:

```ts
async execute(
  partnerId: string,
  employeeId: string,
  period: DashboardTimePeriod,
): Promise<EmployeeDetailAnalyticsResponseDto>
```

First verify ownership:

```sql
SELECT
  e.*,
  dp.consultation_fee,
  dp.specializations,
  tp.type AS therapist_type,
  tp.skills,
  tp.device_proficiency,
  tp.commission_rate,
  tp.health_check_date
FROM employees e
LEFT JOIN doctor_profiles dp ON dp.employee_id = e.id
LEFT JOIN therapist_profiles tp ON tp.employee_id = e.id
WHERE e.id = $1
  AND e.partner_id = $2
  AND e.deleted_at IS NULL
```

If not found:

```ts
throw new NotFoundException(`Employee ${employeeId} not found for this partner`);
```

Parallel queries after loading employee:

1. `getSessionStats(employeeId, startDate, endDate)`
2. `getSessionStats(employeeId, prevStartDate, prevEndDate)`
3. `getReviewStats(employeeId, startDate, endDate)`
4. `getTrendData(employeeId, period, startDate, endDate)`
5. `getMixMetrics(employeeId, startDate, endDate)`
6. `getScheduleLoad(employee, employeeId, startDate, endDate)`
7. `getRecommendationStats(employeeId, startDate, endDate)`

### 12.1 Session Stats

```sql
SELECT
  COUNT(*) FILTER (WHERE b.status = 'COMPLETED') AS completed_sessions,
  COALESCE(SUM(
    CASE
      WHEN pay.payment_status IN ('PAID', 'DEPOSITED') THEN pay.amount
      ELSE 0
    END
  ), 0) AS contribution_value,
  COALESCE(SUM(
    EXTRACT(EPOCH FROM (
      COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
    )) / 3600
  ), 0) AS booked_hours
FROM bookings b
LEFT JOIN payments pay
  ON pay.booking_id = b.id
  AND pay.deleted_at IS NULL
WHERE b.staff_id = $1
  AND b.start_time BETWEEN $2 AND $3
  AND b.deleted_at IS NULL
  AND b.status IN ('COMPLETED', 'CONFIRMED', 'PENDING_PAYMENT')
```

### 12.2 Review Stats

```sql
SELECT
  COALESCE(AVG(rating), 0) AS avg_rating,
  COUNT(*) AS review_count,
  COUNT(*) FILTER (WHERE would_recommend = true) AS recommend_count
FROM specialist_reviews
WHERE specialist_id = $1
  AND created_at BETWEEN $2 AND $3
```

### 12.3 Trend Data

```sql
SELECT
  date_trunc($1, b.start_time) AS bucket,
  COUNT(*) FILTER (WHERE b.status = 'COMPLETED') AS sessions,
  COALESCE(SUM(
    CASE
      WHEN pay.payment_status IN ('PAID', 'DEPOSITED') THEN pay.amount
      ELSE 0
    END
  ), 0) AS contribution_value
FROM bookings b
LEFT JOIN payments pay
  ON pay.booking_id = b.id
  AND pay.deleted_at IS NULL
WHERE b.staff_id = $2
  AND b.start_time BETWEEN $3 AND $4
  AND b.deleted_at IS NULL
GROUP BY bucket
ORDER BY bucket ASC
```

Return empty buckets with 0 values so the chart is stable.

### 12.4 Mix Metrics

Use completed bookings grouped by category or product. Return at most 6 items.

If total is 0, use profile metadata fallback as described in section 10.8.

### 12.5 Schedule Load

Recommended TypeScript approach:

1. Parse `employee.schedule`.
2. Generate dates from `startDate` to `endDate`.
3. For each date, find matching schedule item by weekday.
4. Add scheduled hours to `availableHours`.
5. Load bookings grouped by weekday:

```sql
SELECT
  EXTRACT(ISODOW FROM b.start_time) AS iso_dow,
  COALESCE(SUM(
    EXTRACT(EPOCH FROM (
      COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
    )) / 3600
  ), 0) AS booked_hours
FROM bookings b
WHERE b.staff_id = $1
  AND b.start_time BETWEEN $2 AND $3
  AND b.deleted_at IS NULL
  AND b.status IN ('COMPLETED', 'CONFIRMED', 'PENDING_PAYMENT')
GROUP BY iso_dow
```

Map ISO weekday:

- 1 -> `Mon`
- 2 -> `Tue`
- 3 -> `Wed`
- 4 -> `Thu`
- 5 -> `Fri`
- 6 -> `Sat`
- 7 -> `Sun`

## 13. Response Examples

### 13.1 Overview Response

```json
{
  "totalEmployees": 12,
  "activeEmployees": 10,
  "onLeaveEmployees": 1,
  "inactiveEmployees": 1,
  "utilizationRate": 74.5,
  "utilizationDelta": 6.2,
  "averageRating": 4.7,
  "ratingDelta": 1.4,
  "reviewCount": 86,
  "trendPoints": [
    { "label": "Wk 1", "sessions": 18, "contributionValue": 9200000 },
    { "label": "Wk 2", "sessions": 21, "contributionValue": 11200000 }
  ],
  "roleDistribution": [
    { "role": "Doctor", "count": 4 },
    { "role": "Spa therapist", "count": 5 },
    { "role": "Massage therapist", "count": 3 }
  ],
  "topPerformers": [
    {
      "employeeName": "Nguyen An",
      "roleLabel": "Doctor",
      "rating": 4.9,
      "utilizationRate": 82.1,
      "contributionValue": 14800000
    }
  ],
  "complianceItems": [
    {
      "title": "Verification coverage",
      "detail": "All visible profiles have supporting documents.",
      "tone": "positive"
    }
  ]
}
```

### 13.2 Detail Response

```json
{
  "employeeId": "8ad71f50-2f44-4c12-a57d-b1c4c92f5a7d",
  "completedSessions": 26,
  "sessionsDelta": 8.3,
  "contributionValue": 15600000,
  "contributionDelta": 10.1,
  "utilizationRate": 77.4,
  "utilizationDelta": 4.8,
  "averageRating": 4.8,
  "reviewCount": 18,
  "trendPoints": [
    { "label": "Wk 1", "sessions": 6, "contributionValue": 3600000 },
    { "label": "Wk 2", "sessions": 7, "contributionValue": 4200000 }
  ],
  "mixMetrics": [
    { "label": "Skin Consultation", "value": 11, "share": 0.42 },
    { "label": "Laser Treatment", "value": 9, "share": 0.35 }
  ],
  "scheduleLoad": [
    { "label": "Mon", "availableHours": 8, "bookedHours": 6.5 },
    { "label": "Tue", "availableHours": 8, "bookedHours": 7 }
  ],
  "qualityMetrics": [
    {
      "label": "Client sentiment",
      "value": "4.8",
      "detail": "18 reviews across recent services",
      "tone": "positive"
    }
  ],
  "complianceItems": [
    {
      "title": "Profile status",
      "detail": "Doctor profile is active.",
      "tone": "positive"
    }
  ]
}
```

## 14. Frontend Integration Contract

After backend implementation and OpenAPI generation, update:

```txt
lib/features/partner/employee/data/employee_analytics_remote.datasource.dart
```

Expected generated API calls should be similar to:

```dart
final response = await _employeesApi
    .partnerEmployeesControllerGetOverviewAnalytics(
  period: period.value,
);

final response = await _employeesApi
    .partnerEmployeesControllerGetDetailAnalytics(
  employeeId.value,
  period: period.value,
);
```

Map backend tone strings to Flutter enum:

```dart
AnalyticsStatusTone _mapTone(String? value) {
  return switch (value) {
    'positive' => AnalyticsStatusTone.positive,
    'warning' => AnalyticsStatusTone.warning,
    'critical' => AnalyticsStatusTone.critical,
    _ => AnalyticsStatusTone.neutral,
  };
}
```

The backend must return numbers as JSON numbers, not formatted strings, except for `EmployeeQualityMetricDto.value`, which is intentionally a display string.

## 15. Security And Validation

Required behavior:

- Only `HEALTH_PARTNER` accounts can call these endpoints through `@PartnerApi('employees')`.
- Overview endpoint must only aggregate employees where `employees.partner_id` belongs to the authenticated account.
- Detail endpoint must return `404` when the employee exists but belongs to another partner.
- Never accept `partnerId` from query/body.
- Use `ParseUUIDPipe` for `employeeId`.
- Use `EmployeeAnalyticsQueryDto` for period validation.

## 16. Performance Notes

Recommended indexes already likely exist from entity decorators:

- `employees.partner_id`
- `bookings.staff_id`
- `bookings.start_time`
- `payments.booking_id`
- `specialist_reviews.specialist_id`

If analytics is slow with production data, add or confirm:

```sql
CREATE INDEX IF NOT EXISTS idx_bookings_staff_start_deleted
ON bookings (staff_id, start_time)
WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_specialist_reviews_specialist_created
ON specialist_reviews (specialist_id, created_at);

CREATE INDEX IF NOT EXISTS idx_payments_booking_status
ON payments (booking_id, payment_status)
WHERE deleted_at IS NULL;
```

Do not cache v1 unless the dashboard shows measurable latency. The existing queries are partner-scoped and period-scoped.

## 17. Test Plan

### 17.1 Handler Tests

Overview handler:

- Returns zero-safe values when a partner has no employees.
- Counts `ACTIVE`, `INACTIVE`, and `ON_LEAVE` employees correctly.
- Computes review average from `specialist_reviews`.
- Computes rating delta against previous period.
- Returns trend buckets even when some buckets have no sessions.
- Does not include employees from another partner.
- Returns compliance warning/critical when docs or emergency contact are missing.

Detail handler:

- Throws `NotFoundException` when employee does not belong to partner.
- Computes completed sessions from completed bookings only.
- Computes utilization using booked hours divided by schedule capacity.
- Computes contribution from paid/deposited payments only.
- Builds mix metrics from completed booking product/category counts.
- Falls back to profile labels when there are no completed bookings.
- Builds schedule load by weekday.
- Computes recommendation rate from `would_recommend`.

### 17.2 Controller Tests

- `GET /v1/partner/employees/analytics/overview` resolves account ID and calls service with default `THIS_MONTH`.
- `GET /v1/partner/employees/analytics/:employeeId` validates UUID.
- Routes are declared before `GET /v1/partner/employees/:id`.
- Swagger response types are set.

### 17.3 Manual QA

Use a partner account with:

- At least one active doctor.
- At least one spa or massage therapist.
- At least one employee with missing verification documents.
- Completed bookings in the current and previous period.
- Paid payments tied to bookings.
- Specialist reviews tied to bookings.

Validate:

- Overview KPI cards render real values.
- Role distribution pie chart has non-empty counts.
- Workload chart has stable labels for the selected period.
- Top performers sort consistently.
- Detail analytics returns `404` for cross-partner employee IDs.
- Detail schedule load shows booked hours lower than or equal to available hours for normal data.

## 18. Implementation Order

1. Add analytics DTOs.
2. Add `EmployeeAnalyticsQueryDto`.
3. Add overview handler with roster stats, trends, role distribution, top performers, and compliance.
4. Add detail handler with ownership check, session stats, trends, mix, schedule load, quality, and compliance.
5. Wire handlers into `EmployeesModule`.
6. Add service facade methods to `EmployeesService`.
7. Add controller routes before `@Get(':id')`.
8. Run backend tests.
9. Regenerate OpenAPI client for the Flutter admin panel.
10. Replace frontend local analytics builder calls with generated API calls and DTO mappers.

## 19. Acceptance Criteria

Backend is ready when:

- Both endpoints exist under `/v1/partner/employees/analytics`.
- Both endpoints are partner-authenticated and partner-scoped.
- Response JSON matches `EmployeeOverviewAnalytics` and `EmployeeDetailAnalytics` fields exactly.
- `period` supports the same values as the existing dashboard/product analytics.
- The detail endpoint returns `404` for missing or cross-partner employees.
- Empty data returns valid zero/empty-array payloads, not errors.
- Swagger shows DTO schemas for both endpoints.
- Handler tests cover partner scoping, empty data, normal data, and previous-period deltas.
