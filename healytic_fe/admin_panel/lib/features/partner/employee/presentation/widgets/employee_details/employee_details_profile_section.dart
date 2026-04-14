import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_contact_info_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_profile_image_card.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsProfileSection extends StatelessWidget {
  final String? avatarUrl;
  final String? fullName;

  const EmployeeDetailsProfileSection({
    super.key,
    this.avatarUrl,
    this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeProfileImageCard(avatarUrl: avatarUrl, fullName: fullName),
        AppDimens.verticalLarge,
        const EmployeeContactInfoCard(),
      ],
    );
  }
}
