import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_contact_info_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_profile_image_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeFormProfileSection extends StatelessWidget {
  const EmployeeFormProfileSection({super.key});

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
