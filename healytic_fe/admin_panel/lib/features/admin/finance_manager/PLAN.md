# Admin Finance Manager API Integration Plan

**Summary**
Target export file: `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/lib/features/admin/finance_manager/admin_finance_manager_api_integration_plan.md`.

Current Plan Mode blocks repo mutation, so this is the exact plan content to save there during execution. The feature is currently mock-backed; real mode throws `UnimplementedError`. Existing backend finance APIs are partner-scoped and do not satisfy the admin feature, so implement a new admin finance contract first, then regenerate `admin_openapi` and wire the Flutter datasource.

**Backend API Contract**
- Add an admin-only finance controller under the backend admin area, exposed as `/v1/admin/finance`; do not reuse `/v1/partner/*` routes directly because those resolve finance data from the current partner account.
- Create typed Swagger DTOs so codegen produces `AdminFinanceApi`, page DTOs, and request/response models. Use camelCase fields matching Flutter domain names.
- Add `AdminFinanceQueryDto` with `search`, `period`, `startDate`, `endDate`, `partnerId`, `customerId`, `sourceType`, `transactionType`, `transactionStatus`, `settlementStatus`, `payoutStatus`, `refundCaseStatus`, `refundCaseType`, `reconciliationStatus`, `provider`, `currency`, `minAmount`, `maxAmount`, `onlyFlagged`, `onlySlaBreached`, `page`, and `limit`.
- Add admin support persistence where current tables are missing UI state: generic finance notes, reconciliation exceptions, finance export jobs, payout attempts, payout hold/failure fields, and `held` payout status.
- Keep platform-wide finance endpoints admin-only. Use a finance-specific admin decorator or guard instead of broad `ADMIN_ROLES`, because whole-system finance data should not be visible to partner or employee roles.

Required endpoints:

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/summary` | `AdminFinanceOverviewDto` |
| `GET` | `/trend` | daily trend rows with gross/net/refund/payout |
| `GET` | `/alerts` | derived operational alerts |
| `GET` | `/transactions` | paged ledger records |
| `GET` | `/transactions/:id` | transaction detail with provider events, audit, notes, refunds |
| `PATCH` | `/transactions/:id/settlement` | mark settlement with required note |
| `PATCH` | `/transactions/:id/review-flag` | flag/unflag transaction |
| `GET` | `/payouts` and `/payouts/:id` | paged payouts and payout detail |
| `POST` | `/payouts/:id/retry`, `/hold`, `/release-hold` | payout actions |
| `GET` | `/refund-cases` and `/refund-cases/:id` | paged refund/dispute cases and detail |
| `POST` | `/refund-cases/:id/approve`, `/reject` | refund decisions |
| `GET` | `/reconciliation` and `/reconciliation/:id` | reconciliation exceptions and detail |
| `POST` | `/reconciliation/:id/resolve`, `/reopen` | reconciliation actions |
| `GET` | `/partner-exposure` | partner risk ranking |
| `GET` / `POST` | `/exports` | list and create export jobs |
| `POST` | `/notes` | add note to transaction, payout, refund case, or reconciliation item |

**Frontend Integration**
- Regenerate backend OpenAPI, copy the updated spec into `healytic_fe/open-api/admin_apis.json`, then run `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/open-api/bin/generate-integration.sh admin`; never edit `admin_panel/openapi` manually.
- Add `AdminFinanceApi` to `ApiService.setEndpoint`, backed by `clientFor(ServicePrefix.backend)`.
- Replace every `UnimplementedError` in `AdminFinanceRemoteDataSourceImpl` with generated API calls and DTO-to-domain mappers. Keep `AdminFinanceRemoteDataSourceMock` behind `StoreKey.mockFlag`.
- Map frontend `startingAt/count` to backend `page/limit`; implement `get*TotalRows` from page `meta.total`.
- Add converters for all enums. Add `vnpay` to `AdminFinanceProvider` or map it explicitly, because backend payment methods include `VNPAY`.
- Wire currently-unused repository actions into the UI: export dialog calls `createExport`, note panels call `addNote`, and detail screens expose settlement, flag, payout, refund, and reconciliation actions with reload on success.
- Preserve existing domain/repository boundaries; generated DTOs stay inside `datasource`.

**Test Plan**
- Backend: add unit tests for admin query filters, aggregation formulas, page metadata, role denial for non-admin roles, and state transitions for settlement, payout hold/retry, refund approval/rejection, and reconciliation resolve/reopen.
- Backend: run targeted Jest tests for admin finance and existing partner finance to ensure shared enum/schema changes do not regress partner routes.
- Frontend: add datasource mapper tests for overview, list pages, details, notes, exports, and enum fallbacks.
- Frontend: verify non-mock mode does not throw `UnimplementedError`; run scoped `dart analyze` on `lib/features/admin/finance_manager`, `lib/core/services/api.service.dart`, and generated route/API touchpoints.
- Manual acceptance: with mock mode off and backend running, every finance tab and detail route loads, actions persist and refresh, and export jobs appear in the exports table.

**Assumptions**
- Backend is the source of truth for finance data; frontend mocks remain development-only.
- Admin finance is platform-wide, not current-partner-scoped.
- Export v1 may be queued and return a job immediately; async file generation can be implemented behind the same contract.
