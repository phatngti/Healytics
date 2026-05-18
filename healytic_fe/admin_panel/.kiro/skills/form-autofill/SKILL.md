---
name: form-autofill
description: Add `?autofill=true` dev autofill support to any FormBuilder screen. Use when creating a new add/create form or retrofitting an existing one. Follows the project autofill standard.
---

# Form Autofill Skill

## When to Use

- Creating a new `*_add.screen.dart` with `FormBuilder`
- Retrofitting an existing form that lacks autofill
- Verifying a form already follows the autofill standard

## Step-by-Step

### Step 1 — Identify All Field Keys

Grep for `fieldKey:` and `name:` in the feature's widget folder:

```bash
grep -r "fieldKey:\|name:" lib/features/<feature>/presentation/widgets/
```

Collect every key. These are the keys you'll put in the constants file.

### Step 2 — Create Constants File

Create `lib/features/<feature>/presentation/<feature>_autofill.dart`:

```dart
/// Dev-only autofill defaults for the <Feature> Add form.
/// Activate via `?autofill=true` in the URL.
abstract final class <Feature>Autofill {
  // Text fields
  static const fieldKey = 'Sample Value';
  static const numericField = '42';

  // Dropdown / status
  static const status = 'active';

  // Bool toggles
  static const onlineStore = true;
}
```

**Rules:**
- All numeric fields → `String` (FormBuilder reads them as strings)
- Dropdown values → match the `value:` of the `DropdownMenuItem`
- Bool toggles only for widgets that accept `initial*` props

### Step 3 — Update GoRouteData

In `lib/router/<scope>_routes.dart`, add `autofill` to the route:

```dart
class <Feature>AddRoute extends GoRouteData with $<Feature>AddRoute {
  const <Feature>AddRoute({this.autofill});
  static const name = '<scope>-<feature>-add';

  /// Dev flag: `?autofill=true` pre-fills the form.
  final bool? autofill;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: <Feature>AddScreen(autofill: autofill ?? false),
    );
  }
}
```

Then run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4 — Update Screen

```dart
class <Feature>AddScreen extends HookConsumerWidget {
  const <Feature>AddScreen({super.key, this.autofill = false});

  /// Pre-fill form in debug builds when `?autofill=true` is in URL.
  final bool autofill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final initialValue = useMemoized(
      () => (kDebugMode && autofill)
          ? _buildAutofillValues()
          : const <String, dynamic>{},
    );

    return FormBuilder(
      key: formKey,
      initialValue: initialValue,
      child: <Feature>AddDesktop(
        onCancel: ...,
        onSubmit: ...,
        // Pass initial* props for sidebar widgets:
        initialStatus: (kDebugMode && autofill)
            ? <Feature>Autofill.status
            : 'draft',
      ),
    );
  }

  static Map<String, dynamic> _buildAutofillValues() => {
    'field_key': <Feature>Autofill.fieldKey,
    'numeric_field': <Feature>Autofill.numericField,
  };
}
```

### Step 5 — Verify

1. Run the app: `make run-default`
2. Navigate to: `/<route>?autofill=true` — fields should auto-fill
3. Navigate to: `/<route>` — fields should be empty (no regression)
4. Submit the pre-filled form — should validate and call API

## Checklist

- [ ] Constants file created at `*_autofill.dart`
- [ ] All `fieldKey:` values mapped in constants
- [ ] `autofill` query param added to `GoRouteData`
- [ ] `kDebugMode && autofill` guard in screen
- [ ] `FormBuilder.initialValue` or `useEffect` (for controller-based forms)
- [ ] Code gen run after route change
- [ ] No autofill in release build (verify with `kDebugMode` guard)
