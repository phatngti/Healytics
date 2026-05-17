# Admin Partner Manager API Integration Plan

**Summary**
Target section: Admin `Provider Requests` / partner verification management.

Target frontend folder:
`/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/lib/features/admin/partner_manager`.

Target backend source:
`/Volumes/WD850X/Users/workspace/datn/Healytics/backend/src/admin`.

The feature is already partially integrated with the generated `AdminPartnersApi`: list, detail, and review submission call real backend endpoints. The visible screenshot still has hardcoded KPI cards, static tabs, inactive search, and incomplete queue/all-provider filtering. The backend has enough read/review foundation for the review flow, but it is missing a proper stats endpoint, filtered totals, sortable list metadata, and priority derivation for the dashboard cards.

## Current State

### Frontend Already Present

- `partner_manager_desktop.dart` renders the `Provider Requests` header, static `Verification Queue` / `All Providers` tabs, stats cards, and table.
- `partner_verification_remote.datasource.dart` already calls:
  - `GET /v1/admin/partners`
  - `GET /v1/admin/partners/total`
  - `GET /v1/admin/partners/:id`
  - `PUT /v1/admin/partners/:id/review`
- `review_application_desktop.dart` already submits `APPROVED`, `CHANGES_REQUIRED`, and `REJECTED` through the repository.
- `partner_detail.provider.dart` already loads detail through repository and handles loading/error states.
- Mock mode still exists behind `StoreKey.mockFlag`.

### Frontend Gaps

- `PartnerStatsCards` is hardcoded to `24`, `5`, `128`, and `4h 12m`.
- `PartnerVerificationRemoteDataSourceImpl.getStats()` returns an empty default because the backend has no stats endpoint.
- `_TabButtons` is visual only; it does not control table scope.
- `PartnerVerificationTable.onSearchChanged` is still a TODO.
- `PartnerTableSource` reads the datasource directly instead of the repository.
- `getTotalRows(statusFilter)` ignores `statusFilter` because `GET /admin/partners/total` has no query params.
- `getPartnerVerifications()` supports `statusFilter` in the method signature, but the table never passes it.
- List mapping drops `businessType` into an empty `serviceTypes` list, forces `priority` to `normal`, and forces `isEmailVerified` to `true`.
- Frontend `PartnerVerificationStatus` has only `pending`, `approved`, and `rejected`; backend also has `REQUIRED_RESUBMIT`.
- Sorting arguments exist in the datasource API but backend list always sorts by `createdAt DESC`.

### Backend Already Present

- `AdminPartnersController` is exposed through `@AdminApi('partners')`, so routes are under `/v1/admin/partners`.
- Existing backend endpoints:

| Method | Path | Existing purpose |
|---|---|---|
| `GET` | `/v1/admin/partners` | Paginated partner list with `page`, `limit`, `verificationStatus`, and `search` |
| `GET` | `/v1/admin/partners/total` | Total partner count, unfiltered |
| `GET` | `/v1/admin/partners/:id` | Detail with business info, legal representative, KYC documents, status, and latest review feedback |
| `PUT` | `/v1/admin/partners/:id/review` | Admin review decision with field/document feedback |

- `AdminPartnersService.getPartnerDetail()` already loads `account`, `province`, `district`, `ward`, `legalRepresentative`, and `documents`.
- `ReviewPartnerHandler` already updates partner verification status transactionally and writes `PartnerReviewLog`.
- Existing reviewable statuses are `PENDING` and `REQUIRED_RESUBMIT`.

### Backend Gaps

- No stats endpoint for pending review, high priority, active providers, or average wait time.
- `GET /admin/partners/total` cannot filter by status/search/scope.
- `GET /admin/partners` cannot sort by caller-selected columns.
- List DTO has no priority field, so the frontend cannot mark high-priority queue rows from real data.
- Detail DTO always returns `priority = NORMAL`.
- The current partner list DTO does not expose an explicit account active flag or email verification flag. Since `Account` has `isActive` but no email-verified column, frontend should not claim true email verification.

## Target Behavior

- `Verification Queue` tab shows only review work:
  - `PENDING`
  - optionally `REQUIRED_RESUBMIT` if the product decision is that resubmits remain admin-reviewable.
- `All Providers` tab shows all partners across `PENDING`, `REQUIRED_RESUBMIT`, `APPROVED`, and `REJECTED`.
- Search filters table rows by tax code, brand name, legal name, or email.
- Table total count matches the current tab/search/status filters.
- Stats cards load from backend and reflect the same source of truth as the table.
- List rows display real business types and backend-derived priority.
- Detail/review routes continue to use existing review contract.
- Mock mode remains available and mirrors the real DTO behavior closely enough for UI work.

## Backend Contract Plan

### 1. Create Admin Partner Query DTO

Add a backend admin-specific query DTO instead of continuing to reuse the partner module DTO directly:

`/Volumes/WD850X/Users/workspace/datn/Healytics/backend/src/admin/dto/admin-partners-query.dto.ts`

Fields:

| Field | Type | Purpose |
|---|---|---|
| `page` | number | 1-indexed page number |
| `limit` | number | page size |
| `scope` | enum: `VERIFICATION_QUEUE`, `ALL_PROVIDERS` | maps the two screen tabs |
| `verificationStatus` | `PartnerVerificationStatus` optional | explicit status filter for all-provider workflows |
| `search` | string optional | tax code, legal name, brand name, account email |
| `sortBy` | enum optional | `createdAt`, `brandName`, `legalName`, `verificationStatus`, `priority` |
| `sortDirection` | enum optional | `ASC`, `DESC` |

Use this DTO for both list and total endpoints. Keep existing query names camelCase so generated Dart parameters remain clean.

### 2. Add Admin Partner Stats DTO

Add:

`/Volumes/WD850X/Users/workspace/datn/Healytics/backend/src/admin/dto/admin-partner-stats-response.dto.ts`

Recommended response:

```ts
export class AdminPartnerStatsResponseDto {
  pendingReview: number;
  highPriority: number;
  activeToday: number;
  avgWaitSeconds: number;
  avgWaitTime: string;
  totalProviders: number;
  requiredResubmit: number;
  approved: number;
  rejected: number;
}
```

Keep `avgWaitTime` because the current Flutter domain already expects a string. Add `avgWaitSeconds` for future sorting/tooltips without reparsing labels.

### 3. Add Stats Endpoint

In `AdminPartnersController`, add this route before `@Get(':id')`:

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/v1/admin/partners/stats` | KPI card values for the provider requests screen |

Controller signature:

```ts
@Get('stats')
async getPartnerStats(
  @Query() query: AdminPartnersQueryDto,
): Promise<AdminPartnerStatsResponseDto>
```

Service behavior:

- Apply `scope` and `search` consistently with the list endpoint.
- `pendingReview`: count `PENDING` partners.
- `requiredResubmit`: count `REQUIRED_RESUBMIT` partners.
- `highPriority`: count review-queue partners whose computed priority is `HIGH` or `URGENT`.
- `activeToday`: v1 should match the existing mock intent and count approved providers. If the product requirement is literal "active today", replace this with approved providers that had booking/service/account activity since local day start.
- `approved`: count `APPROVED`.
- `rejected`: count `REJECTED`.
- `avgWaitSeconds`: average `now - createdAt` over review-queue partners.
- `avgWaitTime`: backend-formatted compact label such as `4h 12m`.

### 4. Add Filtered Total Endpoint

Update the existing route:

```ts
@Get('total')
async getTotalPartners(
  @Query() query: AdminPartnersQueryDto,
): Promise<TotalPartnersResponseDto>
```

Service behavior:

- Reuse the same filter builder as `getPartners`.
- Do not apply pagination.
- Return total after scope/search/status filtering.

This avoids changing the shared `AppTable` API and lets the frontend keep using `getTotalRows()`.

### 5. Extend Partner List DTO

Update backend `PartnersResponseDto` item shape or introduce an admin-specific list DTO. Prefer an admin-specific DTO to avoid surprising public/partner consumers:

`/Volumes/WD850X/Users/workspace/datn/Healytics/backend/src/admin/dto/admin-partner-list-response.dto.ts`

Recommended item fields:

```ts
export class AdminPartnerItemDto {
  id: string;
  taxCode: string;
  legalName: string;
  brandName: string;
  email: string;
  businessType: BusinessType[];
  verificationStatus: PartnerVerificationStatus;
  priority: PartnerPriority;
  createdAt: Date;
  verificationCompletedAt?: Date | null;
  isAccountActive: boolean;
}
```

Then return:

```ts
export class AdminPartnersResponseDto {
  data: AdminPartnerItemDto[];
  total: number;
  page: number;
  limit: number;
}
```

If minimizing backend churn is more important than DTO purity, add `priority` and `isAccountActive` to the existing `PartnerItemDto`. The frontend only needs generated Dart fields to be stable.

### 6. Centralize Filter and Priority Logic

In `AdminPartnersService`, factor shared helpers:

- `buildPartnerListQuery(query: AdminPartnersQueryDto)`
- `applyPartnerScope(qb, scope)`
- `applyPartnerSearch(qb, search)`
- `applyPartnerStatus(qb, verificationStatus)`
- `computePartnerPriority(partner, now)`
- `formatAverageWait(seconds)`

Recommended priority v1:

| Condition | Priority |
|---|---|
| `PENDING` or `REQUIRED_RESUBMIT` and age >= 72h | `URGENT` |
| `PENDING` or `REQUIRED_RESUBMIT` and age >= 24h | `HIGH` |
| `PENDING` or `REQUIRED_RESUBMIT` and age < 24h | `NORMAL` |
| non-review statuses | `LOW` or `NORMAL` |

Only `HIGH` and `URGENT` should count as `highPriority`.

### 7. Keep Review Endpoint Stable

Do not change the review route shape unless tests reveal a contract bug. The frontend already generates:

```dart
ReviewPartnerProfileDto(
  decision: ReviewPartnerProfileDtoDecisionEnum.CHANGES_REQUIRED,
  generalComment: note,
  items: [ReviewItemDto(fieldKey: ..., feedback: ...)],
)
```

Backend should keep accepting:

```json
{
  "decision": "CHANGES_REQUIRED",
  "generalComment": "General feedback",
  "items": [
    { "fieldKey": "brandName", "feedback": "Please correct name" }
  ]
}
```

Backend validation should reject `CHANGES_REQUIRED` when both `items` and `generalComment` are empty.

## OpenAPI Regeneration Plan

After backend DTO/controller changes:

1. Run the backend in development mode so it writes:
   `/Volumes/WD850X/Users/workspace/datn/Healytics/backend/openapi/openapi.json`.
2. Copy or sync that spec into:
   `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/open-api/admin_apis.json`.
3. Regenerate the Dart admin client:

```bash
cd /Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/open-api
./bin/generate-integration.sh admin
```

4. Do not hand-edit:
   `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi`.

## Frontend Integration Plan

### 1. Add Workspace State

Add:

`lib/features/admin/partner_manager/presentation/partner_manager_state.dart`

```dart
enum PartnerManagerScope {
  verificationQueue,
  allProviders,
}

class PartnerManagerState {
  final PartnerManagerScope scope;
  final String searchQuery;
  final PartnerVerificationStatus? statusFilter;
  final String sortBy;
  final bool sortAsc;
  final int reloadToken;
}
```

Add:

`lib/features/admin/partner_manager/presentation/partner_manager.provider.dart`

Use the same pattern as admin finance:

- `setScope(scope)`
- `setSearchQuery(value)`
- `setStatusFilter(value)`
- `setSort(sortBy, sortAsc)`
- `bumpReload()`
- `resetFilters()`

### 2. Wire Real Tabs

Replace `_TabButtons` in `partner_manager_desktop.dart` with a state-driven segmented control:

- `Verification Queue` -> `PartnerManagerScope.verificationQueue`
- `All Providers` -> `PartnerManagerScope.allProviders`

Changing tabs should:

- update provider state
- increment `reloadToken`
- rebuild the table with a distinct `ValueKey`
- refresh stats for the selected scope/search

### 3. Wire Real Stats Cards

Add a provider:

```dart
final partnerVerificationStatsProvider =
  FutureProvider<PartnerVerificationStats>((ref) async {
    final ws = ref.watch(partnerManagerWorkspaceProvider);
    return ref
      .read(partnerVerificationRepositoryProvider)
      .getStats(scope: ws.scope, searchQuery: ws.searchQuery);
  });
```

Update repository/datasource signatures:

```dart
Future<PartnerVerificationStats> getStats({
  PartnerManagerScope scope,
  String? searchQuery,
});
```

Update `PartnerStatsCards`:

- show lightweight loading placeholders or a `LinearProgressIndicator`
- show an error retry state
- render backend values when loaded
- keep mock mode values meaningful and aligned with real status rules

### 4. Wire Search

Update `PartnerVerificationTable` to accept:

```dart
PartnerManagerState state;
ValueChanged<String> onSearchChanged;
```

Pass `onSearchChanged` to `AppTable`.

Because `AppTable` does not own filter state, give it a key:

```dart
key: ValueKey(
  'partner-manager-${state.scope}-${state.reloadToken}-${state.searchQuery}-${state.statusFilter}',
)
```

This forces pagination cache reset after search/tab/filter changes.

### 5. Move Table Data Access Through Repository

Refactor `PartnerTableSource` to read:

```dart
final repository = ref.read(partnerVerificationRepositoryProvider);
```

instead of:

```dart
final dataSource = ref.read(partnerVerificationRemoteDataSourceProvider);
```

This keeps the feature aligned with the existing clean architecture boundary.

### 6. Pass Filters to List and Total Calls

Update repository and datasource methods:

```dart
Future<List<PartnerVerificationEntity>> getPartnerVerifications({
  required int startingAt,
  required int count,
  required PartnerManagerScope scope,
  String? searchQuery,
  String? sortedBy,
  bool? sortedAsc,
  PartnerVerificationStatus? statusFilter,
});

Future<int> getTotalRows({
  required PartnerManagerScope scope,
  String? searchQuery,
  PartnerVerificationStatus? statusFilter,
});
```

Datasource mapping:

- `startingAt/count` -> `page/limit`
- `scope.verificationQueue` -> backend `scope=VERIFICATION_QUEUE`
- `scope.allProviders` -> backend `scope=ALL_PROVIDERS`
- `searchQuery` -> backend `search`
- `statusFilter` -> backend `verificationStatus`
- `sortedBy/sortedAsc` -> backend `sortBy/sortDirection`

### 7. Fix Status and Priority Mapping

Update frontend domain:

```dart
enum PartnerVerificationStatus {
  pending,
  requiredResubmit,
  approved,
  rejected,
}
```

Mapping:

| Backend | Frontend |
|---|---|
| `PENDING` | `pending` |
| `REQUIRED_RESUBMIT` | `requiredResubmit` |
| `APPROVED` | `approved` |
| `REJECTED` | `rejected` |

Update badges:

- `pending` -> `Pending`
- `requiredResubmit` -> `Changes Required`
- `approved` -> `Active`
- `rejected` -> `Rejected`

Review action:

- `pending` and `requiredResubmit` should route to review only if backend keeps both reviewable.
- `approved` and `rejected` should route to detail.

Priority mapping:

| Backend | Frontend |
|---|---|
| `low` | `normal` |
| `normal` | `normal` |
| `high` | `high` |
| `urgent` | `high` |

If the UI later needs urgent styling, add `urgent` to the frontend enum instead of folding it into high.

### 8. Fix List Mapping

In `_mapPartnerItemToEntity()`:

- map `businessType` to readable `serviceTypes`
- map backend priority to frontend priority
- stop hardcoding `isEmailVerified: true`
- use `isAccountActive` for detail text or future row state if backend returns it
- preserve `providerId = dto.id`

Business type labels can be implemented as a small mapper:

```dart
String _formatBusinessType(openapi.BusinessType type)
```

Do not expose generated enum values directly in UI if they are uppercase or underscore-heavy.

### 9. Clean Debug Logging

Remove or gate these debug prints before final integration:

- `PartnerVerificationRemoteDataSourceImpl: Fetching id=...`
- `Received dto=...`
- `ReviewPartner: ...`
- `Mapping ... KYC documents`

Prefer structured errors and UI retry states over noisy console output.

## Backend Test Plan

Add or update:

- `src/admin/services/admin-partners.service.spec.ts`
- `src/admin/controllers/admin-partners.controller.spec.ts`
- `src/admin/application/handlers/review-partner.handler.spec.ts` if missing

Required backend cases:

- list defaults to page `1`, limit `10`, created date descending
- verification queue scope includes only intended review statuses
- all providers scope includes all statuses
- search applies to tax code, brand name, legal name, and email
- total endpoint applies the same filters as list
- stats endpoint returns counts for pending, required resubmit, approved, rejected, total
- stats average wait uses review-queue records only
- priority helper returns `NORMAL`, `HIGH`, and `URGENT` at the configured age thresholds
- review endpoint still delegates to `ReviewPartnerHandler`
- non-reviewable statuses still fail review with `BadRequestException`

Target command:

```bash
cd /Volumes/WD850X/Users/workspace/datn/Healytics/backend
./node_modules/.bin/jest src/admin/services/admin-partners.service.spec.ts src/admin/controllers/admin-partners.controller.spec.ts src/admin/application/handlers/review-partner.handler.spec.ts --runInBand --reporters=default
```

Also run:

```bash
npm run build
```

## Frontend Test Plan

Add tests under:

`/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/test/features/admin/partner_manager`.

Recommended files:

- `datasource/partner_verification_remote_datasource_test.dart`
- `presentation/partner_manager_provider_test.dart`
- `presentation/partner_stats_cards_test.dart`

Datasource test cases:

- `getPartnerVerifications()` maps offset/count to page/limit.
- queue scope sends `VERIFICATION_QUEUE`.
- all-providers scope sends `ALL_PROVIDERS`.
- search text is passed to generated API.
- `getTotalRows()` passes the same scope/search/status filters.
- stats response maps to `PartnerVerificationStats`.
- `REQUIRED_RESUBMIT` maps to the new frontend status.
- business types map into non-empty UI labels.
- priority maps from backend `high` and `urgent`.
- review submission builds correct `ReviewPartnerProfileDto`.

Provider/widget test cases:

- switching tabs updates state and reload token.
- search updates state and table key.
- stats card loading/error/data states render without hardcoded values.

Target commands:

```bash
cd /Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel
dart run build_runner build --delete-conflicting-outputs
dart analyze lib/features/admin/partner_manager lib/core/services/api.service.dart test/features/admin/partner_manager
flutter test test/features/admin/partner_manager
```

## Implementation Order

1. Backend query/stat DTOs:
   add `AdminPartnersQueryDto`, `AdminPartnerStatsResponseDto`, and optionally admin-specific list/page DTOs.

2. Backend service helpers:
   centralize filter/scope/search/sort query building and priority calculation.

3. Backend endpoints:
   add `GET /stats`, update `GET /total`, update `GET /partners` response with priority and filtered totals.

4. Backend tests:
   lock down list, total, stats, priority, and review behavior.

5. OpenAPI regeneration:
   refresh backend OpenAPI, sync `admin_apis.json`, regenerate `admin_openapi`.

6. Frontend domain updates:
   add `requiredResubmit`, update priority/status mappers, update stats datasource contract.

7. Frontend state wiring:
   add partner manager workspace state/provider, wire tabs/search/table key.

8. Frontend stats cards:
   replace hardcoded values with `partnerVerificationStatsProvider`.

9. Frontend table integration:
   pass scope/search/status/sort to repository, route data through repository, map business types and priority.

10. Frontend tests and analyze:
    add datasource/provider/widget tests, run scoped analyzer and focused tests.

## Acceptance Checklist

- With mock mode off, `Provider Requests` loads without fallback constants.
- `Verification Queue` tab only shows backend-defined review queue rows.
- `All Providers` tab shows all provider statuses.
- KPI cards change when backend data changes.
- Search changes list rows and total count.
- Table business type chips are populated from backend `businessType`.
- High-priority card matches row priority logic.
- Approved/rejected rows route to detail; reviewable rows route to review.
- Approve/reject/request-revision still persist through `PUT /v1/admin/partners/:id/review`.
- After a review action, the list and stats refresh.
- Generated OpenAPI client contains any new stats/query/list DTOs.
- Backend targeted Jest tests pass.
- Frontend scoped analyze and focused tests pass.

## Notes and Risks

- `activeToday` is ambiguous. Current mock treats it as approved provider count, not literal activity today. The backend plan preserves that behavior for v1 unless product requires true activity tracking.
- `REQUIRED_RESUBMIT` needs a UX decision: show it in queue only if admins can act on it immediately; otherwise show it in all providers as `Changes Required`.
- Adding admin-specific list DTOs is cleaner but changes generated Dart names. Extending the existing partner item DTO is smaller but less isolated.
- Do not hand-edit generated Dart files under `admin_panel/openapi`; regenerate through `healytic_fe/open-api`.
