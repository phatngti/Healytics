import 'dart:async';

import 'package:admin_panel/features/partner/employee/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_assigned_service.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/employee_services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final employee = createMockDoctor(const EmployeeId('employee-services-test'));

  Future<void> pumpSection(
    WidgetTester tester,
    Future<List<EmployeeAssignedServiceEntity>> Function(Ref ref) load,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          employeeAssignedServicesProvider(employee.id).overrideWith(load),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EmployeeServicesSection(employee: employee),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading state', (tester) async {
    final pending = Completer<List<EmployeeAssignedServiceEntity>>();
    await pumpSection(tester, (_) => pending.future);

    expect(find.text('Loading assigned services'), findsOneWidget);
  });

  testWidgets('shows error state', (tester) async {
    await pumpSection(tester, (_) async => throw Exception('network failed'));
    await tester.pumpAndSettle();

    expect(find.text('Unable to load assigned services'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows empty state', (tester) async {
    await pumpSection(tester, (_) async => const []);
    await tester.pumpAndSettle();

    expect(find.text('No services assigned'), findsOneWidget);
  });

  testWidgets('shows assigned services', (tester) async {
    await pumpSection(
      tester,
      (_) async => const [
        EmployeeAssignedServiceEntity(
          id: 'service-1',
          name: 'Skin Consultation',
          status: 'ACTIVE',
          basePrice: 500000,
          salePrice: 450000,
          currency: 'VND',
          durationMinutes: 45,
          categoryName: 'Dermatology',
          isPrimary: true,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Skin Consultation'), findsOneWidget);
    expect(find.text('Dermatology - 45 min'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('PRIMARY'), findsOneWidget);
  });
}
