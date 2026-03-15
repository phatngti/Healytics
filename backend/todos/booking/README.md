# Booking Feature — Todo Pipeline

This folder contains the implementation pipeline for the **Booking Module** (async checkout with Redis locks + RabbitMQ queue). Each file is a self-contained todo with full context so any agent can pick up from where the previous one left off.

## Ordering

Files are numbered `01-` through `09-`. Execute sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built (Before This Pipeline)

| Component | Status | Location |
|---|---|---|
| Entities (`Booking`, `CheckoutTicket`, `BookingStatusLog`) | ✅ | `src/common/entities/` |
| Enums (`BookingStatus`, `CheckoutTicketStatus`) | ✅ | `src/booking/enums/` |
| Migration `CreateBookingCheckoutTables` | ✅ | `migrations/scripts/` |
| Redis Module + `RedisService` (lock helpers) | ✅ | `src/redis/` |
| RabbitMQ Module (`RABBITMQ_CLIENT`) | ✅ | `src/rabbitmq/` |
| Env vars (`REDIS_*`, `RABBITMQ_*`) | ✅ | `.env` |

## TDD Reference

See the original Technical Design Document in the conversation history for:
- 2-level Redis locking strategy (Micro-Lock 120s, Checkout Lock 600s)
- Async checkout workflow (API → Queue → Worker → Webhook)
- API contract (JSON request/response formats)
