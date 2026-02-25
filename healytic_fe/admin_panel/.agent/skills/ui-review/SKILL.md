---
name: ui-review
description: Reviews Flutter pages and widgets for UI design system compliance. Use when reviewing UI code for theme usage, spacing, accessibility, responsive design, and performance. Provides structured reports with severity levels and auto-fix suggestions.
---

# UI Design System Review

## When to Use
- Reviewing a screen or widget for design system compliance.
- Auditing UI code after implementation.
- Before merging UI changes in PRs.
- When fixing theme violations across files.
- When checking accessibility compliance.

## Review Checklist

### 1. Theme Compliance (Critical)

**Hardcoded colors:**
```dart
// VIOLATION
Colors.blue, Colors.red, Color(0xFF123456), Color.fromRGBO(...)

// CORRECT
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.error
```

**Hardcoded text styles:**
```dart
// VIOLATION
TextStyle(fontSize: 16, fontWeight: FontWeight.bold)

// CORRECT
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
```

**Deprecated APIs:**
```dart
// VIOLATION
color.withOpacity(0.5)

// CORRECT
color.withValues(alpha: 0.5)
```

### 2. Spacing and Dimensions

**Magic numbers:**
```dart
// VIOLATION
EdgeInsets.all(16.0)
SizedBox(height: 8.0)
BorderRadius.circular(12.0)

// CORRECT
EdgeInsets.all(Demensions.paddingMedium)
SizedBox(height: Demensions.spacingSmall)
BorderRadius.circular(Demensions.borderRadiusMedium)
```

Verify `import 'package:common/utils/demensions.dart';` is present.

### 3. Shared Components

Check if custom implementations duplicate `package:common`:
- Custom buttons → should use `package:common/widgets/button/button.dart`
- Custom text fields → `package:common/widgets/input/simple_fields.dart`
- Custom toasts → `package:common/widgets/toast.dart`
- Custom loaders → `package:common/widgets/linear_indicator.dart`

### 4. Widget Composition

- `build()` method > 50 lines → break into sub-widgets.
- Repeated widget trees → extract to private widget classes.
- Helper methods returning widgets → convert to private widget classes.
- Missing `const` constructors where possible.

### 5. Performance

- `ListView(children: [...])` for dynamic data → use `ListView.builder`.
- `.map().toList()` on large lists → use `ListView.builder`.
- Expensive operations in `build()` → move to provider/notifier.
- Missing `const` on static widgets.

### 6. Responsive Design

- Fixed widths like `Container(width: 300)` → use responsive sizing.
- Missing `LayoutBuilder` or `MediaQuery` for adaptive layouts.
- Grid column counts should adapt to screen width.

### 7. Accessibility

- `IconButton` without `tooltip` or `Semantics` label.
- `GestureDetector` without semantic annotation.
- `Image.network` without `semanticLabel` (if meaningful).
- Color contrast below WCAG: 4.5:1 normal text, 3:1 large text.
- Touch targets below 48x48 dp.

### 8. Error Handling

- `Image.network` without `errorBuilder`.
- `AsyncValue` without `.when()` or error state handling.
- Missing loading indicators during data fetch.

### 9. Naming Conventions

- Screens: `*.screen.dart`
- Widgets: `*.widget.dart`
- PascalCase class names, descriptive (not `Widget1`).

## Report Format

```markdown
# UI Design System Review: <filename>

## Critical Issues (Must Fix)
- Line XX: `Colors.blue` → `Theme.of(context).colorScheme.primary`
- Line XX: `TextStyle(fontSize: 16)` → `Theme.of(context).textTheme.bodyMedium`

## Warnings (Should Fix)
- Line XX: Large build method (85 lines) → break into sub-widgets
- Line XX: `.map().toList()` → use ListView.builder
- Line XX: `.withOpacity(0.5)` → `.withValues(alpha: 0.5)`

## Suggestions (Nice to Have)
- Line XX: Add semantic label to IconButton
- Line XX: Add `const` to constructor
- Line XX: Fixed width 300 → use responsive sizing

## Positive Observations
- Proper use of ListView.builder at line XX
- Good widget composition with private classes

## Score: XX/100
- 90-100: Excellent — follows all guidelines
- 70-89: Good — minor issues
- 50-69: Needs improvement — several violations
- <50: Poor — major refactoring needed
```

## Auto-Fix Capability

Offer to automatically fix:
- Hardcoded colors → theme colors (with user confirmation on mapping)
- `.withOpacity()` → `.withValues(alpha:)`
- Common magic numbers → `Demensions` constants

## How to Run Review

1. Read the target file.
2. Check each line against the 9 categories above.
3. Generate the structured report.
4. Offer auto-fix for applicable violations.
5. Provide before/after code examples for complex fixes.
