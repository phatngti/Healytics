# 02 — Create Handlers (Doctor & Therapist)

**Status:** ✅ COMPLETED

## Context

Employee creation is type-specific — doctors and therapists have different required fields and profile structures. Each type gets its own handler and DTO.

## Prerequisites

- ✅ Todo 01 — Entities and module setup
- ✅ `EmployeesService` with `getPartnerIdByAccountId()`

## Tasks

### 1. Create DTOs in `src/employees/dto/`
- **`create-doctor.dto.ts`** — base employee fields + licenseNumber, specializations, yearsOfExperience
- **`create-therapist.dto.ts`** — base employee fields + certifications, specialties, therapist type
  - Two concrete classes: `CreateSpaTherapistDto`, `CreateMassageTherapistDto`
- **`employee-response.dto.ts`** — unified response with static `fromEntity()`, includes type-specific profile data
- **`work-schedule-entry.dto.ts`** — day, startTime, endTime for work schedule

### 2. Create `src/employees/application/handlers/create-doctor.handler.ts`
**Logic:**
- Creates Employee entity with type = DOCTOR
- Creates associated DoctorProfile
- Links to partner via partnerId
- Returns EmployeeResponseDto

### 3. Create `src/employees/application/handlers/create-therapist.handler.ts`
**Logic:**
- Creates Employee entity with type = SPA_THERAPIST or MASSAGE_THERAPIST
- Creates associated TherapistProfile
- Links to partner
- Returns EmployeeResponseDto

## Completed

Type-specific creation handlers for doctors and therapists. Work schedule stored as JSONB. Response DTO dynamically includes type-specific profile data.
