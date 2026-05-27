# Healytics User App — Deep Scan & Missing E-Commerce Features Plan

## Executive Summary

A **complete deep scan** of every source file across **16 feature modules**, **core infrastructure** (10 subdirectories), and the **OpenAPI client** (48 API classes, 370 DTOs) reveals a well-architected Flutter application. The backend API surface is significantly larger than what the frontend currently uses — **multiple API controllers with full CRUD operations have zero frontend implementation**.

> [!IMPORTANT]
> The backend provides ready-to-use APIs for **Wishlist**, **Search**, **Saved Payment Cards** (partially used), **Vouchers/Coupons** (mock only), **Advanced Clinic Filtering**, and more — all with generated TypeScript DTOs waiting to be consumed.

---

## Current State — What EXISTS (Ground Truth from Full Scan)

### ✅ Implemented Feature Modules (16)

| # | Feature | Key Screens | Real API | Mock | Status |
|---|---------|-------------|----------|------|--------|
| 1 | `authenticate` | Sign In, Forgot Password (3 screens), Reset Password | ✅ 5/5 endpoints | ❌ No mock class | ✅ **Complete** |
| 2 | `onboarding` | Splash, Onboard, Email Form, OTP Verify, Finish Sign Up, Google Sign Up, Survey (4 steps) | ✅ 5/7 endpoints | ⚠️ OTP stubbed (hardcoded "12345") | ⚠️ **Mostly complete** |
| 3 | `home` | Home Dashboard, Recommendations, Recent Activity, Specialists, Premium Treatments | ✅ All | ✅ Full mock | ✅ **Complete** |
| 4 | `profile` | Profile, Edit Profile, Payment Cards | ✅ 8/8 endpoints | ✅ Full mock | ✅ **Complete** |
| 5 | `clinic_info` | Clinic Detail (3 tabs: Shop/Services/Reviews), Specialist List | ✅ All (pagination, filtering, sorting) | ✅ Full mock | ✅ **Complete** |
| 6 | `service_details` | Service Detail, Reviews List, Specialist Selection | ✅ All (5 providers) | ✅ Full mock | ✅ **Complete** |
| 7 | `booking` | Book Appointment (3-step wizard), Booking Summary | ✅ All (7 datasource methods) | ✅ 1653+ lines mock | ✅ **Complete** |
| 8 | `cart` | Cart Screen with search, voucher selection | ✅ CRUD (4/7 real) | ✅ Full mock | ⚠️ **Voucher/coupon APIs not wired** |
| 9 | `checkout` | Checkout, Success Dialog | ✅ Async checkout, ticket polling | ✅ Full mock | ✅ **Complete** (Stripe + MoMo + Pay Later) |
| 10 | `orders` | Orders (5 tabs + calendar view), Order Details, Service Manual | ✅ Real-time WS booking status | ✅ Full mock | ✅ **Complete** |
| 11 | `partner_chat` | Chat Screen with real-time WS | ✅ WebSocket + REST | ✅ (implied) | ✅ **Complete** (typing indicators, read receipts) |
| 12 | `notifications` | Notification List (date-grouped, paginated) | ✅ Cursor-paginated + WS real-time | ✅ | ✅ **Complete** (toast + local notifications) |
| 13 | `review` | Treatment → Specialist → Facility → Submitted (4-screen flow) | ✅ 3 review types | ✅ | ✅ **Complete** (auto-trigger on booking completion) |
| 14 | `ai_health_assistant` | Landing, Chat (SSE streaming), Conversation History | ✅ SSE streaming | ✅ | ✅ **Complete** (rich message types) |
| 15 | `employee` | Employee Detail, Booking, Reviews, Certificates (PDF/image viewer) | ✅ All | ✅ | ✅ **Complete** |
| 16 | `app` | Splash, Root App widget | ✅ | N/A | ✅ **Complete** |

### ✅ Core Infrastructure (Fully Scanned)

| Component | Details | Status |
|-----------|---------|--------|
| **Architecture** | Clean Architecture + Riverpod 3.0 codegen | ✅ |
| **State Management** | `hooks_riverpod: ^3.0.3`, `riverpod_annotation: ^3.0.3` | ✅ |
| **Router** | GoRouter with 50+ typed routes, auth guards, MoMo deep-link redirect | ✅ |
| **Theme** | Material 3 + `flex_color_scheme`, `SemanticColors` ThemeExtension, AMOLED black mode | ✅ |
| **WebSocket** | 4 typed Socket.IO clients: BookingEvents, UserChat, ChatNotifications, Notifications | ✅ |
| **Push Notifications** | Firebase Messaging with background handler + `flutter_local_notifications` | ✅ |
| **Payments** | Stripe (PaymentIntent + SetupIntent + saved cards) + MoMo (deep-link + web fallback) | ✅ |
| **Maps** | `flutter_map` + CARTO tiles + Mapbox API (geocoding, directions, distance) | ✅ |
| **File Upload** | S3 presigned URL upload via `S3Service` | ✅ |
| **Database** | Drift with `StoreValue` table, WAL mode, migration support | ✅ |
| **Secure Storage** | `StoreService` with in-memory cache + Drift DB sync, JWT decoding | ✅ |
| **Auth Token** | `AuthHttpClient` with auto-retry on 401, `Completer<bool>` for concurrent refresh prevention | ✅ |
| **Error Handling** | `AppException` sealed class, `ErrorObserver` for all providers, `GlobalErrorStream` | ✅ |
| **i18n** | `slang` with English (full) | ✅ |
| **Location** | `geolocator` + `geocoding` for user location | ✅ |
| **Testing** | `patrol: 4.2.0`, `mocktail`, `glados`, integration test keys defined | ✅ |
| **Mock Toggle** | `AppEnvironment.useMock` flag per environment | ✅ |

### ✅ Key Corrections from Deep Scan

Several things that appeared missing in a shallow scan are actually **already implemented**:

| Feature | Previously Assumed | Actually Found |
|---------|-------------------|----------------|
| Forgot/Reset Password | ❌ Missing | ✅ **3 screens fully implemented** (ForgotPassword → ResetCode → ResetPassword) |
| Token Refresh | ❌ Missing | ✅ **AuthHttpClient auto-retries 401** with `Completer<bool>` for concurrent refresh prevention |
| Account Deletion | ❌ Missing | ✅ **Fully implemented** in Edit Profile with DELETE confirmation dialog |
| Change Password | ❌ Missing | ✅ **Fully implemented** in Edit Profile Security section |
| Push Notifications | ❌ Missing | ✅ **FCM + local notifications** with background handler, deep-link routing |
| Typing Indicators | ❌ Missing | ✅ **Fully implemented** in partner_chat with bouncing dots animation |
| Read Receipts | ❌ Missing | ✅ **Implemented** (clock → check → double-check icons) |
| Map Integration | ❌ Missing | ✅ **FlutterMap + Mapbox directions** with route polyline + distance/duration |
| Saved Payment Cards | ❌ Missing | ✅ **PaymentCardsScreen** in profile + Stripe SetupIntent flow |
| Payment History | ❌ Missing | ✅ **Checkout handles pending payment** status with countdown timer |
| Streaming AI | ❌ Missing | ✅ **SSE streaming** with token-by-token rendering |
| Calendar View | ❌ Missing | ✅ **TableCalendar** with markers and agenda cards in orders |
| Service Gallery | ❌ Missing | ✅ **Hero image carousel** with PageView in service details |
| Clinic Follow/Unfollow | ❌ Missing | ✅ **Optimistic update** with follow/unfollow API |

---

## Gap Analysis — What's ACTUALLY Missing

After reading every file, these are the **genuine gaps** between the backend API surface and the frontend implementation:

### Overview Matrix

| # | Missing Feature | Backend API Ready? | Frontend Status | Priority | Effort |
|---|----------------|--------------------|-----------------|----------|--------|
| 1 | **Wishlist** | ✅ `UserWishlistApi` | ⚠️ Toggle exists in service_details but **no feature module** | P0 | Medium |
| 2 | **Global Search Screen** | ✅ `UserBookingSearchApi` | ⚠️ Booking has search popup, **no dedicated search feature** | P0 | Large |
| 3 | **Voucher/Coupon Backend Integration** | ❌ **API not in backend spec** | ⚠️ Cart has full mock voucher system, **real API returns unchanged** | P1 | Backend-blocked |
| 4 | **Clinic Products Advanced Filters** | ✅ `minPrice/maxPrice/minDuration/maxDuration/discountOnly` | ❌ Available in API, **not wired in frontend filter sheet** | P1 | Small |
| 5 | **Clinic Products Category Mapping** | ✅ API returns `categories` | ❌ Real datasource returns `const []` instead of mapping | P0 | Tiny |
| 6 | **Pending Payment DTO Fields** | ✅ `paymentUrl`, `paymentExpiresAt` in DTO | ⚠️ TODO marker in real datasource (~line 114) | P0 | Tiny |
| 7 | **MoMo Payment Integration Guide** | ✅ Full API available | ⚠️ Checkout impl exists but **no user-facing guide** | P2 | Small |
| 8 | **OTP Send/Verify (Real Backend)** | ❓ Unknown if backend exists | ⚠️ Hardcoded to "12345" in onboarding datasource | P1 | Small |
| 9 | **Notification Preferences Backend Sync** | ✅ `NotificationControllerApi.updatePreferences` implied | ⚠️ Settings toggles are **local only** | P1 | Small |
| 10 | **Booking Reschedule** | ✅ `BookingControllerApi.rescheduleBooking` | ❌ No UI for rescheduling | P1 | Medium |
| 11 | **Employee Availability in Booking** | ✅ `EmployeeControllerApi.getAvailability` | ⚠️ Time slots used but **availability calendar not shown** | P2 | Medium |
| 12 | **Review Edit/Delete** | ❓ Unknown if API supports | ❌ Current flow is create-only (3 types) | P2 | Small |
| 13 | **Offline/Cache Mode** | N/A | ❌ Drift DB exists but only used for `StoreValue` KV store | P2 | Large |
| 14 | **Analytics/Tracking** | N/A | ❌ No Firebase Analytics, no event tracking | P1 | Medium |
| 15 | **Crash Reporting** | N/A | ❌ No Crashlytics or Sentry | P0 | Small |

---

## Detailed Feature Specifications

---

### 1. 🫶 Wishlist Feature Module

**Priority:** P0 – Critical | **Effort:** Medium (2–3 days) | **Backend:** ✅ Ready

#### Current State

The `service_details` feature already has a **wishlist toggle** (heart icon) on the service detail screen with optimistic UI update. The `ServiceDetailsRepository` has a `setWishlisted(serviceId, isWishlisted)` method. The `UserWishlistApi` provides `GET/POST/DELETE /user/wishlist/{productId}`.

**However**: There is **no Wishlist list screen**, **no profile menu entry**, and **no dedicated feature module**. Users can toggle wishlist but cannot view their saved items.

#### What Needs to Be Built

```
lib/features/wishlist/
├── data/
│   ├── datasources/remote/
│   │   ├── wishlist_remote_datasource.dart
│   │   └── wishlist_mock_data.dart
│   ├── provider/
│   │   └── wishlist.provider.dart
│   └── repositories/
│       └── wishlist_impl.repository.dart
├── domain/
│   ├── entities/
│   │   └── wishlist_item.entity.dart
│   └── repositories/
│       └── wishlist.repository.dart
└── presentation/
    ├── providers/
    │   └── wishlist.provider.dart
    ├── screens/
    │   └── wishlist.screen.dart
    └── widgets/
        └── wishlist_item_card.widget.dart
```

#### Entity Design

```dart
/// Represents a saved wishlist item.
class WishlistItemEntity {
  final String id;
  final String serviceId;
  final String serviceName;
  final String? imageUrl;
  final double price;
  final String? clinicName;
  final double? rating;
  final int? reviewCount;
  final DateTime addedAt;
}
```

#### Backend Endpoints to Integrate

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `UserWishlistApi.getWishlist()` | GET `/user/wishlist` | List all wishlisted services |
| `UserWishlistApi.addToWishlist(productId)` | POST `/user/wishlist/{productId}` | Add to wishlist |
| `UserWishlistApi.removeFromWishlist(productId)` | DELETE `/user/wishlist/{productId}` | Remove from wishlist |

#### Existing Code to Modify

- **`routes.dart`** → Add `WishlistRoute` (`/wishlist`)
- **`profile.screen.dart`** → `ProfileQuickStats` already shows "Wishlist" count from `profileSummaryProvider` — make it navigate to `WishlistRoute`
- **`service_details.screen.dart`** → Already has toggle, no changes needed

#### Acceptance Criteria

- [ ] Wishlist list screen accessible from Profile `ProfileQuickStats` "Wishlist" tile
- [ ] Each item card shows service image, name, price, clinic name, rating
- [ ] Tap navigates to `ServiceDetailsRoute`
- [ ] Swipe-to-remove with optimistic update
- [ ] Pull-to-refresh
- [ ] Empty state with "Explore Services" CTA → `HomeRoute`
- [ ] Wishlist count in profile `ProfileQuickStats` reflects real data

---

### 2. 🔍 Global Search Feature

**Priority:** P0 – Critical | **Effort:** Large (3–4 days) | **Backend:** ✅ Ready

#### Current State

The booking feature has a `BookingSearchBar` widget with a debounced popup showing `BookingSearchResult` (services + specialists). The `UserBookingSearchApi` provides `GET /user/booking-search?q=`. However, this is a **booking-context-only popup**, not a standalone search screen. There is **no search from the home screen** and no way to search clinics specifically.

The home screen has a `QuickActionsSection` but **no search bar**. Users must navigate to "Book Appointment" to access any search functionality.

#### What Needs to Be Built

```
lib/features/search/
├── data/
│   ├── datasources/remote/
│   │   ├── search_remote_datasource.dart
│   │   └── search_mock_data.dart
│   ├── provider/
│   │   └── search.provider.dart
│   └── repositories/
│       └── search_impl.repository.dart
├── domain/
│   ├── entities/
│   │   └── search_result.entity.dart
│   └── repositories/
│       └── search.repository.dart
└── presentation/
    ├── providers/
    │   └── search.provider.dart
    ├── screens/
    │   └── search.screen.dart
    └── widgets/
        ├── search_result_card.widget.dart
        ├── search_empty_state.widget.dart
        └── recent_searches.widget.dart
```

#### Entity Design

Can reuse/extend the existing `BookingSearchResult` entity:

```dart
class SearchResultEntity {
  final List<BookingService> services;
  final List<BookingSpecialist> specialists;
  // Future: clinics
}
```

#### Backend Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `UserBookingSearchApi.searchBooking(q)` | GET `/user/booking-search?q=` | Search services + specialists |
| `PartnerControllerApi.search(q)` | GET (if available) | Search partners/clinics |

#### Acceptance Criteria

- [ ] Search screen accessible from home (add search bar or quick action)
- [ ] Full-screen search with auto-focus on keyboard
- [ ] Debounced search (300ms) using `useDebounce` hook
- [ ] Results grouped by type: Services | Specialists
- [ ] Service tap → `ServiceDetailsRoute`; Specialist tap → `EmployeeDetailRoute`
- [ ] Recent searches persisted locally (SharedPreferences)
- [ ] Clear search history button
- [ ] Empty/No-results states

---

### 3. 🎫 Voucher/Coupon Backend Integration

**Priority:** P1 – High | **Effort:** Backend-blocked | **Backend:** ❌ NOT ready

#### Current State

The cart feature has a **fully functional mock voucher system**:
- `VoucherEntity` with `code`, `discountPercent`, `maxDiscount`, `expiresAt`
- `CartRepository.applyCoupon()`, `.removeCoupon()`, `.getAvailableVouchers()`
- `VoucherPickerSheet` bottom sheet UI
- `VoucherSelectorRow` per cart item
- Mock simulates 5% discount for any code

**But the real datasource explicitly notes**: `applyCoupon()` returns the item unchanged with a warning log. `getAvailableVouchers()` returns empty list. The backend does not have voucher/coupon endpoints in the OpenAPI spec.

> [!WARNING]
> This feature is **backend-blocked**. The frontend mock is ready but the backend API does not exist yet. When the backend adds voucher endpoints, only the real datasource implementation needs to be updated — no UI changes required.

#### What Needs to Be Done (When Backend is Ready)

- [ ] Update `CartRemoteDataSourceImpl.applyCoupon()` to call real API
- [ ] Update `CartRemoteDataSourceImpl.removeCoupon()` to call real API
- [ ] Update `CartRemoteDataSourceImpl.getAvailableVouchers()` to call real API
- [ ] Test end-to-end with real discount calculations

---

### 4. 🔧 Clinic Products Advanced Filters (Quick Win)

**Priority:** P1 – High | **Effort:** Small (0.5 day) | **Backend:** ✅ Ready

#### Current State

The `ClinicInfoScreen` has a `ProductFilterSheet` bottom sheet UI that can display price and duration filters. The `ClinicProductFilters` entity already has `minPrice`, `maxPrice`, `minDuration`, `maxDuration`, `discountOnly` fields. The API accepts all these parameters.

**However**: The `ClinicInfoRemoteDataSourceImpl` is not passing these filter parameters to the API call. The filters work only in mock mode.

#### What Needs to Be Done

- [ ] In `clinic_info_remote_datasource.dart` real impl: pass `filters.minPrice`, `filters.maxPrice`, `filters.minDuration`, `filters.maxDuration`, `filters.discountOnly` to the API call
- [ ] Verify filter behavior with real API responses

---

### 5. 🏷️ Clinic Products Category Mapping (Quick Fix)

**Priority:** P0 – Critical | **Effort:** Tiny (< 1 hour) | **Backend:** ✅ Ready

#### Current State

The real datasource's `getClinicProducts()` method **returns `const []`** for categories instead of mapping `dto.categories` from the API response. This means the category chips in the Services tab don't work with real data.

> [!CAUTION]
> This is documented in `CLINIC_INFO_FRONTEND_INTEGRATION.md` as a known gap. It's a simple mapping fix.

#### What Needs to Be Done

- [ ] In `clinic_info_remote_datasource.dart`: Map `dto.categories` to `List<ClinicProductCategory>` instead of returning `const []`
- [ ] Verify category chips populate correctly with real data

---

### 6. 💳 Pending Payment DTO Mapping (Quick Fix)

**Priority:** P0 – Critical | **Effort:** Tiny (< 1 hour) | **Backend:** ✅ Ready

#### Current State

The appointment remote datasource has a **TODO marker** (~line 114) where `paymentUrl` and `paymentExpiresAt` from the DTO are not mapped to the entity. The `AppointmentEntity` already has these fields. The UI already handles `paymentUrl` with a countdown timer and deep-link/web launch.

#### What Needs to Be Done

- [ ] In `appointment_remote_datasource.dart` real impl: Map `dto.paymentUrl` → entity `paymentUrl`
- [ ] Map `dto.paymentExpiresAt` → entity `paymentExpiresAt`
- [ ] Optional: Map `dto.paymentDeeplink` → entity `paymentDeeplink`

---

### 7. ✉️ OTP Verification (Real Backend)

**Priority:** P1 – High | **Effort:** Small (0.5 day) | **Backend:** ❓ Needs verification

#### Current State

In `register_remote_datasource.dart`, the OTP send and verify methods are **hardcoded**:
- `sendOtp()` → `Future.delayed(500ms)` (no API call)
- `verifyCode()` → checks against hardcoded `"12345"`

The backend has `POST /auth/user/register` but it's unclear if separate OTP endpoints exist.

#### What Needs to Be Done

- [ ] Verify if backend has `POST /auth/user/send-otp` and `POST /auth/user/verify-otp` endpoints
- [ ] If yes: Wire real API calls in `RegisterRemoteDatasourceImpl`
- [ ] If no: Discuss with backend team to add OTP verification endpoints

---

### 8. 🔔 Notification Preferences Backend Sync

**Priority:** P1 – High | **Effort:** Small (0.5 day) | **Backend:** ✅ Ready (`UserDevicesApi`)

#### Current State

The app has `NotificationConfig` with runtime switches (`inAppEnabled`, `webSocketEnabled`, etc.) that load from the `Store`. Device registration exists via `UserDevicesApi.registerDevice()` / `.unregisterDevice()`. Push notifications are functional.

However, there's no UI for users to toggle notification preferences, and the backend sync for preference updates is not exposed.

#### What Needs to Be Done

- [ ] Add notification preferences section in Settings/Profile
- [ ] Wire toggle states to `NotificationConfig` persistence
- [ ] Sync device registration/unregistration based on user preference

---

### 9. 📅 Booking Reschedule

**Priority:** P1 – High | **Effort:** Medium (2 days) | **Backend:** ✅ Ready

#### Current State

Bookings can be created but **not rescheduled**. The `BookingControllerApi` has `rescheduleBooking` endpoint available but unused.

#### What Needs to Be Built

- [ ] "Reschedule" button on order detail screen (for upcoming/confirmed bookings)
- [ ] Reschedule flow: reuses `DatePickerRow` + `TimeSlotSection` from booking feature
- [ ] New datasource method: `rescheduleBooking(bookingId, newDate, newTimeSlot)`
- [ ] Confirmation dialog before rescheduling
- [ ] Toast notification on success
- [ ] Auto-refresh order list after reschedule

---

### 10. 📊 Analytics & Crash Reporting

**Priority:** P0/P1 | **Effort:** Medium (1–2 days) | **Backend:** N/A (client-side)

#### Current State

No analytics or crash reporting is set up. Firebase is already a dependency for push notifications.

#### What Needs to Be Done

- [ ] Add `firebase_analytics` and `firebase_crashlytics` to pubspec.yaml
- [ ] Initialize in `main.dart` alongside existing Firebase setup
- [ ] Wire `FlutterError.onError` to Crashlytics (currently only logs)
- [ ] Add screen view tracking to GoRouter observer
- [ ] Track key events: sign_in, sign_up, add_to_cart, checkout, booking_created

---

## Gaps in EXISTING Features (Detailed)

| Feature | Gap | Severity | Fix Effort |
|---------|-----|----------|------------|
| **Clinic Info** | Real datasource returns `const []` for categories | 🔴 High | < 1 hour |
| **Clinic Info** | Advanced filters (price/duration/discount) not passed to API | 🟡 Medium | < 1 hour |
| **Orders** | Pending payment `paymentUrl`/`paymentExpiresAt` not mapped from DTO | 🔴 High | < 1 hour |
| **Cart** | Voucher/Coupon `applyCoupon`/`removeCoupon`/`getAvailableVouchers` return mock data | 🟡 Medium | Backend-blocked |
| **Onboarding** | OTP send/verify hardcoded to "12345" | 🟡 Medium | 0.5 day |
| **Checkout** | `getCheckoutData()` throws `UnimplementedError` (builds from params locally) | 🟢 Low | By design |
| **Checkout** | Stripe card/setup APIs use raw `invokeAPI()` instead of generated client | 🟢 Low | When OpenAPI spec updated |
| **Booking** | No repository abstraction layer (datasource used directly from providers) | 🟢 Low | Architecture deviation, functional |
| **AppointmentEntity** | Not using `@freezed` (manual `copyWith`/`==`/`hashCode`) | 🟢 Low | Refactor opportunity |
| **CartItemEntity** | Not using `@freezed` (manual `copyWith`) | 🟢 Low | Refactor opportunity |

---

## Implementation Phases

### Phase 0: Quick Fixes (< 1 day total)

> [!TIP]
> These are trivial fixes that unlock real API functionality. They should be done immediately.

| # | Fix | Est. Time |
|---|-----|-----------|
| 1 | Clinic products category mapping (`const []` → `dto.categories`) | 30 min |
| 2 | Pending payment DTO field mapping (`paymentUrl`, `paymentExpiresAt`) | 30 min |
| 3 | Clinic products advanced filter parameter passing | 30 min |
| **Total** | | **~1.5 hours** |

---

### Phase 1: Core Missing Features (P0) — Week 1–2

| # | Feature | Est. Days |
|---|---------|-----------|
| 1 | Wishlist list screen + feature module | 2 |
| 2 | Global Search feature (reuse booking search) | 3 |
| 3 | Crash Reporting (Firebase Crashlytics) | 0.5 |
| **Total** | | **~5.5 days** |

---

### Phase 2: Enhancement & Polish (P1) — Week 2–3

| # | Feature | Est. Days |
|---|---------|-----------|
| 4 | Booking Reschedule flow | 2 |
| 5 | OTP verification (wire real backend) | 0.5 |
| 6 | Notification preferences sync | 0.5 |
| 7 | Analytics (Firebase Analytics + screen tracking) | 1 |
| **Total** | | **~4 days** |

---

### Phase 3: Advanced (P2) — Week 3–4

| # | Feature | Est. Days |
|---|---------|-----------|
| 8 | Employee availability calendar in booking | 2 |
| 9 | Review edit/delete (if backend supports) | 1 |
| 10 | Offline caching with Drift | 3+ |
| **Total** | | **~6 days** |

---

## Backend-Blocked Items (Require Backend Work First)

| Feature | What's Missing on Backend | Frontend Readiness |
|---------|--------------------------|-------------------|
| Voucher/Coupon System | No voucher/coupon API endpoints in OpenAPI spec | ✅ Full mock UI ready, just needs real API wiring |
| Loyalty/Rewards Program | No loyalty API in current spec | ❌ Need full feature module |
| Referral Program | No referral API in current spec | ❌ Need full feature module |
| Insurance Management | No insurance API in current spec | ❌ Need full feature module |
| Health Records | No health records API in current spec | ❌ Need full feature module |
| Reports/Analytics | No user-facing reports API in current spec | ❌ Need full feature module |
| Address Management | No dedicated address API (only `PATCH /account/me/address`) | ⚠️ Single address exists in profile, no multi-address support |

> [!IMPORTANT]
> The initial analysis assumed many API controllers existed (FavoriteControllerApi, PromotionControllerApi, etc.) based on common e-commerce patterns. The **actual** OpenAPI spec contains **48 API classes** — but many are admin/partner-only. The user-facing APIs are well-covered for the current feature set. The gaps are more about **wiring existing real implementations** than building entirely new features.

---

## Verification Plan

### Quick Fix Verification
```bash
# After each quick fix, run in real API mode and verify:
# 1. Clinic products show category chips
# 2. Clinic products filter by price/duration works
# 3. Pending payment orders show countdown timer
```

### Feature Verification
```bash
# Unit tests for new domain & data layers
flutter test test/features/wishlist/
flutter test test/features/search/

# Full test suite
flutter test

# Lint check
dart analyze
```

### Manual Verification
- Test on iPhone SE (320dp), iPhone 14 (393dp), iPhone 16 Pro Max (430dp)
- Verify mock mode works for all new features
- Verify real API integration
- Test dark mode for all new screens

---

## Open Questions

> [!IMPORTANT]
> **1. Voucher Backend Timeline**: When will the backend add voucher/coupon API endpoints? The frontend mock system is fully built and waiting.

> [!IMPORTANT]
> **2. OTP Backend Verification**: Does `POST /auth/user/register` handle OTP internally, or are there separate send/verify endpoints? This affects the onboarding fix.

> [!IMPORTANT]
> **3. Multi-Address Support**: The current backend only supports `PATCH /account/me/address` (single address). Is there a plan for multiple saved addresses?

> [!IMPORTANT]
> **4. Future E-Commerce Features**: Should we plan for Loyalty, Referral, Insurance, Health Records features? These would require **backend API development first** — they don't exist in the current spec.

> [!IMPORTANT]
> **5. Which items should I start implementing?** I recommend starting with Phase 0 quick fixes (< 2 hours total) followed by the Wishlist feature module. Would you like me to proceed?
