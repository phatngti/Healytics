import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_contact_info_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_profile_image_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeFormProfileSection extends StatelessWidget {
  final String? avatarUrl;

  const EmployeeFormProfileSection({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeProfileImageCard(avatarUrl: avatarUrl),
        AppDimens.verticalLarge,
        EmployeeContactInfoCard(),
      ],
    );
  }
}
