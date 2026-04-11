# Partner Profile Completion — Backend API Guide

> **Scope**: Post-verification partner onboarding for approved health partners
> **Framework**: NestJS + TypeORM + PostgreSQL
> **Auth**: Partner JWT (`HEALTH_PARTNER` role)
> **Route Prefix**: `/v1/partners/me/completion`
> **Status**: Implemented

---

## Table of Contents

1. [Feature Goal](#1-feature-goal)
2. [Business Rules](#2-business-rules)
3. [Data Model](#3-data-model)
4. [API Inventory](#4-api-inventory)
5. [Auth and JWT Contract](#5-auth-and-jwt-contract)
6. [Request and Response DTOs](#6-request-and-response-dtos)
7. [Execution Flow](#7-execution-flow)
8. [Touched Backend Files](#8-touched-backend-files)
9. [Error Handling](#9-error-handling)
10. [OpenAPI and Frontend Integration Notes](#10-openapi-and-frontend-integration-notes)
11. [Testing Checklist](#11-testing-checklist)

---

## 1. Feature Goal

The profile completion feature adds a second onboarding step after business verification.

### Flow

1. Partner registers and submits verification documents.
2. Admin reviews the verification application.
3. If the partner is not approved yet:
   - existing `ONBOARDING`, `PENDING`, `REQUIRED_RESUBMIT`, `REJECTED` behavior remains unchanged
4. If the partner is approved:
   - the partner is **not sent directly to dashboard**
   - the partner must complete public clinic profile data first
5. Only after the required completion fields are present does the JWT expose `partnerProfileCompleted: true`

### Why this is separate from verification

Verification confirms business legitimacy.
Profile completion fills storefront/public-profile data such as:

- clinic cover image
- clinic logo image
- clinic description
- clinic gallery
- optional trust badges / certifications

No second admin review cycle is triggered for these fields.

---

## 2. Business Rules

### Completion eligibility

The completion APIs are only available to partners with:

- `verificationStatus = APPROVED`

If the partner is not approved, the completion endpoints reject the request.

### Required fields for completion

Completion is derived, not stored in a separate table.

The partner is considered complete only when all of these conditions are true:

- `coverImageUrl` exists
- `logoImageUrl` exists
- `description.trim().length` is between `120` and `1000`
- `gallery.length >= 3`

### Optional fields

These do not block dashboard access in v1:

- `certifications`

### Limits

- `description`: max `1000`
- `gallery`: max `8`
- `certifications.title`: max `200`
- `certifications.subtitle`: max `200`
- `certifications.iconName`: max `50`

---

## 3. Data Model

This feature intentionally reuses existing tables.

### Primary tables

#### `health_partner_profile`

Used fields:

- `id`
- `account_id`
- `verification_status`
- `brand_name`
- `legal_name`
- `business_type`
- `phone_number`
- `street_address`
- `province_id`
- `district_id`
- `ward_id`
- `cover_image_url`
- `logo_image_url`
- `description`
- `gallery`

#### `partner_certifications`

Used fields:

- `id`
- `partner_id`
- `title`
- `subtitle`
- `icon_name`
- `sort_order`

### No new table

The implementation does **not** create:

- a `partner_profile_completion` table
- a `completion_status` table

The completion state is derived from `health_partner_profile` + `partner_certifications`.

---

## 4. API Inventory

| # | Method | Path | Auth | Description |
|---|--------|------|------|-------------|
| 1 | `GET` | `/v1/partners/me/completion` | Partner JWT | Read current completion data, checklist, percent, and clinic identity context |
| 2 | `PUT` | `/v1/partners/me/completion` | Partner JWT | Immediately save completion fields and optional certifications |

### 4.1 GET `/v1/partners/me/completion`

Returns:

- current cover image
- current logo image
- current description
- current gallery
- current certifications
- readonly clinic identity
- derived checklist
- derived `completionPercent`
- derived `isCompleted`

Example response:

```json
{
  "id": "partner-uuid",
  "clinicIdentity": {
    "brandName": "Healytics Wellness Center",
    "legalName": "Healytics Wellness Joint Stock Company",
    "businessType": ["SPA_BEAUTY", "MASSAGE_THERAPY"],
    "phoneNumber": "0901234567",
    "address": "123 Main Street, Ward 1, District 1, Ho Chi Minh City"
  },
  "coverImageUrl": "https://cdn.example.com/cover.jpg",
  "logoImageUrl": "https://cdn.example.com/logo.jpg",
  "description": "A modern wellness clinic focused on preventive care and personalized treatment planning...",
  "gallery": [
    "https://cdn.example.com/gallery-1.jpg",
    "https://cdn.example.com/gallery-2.jpg",
    "https://cdn.example.com/gallery-3.jpg"
  ],
  "certifications": [
    {
      "id": "cert-uuid",
      "title": "ISO 9001:2015",
      "subtitle": "Quality Management",
      "iconName": "workspace_premium",
      "sortOrder": 0
    }
  ],
  "checklist": [
    {
      "key": "coverImageUrl",
      "label": "Clinic cover image",
      "required": true,
      "completed": true
    },
    {
      "key": "logoImageUrl",
      "label": "Clinic logo image",
      "required": true,
      "completed": true
    },
    {
      "key": "description",
      "label": "Clinic description",
      "required": true,
      "completed": true
    },
    {
      "key": "gallery",
      "label": "Clinic gallery",
      "required": true,
      "completed": true
    },
    {
      "key": "certifications",
      "label": "Trust badges and certifications",
      "required": false,
      "completed": true
    }
  ],
  "completionPercent": 100,
  "isCompleted": true
}
```

### 4.2 PUT `/v1/partners/me/completion`

Immediately saves partner-facing public profile fields.

Example request:

```json
{
  "coverImageUrl": "https://cdn.example.com/cover.jpg",
  "logoImageUrl": "https://cdn.example.com/logo.jpg",
  "description": "A modern wellness clinic focused on preventive care, personalized treatment planning, and a calm patient experience across consultation, therapy, and follow-up visits.",
  "gallery": [
    "https://cdn.example.com/gallery-1.jpg",
    "https://cdn.example.com/gallery-2.jpg",
    "https://cdn.example.com/gallery-3.jpg"
  ],
  "certifications": [
    {
      "title": "ISO 9001:2015",
      "subtitle": "Quality Management",
      "iconName": "workspace_premium",
      "sortOrder": 0
    },
    {
      "title": "Licensed Medical Team",
      "subtitle": "Verified specialists",
      "iconName": "verified",
      "sortOrder": 1
    }
  ]
}
```

Behavior:

- saves changed partner profile fields into `health_partner_profile`
- replaces partner certifications when `certifications` is provided
- returns the same shape as the GET endpoint
- does not create a review log
- does not change verification status

---

## 5. Auth and JWT Contract

### New JWT field

Partner login and partner refresh now include:

```json
{
  "verificationStatus": "APPROVED",
  "partnerProfileCompleted": false
}
```

This is important because the frontend router should not infer readiness from `verificationCompletedAt`.

### Token sources

The field is added in both:

- partner login
- partner refresh

### Result

Frontend logic can safely implement:

- approved + incomplete → `/provider/profile-completion`
- approved + complete → `/provider/dashboard`

---

## 6. Request and Response DTOs

### 6.1 Request DTO

`UpdatePartnerProfileCompletionDto`

```ts
coverImageUrl?: string;
logoImageUrl?: string;
description?: string;
gallery?: string[];
certifications?: UpdatePartnerCertificationDto[];
```

Validation:

- `coverImageUrl`: `@IsUrl()`
- `logoImageUrl`: `@IsUrl()`
- `description`: `@IsString()` + `@MaxLength(1000)`
- `gallery`: `@IsArray()` + `@ArrayMaxSize(8)` + `@IsUrl({}, { each: true })`
- `certifications`: nested validation

### 6.2 Response DTO

`MyProfileCompletionResponseDto`

Contains:

- `clinicIdentity`
- `coverImageUrl`
- `logoImageUrl`
- `description`
- `gallery`
- `certifications`
- `checklist`
- `completionPercent`
- `isCompleted`

### 6.3 Checklist derivation

Checklist is computed server-side so the frontend and JWT contract share one source of truth.

Rules:

- cover: complete if present
- logo: complete if present
- description: complete if trimmed length is between `120` and `1000`
- gallery: complete if length is at least `3`
- certifications: optional, complete if at least one exists

---

## 7. Execution Flow

### GET flow

1. Resolve `accountId` from JWT
2. Load partner by `accountId`
3. Ensure partner exists
4. Ensure `verificationStatus === APPROVED`
5. Load `partner_certifications`
6. Build readonly identity block
7. Build derived checklist
8. Calculate:
   - `completionPercent`
   - `isCompleted`
9. Return DTO

### PUT flow

1. Resolve `accountId` from JWT
2. Load partner by `accountId`
3. Ensure partner exists
4. Ensure `verificationStatus === APPROVED`
5. Apply provided fields:
   - trim strings
   - drop empty string into `null`
   - trim gallery entries and remove empty values
6. Save partner if partner fields changed
7. If `certifications` exists:
   - load existing certifications
   - delete missing items
   - upsert provided items
   - enforce `partnerId`
   - normalize sort order
8. Re-read completion response via GET flow
9. Return DTO

---

## 8. Touched Backend Files

### Core implementation

- `src/partners/partners.controller.ts`
  - exposes `GET /me/completion`
  - exposes `PUT /me/completion`

- `src/partners/partners.service.ts`
  - `getMyProfileCompletion(accountId)`
  - `updateMyProfileCompletion(accountId, dto)`
  - `isPartnerProfileCompleted(partner)`
  - certification sync helper
  - approval guard for completion access

- `src/partners/dto/request/update-partner-profile-completion.dto.ts`
  - request validation contract

- `src/partners/dto/response/my-profile-completion-response.dto.ts`
  - response contract
  - checklist derivation
  - completion percent derivation

- `src/partners/partners.module.ts`
  - registers `PartnerCertification` repository

### Auth integration

- `src/auth/auth.service.ts`
  - injects `partnerProfileCompleted` into JWT payloads for partner login and refresh

### Adjacent contract fixes included in the same release

- `src/partners/application/handlers/register-partner.handler.ts`
  - persists `account.username`
  - checks duplicate username

- `src/partners/application/handlers/update-partner-profile.handler.ts`
  - applies username/email updates
  - supports business type update path used during resubmission

- `src/partners/dto/response/my-profile-response.dto.ts`
  - exposes `legalName`
  - exposes `username`

---

## 9. Error Handling

### `401 Unauthorized`

Returned when:

- missing token
- invalid token
- expired token

### `403 Forbidden`

Returned by auth/role guard if:

- authenticated account is not `HEALTH_PARTNER`

### `404 Not Found`

Returned when:

- partner profile does not exist for the authenticated account

### `400 Bad Request`

Returned when:

- partner is not in `APPROVED` status
- request body fails DTO validation
- gallery exceeds maximum size

---

## 10. OpenAPI and Frontend Integration Notes

### Backend OpenAPI

If the team wants the frontend OpenAPI package to consume these APIs directly, regenerate `openapi/openapi.json` after backend changes.

### Current frontend integration

The admin panel currently calls these endpoints through `ApiClient.invokeAPI(...)` instead of generated OpenAPI classes.

That is acceptable when:

- frontend and backend are being developed in parallel
- the OpenAPI package is intentionally not regenerated yet

### Important frontend dependency

The frontend expects `partnerProfileCompleted` in:

- partner login response JWT payload
- partner refresh response JWT payload

Do not remove or rename this field without coordinating router changes.

---

## 11. Testing Checklist

### Unit tests

- `PartnersService.isPartnerProfileCompleted()`
- completion response checklist derivation
- certification upsert and delete behavior
- auth token payload contains `partnerProfileCompleted`

### Integration tests

- approved partner with missing fields returns `isCompleted = false`
- approved partner with complete profile returns `isCompleted = true`
- `PUT /me/completion` persists profile fields
- `PUT /me/completion` replaces certifications correctly
- non-approved partner cannot access completion endpoints
- partner refresh reflects the updated `partnerProfileCompleted` status

### Regression tests from adjacent fixes

- registration persists username
- self-profile response exposes `legalName`
- self-profile response exposes `username`

---

## Recommended Rollout Notes

- Keep verification review and profile completion separate
- Treat completion fields as immediate-publish content
- Avoid creating a second admin review state machine for these fields
- Keep the server-side derived completion rule as the authoritative source
- If frontend UX rules change, update:
  - `PartnersService.isPartnerProfileCompleted()`
  - `MyProfileCompletionResponseDto.fromPartner()`
  - frontend completion form validation

