import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminLogo extends StatelessWidget {
  const AdminLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // justify-center
      crossAxisAlignment: CrossAxisAlignment.center, // items-center
      mainAxisSize: MainAxisSize.min, // Wraps content tightly
      children: [
        // 1. The Logo Box (h-10 w-10 rounded-lg bg-primary)
        Container(
          padding: AppDimens.paddingAllSmall,
          decoration: BoxDecoration(
            color: Theme.of(context).extension<SemanticColors>()?.info,
            borderRadius: AppDimens.radiusSmall,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.shield, size: 24, color: Colors.white),
        ),

        // 2. The Gap (gap-2)
        AppDimens.horizontalSmall,
        // 3. The Text (text-xl font-bold)
        Text(
          'Admin Panel',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
