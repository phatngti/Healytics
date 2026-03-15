# Auth Feature — Todo Pipeline

This folder documents the implementation history of the **Authentication Module** (JWT + Passport for 3 user types: User, Partner, Admin). Each file is a self-contained record of what was built and why.

## Ordering

Files are numbered `01-` through `04-`. They were executed sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built

| Component | Status | Location |
|---|---|---|
| `Account` entity (email, password, role) | ✅ | `src/common/entities/account.entity.ts` |
| `Role` enum (USER, HEALTH_PARTNER, ADMIN, SUPER_ADMIN) | ✅ | `src/account/enum/role.enum.ts` |
| Role groups (ALL_ROLES, ADMIN_ROLES) | ✅ | `src/auth/constants/role-groups.ts` |
| JWT secret config | ✅ | `src/auth/constants.ts` |
| Throttle module (rate limiting) | ✅ | `app.module.ts` |
