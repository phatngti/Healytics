# Rule 11 — Todo Tracking

## When to Update Todos

After completing **any implementation work** on a module (new feature, bugfix, refactor, tests), you **MUST** update the module's `todos/` directory.

## How

1. Use the `/update-todos` workflow for step-by-step instructions
2. If the module has no `todos/` directory, create one
3. Add a new numbered step file documenting what was built
4. Update the `README.md` file count

## Todo File Format

Every step file must have these sections:
- **Status** — `✅ COMPLETED`, `🔄 IN PROGRESS`, or `🔲 TODO`
- **Context** — What and why
- **Prerequisites** — What was already in place
- **Tasks** — Numbered tasks with details
- **Completed** — Bullet list of what was actually done (file paths, test counts)

## Module → Todos Mapping

Source directories map to `todos/<module-name>/`. Infrastructure modules (`redis`, `rabbitmq`, `s3`, `config`, `database`) share `todos/infrastructure/`.

## Priority

This rule applies after every implementation. Do not skip it. The todos serve as a living history for agents picking up future work.
