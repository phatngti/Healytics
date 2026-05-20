---
inclusion: manual
---

# Workflow: Theme Check

Scans the codebase for theme-related violations and provides auto-fix suggestions for hardcoded colors, text styles, and deprecated APIs.

## Steps

1. **Scan for hardcoded colors:**
   Search all `.dart` files in `lib/` for:
   - `Colors.` (excluding theme files, comments, and `Theme.of(context)` lines)
   - `Color(0x` — hex color literals
   - `Color.fromRGBO(` — RGBO color literals

   Each match is a violation. Map to correct theme usage:
   | Common Hardcoded | Replace With |
   |-----------------|-------------|
   | `Colors.blue`, `Colors.deepPurple` | `colorScheme.primary` |
   | `Colors.grey` | `colorScheme.outline` or `colorScheme.onSurface` |
   | `Colors.white` | `colorScheme.surface` or `colorScheme.onPrimary` |
   | `Colors.black` | `colorScheme.onSurface` |
   | `Colors.red` | `colorScheme.error` |
   | `Colors.green` | Use `ThemeExtension` for semantic `success` |

2. **Scan for hardcoded text styles:**
   Search for `TextStyle(` not preceded by `Theme.of(context)` or `copyWith`:
   | Common Hardcoded | Replace With |
   |-----------------|-------------|
   | `TextStyle(fontSize: 24, fontWeight: FontWeight.bold)` | `textTheme.headlineMedium` |
   | `TextStyle(fontSize: 16)` | `textTheme.bodyLarge` |
   | `TextStyle(fontSize: 14)` | `textTheme.bodyMedium` |
   | `TextStyle(fontSize: 12)` | `textTheme.bodySmall` |
   | `TextStyle(fontSize: 10)` | `textTheme.labelSmall` |

3. **Scan for deprecated APIs:**
   Search for `.withOpacity(` — replace with `.withValues(alpha:)`.

4. **Scan for magic numbers in spacing:**
   Search for:
   - `EdgeInsets.all(` / `EdgeInsets.symmetric(` / `EdgeInsets.only(` with literal numbers
   - `SizedBox(height:` / `SizedBox(width:` with literal numbers
   - `BorderRadius.circular(` with literal numbers

   Flag any not using `Demensions.*` constants.

5. **Report violations:**
   ```
   Theme Violations Found:

   Hardcoded Colors (X violations):
   - lib/features/home/widgets/card.dart:45 — Colors.blue
   - lib/features/profile/screen.dart:78 — Color(0xFF123456)

   Hardcoded Text Styles (Y violations):
   - lib/features/auth/signin.dart:120 — TextStyle(fontSize: 16)

   Deprecated APIs (Z violations):
   - lib/features/home/banner.dart:34 — .withOpacity(0.5)

   Magic Numbers (W violations):
   - lib/features/home/screen.dart:56 — EdgeInsets.all(16.0)

   Total: X + Y + Z + W violations across N files.
   ```

6. **Auto-fix (with user confirmation):**
   - Replace `.withOpacity(N)` → `.withValues(alpha: N)`
   - Replace common `Colors.*` → `Theme.of(context).colorScheme.*`
   - Add `// TODO: Replace with theme` comments for ambiguous cases

7. **Exceptions (do NOT flag):**
   - Theme definition files (`lib/theme/`)
   - Color constants in design token files
   - Comments and documentation
   - Test files
   - Generated files (`*.g.dart`, `*.freezed.dart`)
