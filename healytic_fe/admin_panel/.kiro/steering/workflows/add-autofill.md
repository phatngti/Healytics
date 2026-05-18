---
inclusion: manual
---

# Workflow: Add Dev Autofill to a Form

Adds `?autofill=true` URL-query-param autofill to a named `FormBuilder`
screen. The form is pre-populated with realistic sample data in debug
builds only.

## Usage

Invoke with: `#add-autofill <ScreenName>`

Example: `#add-autofill ProductAdd`

## Steps

1. Read the `form-autofill` skill for full context.

2. Identify all field keys by grepping the feature's widget folder.

3. Create the constants file:
   `lib/features/.../presentation/<feature>_autofill.dart`

4. Locate the `GoRouteData` class for the screen's route in
   `lib/router/` and add the optional `autofill` param.

5. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. Update the screen to accept `autofill` and pass
   `initialValue` (or `useEffect` for controller-based forms).

7. For desktop layout widgets that manage their own state (dropdowns,
   toggles), add `initial*` constructor params and pass autofill
   constants from the screen.

8. Verify:
   - Navigate to `<route>?autofill=true` → fields filled
   - Navigate to `<route>` → fields empty
