# Implementation Plan: Revenue API Integration

## Overview

Replace the stub `RevenueRemoteDatasourceImpl` with a real implementation that delegates to the OpenAPI-generated `EmployeeRevenueApi`. Register the API client in `ApiService`, implement DTO-to-entity mapping with proper error handling, and update the Riverpod provider to inject `ApiService` into the real datasource.

## Tasks

- [x] 1. Register EmployeeRevenueApi in ApiService
  - [x] 1.1 Add `EmployeeRevenueApi` field and initialization in `ApiService`
    - Add `late EmployeeRevenueApi employeeRevenueApi` field declaration alongside existing API fields
    - Add `employeeRevenueApi = EmployeeRevenueApi(backend)` in `setEndpoint()` after the existing backend API assignments
    - _Requirements: 1.1, 1.2, 1.3_

- [x] 2. Implement RevenueRemoteDatasourceImpl with real API calls
  - [x] 2.1 Add constructor injection and helper methods
    - Add `final ApiService apiService` field with required named constructor parameter
    - Add `_mapPeriod(RevenuePeriod) → EmployeeRevenuePeriod` exhaustive switch expression
    - Add `_mapPeriodBack(EmployeeRevenuePeriod) → RevenuePeriod` reverse mapping with defensive fallback
    - Add `_formatDate(DateTime?) → String?` helper producing yyyy-MM-dd or null
    - Add necessary imports (`dart:developer`, `employee_openapi/api.dart`, `api.provider.dart`, `api.service.dart`)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 6.1, 6.2, 8.1, 8.2, 8.3_

  - [x] 2.2 Implement `getSummary` method
    - Call `apiService.employeeRevenueApi.employeeRevenueControllerGetSummary` with mapped period and formatted date
    - Map response DTO to `RevenueSummaryEntity` (num→double, num→int, period→RevenuePeriod)
    - Throw exception on null response (HTTP 204)
    - Catch `ApiException`, log with `dart:developer`, and rethrow
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [x] 2.3 Implement `getTrendData` method
    - Call `apiService.employeeRevenueApi.employeeRevenueControllerGetTrend` with mapped period and formatted date
    - Map each DTO in response list to `RevenueDataPoint` (amount→double, date direct, label direct)
    - Return empty list on null response
    - Catch `ApiException`, log, and rethrow
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

  - [x] 2.4 Implement `getBreakdown` method
    - Call `apiService.employeeRevenueApi.employeeRevenueControllerGetBreakdown` with mapped period and formatted date
    - Map each DTO to `RevenueBreakdownItem` (serviceName direct, count→int, totalAmount→double)
    - Return empty list on null response
    - Catch `ApiException`, log, and rethrow
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [x] 2.5 Update datasource provider to inject ApiService
    - Import `apiServiceProvider` from core providers
    - Modify `revenueRemoteDatasourceProvider` to pass `apiService` to `RevenueRemoteDatasourceImpl` when `useMock == false`
    - Ensure mock path remains unchanged (no-arg constructor)
    - _Requirements: 7.1, 7.2, 7.3, 6.3_

- [x] 3. Checkpoint - Verify code generation and compilation
  - Ensure all tests pass, ask the user if questions arise.
  - Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `.g.dart` files
  - Run `flutter analyze` to verify no compile errors

- [x] 4. Write tests for revenue API integration
  - [ ]* 4.1 Write property test for period enum mapping
    - **Property 1: Period enum mapping is name-preserving**
    - **Validates: Requirements 2.1, 2.2, 2.3**

  - [ ]* 4.2 Write property test for summary DTO mapping
    - **Property 2: Summary DTO mapping preserves numeric values**
    - **Validates: Requirements 3.2**

  - [ ]* 4.3 Write property test for trend DTO list mapping
    - **Property 3: Trend DTO list mapping preserves all data points**
    - **Validates: Requirements 4.2**

  - [ ]* 4.4 Write property test for breakdown DTO list mapping
    - **Property 4: Breakdown DTO list mapping preserves all items**
    - **Validates: Requirements 5.2**

  - [ ]* 4.5 Write property test for date formatting
    - **Property 5: Date formatting produces valid ISO 8601 date-only strings**
    - **Validates: Requirements 8.1, 8.3**

  - [ ]* 4.6 Write unit tests for RevenueRemoteDatasourceImpl
    - Test `getSummary` passes correct mapped period and formatted date to API
    - Test `getSummary` throws on null API response
    - Test `getSummary` logs and rethrows ApiException
    - Test `getTrendData` returns empty list on null response
    - Test `getBreakdown` returns empty list on null response
    - Test provider returns mock when `useMock == true`
    - Test provider returns real impl with ApiService when `useMock == false`
    - _Requirements: 3.1, 3.3, 3.4, 4.3, 4.4, 5.3, 5.4, 7.1, 7.2_

- [x] 5. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- The implementation follows the established pattern from the appointments feature datasource
- All code uses Dart with the existing project conventions (Riverpod, OpenAPI codegen, dart:developer logging)

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1"] },
    { "id": 1, "tasks": ["2.1"] },
    { "id": 2, "tasks": ["2.2", "2.3", "2.4"] },
    { "id": 3, "tasks": ["2.5"] },
    { "id": 4, "tasks": ["4.1", "4.2", "4.3", "4.4", "4.5", "4.6"] }
  ]
}
```
