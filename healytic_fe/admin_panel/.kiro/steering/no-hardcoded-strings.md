---
inclusion: manual
---

# No Hardcoded Strings

Apply when writing or reviewing code that uses string literals for form fields, enum comparisons, JSON keys, or business logic values.

## Rule

**Never use raw string literals** for:
- **Form field keys** (e.g., `values['first_name']`)
- **Business/compare values** (e.g., `== 'DOCTOR'`, `?? 'Full-Time'`)
- **API enum values** (e.g., `'MALE'`, `'THERAPIST'`)
- **JSON/map keys** for structured data (e.g., `'day'`, `'isWorking'`)

**Exceptions** — raw strings ARE allowed for:
- User-facing messages (SnackBar text, dialog titles, error messages)
- Placeholder URLs for avatars / fallback assets
- Log messages (`dart:developer` `log()`)
- Route names (already covered by the routing rule)

## How to Comply

### Form Field Keys
Create or extend a `*FormField` enum in the feature's `domain/` layer:

```dart
// domain/employee_form_field.dart
enum EmployeeFormField {
  firstName('first_name'),
  lastName('last_name'),
  email('email');

  const EmployeeFormField(this.key);
  final String key;
}
```

Usage:
```dart
// Correct
values[EmployeeFormField.firstName.key]

// Wrong
values['first_name']
```

### Business / API Values
Use existing domain enums with `apiValue` / `displayName`:

```dart
// Correct
EmployeeRole.therapist.apiValue   // 'THERAPIST'
EmployeeGender.nonBinary.apiValue // 'OTHER'
EmploymentType.fullTime.displayName // 'Full-Time'

// Wrong
'THERAPIST'
'OTHER'
'Full-Time'
```

### JSON Map Keys
Use an `abstract final class` with `static const` fields:

```dart
// domain/schedule_entry_key.dart
abstract final class ScheduleEntryKey {
  static const day = 'day';
  static const start = 'start';
  static const end = 'end';
  static const isWorking = 'isWorking';
}
```

Usage:
```dart
// Correct
{ScheduleEntryKey.day: day.displayName}

// Wrong
{'day': day.displayName}
```

### Default/Fallback Values
When a default value represents a business concept, use the enum:

```dart
// Correct
final gender = parsedGender
    ?? EmployeeGender.nonBinary.apiValue!;

// Wrong
final gender = parsedGender ?? 'OTHER';
```

## Quick Checklist

- [ ] No `values['some_key']` — use `*FormField.*.key`
- [ ] No `== 'SOME_VALUE'` — use `SomeEnum.*.apiValue`
- [ ] No `?? 'Default'` for business values — use enum getter
- [ ] No `{'key': value}` for API maps — use `*Key.key`
- [ ] User-facing messages remain as plain strings
