# API Guide: Get Specialists by Service ID

## Overview

The frontend requires an endpoint that returns a list of **specialists (employees)** assigned to a given health service, along with their **profile information** and **day-by-day booking schedules** with available time slots.

This endpoint powers **two screens**:

| Screen | File | Usage |
|---|---|---|
| **Service Details → Specialist Section** | `specialist_section.widget.dart` | Shows specialist avatars, profile card (quote, credentials, bio), horizontal date selector, and time-slot grid |
| **Book Appointment → Select Specialist** | `select_specialist.screen.dart` | Shows specialist cards for selection, then date picker and time-slot selection |

---

## Endpoint

```
GET /health-services/{serviceId}/employees
```

### Path Parameter

| Name | Type | Description |
|---|---|---|
| `serviceId` | `string` (UUID) | The health service ID |

### Authentication

Bearer token (logged-in user). Required to check booking availability against user-specific constraints.

---

## Response Shape

```
HTTP 200 OK
Content-Type: application/json
```

Returns an **array** of specialist objects:

```jsonc
[
  {
    // ── Identity (required) ──
    "id": "emp-sarah-lin",         // string, unique employee ID
    "name": "Dr. Sarah Lin",       // string, display name
    "role": "Dermatologist",       // string, job title / role label

    // ── Avatar (optional) ──
    "imageUrl": "https://...",     // string | null, profile photo URL
                                   // May return SVG (e.g. DiceBear) or raster

    // ── Selection hint (required) ──
    "isSelected": true,            // boolean, true for the default/recommended specialist
                                   // Exactly ONE specialist should have isSelected=true

    // ── Profile details (all optional) ──
    "quote": "Specializing in cosmetic laser procedures...",  // string | null
    "degrees": "MD, PhD",                                      // string | null
    "languages": "EN, ES",                                     // string | null, comma-separated
    "experience": "12 years",                                  // string | null, human-readable
    "specializations": ["Laser Therapy", "Acne Treatment"],    // string[] | null
    "bio": "Dr. Sarah Lin graduated top of her class...",      // string | null

    // ── Schedules (required, may be empty []) ──
    "daySchedules": [
      {
        "date": "2026-03-25",       // string, ISO 8601 date (YYYY-MM-DD)
        "isAvailable": true,        // boolean, false = clinic closed / fully booked
        "timeSlots": [              // array, empty if isAvailable=false
          {
            "label": "09:00 AM",    // string, display label (12h format)
            "isAvailable": true     // boolean, false = already booked
          },
          {
            "label": "09:30 AM",
            "isAvailable": false
          }
          // ... more slots
        ]
      }
      // ... more days
    ]
  }
  // ... more specialists
]
```

---

## Field Reference

### Specialist Object

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | `string` | ✅ | Unique employee identifier |
| `name` | `string` | ✅ | Full display name |
| `role` | `string` | ✅ | Job title (shown below avatar in UPPERCASE) |
| `imageUrl` | `string \| null` | ❌ | Profile photo URL. Can be SVG or raster. Frontend handles both formats automatically |
| `isSelected` | `boolean` | ✅ | Pre-select hint. Exactly **one** specialist should be `true` (the recommended/default). Rest should be `false` |
| `quote` | `string \| null` | ❌ | Short personal quote displayed in an italic card |
| `degrees` | `string \| null` | ❌ | Abbreviated credentials (e.g. `"MD, PhD"`, `"Licensed Aesthetician"`) |
| `languages` | `string \| null` | ❌ | Comma-separated language codes (e.g. `"EN, ES"`) |
| `experience` | `string \| null` | ❌ | Human-readable experience (e.g. `"12 years"`) |
| `specializations` | `string[]` | ❌ | List of specialization tags. Rendered as chips in the UI. Defaults to `[]` if omitted |
| `bio` | `string \| null` | ❌ | Extended biography (shown in expandable "Show More" panel) |
| `daySchedules` | `DaySchedule[]` | ✅ | Per-day booking availability. Defaults to `[]` if no schedules exist |

### DaySchedule Object

| Field | Type | Required | Description |
|---|---|---|---|
| `date` | `string` | ✅ | ISO 8601 date string (`YYYY-MM-DD`). Frontend parses with `DateTime.tryParse()` |
| `isAvailable` | `boolean` | ✅ | `false` when clinic is closed or fully booked on this day |
| `timeSlots` | `TimeSlot[]` | ✅ | Available/booked time slots. Should be **empty `[]`** when `isAvailable` is `false` |

### TimeSlot Object

| Field | Type | Required | Description |
|---|---|---|---|
| `label` | `string` | ✅ | Display label in **12-hour format** (e.g. `"09:00 AM"`, `"02:30 PM"`). Frontend splits AM/PM into "Morning" and "Afternoon" sections |
| `isAvailable` | `boolean` | ✅ | `true` if the slot is bookable, `false` if already taken |

---

## Business Rules

### Specialist Selection
- At least **one specialist** should have `isSelected: true` (the recommended/default specialist)
- If no specialist is specifically recommended, set the **first** one as selected

### Schedule Generation
- Generate schedules for **at least 7 days** ahead (frontend shows a 7-day horizontal date picker by default)
- Ideally provide **30 days** of schedule data (the date picker has a "show more" button that opens a calendar modal for the full range)
- Days when the clinic is closed should still appear with `isAvailable: false` and `timeSlots: []` — this allows the frontend to gray them out in the calendar picker

### Time Slot Format
- Use **12-hour format** with `AM`/`PM` suffix: `"09:00 AM"`, `"02:30 PM"`
- The frontend groups slots by AM (☀️ Morning) and PM (🌅 Afternoon)
- Include **both available and booked** slots — the frontend shows booked slots as grayed out, giving users a visual sense of demand

### Empty States
- If a service has **no specialists assigned**, return an empty array `[]`
- If a specialist has **no schedule configured**, return `daySchedules: []`

---

## Existing OpenAPI DTO Reference

The current OpenAPI spec already defines these DTOs used by the generated client:

| DTO Class | Notes |
|---|---|
| `PublicHealthServiceEmployeeResponseDto` | Main specialist response DTO |
| `PublicHealthServiceEmployeeDayScheduleDto` | Nested day schedule with `date`, `isAvailable`, `timeSlots` |
| `PublicEmployeeTimeSlotDto` | Nested time slot with `label`, `isAvailable` |

> [!IMPORTANT]
> The generated client already maps these DTOs. If you change the response shape, update the OpenAPI spec and regenerate the client on the frontend side.

---

## Example Response

```json
[
  {
    "id": "emp-sarah-lin",
    "name": "Dr. Sarah Lin",
    "role": "Dermatologist",
    "imageUrl": "https://example.com/photos/sarah-lin.jpg",
    "isSelected": true,
    "quote": "Specializing in cosmetic laser procedures with over 10 years of experience.",
    "degrees": "MD, PhD",
    "languages": "EN, ES",
    "experience": "12 years",
    "specializations": ["Laser Therapy", "Acne Treatment", "Skin Rejuvenation", "Scar Removal"],
    "bio": "Dr. Sarah Lin graduated top of her class from Harvard Medical School.",
    "daySchedules": [
      {
        "date": "2026-03-25",
        "isAvailable": true,
        "timeSlots": [
          { "label": "07:00 AM", "isAvailable": true },
          { "label": "07:30 AM", "isAvailable": false },
          { "label": "08:00 AM", "isAvailable": true },
          { "label": "09:00 AM", "isAvailable": true },
          { "label": "09:30 AM", "isAvailable": false },
          { "label": "10:00 AM", "isAvailable": true },
          { "label": "02:00 PM", "isAvailable": true },
          { "label": "03:00 PM", "isAvailable": true },
          { "label": "04:00 PM", "isAvailable": false }
        ]
      },
      {
        "date": "2026-03-26",
        "isAvailable": true,
        "timeSlots": [
          { "label": "09:00 AM", "isAvailable": true },
          { "label": "10:00 AM", "isAvailable": true },
          { "label": "02:00 PM", "isAvailable": true }
        ]
      },
      {
        "date": "2026-03-28",
        "isAvailable": false,
        "timeSlots": []
      }
    ]
  },
  {
    "id": "emp-jessica-m",
    "name": "Jessica M.",
    "role": "Aesthetician",
    "imageUrl": "https://example.com/photos/jessica-m.jpg",
    "isSelected": false,
    "quote": "I focus on creating personalized skincare routines.",
    "degrees": "Licensed Aesthetician",
    "languages": "EN, FR",
    "experience": "8 years",
    "specializations": ["Post-Laser Care", "Chemical Peels", "Microdermabrasion"],
    "bio": null,
    "daySchedules": [
      {
        "date": "2026-03-25",
        "isAvailable": true,
        "timeSlots": [
          { "label": "09:00 AM", "isAvailable": true },
          { "label": "10:30 AM", "isAvailable": true },
          { "label": "02:00 PM", "isAvailable": false }
        ]
      }
    ]
  }
]
```

---

## How Frontend Consumes This

```
┌──────────────────────────────────────────────────┐
│  GET /health-services/{id}/employees             │
│                                                  │
│  ┌──────────────┐    ┌────────────────────────┐  │
│  │DTO (OpenAPI) │───▶│ SpecialistEntity       │  │
│  │              │    │  ├─ id, name, role      │  │
│  │              │    │  ├─ imageUrl             │  │
│  │              │    │  ├─ isSelected           │  │
│  │              │    │  ├─ quote, degrees, etc. │  │
│  │              │    │  └─ daySchedules[]       │  │
│  │              │    │      ├─ date             │  │
│  │              │    │      ├─ isAvailable      │  │
│  │              │    │      └─ timeSlots[]      │  │
│  │              │    │          ├─ label         │  │
│  │              │    │          └─ isAvailable   │  │
│  └──────────────┘    └────────────────────────┘  │
│                                                  │
│  Used by:                                        │
│  • serviceEmployeesProvider(serviceId)            │
│  • SpecialistSection widget                      │
│  • SelectSpecialistScreen                        │
└──────────────────────────────────────────────────┘
```
