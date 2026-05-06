# API Integration

Description: Connects a new API endpoint to the app following the data source pattern with OpenAPI client and proper error handling.

## Input Required
- `<feature_name>`: Feature this API serves
- `<endpoint>`: API endpoint path (e.g., `/api/v1/appointments`)
- `<method>`: HTTP method (GET, POST, PUT, DELETE)
- `<request_dto>`: Request DTO class (if any, from `employee_openapi`)
- `<response_dto>`: Response DTO class (from `employee_openapi`)
- `<entity_name>`: Domain entity to map to

## Steps

1. **Check OpenAPI client:** Verify the DTO exists in `./openapi`:
   ```dart
   import 'package:employee_openapi/model/<dto_name>.dart';
   ```
   If the DTO doesn't exist, the backend OpenAPI spec may need updating and the client regenerated.

2. **Create or update domain entity:** Ensure `lib/features/<feature_name>/domain/entities/<entity>.entity.dart` has the fields matching the API response. Use `@freezed`.

3. **Define repository interface method:** In `domain/repositories/<feature>.repository.dart`, add the abstract method:
   ```dart
   abstract class AppointmentRepository {
     Future<List<AppointmentEntity>> getAppointments();
     Future<AppointmentEntity> createAppointment(
       CreateAppointmentRequest request,
     );
   }
   ```

4. **Implement data source (real):** In the Implementation class within `*_remote_datasource.dart`:
   ```dart
   @override
   Future<List<AppointmentEntity>> getAppointments() async {
     try {
       final response = await _api.get('/api/v1/appointments');
       return (response.data as List)
           .map((json) => AppointmentEntity.fromJson(json))
           .toList();
     } catch (e, s) {
       developer.log(
         'Failed to fetch appointments',
         error: e,
         stackTrace: s,
       );
       rethrow;
     }
   }
   ```

5. **Implement data source (mock):** In the Mock class, add realistic test data:
   ```dart
   @override
   Future<List<AppointmentEntity>> getAppointments() async {
     await Future.delayed(const Duration(milliseconds: 500));
     return mockAppointmentsList;
   }
   ```

6. **Implement repository:** In `*_impl.repository.dart`, delegate to data source.

7. **Create/update provider:** Ensure the repository provider uses `Ref ref` and wires the data source correctly with mock switching.

8. **Update presentation:** Connect the new data to the UI via the presentation provider.

9. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

10. **Test:** Write unit tests for the repository using the mock data source. Verify the mock returns expected data and the real implementation handles errors.

11. **Verify:** Run `dart analyze` and `flutter test` to ensure everything compiles and passes.
