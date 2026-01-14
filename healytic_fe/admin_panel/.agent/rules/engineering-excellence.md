---
trigger: always_on
---

This scope focuses on practices that ensure code quality, reliability, and maintainability in Flutter projects. Prioritize testing, linting, and automated workflows. Use GoRouter for navigation, proper API handling for data, and code generation for efficiency. These standards help prevent bugs and streamline collaboration.

## Code Quality and Best Practices
- **Interaction Guidelines:** Assume users know programming but may be new to Dart. Explain Dart features (null safety, futures, streams) in code. Clarify ambiguous requests (functionality, platform). Explain dependency benefits.
- **Code Structure:** Maintainable with separation of concerns. Use meaningful names; avoid abbreviations. Write concise, simple code. Functions: single purpose, <20 lines. Line length: <=80 chars. Naming: PascalCase classes, camelCase members, snake_case files.
- **Dart Best Practices:** Follow Effective Dart (https://dart.dev/effective-dart). Organize classes in libraries; group in folders. Doc comments for public APIs; clear comments for complex code (no trailing/over-commenting). Use async/await with error handling; Futures/Streams appropriately. Null-safe code; avoid `!`. Pattern matching, records, exhaustive switches, custom exceptions, arrow functions.
- **Flutter Best Practices:** Immutability in widgets; composition over inheritance. Private widgets over helpers. Break build methods. `ListView.builder` for performance. `compute()` for isolates. `const` constructors; no expensive ops in build.
- **Error Handling:** Anticipate errors; no silent failures. Use try-catch.
- **Logging:** Use `logging` package over print; or `dart:developer` for structured logs.
  ```dart
  import 'dart:developer' as developer;
  developer.log('Message', error: e, stackTrace: s);
  ```
- **API Design:** User-centric, intuitive; essential documentation with examples.
- **SOLID Principles:** Apply codebase-wide. Prefer functional/declarative patterns.

## Testing Strategies
- **Types:**
  - Unit: For domain/data/state with `package:test`.
  - Widget: For UI with `package:flutter_test`.
  - Integration: End-to-end with `package:integration_test` (add as dev_dependency: sdk: flutter).
- **Best Practices:**
  - AAA/Given-When-Then pattern.
  - High coverage; test layers independently.
  - Mocks: Prefer fakes/stubs; use `mockito`/`mocktail` if needed (avoid code-gen for mocks). Use `file`, `process`, `platform` for injectables.
  - Run: `flutter test`.
- **Data Layer Testing:** Use mock data sources.

## Linting and Formatting
- **Configuration:** `analysis_options.yaml` with `include: package:flutter_lints/flutter.yaml`. Add rules (e.g., `prefer_single_quotes: true`).
- **Tools:** `dart analyze` for linting; `dart format` for formatting; `dart fix` for auto-fixes.

## Routing
- **Standard:** Use `go_router` for declarative routing, deep links, and redirects (e.g., auth flows).
- **Setup:** Add dependency; configure in `MaterialApp.router`. Use redirects for auth.
  ```dart
  final GoRouter _router = GoRouter(routes: [GoRoute(path: '/', builder: (...) )]);
  MaterialApp.router(routerConfig: _router);
  ```
- **Fallback:** Built-in `Navigator` for dialogs.
  ```dart
  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
  ```
- **Alternatives:** `auto_route` if needed.

## Package Management
- **Tools:** Use `pub` if available; else `flutter pub add <package>`, `flutter pub add dev:<package>`, `dart pub remove <package>`. Overrides: `override:<package>:version`.
- **External Packages:** Search via `pub_dev_search` or pub.dev; choose stable ones and explain benefits.

## Code Generation Workflows
- **Tools:** `build_runner` as dev_dependency.
- **Usage:** For Freezed, Riverpod, JSON. Run `dart run build_runner build --delete-conflicting-outputs`.

## Documentation
- **Philosophy:** Explain 'why'; user-focused; no redundancy; consistent terms.
- **Style:** `///` for docs; single-sentence summary; separate paragraphs; brief, no jargon; Markdown sparingly; backticks for code.
- **What to Document:** Public APIs priority; private optional; library overviews; samples; params/returns/exceptions. Before annotations.
- **Tools:** Use `dartdoc` for generation.

Follow these to achieve robust engineering. Integrate into CI/CD for automated checks when onboarding.