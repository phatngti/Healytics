# UI & Design System

## Theming

### Color Usage
- **Always** use `Theme.of(context).colorScheme.*` — never hardcode colors.
- Use `Color.withValues(alpha: 0.5)` instead of deprecated `withOpacity()`.
- For custom semantic colors, use `ThemeExtension`.

```dart
// Correct
color: Theme.of(context).colorScheme.primary
color: Theme.of(context).colorScheme.surface

// Wrong
color: Colors.blue
color: Color(0xFF1976D2)
```

### Typography
- **Always** use `Theme.of(context).textTheme.*` — never inline styles.
- Use `copyWith` for overrides on theme styles.
- Hierarchy: `displayLarge` > `headlineMedium` > `titleLarge` > `bodyMedium` > `labelSmall`.

```dart
// Correct
style: Theme.of(context).textTheme.bodyMedium
style: Theme.of(context).textTheme.titleLarge?.copyWith(
  fontWeight: FontWeight.bold,
)

// Wrong
style: TextStyle(fontSize: 14)
```

### Component Themes
- Customize via `appBarTheme`, `elevatedButtonTheme`, etc. in `ThemeData`.
- Use `WidgetStateProperty` for state-based styles.

## Responsive Design

### Breakpoints
| Tier         | Width (dp) | Examples                       |
|-------------|------------|--------------------------------|
| smallMobile | < 360      | iPhone SE (320)                |
| mobile      | 360–399    | Pixel 5 (393), iPhone 13 Mini  |
| largeMobile | 400–599    | iPhone 16 Pro Max (430)        |
| tablet      | 600–1200   | iPad, Android tablets          |
| desktop     | > 1200     | Web, macOS, Windows            |

### Proportional Sizing
- Use `MediaQuery.sizeOf(context).width` fractions for scaling.
- Use `FractionallySizedBox` for percentage-based widths.
- Fixed sizes only for invariant elements (icons, 48dp touch targets).

### Adaptive Padding
```dart
double getHorizontalPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 360) return 16.0;
  if (width < 400) return 20.0;
  return 24.0;
}
```

### Grid Rules
- Use `LayoutBuilder` for adaptive column counts.
- 2 columns for `< 400dp`, 3 columns for `>= 400dp` mobile.
- Horizontal lists: item width = `screenWidth * 0.65` (hint at scroll).

### Text Scaling
- Respect system text scale but clamp (0.8–1.3).
- Always use `maxLines` + `overflow: TextOverflow.ellipsis`.

## Widget Composition

- **Composition over inheritance** — build from small, reusable widgets.
- **Private widgets** over helper methods for sub-components.
- Break large `build()` methods into separate widget classes.
- **`const` constructors** wherever possible.
- **`ListView.builder`** for dynamic/long lists (never `ListView` with children for large datasets).
- **`compute()`** for expensive operations on isolates.
- No expensive operations in `build()`.

## Touch Targets
- Minimum **48 x 48 dp** for all interactive elements.
- Use `SizedBox`, `ConstrainedBox`, or padding to enforce.

## Images and Assets
- Declare in `pubspec.yaml` under `assets:`.
- Use `Image.asset` for local, `Image.network` with `errorBuilder` and `loadingBuilder`.
- Use `BoxFit.cover` for hero/banner images.
- Set container heights proportionally (`screenWidth * factor`).

## Accessibility
- High contrast, dynamic text scaling, semantic labels.
- Use `Semantics` widget for screen reader support.
- WCAG: 4.5:1 contrast for normal text, 3:1 for large.

## Testing Matrix
Every screen must be verified on:
1. Small phone: 320dp (iPhone SE)
2. Standard: 375–393dp (iPhone 14 / Pixel 5)
3. Large phone: 428–430dp (iPhone 16 Pro Max)
