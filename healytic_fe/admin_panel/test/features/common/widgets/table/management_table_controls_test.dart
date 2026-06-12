import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManagementTableMenuOption', () {
    testWidgets('fills bounded filter menu width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ManagementTableMenuOption(
                    label: 'All Categories',
                    selected: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(InkWell)).width, 280);
    });

    testWidgets('keeps option icons aligned for different label lengths', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ManagementTableMenuOption(
                    label: 'All Categories',
                    selected: true,
                    onTap: () {},
                  ),
                  ManagementTableMenuOption(
                    label: 'Dermatology',
                    selected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final selectedIconLeft = tester.getTopLeft(
        find.byIcon(Icons.check_circle),
      );
      final unselectedIconLeft = tester.getTopLeft(
        find.byIcon(Icons.circle_outlined),
      );

      expect(unselectedIconLeft.dx, selectedIconLeft.dx);
    });
  });
}
