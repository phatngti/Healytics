# Management Table Controls Upgrade Log

## Done
- Added table query/selection/reload state and local query methods to:
  - `lib/features/partner/employee/presentation/providers/employee.provider.dart`
  - `lib/features/partner/products/presentation/providers/product.provider.dart`
  - `lib/features/partner/service_tags/presentation/providers/service_tag.provider.dart`
  - `lib/features/admin/category/presentation/providers/category.provider.dart`
- Added notifier methods for search, sort, filters, selection, single delete, selected delete, visible total rows, and visible pages.
- Added stable management table keys in `lib/core/keys/integration_test_keys.dart`.
- Added shared UI helpers in `lib/features/common/widgets/table/management_table_controls.dart`.
- Wired Employee table to provider-backed search, sort, filters, selected-row delete, row delete, and reload key.
- Wired Product table to provider-backed search, sort, status/category filters, selected-row delete, row delete, and reload key.
- Wired Service Tags table to provider-backed search, sort, active/inactive filter, selected-row delete, row delete, and reload key.
- Wired Category table to provider-backed search, sort, visible/hidden filter, selected-row delete, row delete, and reload key.
- Wired `CategoryAddScreen` submit to `categoryProvider.createCategory(...)` instead of the simulated delay.
- Updated `EmployeeRemoteDataSourceMock` so create/delete mutates the in-memory employee list.
- Updated `ProductRemoteDataSourceMock`, `ServiceTagRemoteDataSourceMock`, and `CategoryRemoteDataSourceMock` so mock create/update/delete mutate in-memory lists.
- Fixed shared `AppTable` search by updating `../common/lib/widgets/input/search_field.dart` to render visible text/cursor and expose a `fieldKey`.
- Added `AppTable.searchFieldKey` in `../common/lib/widgets/table/table.dart` and wired it through `../common/lib/widgets/table/header.dart`.
- Wired stable search keys into Employee, Product, Service Tags, and Category `AppTable` usage.
- Fixed common `AppTable` action column propagation by passing the mutated column list to `AsyncPaginatedDataTable2`.
- Added an `AppTable` widget regression test for visible search input, callback firing, and search key lookup.
- Cleared scoped analyzer issues from touched table-control files and two nearby scoped warnings that blocked clean verification.
- Ran `dart run build_runner build --delete-conflicting-outputs` successfully after provider/codegen changes.
- Ran focused `flutter test test/features/common/widgets/table/table_test.dart` successfully.
- Ran scoped analyzer successfully:
  - `dart analyze ../common/lib/widgets/input/search_field.dart ../common/lib/widgets/table/table.dart ../common/lib/widgets/table/header.dart lib/features/partner/employee lib/features/partner/products lib/features/partner/service_tags lib/features/admin/category lib/core/keys/integration_test_keys.dart`

## Doing
- Management table control implementation is code-complete for this pass.
- Remaining work is mostly test expansion and optional browser/Patrol smoke verification.

## Todo
- Add pure query/provider tests for Employee, Product, Service Tags, and Category table state if more coverage is required.
- Add widget tests for each feature table's Delete Selected disabled/enabled state and confirmation flow if more coverage is required.
- Add DEV-only Patrol smoke `patrol_test/management_table_controls_test.dart` when a dev mock browser run is needed.
- Run the DEV-only Patrol command only against mock/dev data:
  - `patrol test --device chrome -t patrol_test/management_table_controls_test.dart --dart-define=ENV=dev --dart-define=patrol=true`

## Notes
- The worktree was already heavily dirty before this implementation started, including employee/openapi/backend changes. Do not reset or revert unrelated changes.
- Shared `../common` package files are now edited for the search-input fix and key passthrough.
- The worktree remains heavily dirty with many unrelated changes outside this pass; do not reset or revert unrelated files.
