import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_details_desktop.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/employee_details/employee_details.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: const EmployeeDetailsDesktop(),
    );
  }
}

// class EmployeeDetailsScreen extends HookConsumerWidget {
//   final String employeeId;

//   const EmployeeDetailsScreen({super.key, required this.employeeId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Card
//             const EmployeeHeaderCard(),
//             AppDimens.verticalLarge,
//             // Content Grid
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth >= 1024) {
//                   return const Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Left Column
//                       SizedBox(width: 340, child: _EmployeeLeftColumn()),
//                       AppDimens.horizontalLarge,
//                       // Right Column
//                       Expanded(child: _EmployeeRightColumn()),
//                     ],
//                   );
//                 } else {
//                   return const Column(
//                     children: [
//                       _EmployeeLeftColumn(),
//                       AppDimens.verticalLarge,
//                       _EmployeeRightColumn(),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _EmployeeLeftColumn extends StatelessWidget {
//   const _EmployeeLeftColumn();

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         EmployeeContactCard(),
//         AppDimens.verticalMedium,
//         EmployeeNotesCard(),
//       ],
//     );
//   }
// }

// class _EmployeeRightColumn extends StatelessWidget {
//   const _EmployeeRightColumn();

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         EmployeeSkillsCard(),
//         AppDimens.verticalMedium,
//         EmployeeOperationalCard(),
//       ],
//     );
//   }
// }
