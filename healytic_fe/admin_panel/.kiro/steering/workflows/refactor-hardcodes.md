---
inclusion: manual
---

# Workflow: Refactor Hardcoded Strings

Refactor hardcoded strings in a Dart file to use enums and constants. Use when a file has raw string literals for form field keys, business values, comparisons, or API map keys.

## Input Required
- `<target_file>`: Absolute path to the Dart file to refactor.
- `<feature_name>`: Feature name (e.g., `employee`, `partner`).

## Steps

1. **Read the target file** and identify all hardcoded strings:
   - Form field keys: `values['key']`, `FormBuilderTextField(name: 'key')`
   - Business compare values: `== 'VALUE'`, `!= 'VALUE'`
   - Default fallback values: `?? 'VALUE'`
   - API map keys: `{'key': value}`
   - Classify which strings are user-facing messages (allowed to stay).

2. **Check existing domain enums** in `lib/features/<feature_path>/domain/`:
   ```bash
   ls lib/features/<feature_path>/domain/
   ```
   Note which enums already have `apiValue` / `displayName` getters.

3. **For form field keys**, check if a `*_form_field.dart` enum exists:
   - If yes → use it, add missing entries.
   - If no → create `lib/features/<feature_path>/domain/<feature>_form_field.dart`:
     ```dart
     enum <Feature>FormField {
       fieldName('field_name');
       const <Feature>FormField(this.key);
       final String key;
     }
     ```

4. **For API map keys**, check if a `*_key.dart` class exists:
   - If yes → use it, add missing entries.
   - If no → create `lib/features/<feature_path>/domain/<name>_key.dart`:
     ```dart
     abstract final class SomeKey {
       static const key1 = 'key1';
     }
     ```

5. **For business/compare values**, identify the matching domain enum:
   - `'DOCTOR'` → `EmployeeRole.doctor.apiValue`
   - `'MALE'` → `EmployeeGender.male.apiValue`
   - `'Full-Time'` → `EmploymentType.fullTime.displayName`
   - If no enum exists, create one following the standard pattern.

6. **Apply replacements** in the target file:
   - Add necessary imports.
   - Replace each hardcoded string with enum/constant reference.
   - Leave user-facing message strings unchanged.

7. **Run static analysis** to verify:
   ```bash
   dart analyze <target_file>
   ```
   Fix any issues found.

8. **Verify no remaining hardcodes** by searching:
   ```bash
   grep -n "values\['" <target_file>
   grep -n "== '" <target_file>
   grep -n "?? '" <target_file>
   ```
   Any hits should be user-facing messages only.
