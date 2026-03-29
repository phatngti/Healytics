import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/admin/category/domain/category_form_field.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/admin/category/presentation/autofill/category_add.autofill.dart';
import 'package:admin_panel/features/admin/category/presentation/layouts/category_add_desktop.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryAddScreen extends ConsumerStatefulWidget {
  const CategoryAddScreen({super.key, this.autofill = false});

  /// Pre-fill all fields in debug builds when `?autofill=true` is in URL.
  final bool autofill;

  @override
  ConsumerState<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends ConsumerState<CategoryAddScreen> {
  Future<void> _handleSubmit(Map<String, dynamic> values) async {
    try {
      // TODO: Implement actual category creation via provider
      final categoryName = values[
        CategoryFormField.categoryName.key
      ]?.toString().trim() ?? '';

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
    final shouldAutofill =
        kDebugMode &&
        (widget.autofill || (Store.tryGet(StoreKey.autoFill) ?? false));
    final initialValue = shouldAutofill
        ? _buildAutofillValues()
        : const <String, dynamic>{};

    return ResponsiveWrapper(
      useLayout: true,
      desktop: CategoryAddDesktop(
        onCancel: _handleCancel,
        onSubmit: _handleSubmit,
        initialValue: initialValue,
      ),
    );
  }

  static Map<String, dynamic> _buildAutofillValues() => {
    CategoryFormField.categoryName.key:
        CategoryAddAutofill.name,
    CategoryFormField.description.key:
        CategoryAddAutofill.description,
    CategoryFormField.status.key:
        CategoryAddAutofill.status,
    CategoryFormField.sortOrder.key:
        CategoryAddAutofill.sortOrder,
    CategoryFormField.iconName.key:
        CategoryAddAutofill.iconName,
    CategoryFormField.colorHex.key:
        CategoryAddAutofill.colorHex,
  };
}
