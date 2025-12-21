import 'package:admin_panel/features/common/widgets/button/back_button.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_contact_info_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_documents_certifications_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_professional_role_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_profile_image_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_skills_services_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_work_schedule_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeAddDesktop extends StatefulWidget {
  final VoidCallback? onCancel;
  final ValueChanged<Map<String, dynamic>>? onSubmit;

  const EmployeeAddDesktop({super.key, this.onCancel, this.onSubmit});

  @override
  State<EmployeeAddDesktop> createState() => _EmployeeAddDesktopState();
}

class _EmployeeAddDesktopState extends State<EmployeeAddDesktop> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onSubmit?.call(_formKey.currentState!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilder(
      key: _formKey,
      child: Stack(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Profile Image & Contact Info
                    const SizedBox(width: 340, child: _LeftColumn()),
                    AppDimens.horizontalLarge,
                    // Right Column - Role, Skills, Schedule
                    const Expanded(child: _RightColumn()),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppBackButton(onTap: widget.onCancel ?? () {}),
                      AppDimens.horizontalMedium,
                      Text(
                        'Create Employee',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AppButton(
                        buttonType: ButtonType.outline,
                        onPressed: widget.onCancel,
                        child: const Text('Cancel'),
                      ),
                      AppDimens.horizontalSmall,
                      AppButton(
                        buttonType: ButtonType.elevated,
                        onPressed: _handleSubmit,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_add_outlined,
                              size: 18,
                              color: colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            const Text('Create Employee'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeProfessionalRoleCard(),
        AppDimens.verticalMedium,
        EmployeeSkillsServicesCard(),
        AppDimens.verticalMedium,
        EmployeeDocumentsCertificationsCard(),
        AppDimens.verticalMedium,
        EmployeeWorkScheduleCard(),
      ],
    );
  }
}
