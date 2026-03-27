# Create Provider

Description: Creates a new Riverpod 3.0 provider using code generation, following project patterns for either data or presentation layer.

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
   <RepositoryType> <repositoryName>(Ref ref) {
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
   Future<List<ItemEntity>> <providerName>(Ref ref) async {
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
         // Always check mounted after await
         if (!ref.mounted) return;
         state = <StateType>.loaded(data);
       } catch (e) {
         if (!ref.mounted) return;
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
- Always use unified `Ref ref` — never typed refs like `<Name>Ref`.
- Always check `ref.mounted` after `await` in notifier methods.
- Data providers inject data sources into repositories.
- Presentation providers call repositories, never data sources directly.
- Use `ref.watch` in `build()`, `ref.read` in callbacks.
- Use Freezed sealed classes for complex state types.
