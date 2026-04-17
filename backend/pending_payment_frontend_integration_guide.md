# Frontend Integration Guide: Pending Payment Status

This guide details every frontend change required to fully integrate the backend's `pending_payment` appointment status and payment fields.

---

## 1. What Changed in the Backend

### 1.1 `AppointmentResponseDto` — 3 New Fields + New Status

The `GET /v1/user/appointments` and `GET /v1/user/appointments/:id` endpoints now return:

| Field | Type | Nullable | When Present |
|---|---|---|---|
| `status` | `string` enum | No | **New value:** `pending_payment` (in addition to `upcoming`, `completed`, `canceled`) |
| `paymentUrl` | `string` | Yes | Non-null only when `status = pending_payment` |
| `paymentDeeplink` | `string` | Yes | Non-null only when `status = pending_payment` — opens MoMo app directly |
| `paymentExpiresAt` | `string` (ISO 8601) | Yes | Non-null only when `status = pending_payment` — typically 10 min from booking creation |

### 1.2 `RecentActivityResponseDto` — New Status

The `GET /v1/user/appointments/recent-activity` endpoint now returns:

| Field | Type | Change |
|---|---|---|
| `status` | `string` enum | **New value:** `PENDING_PAYMENT` (in addition to `COMPLETED`, `SCHEDULED`, `CANCELED`) |

### 1.3 Automatic Expiration (Backend Cron)

A cron job runs every minute. When `paymentExpiresAt < NOW()` and `status = PENDING_PAYMENT`, the booking is automatically cancelled. The frontend countdown timer should reflect this — when the timer hits zero, the appointment moves from the "Pending" tab to the "Canceled" tab on next refresh.

### 1.4 API Response Examples

**Pending payment appointment:**
```json
{
  "id": "apt-123",
  "serviceName": "Hot Stone Therapy",
  "healthPartnerName": "Glow Saigon Spa Retreat",
  "healthPartnerId": "vendor-spa-1",
  "imageUrl": "https://...",
  "status": "pending_payment",
  "category": "spa",
  "specialistName": "Dr Alexander Linda",
  "specialistId": "emp-doctor-1",
  "serviceId": "svc-hot-stone",
  "address": "311 Vo Van Tan, Ward 14, District 1, HCM City, VN",
  "date": "2026-04-15T00:00:00.000Z",
  "checkInTime": "9:00 AM",
  "checkOutTime": "10:00 AM",
  "duration": "60 min",
  "distanceKm": 2.5,
  "isReviewed": false,
  "paymentUrl": "https://test-payment.momo.vn/gw_payment/transactionProcessor?..",
  "paymentDeeplink": "momo://app?action=payWithApp&amount=500000&...",
  "paymentExpiresAt": "2026-04-14T12:10:00.000Z"
}
```

**Non-pending appointment (unchanged):**
```json
{
  "id": "apt-456",
  "status": "upcoming",
  "paymentUrl": null,
  "paymentDeeplink": null,
  "paymentExpiresAt": null
}
```

---

## 2. OpenAPI Client Regeneration

After pulling the latest backend, regenerate the Dart client:

```bash
cd healytic_fe/user_app
make generate-openapi
```

This will automatically:
- Add `pending_payment` to `AppointmentResponseDtoStatusEnum`
- Add `paymentUrl`, `paymentDeeplink`, `paymentExpiresAt` fields to `AppointmentResponseDto`
- Add `PENDING_PAYMENT` to `RecentActivityResponseDtoStatusEnum`

---

## 3. Current Frontend Status (What's Already Done)

The frontend was pre-scaffolded in a previous conversation. Here's what **already works**:

| Concern | File | Status |
|---------|------|--------|
| `AppointmentEntity.paymentUrl` field | `domain/entities/appointment.entity.dart` | ✅ Already has `paymentUrl` and `paymentExpiresAt` |
| Tab bar with "Pending" tab | `presentation/widgets/orders/orders_tab_bar.widget.dart` | ✅ 4-tab layout: Pending, Upcoming, Completed, Canceled |
| Tab index constants | `presentation/providers/appointment.provider.dart` | ✅ `kTabPendingPayment = 0`, status filter: `'pending_payment'` |
| Status badge styling | `presentation/widgets/orders/appointment_card.widget.dart` | ✅ `'pending_payment' => (orange bg, orange text, 'Pending Payment')` |
| Payment banner with countdown | `presentation/widgets/orders/appointment_card.widget.dart` | ✅ `_PaymentBanner` widget with live countdown timer |
| Mock data | `data/datasources/remote/appointment_mock_data.dart` | ✅ Two mock appointments with `status: 'pending_payment'` |

---

## 4. What Needs to Change (TODO)

### 4.1 Resolve the DTO Mapping TODO

**File:** `data/datasources/remote/appointment_remote_datasource.dart`, line ~114

The existing code has a `TODO(api)` marker:

```dart
// TODO(api): Map dto.paymentUrl and
// dto.paymentExpiresAt once the backend adds
// these fields to AppointmentResponseDto.
```

**After regenerating the OpenAPI client**, update `_mapAppointmentDto` to map the 3 new fields:

```diff
  AppointmentEntity _mapAppointmentDto(AppointmentResponseDto dto) {
    return AppointmentEntity(
      id: dto.id,
      serviceName: dto.serviceName,
      healthPartnerName: dto.healthPartnerName,
      healthPartnerId: _parseString(dto.healthPartnerId)!,
      imageUrl: dto.imageUrl,
      status: dto.status.value.toLowerCase(),
      category: dto.category,
      specialistName: dto.specialistName,
      specialistId: dto.specialistId,
      serviceId: _parseString(dto.serviceId),
      address: dto.address,
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      checkInTime: dto.checkInTime,
      checkOutTime: dto.checkOutTime,
      duration: dto.duration,
      distanceKm: _parseDistance(dto.distanceKm),
      isReviewed: dto.isReviewed,
-     // TODO(api): Map dto.paymentUrl and
-     // dto.paymentExpiresAt once the backend adds
-     // these fields to AppointmentResponseDto.
+     paymentUrl: _parseString(dto.paymentUrl),
+     paymentExpiresAt: dto.paymentExpiresAt != null
+         ? DateTime.tryParse(dto.paymentExpiresAt!)
+         : null,
    );
  }
```

> **Note:** `paymentDeeplink` is not mapped to the domain entity. It's available in the DTO for future use — the `_PaymentBanner` currently uses `paymentUrl` for the web checkout flow. If you want to support opening the MoMo app directly on mobile, add `paymentDeeplink` to `AppointmentEntity` and use `url_launcher` with `launchUrl(Uri.parse(paymentDeeplink))`.

### 4.2 Add `paymentDeeplink` to `AppointmentEntity` (Optional)

If the mobile team wants to open the MoMo app directly instead of a webview:

**File:** `domain/entities/appointment.entity.dart`

```diff
  /// Payment gateway checkout URL.
  /// Non-null only when status is `pending_payment`.
  final String? paymentUrl;

+ /// Deep link to open the payment app directly (e.g. MoMo).
+ /// Non-null only when status is `pending_payment`.
+ final String? paymentDeeplink;

  /// When the payment link expires.
  /// Non-null only when status is `pending_payment`.
  final DateTime? paymentExpiresAt;
```

Then update the constructor, `==`, and `hashCode` to include `paymentDeeplink`.

### 4.3 Update `_PaymentBanner` to Use Deep Link (Optional)

If `paymentDeeplink` is added to the entity:

**File:** `presentation/widgets/orders/appointment_card.widget.dart`

```dart
// In the "Pay Now" button handler:
onPressed: () async {
  final deeplink = appointment.paymentDeeplink;
  final webUrl = appointment.paymentUrl;

  // Try deep link first (opens MoMo app), fallback to web checkout
  if (deeplink != null && await canLaunchUrl(Uri.parse(deeplink))) {
    await launchUrl(Uri.parse(deeplink), mode: LaunchMode.externalApplication);
  } else if (webUrl != null) {
    await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
  }
}
```

---

## 5. Home Dashboard: Recent Activity Widget

If your home page uses the `RecentActivityResponseDto`, the status mapping has changed:

### Before
```
BookingStatus.PENDING_PAYMENT → RecentActivityStatus.SCHEDULED
```

### After
```
BookingStatus.PENDING_PAYMENT → RecentActivityStatus.PENDING_PAYMENT
```

**What to update in the frontend:**

The recent activity icon/badge mapping should now handle `PENDING_PAYMENT` as a distinct status. If your widget uses a `switch` expression for status colors:

```dart
final (bgColor, textColor, label) = switch (status) {
  'PENDING_PAYMENT' => (
    const Color(0xFFFFF7ED),    // orange-50
    const Color(0xFFEA580C),    // orange-600
    'Pending Payment',
  ),
  'SCHEDULED' => (
    const Color(0xFFDBEAFE),    // blue-100
    const Color(0xFF2563EB),    // blue-600
    'Scheduled',
  ),
  'COMPLETED' => (
    const Color(0xFFDCFCE7),    // green-100
    const Color(0xFF16A34A),    // green-600
    'Completed',
  ),
  'CANCELED' => (
    const Color(0xFFFEE2E2),    // red-100
    const Color(0xFFDC2626),    // red-600
    'Canceled',
  ),
  _ => (
    const Color(0xFFF3F4F6),
    const Color(0xFF6B7280),
    status,
  ),
};
```

---

## 6. Countdown Timer Behavior

The `_PaymentBanner` already implements a live countdown timer using the `paymentExpiresAt` field. Here's the expected lifecycle:

```
┌─────────────────────────────────────────────────────────┐
│  User creates booking                                    │
│  → status = pending_payment                              │
│  → paymentExpiresAt = now + 10 minutes                   │
│  → paymentUrl = MoMo checkout link                       │
│  → Shows in "Pending" tab with countdown banner          │
├─────────────────────────────────────────────────────────┤
│  User pays via MoMo                                      │
│  → Backend IPN callback fires                            │
│  → status = upcoming (confirmed)                         │
│  → paymentUrl = null                                     │
│  → Moves to "Upcoming" tab on next refresh               │
├─────────────────────────────────────────────────────────┤
│  Timer hits 00:00 (user didn't pay)                      │
│  → Backend cron cancels booking automatically            │
│  → status = canceled                                     │
│  → Moves to "Canceled" tab on next refresh               │
│  → Frontend should trigger silentRefresh() or poll       │
└─────────────────────────────────────────────────────────┘
```

### Recommended: Auto-Refresh on Timer Expiry

When the countdown reaches zero, the frontend should auto-refresh the appointment list so the item disappears from the "Pending" tab:

```dart
// In the countdown timer's onFinished or when remaining == 0:
if (remaining <= Duration.zero) {
  // Trigger background refresh — the backend cron will have
  // already cancelled this booking
  ref.read(appointmentsProvider.notifier).silentRefresh();
}
```

---

## 7. Edge Cases to Handle

| Scenario | Expected Behavior |
|----------|-------------------|
| `paymentExpiresAt` is in the past | Show "Expired" instead of countdown. The backend cron may not have run yet. |
| `paymentUrl` is null but status is `pending_payment` | Checkout link not yet generated. Show "Preparing payment..." with a retry/refresh button. |
| `paymentDeeplink` is null | Fall back to `paymentUrl` (web checkout). |
| User navigates away and returns | Recalculate countdown from current time vs `paymentExpiresAt`. |
| App is in background when timer expires | On foreground resume, check if `paymentExpiresAt < now` and refresh. |

---

## 8. Testing Checklist

| Test | Description |
|------|-------------|
| ✅ Pending tab appears | The "Pending" tab shows appointments with `status: 'pending_payment'` |
| ✅ Countdown timer | Timer counts down from `paymentExpiresAt - now` |
| ✅ Pay Now button | Opens `paymentUrl` in browser/webview |
| ✅ Timer expiry | When timer hits 0, appointment disappears on next refresh |
| ✅ Payment success | After MoMo payment, appointment moves to "Upcoming" tab |
| ✅ Null payment URL | Shows fallback UI when `paymentUrl` is null |
| ✅ Deep link (optional) | Opens MoMo app if `paymentDeeplink` is available |
| ✅ Recent Activity widget | Shows `PENDING_PAYMENT` status with orange badge |
| ✅ Empty state | "Pending" tab shows appropriate empty state when no pending appointments |

---

## 9. Quick Summary of Changes Required

| Priority | File | Change |
|----------|------|--------|
| 🔴 **Required** | `make generate-openapi` | Regenerate OpenAPI client from latest backend spec |
| 🔴 **Required** | `appointment_remote_datasource.dart` | Map `paymentUrl` and `paymentExpiresAt` from DTO → remove TODO comment |
| 🟡 **Recommended** | Home dashboard recent activity widget | Handle `PENDING_PAYMENT` status for badge/icon styling |
| 🟢 **Optional** | `appointment.entity.dart` | Add `paymentDeeplink` field |
| 🟢 **Optional** | `appointment_card.widget.dart` | Use `paymentDeeplink` for direct MoMo app launch |
