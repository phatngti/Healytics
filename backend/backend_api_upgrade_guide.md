# Backend API Upgrade Guide: Pending Payment Status for Appointments

This guide details every backend change required to support the new `pending_payment` appointment status in the user-facing appointment list API.

## 1. Problem Statement

The **Booking** entity already supports `PENDING_PAYMENT` status (`BookingResponseDtoStatusEnum.PENDING_PAYMENT`), but the **Appointment** endpoint (`/user/appointments`) only exposes three statuses: `upcoming`, `completed`, `canceled`. The frontend needs appointments with pending payment to appear in a dedicated tab with a payment CTA and countdown timer.

## 2. OpenAPI Spec Changes

### 2.1 Add `pending_payment` to `AppointmentResponseDtoStatusEnum`

**File**: `backend/openapi/openapi.json` (or wherever the spec source lives)

```diff
 "AppointmentResponseDto": {
   "properties": {
     "status": {
       "type": "string",
       "enum": [
+        "pending_payment",
         "upcoming",
         "completed",
         "canceled"
       ]
     },
```

### 2.2 Add `paymentUrl` field to `AppointmentResponseDto`

```json
"paymentUrl": {
  "type": "string",
  "nullable": true,
  "description": "Stripe/payment gateway checkout URL. Only present when status is 'pending_payment'.",
  "example": "https://checkout.stripe.com/c/pay/cs_live_abc123..."
}
```

### 2.3 Add `paymentExpiresAt` field to `AppointmentResponseDto`

```json
"paymentExpiresAt": {
  "type": "string",
  "format": "date-time",
  "nullable": true,
  "description": "ISO 8601 timestamp when the payment link expires. Only present when status is 'pending_payment'. Typically 10 minutes from booking creation.",
  "example": "2026-04-14T12:10:00.000Z"
}
```

### 2.4 Full `AppointmentResponseDto` additions summary

| Field | Type | Nullable | Condition |
|---|---|---|---|
| `status` | `string` enum | No | Add `pending_payment` value |
| `paymentUrl` | `string` | Yes | Non-null only when `status = pending_payment` |
| `paymentExpiresAt` | `string` (date-time) | Yes | Non-null only when `status = pending_payment` |

---

## 3. Database / Entity Changes

### 3.1 Appointment Entity

If the appointment entity is derived from or linked to the booking entity, ensure the status mapping includes:

```typescript
// appointment.entity.ts or equivalent
export enum AppointmentStatus {
  PENDING_PAYMENT = 'pending_payment',
  UPCOMING = 'upcoming',
  COMPLETED = 'completed',
  CANCELED = 'canceled',
}
```

### 3.2 Migration (if status is stored as enum in DB)

```sql
-- PostgreSQL example
ALTER TYPE appointment_status ADD VALUE 'pending_payment' BEFORE 'upcoming';
```

Or if using a string column, no migration needed.

---

## 4. Service Layer Changes

### 4.1 Appointment Listing Query

The `listAppointments` query must now include bookings with `PENDING_PAYMENT` status. If the current query filters by status, update:

```typescript
// appointment.service.ts
async listAppointments(userId: string): Promise<AppointmentResponseDto[]> {
  const bookings = await this.bookingRepo.find({
    where: {
      userId,
      status: In([
        BookingStatus.PENDING_PAYMENT,  // ← NEW
        BookingStatus.CONFIRMED,        // maps to 'upcoming'
        BookingStatus.COMPLETED,
        BookingStatus.CANCELLED,
      ]),
    },
    order: { startTime: 'ASC' },
  });

  return bookings.map(booking => this.mapToAppointmentDto(booking));
}
```

### 4.2 Status Mapping Logic

Map from `BookingStatus` → `AppointmentStatus`:

```typescript
private mapBookingStatusToAppointmentStatus(
  bookingStatus: BookingStatus,
): AppointmentStatus {
  switch (bookingStatus) {
    case BookingStatus.PENDING_PAYMENT:
      return AppointmentStatus.PENDING_PAYMENT;
    case BookingStatus.CONFIRMED:
      return AppointmentStatus.UPCOMING;
    case BookingStatus.COMPLETED:
      return AppointmentStatus.COMPLETED;
    case BookingStatus.CANCELLED:
      return AppointmentStatus.CANCELED;
    case BookingStatus.NO_SHOW:
      return AppointmentStatus.COMPLETED; // or a separate status
  }
}
```

### 4.3 Payment Fields Population

```typescript
private mapToAppointmentDto(booking: BookingEntity): AppointmentResponseDto {
  const status = this.mapBookingStatusToAppointmentStatus(booking.status);

  return {
    // ... existing fields ...
    status,
    paymentUrl: status === AppointmentStatus.PENDING_PAYMENT
      ? booking.paymentUrl
      : null,
    paymentExpiresAt: status === AppointmentStatus.PENDING_PAYMENT
      ? booking.paymentExpiresAt?.toISOString()
      : null,
  };
}
```

---

## 5. Payment Expiration Logic

### 5.1 Setting expiration on booking creation

When a booking is created with `PENDING_PAYMENT` status, set the expiration:

```typescript
// checkout.service.ts — during booking creation
const PAYMENT_EXPIRY_MINUTES = 10;

const booking = this.bookingRepo.create({
  // ... other fields ...
  status: BookingStatus.PENDING_PAYMENT,
  paymentUrl: stripeSession.url,
  paymentExpiresAt: new Date(
    Date.now() + PAYMENT_EXPIRY_MINUTES * 60 * 1000,
  ),
});
```

### 5.2 Auto-cancellation of expired payments

> [!IMPORTANT]
> A cron job or scheduled task should auto-cancel bookings where `paymentExpiresAt < NOW()` and `status = PENDING_PAYMENT`.

```typescript
// payment-expiry.cron.ts
@Cron(CronExpression.EVERY_MINUTE)
async cancelExpiredPayments() {
  const expired = await this.bookingRepo.find({
    where: {
      status: BookingStatus.PENDING_PAYMENT,
      paymentExpiresAt: LessThan(new Date()),
    },
  });

  for (const booking of expired) {
    booking.status = BookingStatus.CANCELLED;
    await this.bookingRepo.save(booking);
    this.logger.log(`Auto-cancelled expired booking ${booking.id}`);
    // Optionally release the time slot / micro-lock
  }
}
```

---

## 6. API Response Example

### `GET /user/appointments` — Pending Payment item

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
  "address": "311 Vo Van Tan, Ward 14\nDistrict 1, HCM City, VN",
  "date": "2026-04-15",
  "checkInTime": "9:00 AM",
  "checkOutTime": "10:00 AM",
  "duration": "About 1 hour",
  "distanceKm": 2.5,
  "isReviewed": false,
  "paymentUrl": "https://checkout.stripe.com/c/pay/cs_live_abc123",
  "paymentExpiresAt": "2026-04-14T12:10:00.000Z"
}
```

### `GET /user/appointments` — Non-pending item (unchanged)

```json
{
  "id": "apt-456",
  "status": "upcoming",
  "paymentUrl": null,
  "paymentExpiresAt": null
}
```

---

## 7. Frontend Client Regeneration

After updating the OpenAPI spec, regenerate the Dart client:

```bash
cd healytic_fe/user_app
# Regenerate from the updated spec
make generate-openapi
# or
npx @openapitools/openapi-generator-cli generate \
  -i ../../backend/openapi/openapi.json \
  -g dart \
  -o ./openapi \
  --additional-properties=pubName=user_openapi
```

This will automatically:
- Add `pending_payment` to `AppointmentResponseDtoStatusEnum`
- Add `paymentUrl` and `paymentExpiresAt` fields to `AppointmentResponseDto`

---

## 8. Testing Checklist

| Test | Description |
|---|---|
| Unit: listing includes pending | Verify `listAppointments` returns bookings with `PENDING_PAYMENT` status |
| Unit: DTO mapping | Verify `paymentUrl` and `paymentExpiresAt` are populated only for pending_payment |
| Unit: expiry cron | Verify expired bookings are auto-cancelled after 10 minutes |
| Integration: full flow | Create booking → verify it appears as `pending_payment` → complete payment → verify it transitions to `upcoming` |
| Integration: expiry flow | Create booking → wait 10 min → verify auto-cancelled |
| E2E: API response shape | Verify the full response JSON matches the schema above |

---

## 9. Rollout Considerations

> [!WARNING]
> **Backwards compatibility.** Older app versions won't recognize `pending_payment` status. They will fall through to the default case in the status badge (`_` pattern). This is safe — they'll display the raw status string with neutral colors. However, the payment CTA won't appear. Consider a minimum app version check or a feature flag if this is a concern.

> [!NOTE]
> **Payment URL lifetime.** Stripe checkout sessions expire after 24 hours by default, but we're using a 10-minute window for urgency. Ensure the Stripe session is configured with `expires_at` matching our `paymentExpiresAt`:
> ```typescript
> const session = await stripe.checkout.sessions.create({
>   // ...
>   expires_at: Math.floor(Date.now() / 1000) + 10 * 60, // 10 min
> });
> ```
