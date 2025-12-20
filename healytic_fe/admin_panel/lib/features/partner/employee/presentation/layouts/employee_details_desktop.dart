import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_contact_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_notes_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_operational_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_skills_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/header/employee_header_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsDesktop extends StatelessWidget {
  const EmployeeDetailsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            const EmployeeHeaderCard(),
            AppDimens.verticalLarge,
            // Content Grid
            LayoutBuilder(
              builder: (context, constraints) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    SizedBox(width: 340, child: _EmployeeLeftColumn()),
                    AppDimens.horizontalLarge,
                    // Right Column
                    Expanded(child: _EmployeeRightColumn()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeLeftColumn extends StatelessWidget {
  const _EmployeeLeftColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeContactCard(),
        AppDimens.verticalMedium,
        EmployeeNotesCard(),
      ],
    );
  }
}

class _EmployeeRightColumn extends StatelessWidget {
  const _EmployeeRightColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeSkillsCard(),
        AppDimens.verticalMedium,
        EmployeeOperationalCard(),
      ],
    );
  }
}
