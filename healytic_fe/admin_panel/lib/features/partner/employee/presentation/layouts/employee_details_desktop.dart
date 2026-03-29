import 'package:common/widgets/button/back_button.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_contact_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_notes_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_education_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_operational_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_skills_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_verification_documents_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_work_history_details_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/header/employee_header_card.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailsDesktop extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onEdit;

  const EmployeeDetailsDesktop({
    super.key,
    required this.employee,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 100, // Height for the floating header
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmployeeHeaderCard(
                employee: employee,
                onEdit: onEdit,
              ),
              AppDimens.verticalLarge,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (1/3)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        EmployeeContactCard(
                          email: employee.email,
                          phone: employee.phone,
                          emergencyContactName:
                              employee.emergencyContactName,
                          emergencyContactPhone:
                              employee.emergencyContactPhone,
                        ),
                        AppDimens.verticalMedium,
                        EmployeeNotesCard(
                          description: employee.description,
                        ),
                        AppDimens.verticalMedium,
                        EmployeeVerificationDocumentsCard(
                          documents: employee
                              .verificationDocuments,
                        ),
                      ],
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  // Right Columns (2/3)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        EmployeeSkillsCard(
                          employee: employee,
                        ),
                        AppDimens.verticalMedium,
                        EmployeeWorkHistoryDetailsCard(
                          workHistory:
                              employee.workHistory,
                        ),
                        AppDimens.verticalMedium,
                        if (employee case DoctorEntity doctor)
                          ...[
                            EmployeeEducationCard(
                              doctor: doctor,
                            ),
                            AppDimens.verticalMedium,
                          ],
                        EmployeeOperationalCard(
                          employee: employee,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Floating header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(8),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppBackButton(
                      onTap: () {
                        context.goNamed(
                          EmployeeHomeRoute.name,
                        );
                      },
                    ),
                    AppDimens.horizontalMedium,
                    Text(
                      '${employee.role} Profile',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
