# Frontend Integration Guide — Partner Public Profile API

## Overview

Two new endpoints for the **Edit Profile** page, available to verified partners who have completed their clinic profile. These provide a single aggregate read model and a storefront-only mutation endpoint.

| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| `GET` | `/v1/partner/partners/public-profile` | `Bearer <JWT>` | Load full profile aggregate for edit page |
| `PUT` | `/v1/partner/partners/public-profile` | `Bearer <JWT>` | Update storefront fields only |

> [!IMPORTANT]
> These endpoints are **only accessible** when `verificationStatus === "APPROVED"` **AND** the profile is completed. Otherwise the backend returns `403 Forbidden`.

---

## 1. `GET /v1/partner/partners/public-profile`

### Request

```http
GET /v1/partner/partners/public-profile HTTP/1.1
Authorization: Bearer <access_token>
```

No query parameters or body required.

### Response — `200 OK`

```jsonc
{
  "id": "7ec0e7fb-9e19-4f64-bcee-beaf3c12fd5d",

  // ──────────────────────────────────────────────
  // READ-ONLY sections (display only, not editable)
  // ──────────────────────────────────────────────

  "businessInfo": {
    "brandName": "Healytics Wellness Center",
    "legalName": "Healytics Wellness Joint Stock Company",
    "taxCode": "0123456789",
    "businessType": ["SPA_BEAUTY", "MASSAGE_THERAPY"],
    "phoneNumber": "0901234567",       // nullable
    "email": "clinic@example.com",     // nullable
    "username": "healytics_clinic"     // nullable
  },

  "address": {
    "streetAddress": "123 Nguyen Hue, Ward 1",
    "ward": { "id": "uuid-ward", "name": "Phường 1" },         // nullable
    "district": { "id": "uuid-dist", "name": "Quận 1" },       // nullable
    "province": { "id": "uuid-prov", "name": "TP. Hồ Chí Minh" }, // nullable
    "latitude": 10.7769,               // nullable
    "longitude": 106.7009,             // nullable
    "formattedAddress": "123 Nguyen Hue, Phường 1, Quận 1, TP. Hồ Chí Minh" // nullable
  },

  "readOnlyLegalSummary": {            // nullable (null if no legal rep)
    "fullName": "Nguyễn Văn A",
    "position": "Giám đốc",
    "idType": "cccd",
    "idNumber": "012345678901"
  },

  "verificationStatus": "APPROVED",    // enum: ONBOARDING | PENDING | APPROVED | REJECTED | REQUIRED_RESUBMIT

  // ──────────────────────────────────────────────
  // EDITABLE section (maps to PUT payload)
  // ──────────────────────────────────────────────

  "publicProfile": {
    "coverImageUrl": "https://cdn.example.com/cover.jpg",   // nullable
    "logoImageUrl": "https://cdn.example.com/logo.jpg",     // nullable
    "description": "A modern wellness clinic focused on...", // nullable
    "gallery": [
      "https://cdn.example.com/g1.jpg",
      "https://cdn.example.com/g2.jpg",
      "https://cdn.example.com/g3.jpg"
    ],
    "certifications": [
      {
        "id": "8d2ee5c7-4f58-46a5-8f8d-4a14a8fd9e2b",
        "title": "ISO 9001:2015",
        "subtitle": "Quality Management",   // nullable
        "iconName": "workspace_premium",
        "sortOrder": 0
      }
    ]
  },

  // ──────────────────────────────────────────────
  // DERIVED section (computed by backend)
  // ──────────────────────────────────────────────

  "completionSummary": {
    "checklist": [
      { "key": "coverImageUrl",   "label": "Clinic cover image",               "required": true,  "completed": true  },
      { "key": "logoImageUrl",    "label": "Clinic logo image",                "required": true,  "completed": true  },
      { "key": "description",     "label": "Clinic description",               "required": true,  "completed": true  },
      { "key": "gallery",         "label": "Clinic gallery",                   "required": true,  "completed": true  },
      { "key": "certifications",  "label": "Trust badges and certifications",  "required": false, "completed": true  }
    ],
    "completionPercent": 100,
    "isCompleted": true
  }
}
```

### TypeScript Interface

```typescript
interface PartnerPublicProfileResponse {
  id: string;
  businessInfo: PublicProfileBusinessInfo;
  address: PublicProfileAddress;
  readOnlyLegalSummary: PublicProfileLegalSummary | null;
  verificationStatus: PartnerVerificationStatus;
  publicProfile: PublicProfileStorefront;
  completionSummary: PublicProfileCompletionSummary;
}

interface PublicProfileBusinessInfo {
  brandName: string;
  legalName: string;
  taxCode: string;
  businessType: string[];
  phoneNumber: string | null;
  email: string | null;
  username: string | null;
}

interface PublicProfileAddress {
  streetAddress: string;
  ward: { id: string; name: string } | null;
  district: { id: string; name: string } | null;
  province: { id: string; name: string } | null;
  latitude: number | null;
  longitude: number | null;
  formattedAddress: string | null;
}

interface PublicProfileLegalSummary {
  fullName: string;
  position: string;
  idType: string;
  idNumber: string;
}

interface PublicProfileStorefront {
  coverImageUrl: string | null;
  logoImageUrl: string | null;
  description: string | null;
  gallery: string[];
  certifications: PublicProfileCertification[];
}

interface PublicProfileCertification {
  id: string;
  title: string;
  subtitle: string | null;
  iconName: string;
  sortOrder: number;
}

interface PublicProfileChecklistItem {
  key: string;
  label: string;
  required: boolean;
  completed: boolean;
}

interface PublicProfileCompletionSummary {
  checklist: PublicProfileChecklistItem[];
  completionPercent: number;
  isCompleted: boolean;
}

type PartnerVerificationStatus =
  | 'ONBOARDING'
  | 'PENDING'
  | 'APPROVED'
  | 'REJECTED'
  | 'REQUIRED_RESUBMIT';
```

---

## 2. `PUT /v1/partner/partners/public-profile`

### Request

```http
PUT /v1/partner/partners/public-profile HTTP/1.1
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Request Body

All fields are **optional**. Only send the fields you want to update. Omitted fields are **not touched**.

```jsonc
{
  "coverImageUrl": "https://cdn.example.com/new-cover.jpg",
  "logoImageUrl": "https://cdn.example.com/new-logo.jpg",
  "description": "Updated clinic description with at least 120 characters for best results. This helps patients understand your clinic's focus and expertise areas.",
  "gallery": [
    "https://cdn.example.com/gallery-1.jpg",
    "https://cdn.example.com/gallery-2.jpg",
    "https://cdn.example.com/gallery-3.jpg"
  ],
  "certifications": [
    {
      "id": "existing-cert-uuid",        // include ID to update existing
      "title": "ISO 9001:2015",
      "subtitle": "Quality Management",  // nullable
      "iconName": "workspace_premium",
      "sortOrder": 0
    },
    {
      // omit ID to create new
      "title": "WHO Certified",
      "subtitle": null,
      "iconName": "verified",
      "sortOrder": 1
    }
  ]
}
```

### Field Validation Rules

| Field | Type | Validation | Notes |
|-------|------|------------|-------|
| `coverImageUrl` | `string?` | Valid URL | S3/CDN URL from upload |
| `logoImageUrl` | `string?` | Valid URL | S3/CDN URL from upload |
| `description` | `string?` | Max 1000 chars | 120–1000 chars recommended for completion |
| `gallery` | `string[]?` | Max 8 items, each valid URL | ≥3 required for completion |
| `certifications` | `object[]?` | Nested validation | See below |

### Certification Object

| Field | Type | Validation | Notes |
|-------|------|------------|-------|
| `id` | `string?` | UUID | Omit to create; include to update |
| `title` | `string?` | 1–200 chars | Required for non-empty cert |
| `subtitle` | `string?` | Max 200 chars | Optional subtitle |
| `iconName` | `string?` | Max 50 chars | Material icon slug, defaults to `workspace_premium` |
| `sortOrder` | `number?` | 0–999 integer | Display order |

### Certification Sync Behavior

The `certifications` array uses **full-replacement sync** when provided:
- **Include ID** → update existing certification
- **Omit ID** → create new certification
- **Existing certs NOT in array** → automatically **deleted**
- **Empty array `[]`** → deletes all certifications
- **Omit `certifications` field entirely** → no changes to certs

> [!WARNING]
> When sending `certifications`, you must include ALL certifications you want to keep. Any existing certification whose `id` is not in the array will be **permanently deleted**.

### Response — `200 OK`

Returns the **same shape** as the GET response, with updated values and recalculated `completionSummary`.

---

## 3. Error Responses

| Status | Condition | Response Body |
|--------|-----------|---------------|
| `400` | Validation failure (invalid URL, max length exceeded, etc.) | `{ "statusCode": 400, "message": ["coverImageUrl must be a URL address"], "error": "Bad Request" }` |
| `401` | Missing or invalid JWT token | `{ "statusCode": 401, "message": "Unauthorized" }` |
| `403` | Partner not `APPROVED` or profile not completed | `{ "statusCode": 403, "message": "Public profile editing is only available for approved partners" }` |
| `404` | No partner profile for the authenticated account | `{ "statusCode": 404, "message": "Partner not found" }` |
| `429` | Rate limit exceeded (10 req/min for PUT) | `{ "statusCode": 429, "message": "Too Many Requests" }` |
| `500` | Server error | `{ "statusCode": 500, "message": "Internal server error" }` |

---

## 4. UI Integration Guidance

### Page Layout Mapping

```
┌─────────────────────────────────────┬──────────────────────────┐
│          LEFT COLUMN                │      RIGHT RAIL          │
│                                     │                          │
│  ┌─ Business Overview ──────────┐   │  ┌─ Verification ──────┐ │
│  │  businessInfo.brandName      │   │  │  verificationStatus  │ │
│  │  businessInfo.legalName      │   │  │  (chip/badge)        │ │
│  │  businessInfo.taxCode        │   │  └────────────────────┘ │
│  │  businessInfo.businessType   │   │                          │
│  │  ⚠️ ALL READ-ONLY            │   │  ┌─ Completion ────────┐ │
│  └──────────────────────────────┘   │  │  completionSummary   │ │
│                                     │  │  .completionPercent  │ │
│  ┌─ Address ────────────────────┐   │  │  .isCompleted        │ │
│  │  address.formattedAddress    │   │  │  .checklist[]        │ │
│  │  ⚠️ READ-ONLY                │   │  └────────────────────┘ │
│  └──────────────────────────────┘   │                          │
│                                     │  ┌─ Legal Summary ──────┐ │
│  ┌─ Contact & Visibility ───────┐   │  │  readOnlyLegalSummary│ │
│  │  businessInfo.phoneNumber    │   │  │  .fullName           │ │
│  │  businessInfo.email          │   │  │  .position           │ │
│  │  businessInfo.username       │   │  │  ⚠️ READ-ONLY        │ │
│  │  ⚠️ READ-ONLY                │   │  └────────────────────┘ │
│  └──────────────────────────────┘   │                          │
│                                     │  ┌─ CTA ───────────────┐ │
│  ┌─ Branding ✏️ ─────────────────┐   │  │  "Go to Verification│ │
│  │  publicProfile.coverImageUrl │   │  │   Page" link         │ │
│  │  publicProfile.logoImageUrl  │   │  └────────────────────┘ │
│  └──────────────────────────────┘   │                          │
│                                     └──────────────────────────┘
│  ┌─ Description ✏️ ──────────────┐
│  │  publicProfile.description   │
│  └──────────────────────────────┘
│
│  ┌─ Gallery ✏️ ──────────────────┐
│  │  publicProfile.gallery[]     │
│  └──────────────────────────────┘
│
│  ┌─ Certifications ✏️ ───────────┐
│  │  publicProfile.certifications│
│  └──────────────────────────────┘
│
│  ┌─ Save / Discard Bar ─────────┐
│  │  [Discard Changes]  [Save]   │
│  │  Visible only when dirty     │
│  └──────────────────────────────┘
└─────────────────────────────────────┘

✏️ = editable sections     ⚠️ = read-only (from admin-verified data)
```

### State Machine (Notifier)

```
bootstrapping ──GET success──→ ready_clean
      │                             │
      │                        field mutation
      │                             ↓
      └──GET failure──→ load_failed  ready_dirty
                                     │        ↑
                                  [Save]   [Discard]
                                     ↓        │
                                   saving ─────┘ (on failure → save_failed)
                                     │
                                  PUT success
                                     ↓
                                 ready_clean (replace snapshot + draft)
```

### Key Integration Points

1. **On page load** → call `GET /public-profile`
2. **Store `serverSnapshot`** from GET response's `publicProfile`
3. **Maintain `draft`** copy — user edits this
4. **Dirty check** → compare `draft` vs `serverSnapshot` to enable/disable Save
5. **On Save** → send only changed fields in PUT body
6. **On PUT success** → replace both `serverSnapshot` and `draft` with new response's `publicProfile`
7. **On PUT failure** → keep `draft` intact, show error, let user retry
8. **Discard** → reset `draft` back to `serverSnapshot`
9. **Route leave guard** → warn if `dirty === true`
10. **After save** → invalidate `accountMeProvider` to sync session

### Partial Update Example

If the user only changes the description:

```json
{
  "description": "New description that is at least 120 characters long to satisfy the completion requirement and provide patients with meaningful information."
}
```

If the user only reorders certifications:

```json
{
  "certifications": [
    { "id": "cert-2-uuid", "title": "WHO Certified", "sortOrder": 0 },
    { "id": "cert-1-uuid", "title": "ISO 9001:2015", "sortOrder": 1 }
  ]
}
```

---

## 5. Completion Rules Reference

These rules determine the `completionSummary.checklist` status:

| Key | Label | Required | Completed When |
|-----|-------|----------|----------------|
| `coverImageUrl` | Clinic cover image | ✅ yes | Non-empty URL |
| `logoImageUrl` | Clinic logo image | ✅ yes | Non-empty URL |
| `description` | Clinic description | ✅ yes | 120–1000 characters (trimmed) |
| `gallery` | Clinic gallery | ✅ yes | ≥ 3 image URLs |
| `certifications` | Trust badges | ❌ no | ≥ 1 certification |

- `completionPercent` = `round(completed_count / total_count × 100)`
- `isCompleted` = all **required** items are completed

---

## 6. Quick Reference

### Endpoint Summary
```
Base URL:  https://<api-host>/v1/partner/partners

GET  /public-profile     → Load aggregate for edit page
PUT  /public-profile     → Save storefront changes (rate limit: 10/min)
```

### Relationship to Other Endpoints

| Endpoint | When to use |
|----------|-------------|
| `GET /me` | Registration/verification page (business data + KYC docs) |
| `PUT /me` | Resubmit rejected fields (only when `REQUIRED_RESUBMIT`) |
| `GET /me/completion` | Initial profile completion flow (first time after approval) |
| `PUT /me/completion` | Initial profile completion save |
| **`GET /public-profile`** | **Edit profile page (post-completion, ongoing edits)** |
| **`PUT /public-profile`** | **Save public profile edits (storefront only)** |
