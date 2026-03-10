---
description: Extract inline private widgets from screen files into dedicated widget files under a screen-context sub-folder
---

# Refactor Screen Widgets

Extract inline private widgets from a screen file into separate public widget files,
grouped by screen context in `presentation/widgets/<screen_name>/`.

## When to Apply

- A screen file exceeds **~150 lines** due to inline widget classes.
- A screen has **3+ private widget classes** alongside the main screen widget.
- You want clearer separation of concerns for maintainability and testability.

## Input Required

- `<feature_name>`: The feature (e.g., `orders`)
- `<screen_name>`: The screen being refactored (snake_case, e.g., `order_details`)

## Steps

// turbo-all

1. **Audit the screen file** — list all private widget classes (`_WidgetName`):
   ```bash
   grep -n 'class _' lib/features/<feature_name>/presentation/screens/<screen_name>.screen.dart
   ```

2. **Decide what to extract.** Extract a widget if it meets ANY of these:
   - Has its own `build()` longer than **15 lines**
   - Is **logically separable** (e.g., a card, a section, a filter bar)
   - Could be **reused** in other parts of the feature or tested independently

   Keep a widget **inline** if it is:
   - A tiny layout adapter (< 10 lines, e.g., a sliver wrapper)
   - Tightly coupled to the screen's scroll/layout structure (e.g., custom sliver delegates)

3. **Create the sub-folder:**
   ```bash
   mkdir -p lib/features/<feature_name>/presentation/widgets/<screen_name>
   ```

4. **For each widget to extract, create a new file:**
   - Path: `widgets/<screen_name>/<widget_name>.widget.dart`
   - Rename from `_WidgetName` (private) → `WidgetName` (public)
   - Add all necessary imports at the top of the new file
   - Include `///` doc comments
   - Use `const` constructor when possible
   - Keep closely-related private helpers (e.g., `_TimeColumn` inside `CheckInOutCard`) in the same file

5. **Update the screen file:**
   - Remove all extracted widget classes
   - Add imports for the new widget files
   - Keep only the main screen class and its thin composition shell (e.g., `_Body`)
   - Replace `_WidgetName(...)` → `WidgetName(...)`

6. **Handle shared vs. screen-specific widgets:**
   - Widgets used by **multiple screens** → keep in flat `widgets/` root
   - Widgets specific to **one screen** → sub-folder `widgets/<screen_name>/`

7. **Verify:**
   ```bash
   dart analyze lib/features/<feature_name>/presentation/
   ```

## Example: Before vs After

### Before
```
presentation/
├── screens/
│   └── orders.screen.dart        (332 lines, 8 widget classes)
└── widgets/
    └── appointment_card.widget.dart
```

### After
```
presentation/
├── screens/
│   └── orders.screen.dart        (~40 lines, 1 screen + 1 body shell)
├── widgets/
│   ├── appointment_card.widget.dart  (shared, unchanged)
│   └── orders/
│       ├── orders_tab_bar.widget.dart
│       ├── category_filters.widget.dart
│       └── appointment_list.widget.dart
```

## Naming Conventions

| Original Private Class | File Name | Public Class |
|------------------------|-----------|--------------|
| `_TabBar` | `orders_tab_bar.widget.dart` | `OrdersTabBar` |
| `_CategoryFilters` | `category_filters.widget.dart` | `CategoryFilters` |
| `_HeroImage` | `hero_image.widget.dart` | `HeroImage` |

- File name = `snake_case` of the widget purpose + `.widget.dart`
- Prefix with screen name if the class name would be too generic (e.g., `OrdersTabBar` not `TabBar`)

## Checklist

- [ ] All extracted widgets have `///` doc comments
- [ ] All colors use `Theme.of(context).colorScheme.*`
- [ ] All text styles use `Theme.of(context).textTheme.*`
- [ ] `const` constructors where possible
- [ ] No unused imports in screen or widget files
- [ ] `dart analyze` passes with zero errors
