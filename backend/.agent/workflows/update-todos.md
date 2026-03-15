---
description: Update module todo files after implementing changes to any module
---

# Update Module Todos Workflow

Use this workflow **after completing any implementation** that changes a module. This keeps the `todos/<module>/` directory up-to-date as a living history of what was built.

---

## 1. Identify the Module

Determine which module was modified. The module name maps to its `todos/` folder:

| Source Directory | Todos Directory |
|---|---|
| `src/account/` | `todos/account/` |
| `src/admin/` | `todos/admin/` |
| `src/audit/` | `todos/audit/` |
| `src/auth/` | `todos/auth/` |
| `src/booking/` | `todos/booking/` |
| `src/categories/` | `todos/categories/` |
| `src/chatbot/` | `todos/chatbot/` |
| `src/employees/` | `todos/employees/` |
| `src/google-maps/` | `todos/google-maps/` |
| `src/health-service/` | `todos/health-service/` |
| `src/locations/` | `todos/locations/` |
| `src/partners/` | `todos/partners/` |
| `src/redis/`, `src/rabbitmq/`, `src/s3/`, `src/config/`, `src/database/` | `todos/infrastructure/` |
| `src/service-tags/` | `todos/service-tags/` |

If the module doesn't have a `todos/` directory yet, create one following step 3.

---

## 2. Check if Todo Already Exists

// turbo
```bash
ls todos/<module-name>/
```

Read the `README.md` to understand the current numbered range and what's been done.

---

## 3. Create or Update the Todo File

### For a NEW implementation step:

1. Create a new numbered file: `<NN>-<short-name>.md` where `NN` is the next number
2. Use this template:

```markdown
# <NN> — <Title>

**Status:** ✅ COMPLETED

## Context

<What was done and why.>

## Prerequisites

- ✅ <List what was already in place>

## Tasks

### 1. <First task>
<Details>

### 2. <Second task>
<Details>

## Completed

- <Bullet list of what was actually built>
- <Include file paths, test counts, etc.>
```

3. Update the `README.md` to reflect the new file count:
   - Change `Files are numbered 01- through <previous>.` to include the new max number

### For a module WITHOUT any todos yet:

1. Create the `todos/<module-name>/` directory
2. Create `README.md` using the template from `todos/booking/README.md` as reference
3. Create numbered step files for each implementation phase already completed
4. Mark all existing steps as `✅ COMPLETED`

---

## 4. Verify

// turbo
```bash
ls todos/<module-name>/
cat todos/<module-name>/README.md
```

Confirm:
- [ ] `README.md` file count matches actual files
- [ ] All completed steps are marked `✅ COMPLETED`
- [ ] New file has `Context`, `Prerequisites`, `Tasks`, and `Completed` sections
