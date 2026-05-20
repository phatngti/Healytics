# Requirements Document

## Introduction

This feature replaces the stub `RevenueRemoteDatasourceImpl` (which currently throws `UnimplementedError`) with a real implementation that calls the OpenAPI-generated `EmployeeRevenueApi`. It also registers the `EmployeeRevenueApi` in the centralized `ApiService` and ensures the provider correctly injects `ApiService` into the real datasource, following the same pattern established by the appointments feature.

## Glossary

- **ApiService**: Centralized service class that holds all OpenAPI client instances and manages HTTP authentication headers
- **EmployeeRevenueApi**: OpenAPI-generated client class exposing three revenue endpoints (summary, trend, breakdown)
- **RevenueRemoteDatasource**: Abstract class defining the contract for fetching revenue data
- **RevenueRemoteDatasourceImpl**: Concrete class implementing `RevenueRemoteDatasource` using real API calls
- **RevenueSummaryEntity**: Domain entity representing aggregated revenue KPIs for a period
- **RevenueDataPoint**: Domain entity representing a single point in the revenue trend chart
- **RevenueBreakdownItem**: Domain entity representing revenue grouped by service category
- **RevenuePeriod**: Domain enum with values `day`, `month`, `year` for time-based filtering
- **EmployeeRevenuePeriod**: OpenAPI-generated enum with values `day`, `month`, `year`
- **DTO**: Data Transfer Object — OpenAPI-generated model representing the API response shape
- **Mapper**: Logic that converts an OpenAPI DTO into a domain entity

## Requirements

### Requirement 1: Register EmployeeRevenueApi in ApiService

**User Story:** As a developer, I want the `EmployeeRevenueApi` registered in `ApiService`, so that all revenue API calls use the centralized authenticated HTTP client.

#### Acceptance Criteria

1. THE ApiService SHALL declare a public `late EmployeeRevenueApi employeeRevenueApi` field, following the same declaration pattern as the existing `employeeAppointmentsApi` field
2. WHEN `setEndpoint` is called on ApiService, THE ApiService SHALL instantiate `employeeRevenueApi` by passing the backend `ApiClient` (i.e., `clientFor(ServicePrefix.backend)`) to the `EmployeeRevenueApi` constructor, in the same section where other backend API instances are assigned
3. WHEN `setEndpoint` completes, THE ApiService SHALL have `employeeRevenueApi` fully initialized such that accessing the field does not throw a `LateInitializationError`

### Requirement 2: Map Domain RevenuePeriod to OpenAPI EmployeeRevenuePeriod

**User Story:** As a developer, I want a reliable mapping between the domain `RevenuePeriod` enum and the OpenAPI `EmployeeRevenuePeriod` enum, so that API calls use the correct period parameter.

#### Acceptance Criteria

1. THE RevenueRemoteDatasourceImpl SHALL map `RevenuePeriod.day` to `EmployeeRevenuePeriod.day`
2. THE RevenueRemoteDatasourceImpl SHALL map `RevenuePeriod.month` to `EmployeeRevenuePeriod.month`
3. THE RevenueRemoteDatasourceImpl SHALL map `RevenuePeriod.year` to `EmployeeRevenuePeriod.year`
4. THE RevenueRemoteDatasourceImpl SHALL provide an exhaustive mapping that covers every value of the `RevenuePeriod` enum, such that adding a new enum value without updating the mapping produces a compile-time error
5. WHEN the RevenueRemoteDatasourceImpl calls any EmployeeRevenueApi method, THE RevenueRemoteDatasourceImpl SHALL pass the mapped `EmployeeRevenuePeriod` value as the `period` parameter

### Requirement 3: Implement Revenue Summary API Call

**User Story:** As an employee, I want to see my real revenue summary (total revenue, commission, net earnings, appointment counts), so that I can track my actual financial performance.

#### Acceptance Criteria

1. WHEN `getSummary` is called with a `RevenuePeriod` period and an optional `DateTime? date`, THE RevenueRemoteDatasourceImpl SHALL call `employeeRevenueControllerGetSummary` on the EmployeeRevenueApi, passing the period mapped from `RevenuePeriod` to the corresponding `EmployeeRevenuePeriod` enum value (day→day, month→month, year→year), and the date formatted as an ISO 8601 date string (yyyy-MM-dd) if provided or omitted if null
2. WHEN the API returns a valid `EmployeeRevenueSummaryResponseDto`, THE RevenueRemoteDatasourceImpl SHALL map the DTO to a `RevenueSummaryEntity` by converting `totalRevenue` (num→double via `.toDouble()`), `totalCommission` (num→double), `netEarnings` (num→double), `completedAppointments` (num→int via `.toInt()`), `canceledAppointments` (num→int), and passing `period` (mapped back to `RevenuePeriod`), `periodStart` (DateTime), and `periodEnd` (DateTime) directly
3. IF the API returns null (HTTP 204 No Content), THEN THE RevenueRemoteDatasourceImpl SHALL throw an exception indicating that no revenue data is available for the requested period
4. IF the API throws an `ApiException`, THEN THE RevenueRemoteDatasourceImpl SHALL log the error code with the datasource name identifier and rethrow the original `ApiException` without wrapping it

### Requirement 4: Implement Revenue Trend API Call

**User Story:** As an employee, I want to see my real revenue trend data over time, so that I can visualize my earnings pattern on the chart.

#### Acceptance Criteria

1. WHEN `getTrendData` is called with a `RevenuePeriod` period and an optional `DateTime? date`, THE RevenueRemoteDatasourceImpl SHALL call `employeeRevenueControllerGetTrend` on the EmployeeRevenueApi, passing the period mapped from `RevenuePeriod` to the corresponding `EmployeeRevenuePeriod` enum value and the date formatted as an ISO 8601 date string (yyyy-MM-dd) if provided or null if omitted
2. WHEN the API returns a valid list of `EmployeeRevenueTrendPointDto`, THE RevenueRemoteDatasourceImpl SHALL map each DTO to a `RevenueDataPoint` entity by converting `amount` (num→double via `.toDouble()`), passing `date` (DateTime) and `label` (String) directly
3. WHEN the API returns null or an empty list, THE RevenueRemoteDatasourceImpl SHALL return an empty list of `RevenueDataPoint`
4. IF the API throws an `ApiException`, THEN THE RevenueRemoteDatasourceImpl SHALL log the error status code and rethrow the original exception without modification

### Requirement 5: Implement Revenue Breakdown API Call

**User Story:** As an employee, I want to see my real revenue breakdown by service, so that I can understand which services generate the most income.

#### Acceptance Criteria

1. WHEN `getBreakdown` is called with a period and an optional date, THE RevenueRemoteDatasourceImpl SHALL call `employeeRevenueControllerGetBreakdown` on the EmployeeRevenueApi with the period mapped by name from RevenuePeriod to EmployeeRevenuePeriod (day→day, month→month, year→year) and the date formatted as an ISO-8601 date string (yyyy-MM-dd), or null if no date is provided
2. WHEN the API returns a valid list of `EmployeeRevenueBreakdownItemDto`, THE RevenueRemoteDatasourceImpl SHALL map each DTO to a `RevenueBreakdownItem` entity converting serviceName as-is, count from num to int via `.toInt()`, and totalAmount from num to double via `.toDouble()`
3. WHEN the API returns null or an empty list, THE RevenueRemoteDatasourceImpl SHALL return an empty list of `RevenueBreakdownItem`
4. IF the API throws an `ApiException`, THEN THE RevenueRemoteDatasourceImpl SHALL log the error status code and rethrow the original exception without modification

### Requirement 6: Inject ApiService into Real Datasource

**User Story:** As a developer, I want `RevenueRemoteDatasourceImpl` to receive `ApiService` via constructor injection, so that it follows the established dependency injection pattern.

#### Acceptance Criteria

1. THE RevenueRemoteDatasourceImpl SHALL declare a `final ApiService apiService` field and accept it as a required named constructor parameter using `{required this.apiService}` syntax
2. THE RevenueRemoteDatasourceImpl SHALL access `apiService.employeeRevenueApi` for all API method calls within `getSummary`, `getTrendData`, and `getBreakdown`, without directly instantiating `EmployeeRevenueApi`
3. THE RevenueRemoteDatasourceMock SHALL NOT require an `ApiService` parameter and SHALL remain independently instantiable with a no-argument constructor

### Requirement 7: Update Datasource Provider for Real Implementation

**User Story:** As a developer, I want the datasource provider to inject `ApiService` when creating the real implementation, so that the revenue feature works with the live backend.

#### Acceptance Criteria

1. WHILE `AppEnvironment.current.useMock` is false, THE `revenueRemoteDatasourceProvider` SHALL obtain the `ApiService` instance via `ref.read(apiServiceProvider)` and pass it as the `apiService` named parameter to the `RevenueRemoteDatasourceImpl` constructor
2. WHILE `AppEnvironment.current.useMock` is true, THE `revenueRemoteDatasourceProvider` SHALL create a `RevenueRemoteDatasourceMock` with no constructor arguments
3. THE `revenueRemoteDatasourceProvider` SHALL be annotated with `@Riverpod(keepAlive: true)` and return a `RevenueRemoteDatasource` instance

### Requirement 8: Format Date Parameter for API Calls

**User Story:** As a developer, I want dates formatted consistently for the API, so that the backend correctly interprets the requested time period.

#### Acceptance Criteria

1. WHEN a non-null `DateTime` date is provided to any API method (getSummary, getTrendData, getBreakdown), THE RevenueRemoteDatasourceImpl SHALL format the date as a zero-padded ISO 8601 date-only string (yyyy-MM-dd), discarding any time component, before passing it to the API
2. WHEN a null date is provided to any API method, THE RevenueRemoteDatasourceImpl SHALL pass null to the API, allowing the backend to default to today
3. WHEN a `DateTime` with a non-zero time component (e.g., 2024-03-15T14:30:00) is provided, THE RevenueRemoteDatasourceImpl SHALL produce only the date portion (e.g., "2024-03-15") with no time or timezone suffix
