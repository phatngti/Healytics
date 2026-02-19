# Code Generation

Description: Runs build_runner and related code generation tools after modifying annotated code.

## When to Run
- After modifying `@riverpod` providers or notifiers.
- After modifying `@freezed` entity/state classes.
- After modifying `@JsonSerializable` models.
- After modifying `TypedGoRoute` route definitions.
- After modifying translation files.

## Steps

1. **Check for conflicts:** Ensure no build_runner process is already running. Kill any existing watchers.

2. **Run build_runner:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   This generates:
   - `*.g.dart` — Riverpod providers, JSON serialization, route builders.
   - `*.freezed.dart` — Freezed immutable classes.

3. **For active development** (watch mode):
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```
   This auto-regenerates on file changes. Use during development sessions.

4. **Generate translations** (if translation files changed):
   ```bash
   dart run slang
   ```

5. **Verify generation:** Run `dart analyze` to ensure no errors in generated code.

6. **If generation fails:**
   - Check for syntax errors in annotated classes.
   - Ensure all `part` directives are correct (e.g., `part 'filename.g.dart';`).
   - Delete `.dart_tool/build/` and retry.
   - Ensure all required annotations are imported.

## Quick Reference (Makefile)
```bash
make gen        # Build runner
make translate  # Slang translations
make get        # Pub get
```
