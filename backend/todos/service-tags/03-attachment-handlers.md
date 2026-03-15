# 03 — Attachment Handlers

**Status:** ✅ COMPLETED

## Context

Beyond CRUD (todo 02), tags need to be attached to and detached from products. This uses the `ProductTag` junction table.

## Prerequisites

- ✅ Todo 02 — Tag CRUD handlers
- ✅ `ProductTag` junction entity

## Tasks

### 1. Create DTOs
- **`attach-tag-response.dto.ts`** — confirmation response for attach operation

### 2. Create `src/service-tags/application/handlers/attach-product-tag.handler.ts`
**Logic:**
- Validate tag exists and belongs to user → `NotFoundException` / `ForbiddenException`
- Check product exists → `NotFoundException`
- Check for existing attachment → `ConflictException`
- Create `ProductTag` junction entry
- Return `AttachTagResponseDto`

### 3. Create `src/service-tags/application/handlers/detach-product-tag.handler.ts`
**Logic:**
- Validate tag exists and belongs to user
- Find `ProductTag` junction entry → `NotFoundException`
- Delete junction entry

## Completed

Attach/detach handlers with full validation chain: tag ownership, product existence, duplicate prevention. `ConflictException` for duplicate attachments.
