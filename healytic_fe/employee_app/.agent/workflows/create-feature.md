# Create Feature

Description: Scaffolds a complete new feature module following Clean Architecture with all layers, data sources, and providers.

## Input Required
- `<feature_name>`: The name of the feature (snake_case, e.g., `appointments`)
- `<entity_name>`: The primary entity name (PascalCase, e.g., `Appointment`)
- `<entity_fields>`: Key fields for the entity

## Steps

1. **Create folder structure:** Create the full feature directory tree under `lib/features/<feature_name>/`:
   ```
   lib/features/<feature_name>/
   ├── data/
   │   ├── datasources/remote/
   │   │   └── <feature_name>_remote_datasource.dart
   │   ├── repositories/
   │   │   └── <feature_name>_impl.repository.dart
   │   └── provider/
   │       └── <feature_name>.provider.dart
   ├── domain/
   │   ├── entities/
   │   │   └── <feature_name>.entity.dart
   │   └── repositories/
   │       └── <feature_name>.repository.dart
   └── presentation/
       ├── providers/
       │   └── <feature_name>.provider.dart
       ├── screens/
       │   └── <feature_name>.screen.dart
       └── widgets/
   ```

2. **Create domain entity:** Define a `@freezed` entity class in `domain/entities/<feature_name>.entity.dart` with the specified fields. Keep it pure Dart — no Flutter imports.

3. **Create repository interface:** Define an abstract repository in `domain/repositories/<feature_name>.repository.dart` with methods matching the feature's use cases.

4. **Create remote data source:** In `data/datasources/remote/<feature_name>_remote_datasource.dart`, create all three parts in ONE file:

   ```dart
   import 'package:user_app/features/<feature_name>/domain/entities/<feature_name>.entity.dart';

   // ============================================================
   // INTERFACE
   // ============================================================
   abstract class <FeatureName>RemoteDataSource {
     Future<List<<FeatureName>Entity>> fetchAll();
     Future<<FeatureName>Entity> fetchById(String id);
     Future<<FeatureName>Entity> create(<FeatureName>Entity entity);
     Future<<FeatureName>Entity> update(String id, <FeatureName>Entity entity);
     Future<void> delete(String id);
   }

   // ============================================================
   // IMPLEMENTATION
   // ============================================================
   class <FeatureName>RemoteDataSourceImpl
       implements <FeatureName>RemoteDataSource {
     final ApiService _api;
     <FeatureName>RemoteDataSourceImpl(this._api);

     @override
     Future<List<<FeatureName>Entity>> fetchAll() async {
       try {
         final response = await _api.get('/endpoint');
         return (response.data as List)
             .map((json) => <FeatureName>Entity.fromJson(json))
             .toList();
       } catch (e) {
         rethrow;
       }
     }
     // ... other CRUD methods with try-catch
   }

   // ============================================================
   // MOCK
   // ============================================================
   class <FeatureName>RemoteDataSourceMock
       implements <FeatureName>RemoteDataSource {
     @override
     Future<List<<FeatureName>Entity>> fetchAll() async {
       await Future.delayed(const Duration(seconds: 1));
       return mock<FeatureName>List; // from mock_data file
     }
     // ... other methods with Future.delayed
   }
   ```

5. **Create mock data file:** If the mock data is complex, create `data/datasources/remote/<feature_name>_mock_data.dart` with const/final sample data:
   ```dart
   final mock<FeatureName>List = [
     const <FeatureName>Entity(id: '1', ...),
     const <FeatureName>Entity(id: '2', ...),
   ];
   ```

6. **Create repository implementation:** In `data/repositories/<feature_name>_impl.repository.dart`, implement the domain repository interface using the data source.

7. **Create data provider:** In `data/provider/<feature_name>.provider.dart`, create a `@riverpod` provider (using `Ref ref`) that instantiates the repository with mock/real switching.

8. **Create presentation provider:** In `presentation/providers/<feature_name>.provider.dart`, create a `@riverpod` notifier that manages the feature's UI state, calling the repository.

9. **Create screen:** In `presentation/screens/<feature_name>.screen.dart`, create a `ConsumerWidget` or `HookConsumerWidget` that watches the presentation provider and renders the UI.

10. **Add route:** Add a `TypedGoRoute` in `lib/router/routes.dart` for the new screen. Create the `GoRouteData` class with appropriate parameters.

11. **Run code generation:**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

12. **Verify:** Run `dart analyze` to check for errors. Fix any issues.
