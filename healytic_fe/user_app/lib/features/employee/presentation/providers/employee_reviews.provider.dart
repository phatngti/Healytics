import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/data/provider/employee.provider.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';

part 'employee_reviews.provider.g.dart';

/// Fetches public reviews for a single employee.
@riverpod
Future<List<ReviewEntity>> employeeReviews(Ref ref, String employeeId) async {
  final repo = ref.watch(employeeRepositoryProvider);
  return repo.getEmployeeReviews(employeeId);
}
