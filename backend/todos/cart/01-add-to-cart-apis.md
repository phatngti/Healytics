# 01 — Add To Cart APIs

**Status:** ✅ COMPLETED

## Context

Implemented the authenticated Cart APIs defined in `cart_backend_api_guide.md` so frontend can fully manage cart state server-side (list/add/remove/apply coupon/remove coupon/clear).

## Prerequisites

- ✅ Product/health-service domain is available (`products` table, ACTIVE/visible flags)
- ✅ Partner profile domain is available for clinic metadata
- ✅ JWT + role guards are already implemented
- ✅ Existing module pattern (controller + service facade + mutation handlers) is established

## Tasks

### 1. Create cart module shell and API contracts
Created a new `src/cart` module with DTOs, controller endpoints, service facade, and mutation handlers.

### 2. Add data model for cart and coupons
Added `CartItem` and `Coupon` entities and created a migration for `cart_items` + `coupons` tables with FK/index/unique constraints.

### 3. Implement business logic and errors
Implemented service validation for active services, duplicate prevention, user ownership checks, coupon validity/expiry/limit/applicability checks, and discount calculation with optional cap.

### 4. Add module tests and wire into app
Added unit tests for controller/service behavior and registered `CartModule` in `AppModule`.

## Completed

- Added module files:
  - `src/cart/cart.module.ts`
  - `src/cart/cart.controller.ts`
  - `src/cart/cart.service.ts`
- Added mutation handlers:
  - `src/cart/application/handlers/add-cart-item.handler.ts`
  - `src/cart/application/handlers/remove-cart-item.handler.ts`
  - `src/cart/application/handlers/apply-coupon.handler.ts`
  - `src/cart/application/handlers/remove-cart-coupon.handler.ts`
  - `src/cart/application/handlers/clear-cart.handler.ts`
- Added DTOs + constants:
  - `src/cart/dto/add-to-cart.dto.ts`
  - `src/cart/dto/apply-coupon.dto.ts`
  - `src/cart/dto/cart-item-response.dto.ts`
  - `src/cart/constants/cart-error-codes.ts`
- Added entities:
  - `src/cart/entities/cart-item.entity.ts`
  - `src/cart/entities/coupon.entity.ts`
- Added migration:
  - `migrations/scripts/1775300000000-CreateCartAndCouponTables.ts`
- Wired module:
  - Updated `src/app.module.ts` to import `CartModule`
- Added tests:
  - `src/cart/cart.controller.spec.ts`
  - `src/cart/cart.service.spec.ts`
- Verification status:
  - Could not run `npm`/`node` commands in this environment (`command not found`), so test/build execution is pending on a Node-enabled runtime.
