import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/admin/category/presentation/layouts/category_add_desktop.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryAddScreen extends ConsumerStatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  ConsumerState<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends ConsumerState<CategoryAddScreen> {
  Future<void> _handleSubmit(Map<String, dynamic> values) async {
    try {
      // TODO: Implement actual category creation via provider
      final categoryName = values['category_name']?.toString().trim() ?? '';

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        final semantic = Theme.of(context).extension<SemanticColors>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Category "$categoryName" created successfully',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: semantic.onSuccess),
            ),
            backgroundColor: semantic.success,
          ),
        );
        context.goNamed(CategoryHomeRoute.name);
      }
    } catch (e) {
      if (mounted) {
        final semantic = Theme.of(context).extension<SemanticColors>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error creating category: $e',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: semantic.onError),
            ),
            backgroundColor: semantic.error,
          ),
        );
      }
    }
  }

  void _handleCancel() {
    context.goNamed(CategoryHomeRoute.name);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: CategoryAddDesktop(
        onCancel: _handleCancel,
        onSubmit: _handleSubmit,
      ),
    );
  }
}
