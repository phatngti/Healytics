# Claude Skills for Healytics User App

This directory contains custom skills for working with the Healytics Flutter user app. These skills automate common development tasks and enforce project conventions.

## Available Skills

### 1. `/create-feature`
Scaffolds a complete new feature following Clean Architecture pattern.

**Usage:**
```
/create-feature booking
```

Creates:
- Feature directory structure (domain/data/presentation)
- Entity with Freezed
- Repository interface and implementation
- Data source (interface + impl + mock)
- Basic screen widget
- Riverpod providers

### 2. `/generate-code`
Runs build_runner to generate code for Riverpod, Freezed, JSON, and routes.

**Usage:**
```
/generate-code
```

Executes:
- `dart run build_runner build --delete-conflicting-outputs`
- Reports generated files and any issues

### 3. `/add-route`
Adds a new route to the app using go_router with type-safe routing.

**Usage:**
```
/add-route BookingScreen
```

- Determines appropriate route location (main nav, auth flow, standalone)
- Adds TypedGoRoute annotation
- Creates route class with slide transition
- Runs code generation
- Provides navigation examples

### 4. `/test-feature`
Runs tests for specific features or creates test scaffolding.

**Usage:**
```
/test-feature authenticate
/test-feature authenticate --coverage
```

- Runs feature-specific tests
- Creates test files following AAA pattern
- Provides widget and unit test templates
- Uses built-in mock data sources

### 5. `/check-quality`
Comprehensive code quality checks: linting, formatting, analysis.

**Usage:**
```
/check-quality
```

Runs:
- `dart analyze` for static analysis
- `dart format` for code formatting
- `dart fix` for auto-fixes
- Custom checks for project rules

Reports:
- Analysis issues with file:line references
- Formatting violations
- Project-specific rule violations (naming, imports, etc.)

### 6. `/add-data-source`
Creates a new data source with interface, implementation, and mock.

**Usage:**
```
/add-data-source booking BookingRemoteDataSource
```

Creates:
- Single file with all three components
- CRUD methods (fetchAll, fetchById, create, update, delete)
- Mock with simulated delays
- Repository integration
- Provider configuration

### 7. `/theme-check`
Scans and fixes theme-related issues.

**Usage:**
```
/theme-check
```

Finds:
- Hardcoded colors (should use `Theme.of(context).colorScheme.*`)
- Hardcoded text styles (should use `Theme.of(context).textTheme.*`)
- Deprecated `withOpacity()` (should use `withValues(alpha:)`)

Provides:
- File:line violations
- Auto-fix suggestions
- Theme color/text style mappings

### 8. `/design-mobile-page` ⭐ NEW
Create a mobile page following UI design system guidelines.

**Usage:**
```
/design-mobile-page BookingPage
```

Provides:
- Complete mobile page template with proper theming
- Theme compliance (colors, text styles, spacing)
- Responsive design patterns
- Shared component usage from `package:common`
- Performance best practices (ListView.builder, const constructors)
- Accessibility guidelines
- Page creation checklist

Enforces:
- All colors from `Theme.of(context).colorScheme.*`
- All text styles from `Theme.of(context).textTheme.*`
- All spacing from `Demensions.*` constants
- Proper widget composition
- SafeArea and scrolling
- Loading/error states

### 9. `/review-ui` ⭐ NEW
Review a page or widget for UI design system compliance.

**Usage:**
```
/review-ui lib/features/booking/presentation/screens/booking.screen.dart
```

Reviews:
- Theme compliance (colors, text styles)
- Spacing and dimensions (magic numbers)
- Shared component usage
- Widget composition (large build methods)
- Performance (ListView.builder, const constructors)
- Responsive design
- Accessibility (semantic labels, contrast)
- Error handling
- Naming conventions

Provides:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (nice to have)
- Positive observations
- Design system compliance score (0-100%)
- Auto-fix capability for common issues

### 10. `/create-component` ⭐ NEW
Create a reusable widget component following design system guidelines.

**Usage:**
```
/create-component ProductCard
```

Creates:
- Stateless/Stateful/Consumer widget templates
- Proper documentation with examples
- Theme integration
- Accessibility support
- Customization via properties
- Test file scaffolding

Checks:
- If component exists in `package:common` first
- Proper file naming (`*.widget.dart`)
- Theme usage (no hardcoded colors/styles)
- `Demensions` for spacing
- Documentation completeness

## Skills Philosophy

These skills enforce:

1. **Clean Architecture** - Proper layer separation and dependency flow
2. **Naming Conventions** - Consistent file and class naming
3. **Theme Usage** - No hardcoded colors or text styles (UI Design System)
4. **Code Generation** - Proper use of build_runner
5. **Testing** - AAA pattern with mock data sources
6. **Shared Code** - Use common package for widgets
7. **Responsive Design** - Mobile-first with breakpoints (< 600dp mobile, 600-1200dp tablet, > 1200dp desktop)
8. **Accessibility** - WCAG compliance, semantic labels, sufficient contrast
9. **Performance** - ListView.builder, const constructors, no expensive operations in build()
10. **Composition** - Small, reusable widgets over large build methods

## UI Design System Rules

All UI-related skills (#7-10) enforce these critical rules from `.agent/rules/ui-design-system.md`:

### Colors
- ❌ NEVER: `Colors.blue`, `Color(0xFF123456)`
- ✅ ALWAYS: `Theme.of(context).colorScheme.primary`

### Text Styles
- ❌ NEVER: `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)`
- ✅ ALWAYS: `Theme.of(context).textTheme.bodyMedium`

### Spacing
- ❌ NEVER: `EdgeInsets.all(16.0)`, `SizedBox(height: 8.0)`
- ✅ ALWAYS: `Demensions.paddingMedium`, `Demensions.spacingSmall`

### Shared Components
- ✅ ALWAYS check `package:common/widgets/` before creating new widgets
- Import from: `package:common/widgets/button/button.dart`, etc.

### Modern APIs
- ❌ DEPRECATED: `color.withOpacity(0.5)`
- ✅ NEW: `color.withValues(alpha: 0.5)` (Flutter 3.27+)

### Accessibility
- WCAG contrast ratio: 4.5:1 for normal text, 3:1 for large text
- Add semantic labels to interactive elements
- Support screen readers

## Quick Start Examples

### Create a new feature with UI
```bash
/create-feature booking
/design-mobile-page BookingListPage
/create-component BookingCard
/review-ui lib/features/booking/presentation/screens/booking_list.screen.dart
```

### Fix theme violations
```bash
/theme-check
# Reviews all files for hardcoded colors/styles

/review-ui lib/features/home/home_page.dart
# Detailed review of specific file
```

### Quality assurance workflow
```bash
/check-quality
# Run linting and formatting

/review-ui lib/features/profile/profile_page.dart
# Review UI compliance

/test-feature profile
# Run tests
```

## Creating New Skills

To add a new skill:

1. Create `<skill-name>.json` in this directory
2. Include: `name`, `description`, `version`, `instruction`
3. Follow existing patterns for consistency
4. Document in this README

## Notes

- Skills are project-specific and live in `.claude/skills/`
- Global skills would go in `~/.claude/skills/`
- Skills use JSON format with an `instruction` field for the prompt
- UI skills enforce the design system from `.agent/rules/ui-design-system.md`
- All skills reference the architecture rules from `.agent/rules/core-architecture.md`
