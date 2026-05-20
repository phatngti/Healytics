# Clinic Info — Frontend Integration Guide

> Audience: frontend team (`healytic_fe/user_app`)
> Backend status: implemented
> Frontend OpenAPI package: `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/user_app/openapi`
> Auth: JWT bearer token for user-authenticated routes

## Overview

This guide explains how the `user_app` clinic detail feature should integrate
with the clinic APIs exposed under:

- `GET /v1/user/clinics/{id}/info`
- `GET /v1/user/clinics/{id}/products`
- `GET /v1/user/clinics/{id}/reviews`

The generated Dart client is already up to date and includes the new products
query parameter and response shape for categories. The frontend work is
therefore not a codegen task; it is an integration task in the datasource,
repository, provider, and UI layers.

The most important change is on the product tab:

- the backend now returns server-driven category chips
- the frontend real datasource must pass `categoryId`
- the frontend real datasource must map `dto.categories`
- the frontend must keep `'all'` as local UI state only and never send it to
  the API

## OpenAPI / Generated Client Surface

Use the generated package import:

```dart
import 'package:user_openapi/api.dart';
```

The generated API surface already exists in:

- `user_app/openapi/lib/api/user_clinics_api.dart`
- `user_app/openapi/lib/model/clinic_products_response_dto.dart`
- `user_app/openapi/lib/model/clinic_product_category_dto.dart`

### Exact client methods

```dart
UserClinicsApi.userClinicControllerGetClinicInfo(id)

UserClinicsApi.userClinicControllerGetClinicProducts(
  id,
  categoryId: categoryId,
  sort: sort,
  search: search,
  page: page,
  limit: limit,
)

UserClinicsApi.userClinicControllerGetClinicReviews(
  id,
  page: page,
  limit: limit,
  starCount: starCount,
  hasMedia: hasMedia,
)
```

### DTOs the frontend should rely on

- `ClinicInfoResponseDto`
- `ClinicProductsResponseDto`
- `ClinicProductCategoryDto`
- `ClinicProductDto`
- `ClinicReviewsResponseDto`

### Important generated contract details

`userClinicControllerGetClinicProducts` now has this generated signature:

```dart
Future<ClinicProductsResponseDto?> userClinicControllerGetClinicProducts(
  String id, {
  String? categoryId,
  String? sort,
  String? search,
  num? page,
  num? limit,
})
```

`ClinicProductsResponseDto` now includes:

```dart
class ClinicProductsResponseDto {
  List<ClinicProductCategoryDto> categories;
  List<ClinicProductDto> products;
  num totalCount;
  bool hasMore;
}
```

Do not edit the generated package directly. It is auto-generated and should be
treated as read-only. Frontend changes belong in the feature layer that consumes
this package.

## Frontend Architecture Touchpoints

The current `user_app` clinic detail flow is already structured correctly. The
integration should happen through these existing seams.

### API entrypoint

- `user_app/lib/core/services/api.service.dart`
  - `ApiService.userClinicsApi`
  - already exposes `UserClinicsApi(backend)`

### Datasource layer

- `user_app/lib/features/clinic_info/data/datasources/remote/clinic_info_remote_datasource.dart`
  - real implementation: `ClinicInfoRemoteDatasourceImpl`
  - mock implementation: `ClinicInfoRemoteDatasourceMock`

### Repository layer

- `user_app/lib/features/clinic_info/data/repositories/clinic_info_impl.repository.dart`
- `user_app/lib/features/clinic_info/domain/repositories/clinic_info.repository.dart`

### Domain entities

- `user_app/lib/features/clinic_info/domain/entities/clinic_product.entity.dart`
- `user_app/lib/features/clinic_info/domain/entities/clinic_review.entity.dart`
- `user_app/lib/features/clinic_info/domain/entities/clinic_info.entity.dart`

### Provider / state layer

- `user_app/lib/features/clinic_info/data/provider/clinic_info.provider.dart`
- `user_app/lib/features/clinic_info/presentation/providers/clinic_products.provider.dart`
- `user_app/lib/features/clinic_info/presentation/providers/clinic_reviews.provider.dart`

### UI consumers

- `user_app/lib/features/clinic_info/presentation/widgets/clinic_products/category_scroller.widget.dart`
- `user_app/lib/features/clinic_info/presentation/widgets/clinic_products/product_tab_content.widget.dart`
- `user_app/lib/features/clinic_info/presentation/widgets/clinic_reviews/review_filter_pills.widget.dart`

### Current mismatch that must be fixed

The generated client is correct, but the real datasource is still using the old
integration behavior:

- it does not pass `categoryId` into
  `userClinicControllerGetClinicProducts(...)`
- it maps `ClinicProductsResponseDto.categories` to `const []`
- it therefore prevents the product-tab category UI from using the real backend
  response

The mock datasource is allowed to keep local `'all'` handling, but that special
value must stay inside the UI/provider/mock layer and must not leak into real
API requests.

## Endpoint-by-Endpoint Integration

### 1. `GET /user/clinics/{id}/info`

Generated call:

```dart
final dto = await api.userClinicControllerGetClinicInfo(clinicId);
```

Frontend impact:

- no schema change is required
- current mapping from `ClinicInfoResponseDto` to `ClinicInfoEntity` can remain
  structurally the same
- the backend aggregate behavior is now aligned to public visible clinic
  products, so info metrics should be considered authoritative for the screen

Field expectations:

- `id`, `name`, `coverImageUrl`, `logoImageUrl`, `gallery`
- `followersLabel`, `reviewsLabel`
- `description`, `address`, `phoneNumber`
- `trustMetrics`, `certifications`, `specialists`, `businessTypes`

Frontend guidance:

- keep the existing info-tab mapping code
- do not attempt any fallback client-side recomputation for counts, ratings, or
  review labels
- treat missing optional values defensively, as the current datasource already
  does

### 2. `GET /user/clinics/{id}/products`

Generated call:

```dart
final dto = await api.userClinicControllerGetClinicProducts(
  clinicId,
  categoryId: categoryId,
  sort: sort.toApiValue(),
  search: search,
  page: page,
  limit: limit,
);
```

Backend behavior:

- returns `categories`, `products`, `totalCount`, `hasMore`
- category chips are server-driven
- the first category is synthetic:

```json
{ "id": "all", "label": "All Services" }
```

- only categories with at least one public product for the clinic are returned
- products remain server-filtered by search, sort, page, limit, and optional
  `categoryId`

Frontend changes required:

1. Pass `categoryId` from the real datasource to the generated client.
2. Map `dto.categories` into domain `ClinicProductCategory`.
3. Stop returning `categories: const []` from the real datasource.
4. Keep the provider behavior where `'all'` is local UI state and is converted
   to `null` before calling the repository.

Recommended real datasource implementation shape:

```dart
final dto = await _api.userClinicControllerGetClinicProducts(
  clinicId,
  categoryId: categoryId,
  sort: sort.toApiValue(),
  search: search,
  page: page,
  limit: limit,
);
```

```dart
ClinicProductsData _mapProducts(ClinicProductsResponseDto dto) {
  return ClinicProductsData(
    categories: dto.categories
        .map(
          (item) => ClinicProductCategory(
            id: item.id,
            label: item.label,
          ),
        )
        .toList(),
    products: dto.products.map(_mapProduct).toList(),
    totalCount: dto.totalCount.toInt(),
    hasMore: dto.hasMore,
  );
}
```

Behavior rules the frontend must follow:

- when selected chip id is `'all'`, do not send `categoryId`
- when selected chip id is a real UUID, send it as `categoryId`
- do not hardcode categories in the real API path
- use `data.categories` from the first page response as the category source for
  the category scroller
- use `totalCount` and `hasMore` exactly as returned by the server

### 3. `GET /user/clinics/{id}/reviews`

Generated call:

```dart
final dto = await api.userClinicControllerGetClinicReviews(
  clinicId,
  page: page,
  limit: limit,
  starCount: starCount,
  hasMedia: hasMedia,
);
```

Backend behavior:

- summary, filters, reviews, `totalCount`, and `hasMore` are all scoped to the
  clinic’s public products only
- filter ids remain compatible with the current frontend contract:
  - `all`
  - `${n}star`
  - `media`
- `memberBadge` and `serviceIcon` may remain `null`

Frontend guidance:

- continue rendering filter chips from `dto.filters`
- continue resolving selected chip ids into query params in the provider layer
- keep support for:
  - `all` -> no extra filter params
  - `5star`, `4star`, `3star`, `2star`, `1star` -> `starCount`
  - `media` -> `hasMedia: true`

The current `ClinicReviewsPaginated` provider already matches the intended
behavior and does not need a structural rewrite. The guide for the frontend team
should emphasize preserving this translation layer instead of pushing raw UI ids
down into the datasource.

## Category Filter Behavior

This is the highest-risk part of the integration because the frontend currently
mixes two concepts:

- UI state value: `'all'`
- API query parameter: `categoryId`

Those are not the same thing.

### Correct contract

- UI state may use `'all'` as the selected category id
- real API requests must never send `categoryId=all`
- the repository/provider layer should convert `'all'` to `null`
- the backend interprets missing `categoryId` as “All Services”

### Current frontend state that is already correct

`clinic_products.provider.dart` already does this:

```dart
categoryId: categoryId == 'all' ? null : categoryId
```

That provider behavior should be kept.

### Current frontend state that is not yet correct

The real datasource currently drops `categoryId` completely, so even when the
provider resolves a real UUID, the request still behaves as “all products”.

### Required frontend rule

Do this:

- selected chip `'all'` -> pass `null`
- selected chip real UUID -> pass that UUID to the datasource -> generated API

Do not do this:

- send `'all'` into the API client
- hardcode local categories for the real API path
- assume category ids are slugs or short labels

### Why this matters

The backend validates `categoryId` as UUID. If the caller sends `categoryId=all`,
the response will be `400 Bad Request`.

## State Management and Pagination Behavior

The current Riverpod setup is already close to correct. The frontend team should
keep the state model and update only the integration points that consume the API
response.

### Product tab state rules

`ClinicProductsPaginated` should continue to:

- watch sort state
- watch selected category state
- watch search query state
- fetch page 1 whenever any of those values change
- append only during `loadMore()`

Required behavior:

- category change resets to page 1
- search change resets to page 1
- sort change resets to page 1
- `loadMore()` must preserve the current sort/category/search combination
- categories should come from the latest page-1 response and stay attached to
  the accumulated state

Practical guidance:

- keep `ClinicProductsAccumulated.categories`
- on initial build, store `data.categories`
- on `loadMore()`, keep existing categories instead of replacing them with
  anything local

### Review tab state rules

`ClinicReviewsPaginated` should continue to:

- watch the selected review filter id
- resolve the filter id to `starCount` / `hasMedia`
- fetch page 1 when the selected filter changes
- append reviews during `loadMore()`

Keep the current compatibility behavior in `_resolveFilterParams(...)`:

- `all`
- `media`
- `5star`
- `4star`
- `3star`
- `2star`
- `1star`

This is still correct for the backend contract.

## Error Handling and Loading States

The generated client throws `ApiException` when the response status is `>= 400`.
The frontend feature should continue handling errors at the datasource/provider
boundary rather than inside the generated package.

### Expected failure modes

- `404` if the clinic id does not exist
- `400` if query params are invalid
  - example: `categoryId=all`
  - example: invalid `page`, `limit`, or `starCount`
- transport/network failures
- empty data states with `200 OK`

### UI handling guidance

Info tab:

- show error state if the whole info request fails
- do not try to silently fall back to mock content in production mode

Product tab:

- show loading indicator for first page
- show inline empty state when `products.isEmpty`
- keep category scroller hidden only if `categories.isEmpty`
- if categories are present and products are empty, still render the category
  scroller so the user can change filters

Review tab:

- render summary and filter chips from API response
- show empty-state review list when `reviews.isEmpty`
- do not synthesize filters client-side if the backend returns only `all`

### Logging guidance

If debugging is needed, log at the datasource/provider layer:

- outgoing `clinicId`
- outgoing `categoryId`
- outgoing `sort`, `search`, `page`, `limit`
- selected review filter id and resolved params

Do not add logging inside the generated `user_openapi` package.

## Mock-Data Alignment

The mock datasource can continue to simulate the same UX, but it should stay
aligned with the backend contract so developers do not get false confidence from
mock mode.

Current mock behavior in `ClinicInfoRemoteDatasourceMock` is mostly correct:

- it supports local `'all'` category selection
- it paginates products and reviews
- it returns `kMockClinicProductCategories`

### What should remain in mock mode

- local `'all'` handling
- client-side mock filtering by `categoryId`
- client-side mock sorting and pagination

### What should be documented clearly

- `'all'` is a frontend-only convenience value
- mock mode may keep using `'all'` internally
- real mode must convert `'all'` to `null` before calling the API

### Mock dataset recommendation

Keep the first mock category as:

```dart
ClinicProductCategory(id: 'all', label: 'All Services')
```

This keeps the UI consistent between mock mode and real mode.

## Validation Checklist

Use this checklist after the frontend integration patch is done.

### OpenAPI / compile checks

- `user_openapi` compiles without manual edits
- `UserClinicsApi.userClinicControllerGetClinicProducts(...)` exposes
  `categoryId`
- `ClinicProductsResponseDto` exposes `categories`

### Real datasource checks

- real datasource passes `categoryId` to
  `userClinicControllerGetClinicProducts(...)`
- real datasource maps `dto.categories`
- real datasource no longer returns `categories: const []`

### Product tab behavior checks

- category chips render from API response
- first chip is `All Services`
- selecting `All Services` does not send `categoryId`
- selecting a real category sends that UUID
- selecting a real category reloads page 1
- changing sort reloads page 1
- changing search reloads page 1
- load-more keeps current sort, category, and search values
- load-more appends products instead of replacing them
- `hasMore` controls further pagination correctly

### Review tab behavior checks

- summary renders from API response
- review filters render from API response
- selecting `all` sends no extra params
- selecting `5star` sends `starCount: 5`
- selecting `4star` sends `starCount: 4`
- selecting `media` sends `hasMedia: true`
- filter change reloads page 1
- review pagination appends correctly

### Empty-state checks

- clinic with no products still renders safely
- clinic with no review media still renders safely
- clinic with no reviews still renders safely
- category list with only `All Services` still renders safely

### Error-path checks

- invalid `categoryId=all` is understood as a caller bug and results in `400`
- missing clinic id results in error UI for `404`
- generated client exceptions are surfaced by the feature and not swallowed

## Known Warnings

- The generated OpenAPI package is already correct. Do not patch files under
  `user_app/openapi/lib/...` manually.
- The current real datasource is stale relative to the generated contract:
  - it does not pass `categoryId`
  - it discards `dto.categories`
  - it therefore prevents the category chip UI from using the backend response
- The current mock datasource special-cases `'all'`. That is fine for local UI
  simulation, but it must not become a real API query value.
- The backend validates `categoryId` as UUID. Any request that sends
  `categoryId=all` should be treated as frontend misuse of the API contract.
- Info-tab data shape did not change, but values may shift compared with older
  frontend expectations because backend aggregates are now restricted to public
  visible products only.
- Review-tab filters remain compatible with the current frontend ids
  (`all`, `${n}star`, `media`), so the frontend should preserve that mapping
  instead of inventing a new local filter scheme.
