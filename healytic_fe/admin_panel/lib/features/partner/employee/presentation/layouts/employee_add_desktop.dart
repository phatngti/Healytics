import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_contact_info_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_documents_certifications_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_actions.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_professional_role_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_profile_image_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_skills_services_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_work_schedule_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeAddDesktop extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;

  const EmployeeAddDesktop({super.key, this.onCancel, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Profile Image & Contact Info
            const SizedBox(width: 340, child: _LeftColumn()),
            AppDimens.horizontalLarge,
            // Right Column - Role, Skills, Schedule
            Expanded(
              child: _RightColumn(onCancel: onCancel, onSubmit: onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeProfileImageCard(),
        AppDimens.verticalLarge,
        EmployeeContactInfoCard(),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;

  const _RightColumn({this.onCancel, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmployeeProfessionalRoleCard(),
        AppDimens.verticalMedium,
        const EmployeeSkillsServicesCard(),
        AppDimens.verticalMedium,
        const EmployeeDocumentsCertificationsCard(),
        AppDimens.verticalMedium,
        const EmployeeWorkScheduleCard(),
        AppDimens.verticalLarge,
        EmployeeFormActions(onCancel: onCancel, onSubmit: onSubmit),
      ],
    );
  }
}
