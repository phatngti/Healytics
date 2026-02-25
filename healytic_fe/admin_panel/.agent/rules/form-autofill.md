---
trigger: model_decision
description: Dev-autofill pattern for FormBuilder forms. Apply when creating a new form screen or adding autofill support to an existing screen.
---

# Form Autofill Pattern

Every `FormBuilder` screen with **3 or more fields** must support
`?autofill=true` for development and staging testing.

## Convention

| Item | Rule |
|---|---|
| Store config | `StoreKey.autoFill` in `store.json` — global toggle |
| URL activation | `?autofill=true` — per-navigation override |
| Guard | Always wrapped in `kDebugMode` — stripped in release builds |
| Constants file | `lib/.../presentation/autofill/<feature>_add.autofill.dart` |
| Naming | `abstract final class <Feature>AddAutofill` |

## Activation Priority

Autofill is active when **`kDebugMode`** is true AND either:
1. `Store.tryGet(StoreKey.autoFill)` is `true` (global config), OR
2. `?autofill=true` URL query param is present (per-navigation)

```dart
final shouldAutofill = kDebugMode &&
    (autofill || (Store.tryGet(StoreKey.autoFill) ?? false));
```

## Required Steps

### 1. Constants File

Create `lib/features/<feature>/presentation/autofill/<feature>_add.autofill.dart`:

```dart
// my_feature_add.autofill.dart
abstract final class MyFeatureAddAutofill {
  static const fieldName = 'Sample Value';
  static const otherField = '123';
}
```

### 2. Route — Add Query Param

```dart
class MyAddRoute extends GoRouteData with $MyAddRoute {
  const MyAddRoute({this.autofill});
  static const name = 'my-add';

  final bool? autofill; // parsed from ?autofill=true

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MyAddScreen(autofill: autofill ?? false);
}
```

Run code gen after modifying any `GoRouteData`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Screen — Pass `initialValue`

```dart
class MyAddScreen extends HookConsumerWidget {
  const MyAddScreen({super.key, this.autofill = false});
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
      child: ...,
    );
  }

  static Map<String, dynamic> _buildAutofillValues() => {
    'field_key': MyFeatureAutofill.fieldName,
    'other_field': MyFeatureAutofill.otherField,
  };
}
```

### 4. Sidebar Widgets

Widgets that manage their own state (dropdowns, toggles) receive
autofill values through existing `initial*` constructor props.
The screen decides whether to pass the autofill constant or the
normal default:

```dart
MySidebarWidget(
  initialStatus: (kDebugMode && autofill)
      ? MyFeatureAutofill.status
      : 'draft',
)
```

## TextEditingController Forms

For forms that use explicit `TextEditingController`s instead of
`FormBuilder.initialValue`, use `useEffect`:

```dart
final emailController = useTextEditingController();

useEffect(() {
  if (kDebugMode && autofill) {
    emailController.text = 'admin@example.com';
  }
  return null;
}, []);
```

## Exclusions

- Edit screens (pre-populated from API — no autofill needed)
- Forms with fewer than 3 fields
- Production builds (enforced by `kDebugMode`)
