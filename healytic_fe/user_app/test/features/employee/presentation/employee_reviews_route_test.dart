import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/router/routes.dart';

void main() {
  test('employee reviews route exposes expected location', () {
    const route = EmployeeReviewsRoute(
      employeeId: 'employee-1',
      employeeName: 'Dr. Jane Doe',
    );

    expect(
      route.location,
      '/employee_reviews?employee-id=employee-1&employee-name=Dr.+Jane+Doe',
    );
  });
}
