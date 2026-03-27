# 01 — Entities & Module Setup

**Status:** ✅ COMPLETED

## Context

The Employees module manages healthcare staff under each partner. Employees can be doctors, spa therapists, or massage therapists — each with type-specific profile data (specializations, certifications, work schedules).

## Prerequisites

- ✅ `Partner` entity (employees belong to a partner)
- ✅ Database migrations for employees, doctor_profiles, therapist_profiles

## Tasks

### 1. Create entities in `src/common/entities/`
- **`employee.entity.ts`** — fullName, title, avatarUrl, phoneNumber, email, dateOfBirth, gender, bio, partnerId (FK), type discriminator, work schedule (JSONB), createdAt/updatedAt/deletedAt
- **`doctor-profile.entity.ts`** — licenseNumber, specializations (JSONB), yearsOfExperience, linkedto Employee
- **`therapist-profile.entity.ts`** — certifications (JSONB), specialties (JSONB), therapist type (spa/massage), linkedto Employee

### 2. Create `src/employees/employees.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([Employee, Partner, DoctorProfile, TherapistProfile])],
  controllers: [PartnerEmployeesController, UserEmployeesController],
  providers: [EmployeesService, CreateDoctorHandler, CreateTherapistHandler, UpdateEmployeeHandler, RemoveEmployeeHandler],
  exports: [EmployeesService],
})
```

## Completed

Entities support polymorphic employee types via profile relations. Module registered with dual controllers (partner-scoped and user-facing).
