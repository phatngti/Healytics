---
trigger: always_on
---

# DESIGN SYSTEM SPECS & RULES (STRICT MODE)

## 0. CONTEXT & FILE PATHS (CRITICAL)
Refer to these specific files for definitions and imports:
- **Dimensions constants (`AppDimens`):** `lib/utils/demensions.dart`
- **Theme & Colors (`AppTheme`, `SemanticColors`):** `lib/theme/app_theme.dart`
- **Device Utils (`DeviceUtils`):** `lib/utils/device.dart`
- **Theme Mode (`AppThemeMode`):** `lib/theme/app_theme_mode.dart`

## 1. CORE THEME & COLORS
- **Scheme:** `FlexScheme.aquaBlue` (Primary: `#1A7B99`, Secondary: `#4BAAC8`).
- **Font:** `Roboto`.

**COLOR USAGE (MANDATORY):**
- **Source:** Use `Theme.of(context).colorScheme` or `context.colorScheme`.
- **Semantic:** Use `Theme.of(context).extension<SemanticColors>()!` (Keys: `.success`, `.warning`, `.info`, `.error`).
- **FORBIDDEN:** Hardcoded colors (`Colors.blue`, `Color(0xFF...)`).

## 2. TYPOGRAPHY (MANDATORY)
**RULE:** Every `Text` widget MUST have an explicit `style` property sourced from Theme.
- **Source:** `Theme.of(context).textTheme` (or `context.textTheme`).
- **Mappings:**
  - `headlineLarge`..`headlineSmall` (Module Headers).
  - `titleMedium` (Cards), `titleSmall` (Subsections).
  - `bodyLarge` (Content), `bodyMedium` (Default).
  - `labelLarge` (Buttons).
- **FORBIDDEN:** Null style, raw `TextStyle(...)`, or hardcoded font sizes.
- **Modification:** Use `.copyWith()` on theme styles only when necessary.

## 3. DIMENSIONS & SPACING (CONSTANTS ONLY)
**RULE:** ALL spacing, padding, and radius MUST use `AppDimens` static constants from `lib/utils/demensions.dart`.
**CRITICAL:** Extension methods (e.g., `16.verticalSpace`, `16.paddingAll`) are **FORBIDDEN**.

| Value | Padding Constant | Spacing Constant (SizedBox) | Radius Constant |
|---|---|---|---|
| **4px** | `AppDimens.paddingAllExtraSmall` | `AppDimens.verticalExtraSmall` | `AppDimens.radiusExtraSmall` |
| **8px** | `AppDimens.paddingAllSmall` | `AppDimens.verticalSmall` | `AppDimens.radiusSmall` |
| **12px**| `AppDimens.paddingAllMediumSmall`| - | - |
| **16px**| `AppDimens.paddingAllMedium` | `AppDimens.verticalMedium` | `AppDimens.radiusMedium` |
| **24px**| `AppDimens.paddingAllLarge` | `AppDimens.verticalLarge` | `AppDimens.radiusLarge` |
| **32px**| - | `AppDimens.verticalExtraLarge`| - |

**Responsive:**
- Mobile: `<500px` -> `DeviceUtils.isMobileScreen(context)`
- Tablet: `500-700px` -> `DeviceUtils.isTabletScreen(context)`
- Desktop: `>700px` -> `DeviceUtils.isDesktopScreen(context)`

## 4. COMPONENTS
- **Forms:** MANDATORY `flutter_form_builder` (`FormBuilderTextField`, `FormBuilderDropdown`, `FormBuilderDateTimePicker`).
- **Validation:** Use `FormBuilderValidators`.
- **Inputs:** Decoration must utilize `filled: true` style from Theme.
- **Buttons:** Primary (Filled), Secondary (Outlined), Ghost (Text).

## 5. CODE GENERATION EXAMPLES

❌ **BAD (STRICTLY REJECT):**
```dart
Column(
  children: [
    Text('Hello'), // Error: Missing style
    16.verticalSpace, // Error: Extension forbidden
    Container(
      padding: EdgeInsets.all(8), // Error: Raw number
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)), // Error: Raw radius
    ), 
  ],
)