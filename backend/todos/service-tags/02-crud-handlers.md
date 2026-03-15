# 02 — CRUD Handlers

**Status:** ✅ COMPLETED

## Context

After entity setup (todo 01), this implements create, update, and remove handlers for service tags. Tags are owned by the creating user.

## Prerequisites

- ✅ Todo 01 — Entities and module setup

## Tasks

### 1. Create DTOs in `src/service-tags/dto/`
- **`create-service-tag.dto.ts`** — name, slug, icon, color, description
- **`update-service-tag.dto.ts`** — PartialType
- **`service-tag-response.dto.ts`** — response with product count

### 2. Create handlers in `src/service-tags/application/handlers/`
- **`create-service-tag.handler.ts`** — Creates tag, sets `createdByAccountId`
- **`update-service-tag.handler.ts`** — Loads tag, verifies ownership, updates fields
- **`remove-service-tag.handler.ts`** — Loads tag, verifies ownership, soft deletes

All handlers enforce ownership: `ForbiddenException` if tag creator doesn't match current user.

## Completed

Three CRUD handlers with ownership enforcement. Tags scoped to creating user.
