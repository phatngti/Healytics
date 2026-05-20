import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/category_form_field.dart';
import 'package:admin_panel/features/admin/category/domain/category_status.dart';
import 'package:admin_panel/features/admin/category/presentation/autofill/category_edit.autofill.dart';
import 'package:admin_panel/features/admin/category/presentation/layouts/category_edit_desktop.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen for editing an existing category.
///
/// Fetches category data by [categoryId] on mount, maps it to
/// form-compatible values, and calls `updateCategory` on submit.
class CategoryEditScreen extends ConsumerStatefulWidget {
  const CategoryEditScreen({
    super.key,
    required this.categoryId,
    this.autofill = false,
  });

  /// The ID of the category to edit.
  final String categoryId;

  /// Pre-fill all fields in debug builds when `?autofill=true`.
  final bool autofill;

  @override
  ConsumerState<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends ConsumerState<CategoryEditScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic> _initialValues = const {};

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    if (widget.categoryId.isEmpty) {
      setState(() {
        _error = 'Invalid category ID';
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final entity = await ref
          .read(categoryProvider.notifier)
          .getCategoryById(CategoryId(widget.categoryId));

      if (!mounted) return;

      final shouldAutofill =
          kDebugMode &&
          (widget.autofill || (Store.tryGet(StoreKey.autoFill) ?? false));

      setState(() {
        _initialValues = shouldAutofill
            ? _buildAutofillValues()
            : _mapEntityToFormValues(entity);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
          .updateCategory(
            id: CategoryId(widget.categoryId),
            name: categoryName,
            description: description,
            iconName: iconName?.isEmpty ?? true ? 'category' : iconName!,
            colorValue: colorValue,
            isVisible: status != CategoryStatus.inactive,
            sortOrder: sortOrder,
          );

      if (mounted) {
        final semantic = Theme.of(context).extension<SemanticColors>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Category "$categoryName" updated successfully',
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
              'Error updating category: $e',
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
    if (_error != null) {
      return ResponsiveWrapper(
        useLayout: true,
        desktop: Center(
          child: Text(
            _error!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }

    return ResponsiveWrapper(
      useLayout: true,
      desktop: CategoryEditDesktop(
        onCancel: _handleCancel,
        onSubmit: _handleSubmit,
        initialValue: _initialValues,
        isLoadingData: _isLoading,
      ),
    );
  }

  static Map<String, dynamic> _buildAutofillValues() => {
    CategoryFormField.categoryName.key: CategoryEditAutofill.name,
    CategoryFormField.description.key: CategoryEditAutofill.description,
    CategoryFormField.status.key: CategoryEditAutofill.status,
    CategoryFormField.sortOrder.key: CategoryEditAutofill.sortOrder,
    CategoryFormField.iconName.key: CategoryEditAutofill.iconName,
    CategoryFormField.colorHex.key: CategoryEditAutofill.colorHex,
  };

  /// Maps a [CategoryEntity] to form-compatible initial values.
  static Map<String, dynamic> _mapEntityToFormValues(CategoryEntity entity) {
    return {
      CategoryFormField.categoryName.key: entity.name,
      CategoryFormField.description.key: entity.description,
      CategoryFormField.status.key: entity.isVisible
          ? CategoryStatus.active.displayName
          : CategoryStatus.inactive.displayName,
      CategoryFormField.sortOrder.key: entity.sortOrder.toString(),
      CategoryFormField.iconName.key: entity.iconName,
      CategoryFormField.colorHex.key: _colorValueToHex(entity.colorValue),
    };
  }

  /// Converts an integer color value to `#RRGGBB` hex string.
  static String _colorValueToHex(int colorValue) {
    final hex = (colorValue & 0xFFFFFF)
        .toRadixString(16)
        .padLeft(6, '0')
        .toUpperCase();
    return '#$hex';
  }

  /// Parses a hex color string to an integer value.
  ///
  /// Handles inputs with or without `#`, expands 3-char
  /// shorthand, and prepends `FF` alpha. Falls back to
  /// `0xFF6366F1` on parse failure.
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
