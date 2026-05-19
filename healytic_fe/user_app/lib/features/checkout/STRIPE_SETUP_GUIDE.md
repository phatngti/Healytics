# Stripe Setup Guide

## Keys

1. Open the Stripe Dashboard and go to Developers > API keys.
2. Copy the publishable key (`pk_test_...`) for Flutter.
3. Copy the secret key (`sk_test_...`) for the backend only.

Never put `sk_...` keys in Flutter code, Dart defines, app assets, or client
logs.

## Flutter

Run the user app with the Stripe publishable key:

```sh
flutter run --dart-define=STRIPE_PK=pk_test_your_publishable_key
```

`lib/main.dart` reads `STRIPE_PK` and assigns it to `Stripe.publishableKey`.
If `STRIPE_PK` is empty, the app falls back to `stripePublishableKey` in the
active store file:

- `assets/store.uat.json`
- `assets/store.prod.json`

## Backend

Set these values in the backend `.env`:

```env
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_stripe_webhook_secret
STRIPE_CURRENCY=vnd
```

## Webhook Event Destination

Stripe now creates webhooks from Workbench as event destinations. Create one
event destination per environment: one for sandbox/UAT and one for live
production.

### Create The Destination

1. Open Stripe Dashboard in the correct mode:
   - Sandbox for UAT.
   - Live account for production.
2. Go to Developers > Webhooks.
3. Select Create an event destination.
4. In Event destination scope, select Your account.
   - Use Connected accounts only for Stripe Connect payments created inside
     connected accounts. Healytics saved-card checkout uses the platform Stripe
     account, so Your account is the correct scope.
5. Select the API version for events:
   - Prefer the latest available version in the Dashboard for new destinations.
   - Keep the selected version documented if production is already live.
6. In Select events, select the Payments service or search by event name.
7. Select only these PaymentIntent events:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
8. Select Continue.
9. In Choose destination type, select Webhook endpoint.
10. Select Continue.
11. In Configure your destination, enter the endpoint URL and optional
    description, then create the destination.

UAT example:

```text
https://dev.healytics.me/backend/stripe/webhook
```

Production example:

```text
https://healytics.me/backend/stripe/webhook
```

If the gateway exposes versioned backend routes, use:

```text
/v1/stripe/webhook
```

After creating the endpoint:

1. Open the new webhook endpoint in Stripe.
2. Copy the signing secret (`whsec_...`).
3. Set `STRIPE_WEBHOOK_SECRET=whsec_...` in the backend `.env`.
4. Restart the backend so the new secret is loaded.

The backend currently accepts raw Stripe webhook bodies at:

```text
/stripe/webhook
/v1/stripe/webhook
```

Keep webhook ownership unchanged: `payment_intent.succeeded` marks payments as
paid and confirms bookings, while `payment_intent.payment_failed` logs failure
and leaves the booking retryable.

### Verify Event Deliveries

Open the created event destination and use the Event deliveries tab to verify
that Stripe receives HTTP `2xx` responses from the backend. Stripe retries
failed live deliveries for up to three days; sandbox retries happen only a few
times over a shorter window.

### Local Webhook Testing

Install and log in to the Stripe CLI, then forward events to the local backend:

```sh
stripe listen --forward-to localhost:8080/stripe/webhook
```

To reuse the events and path configured in the Dashboard destination, use:

```sh
stripe listen --load-from-webhooks-api --forward-to localhost:8080
```

The CLI prints a `whsec_...` signing secret. Copy it into the backend `.env` as
`STRIPE_WEBHOOK_SECRET`, then restart the backend.

Trigger a test event:

```sh
stripe trigger payment_intent.succeeded
```

## Test Card

Use Stripe test card `4242 4242 4242 4242` with any future expiry date and any
CVC.
