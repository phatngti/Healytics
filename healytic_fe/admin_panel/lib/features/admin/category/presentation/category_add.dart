import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:admin_panel/features/admin/category/domain/category_form_field.dart';
import 'package:admin_panel/features/admin/category/domain/category_status.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/admin/category/presentation/autofill/category_add.autofill.dart';
import 'package:admin_panel/features/admin/category/presentation/layouts/category_add_desktop.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
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
      final categoryName =
          values[CategoryFormField.categoryName.key]?.toString().trim() ?? '';
      final description =
          values[CategoryFormField.description.key]?.toString().trim() ?? '';
      final status = CategoryStatus.fromApiValue(
        values[CategoryFormField.status.key]?.toString(),
      );
      final sortOrder =
          int.tryParse(
            values[CategoryFormField.sortOrder.key]?.toString() ?? '',
          ) ??
          0;
      final iconName = values[CategoryFormField.iconName.key]
          ?.toString()
          .trim();
      final colorValue = _parseColorHex(
        values[CategoryFormField.colorHex.key]?.toString(),
      );

      await ref
          .read(categoryProvider.notifier)
          .createCategory(
            CreateCategoryRequest(
              name: categoryName,
              description: description,
              iconName: iconName?.isEmpty ?? true ? 'category' : iconName!,
              colorValue: colorValue,
              isVisible: status != CategoryStatus.inactive,
              sortOrder: sortOrder,
            ),
          );

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
    CategoryFormField.categoryName.key: CategoryAddAutofill.name,
    CategoryFormField.description.key: CategoryAddAutofill.description,
    CategoryFormField.status.key: CategoryAddAutofill.status,
    CategoryFormField.sortOrder.key: CategoryAddAutofill.sortOrder,
    CategoryFormField.iconName.key: CategoryAddAutofill.iconName,
    CategoryFormField.colorHex.key: CategoryAddAutofill.colorHex,
  };

  static int _parseColorHex(String? value) {
    final normalized = value?.trim().replaceFirst('#', '');
    if (normalized == null || normalized.isEmpty) {
      return 0xFF6366F1;
    }

    final expanded = normalized.length == 3
        ? normalized.split('').map((char) => '$char$char').join()
        : normalized;
    final argb = expanded.length == 6 ? 'FF$expanded' : expanded;
    return int.tryParse(argb, radix: 16) ?? 0xFF6366F1;
  }
}
