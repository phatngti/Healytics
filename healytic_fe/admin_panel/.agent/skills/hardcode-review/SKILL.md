---
name: hardcode-review
description: Reviews Dart code for hardcoded string violations. Use when reviewing PRs, writing new features, or auditing existing code for raw string literals used as form field keys, business values, API constants, or comparison values.
---

# Hardcoded String Review

## When to Use
- Reviewing pull requests or new feature code.
- Auditing existing code for hardcoded-string violations.
- Before merging to validate no-hardcode compliance.
- When creating new form screens, data sources, or request builders.

## What Counts as a Violation

| Category | Example violation | Fix |
|---|---|---|
| Form field key | `values['first_name']` | `values[MyFormField.firstName.key]` |
| Business compare | `== 'DOCTOR'` | `== EmployeeRole.doctor.apiValue` |
| Default value | `?? 'Full-Time'` | `?? EmploymentType.fullTime.displayName` |
| API enum value | `'MALE'` | `EmployeeGender.male.apiValue` |
| JSON map key | `{'day': ...}` | `{ScheduleEntryKey.day: ...}` |

## What Is Allowed

- User-facing messages: SnackBar text, dialog titles, error messages.
- Placeholder URLs for avatars/fallback assets.
- Log messages via `dart:developer`.
- String interpolation for constructing messages.

## Review Process

1. **Scan imports**: Check that the file imports relevant `*FormField`, `*Key`, and domain enum files.

2. **Search for string literals**: Find all single-quoted strings in the file.

3. **Classify each string**:
   - Is it a **form field key** (used in `values[...]` or `FormBuilderTextField(name: ...)`)?
   - Is it a **comparison value** (used with `==`, `!=`, `switch`)?
   - Is it a **default value** (used with `??`)?
   - Is it a **map key** for API-shaped data?
   - Is it a **user-facing message** (SnackBar, dialog, Text widget)?

4. **Report violations** grouped by category with file path and line number.

5. **Suggest fix** for each violation:
   - If an enum already exists → use it.
   - If no enum exists → create one in `domain/`.
   - If it's a set of map keys → create an `abstract final class` with `static const` fields.

## Enum Creation Pattern

When a new enum is needed:

```dart
// domain/<name>.dart
/// Doc comment explaining the enum.
enum MyEnum {
  valueA,
  valueB;

  /// User-friendly display name.
  String get displayName => switch (this) {
    MyEnum.valueA => 'Value A',
    MyEnum.valueB => 'Value B',
  };

  /// API value for backend communication.
  String get apiValue => switch (this) {
    MyEnum.valueA => 'VALUE_A',
    MyEnum.valueB => 'VALUE_B',
  };

  /// Parse from API value.
  static MyEnum? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'VALUE_A' => MyEnum.valueA,
      'VALUE_B' => MyEnum.valueB,
      _ => null,
    };
  }
}
```

## Map Key Constants Pattern

```dart
// domain/<name>_key.dart
abstract final class SomeKey {
  static const field1 = 'field1';
  static const field2 = 'field2';
}
```

## Form Field Enum Pattern

```dart
// domain/<feature>_form_field.dart
enum MyFormField {
  fieldName('field_name');

  const MyFormField(this.key);
  final String key;
}
```
