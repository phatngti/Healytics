---
inclusion: manual
---

# Workflow: Create Provider

Creates a new Riverpod provider using code generation, following project patterns for either data or presentation layer.

## Input Required
- `<provider_name>`: Provider name (PascalCase, e.g., `ProductList`)
- `<layer>`: Either `data` or `presentation`
- `<feature_name>`: The feature this provider belongs to
- `<provider_type>`: `function` (read-only) or `notifier` (mutable state)

## Steps

### For Data Layer Provider (Repository/DataSource wiring)

1. **Create file:** `lib/features/<feature_name>/data/provider/<name>.provider.dart`

2. **Write provider:**
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part '<name>.provider.g.dart';

   @riverpod
   <RepositoryType> <repositoryName>(ref) {
     final useMock = ref.read(useMockProvider);
     final dataSource = useMock
         ? <DataSourceMock>()
         : <DataSourceImpl>(ref.read(apiServiceProvider));
     return <RepositoryImpl>(dataSource);
   }
   ```

### For Presentation Layer Provider (UI State)

1. **Create file:** `lib/features/<feature_name>/presentation/providers/<name>.provider.dart`

2. **For read-only providers** (fetching/computed data):
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part '<name>.provider.g.dart';

   @riverpod
   Future<List<ItemEntity>> <providerName>(ref) async {
     final repo = ref.read(<repository>Provider);
     return repo.getItems();
   }
   ```

3. **For notifier providers** (mutable state):
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part '<name>.provider.g.dart';

   @riverpod
   class <NotifierName> extends _$<NotifierName> {
     @override
     <StateType> build() => <StateType>.initial();

     Future<void> loadData() async {
       state = <StateType>.loading();
       try {
         final repo = ref.read(<repository>Provider);
         final data = await repo.getData();
         state = <StateType>.loaded(data);
       } catch (e) {
         state = <StateType>.error(e.toString());
       }
     }

     // Additional methods for user actions...
   }
   ```

4. **For keepAlive providers** (persist across screens):
   ```dart
   @Riverpod(keepAlive: true)
   class <NotifierName> extends _$<NotifierName> { ... }
   ```

5. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Verify:** Run `dart analyze`. Ensure the `.g.dart` file is generated correctly.

## Rules
- Always use `@riverpod` annotations — never write providers manually.
- Data providers inject data sources into repositories.
- Presentation providers call repositories, never data sources directly.
- Use `ref.watch` in `build()`, `ref.read` in callbacks.
- Use Freezed sealed classes for complex state types.
