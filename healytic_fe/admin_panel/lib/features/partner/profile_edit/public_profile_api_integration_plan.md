# Partner Public Profile API Integration Plan

## Current feature shape

- Route: `ProfileEditRoute` in `lib/router/partner_routes.dart`.
- Screen: `lib/features/partner/profile_edit/presentation/screens/profile_edit.screen.dart`.
- State: `PublicProfileEditNotifier` loads the server aggregate, keeps a server snapshot plus local draft, and builds a sparse save payload.
- Datasource: `PublicProfileRemoteDataSourceImpl` uses `ApiService.partnerPartnersApi`.
- Mock switching: `publicProfileDataSourceProvider` still respects `StoreKey.mockFlag`.

## Backend contract found

- `GET /backend/partner/partners/public-profile`
  - Controller: `backend/src/partners/partners.controller.ts`.
  - Service: `PartnersService.getPartnerPublicProfile`.
  - Response: `PartnerPublicProfileResponseDto`.
  - Purpose: load read-only verified business data, legal summary, editable storefront fields, and completion checklist.
- `PUT /backend/partner/partners/public-profile`
  - Controller: `PartnerSelfController.updatePublicProfile`.
  - Service: `PartnersService.updatePartnerPublicProfile`.
  - Handler: `UpdatePartnerPublicProfileHandler`.
  - Request: `UpdatePartnerPublicProfileDto`.
  - Purpose: update storefront-only fields: cover image, logo image, description, gallery, and certifications.

## Gaps and fixes

- No new endpoint is needed. The backend already exposes the required public profile read and update APIs, and `admin_openapi` already has generated methods for both endpoints.
- The generated `UpdatePartnerPublicProfileDto.toJson()` sends `null` for optional strings and empty arrays for optional lists. That breaks sparse PATCH-like behavior on the `PUT` endpoint because unchanged fields can be cleared accidentally.
- The frontend feature must use a sparse wrapper DTO that only serializes fields that actually changed. Included `null` remains meaningful for an intentional clear, while omitted fields stay unchanged.
- The screen must not save an incomplete public profile. The backend requires an approved and completed profile to access the public-profile endpoint, so saving a missing cover, logo, valid description, or minimum gallery can produce a failed readback after mutation.

## Implementation checklist

- Keep generated OpenAPI files untouched.
- Add a feature-local sparse update patch model that tracks both field values and field inclusion.
- Map the patch into a custom `UpdatePartnerPublicProfileDto` subclass with a sparse `toJson()`.
- Update mock datasource behavior to match real sparse semantics.
- Block save when required public profile fields are incomplete and surface validation state in the reused completion widgets.
- Run scoped Dart analysis on `lib/features/partner/profile_edit` and `lib/core/services/api.service.dart`.
- Run `make run-uat` and verify the UAT route loads against the real backend with mock mode off.

## Manual UAT acceptance

- Sign in as an approved partner with profile completion already done.
- Open the partner edit-profile route.
- Verify the initial GET loads business info, address, legal summary, current storefront media, description, gallery, certifications, and completion checklist.
- Edit only one field, save, and verify all other storefront fields remain unchanged.
- Remove or reduce a required field locally and verify save is blocked until the profile is complete again.
- Reorder gallery or certifications, save, reload, and verify ordering persists.
