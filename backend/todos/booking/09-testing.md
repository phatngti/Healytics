# 09 — Unit Tests & Integration Tests

**Status:** ✅ COMPLETED

## Context

Add comprehensive unit tests and integration (e2e) tests for the entire Booking module to ensure correctness and enable safe future refactoring.

## Prerequisites

- ✅ All previous todos (01-08) completed
- ✅ All handlers, controllers, and services implemented and wired

## Tasks

### 1. Create test data factories
Add booking-specific factories to `test/fixtures/test-data.factory.ts`:
- `createBookingEntity()`
- `createCheckoutTicketEntity()`
- `createAsyncCheckoutDto()`
- `createMicroLockDto()`

### 2. Unit tests for service facade
- `booking.service.spec.ts` — verifies all 5 methods delegate to handlers

### 3. Unit tests for controllers
- `booking.controller.spec.ts` — async checkout, ticket status, list bookings, get booking
- `slots.controller.spec.ts` — micro-lock endpoint

### 4. Unit tests for handlers (7 files)
- `get-booking.handler.spec.ts` — found/not-found
- `get-checkout-ticket.handler.spec.ts` — found/not-found
- `list-user-bookings.handler.spec.ts` — pagination, ordering, empty
- `acquire-micro-lock.handler.spec.ts` — lock acquired/denied, key formatting
- `check-slot-availability.handler.spec.ts` — DB check, Redis check, combined
- `create-checkout-ticket.handler.spec.ts` — idempotency, slot failure, queue success
- `process-checkout.handler.spec.ts` — success/failure/error paths, transactions

### 5. Unit tests for webhook service
- `webhook.service.spec.ts` — null URL skip, success, retry, exhaust retries

### 6. E2E integration tests
- `test/e2e/booking/booking.e2e-spec.ts` — all 5 API endpoints

## Completed

- Added 4 booking factory functions to `test/fixtures/test-data.factory.ts`
- Added `update` and `delete` to `MockQueryRunner` manager in `test/mocks/mock-types.ts`
- Created 11 unit test files — **39 tests, all passing**
- Created 1 e2e test file — **10 integration tests** covering all endpoints
- Tests run with: `npx jest --testPathPatterns='src/booking/' --verbose`
- E2E tests run with: `npx jest --config ./test/jest-e2e.json --testPathPatterns='booking' --verbose`
