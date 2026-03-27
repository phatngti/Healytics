# Architecture Guardrails

This project follows a feature-first Clean Architecture layout:

- `presentation` depends on `domain`.
- `data` depends on `domain` and `core`.
- `domain` depends on nothing in Flutter.

## Feature Layout

Each feature must follow:

```text
lib/features/<feature_name>/
  data/
    datasources/
      local/
      remote/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    providers/
    screens/
    widgets/
```

## Naming Conventions

- `*_repository_impl.dart`
- `*_remote_datasource.dart`
- `*_local_datasource.dart`
- `*.provider.dart`
- `*.entity.dart`

## Dependency Rules

- No direct `presentation` import from one feature to another feature.
- Router must depend on auth/session abstraction, not low-level storage.
- `domain` must not import Flutter or Riverpod.

## Migration Compatibility

When renaming files/symbols, keep temporary compatibility exports to avoid
breaking all imports in one commit. Remove compatibility shims after all
features are migrated.
