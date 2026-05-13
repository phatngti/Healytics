import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_edit_desktop.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_service_manual_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product_details.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Screen for editing an existing product.
///
/// Uses [productDetailsProvider] to load the product,
/// then wraps a [FormBuilder] around [ProductEditDesktop]
/// and pre-populates fields from the [Product] entity.
class ProductEditScreen extends ConsumerWidget {
  final String productId;

  const ProductEditScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return productAsync.when(
      data: (product) => ResponsiveWrapper(
        useLayout: true,
        desktop: _ProductEditContent(product: product),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.goNamed(ProductHomeRoute.name),
          ),
        ),
        body: Center(
          child: ErrorCard(
            title: 'Error loading product',
            error: error,
            stackTrace: stack,
            onRetry: () => ref.invalidate(productDetailsProvider(productId)),
          ),
        ),
      ),
    );
  }
}

/// Content widget that wraps the form and handles
/// save/cancel logic.
class _ProductEditContent extends HookConsumerWidget {
  final Product product;

  const _ProductEditContent({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final serviceManualKey = useMemoized(
      () => GlobalKey<ProductServiceManualCardState>(),
    );
    final isSubmitting = useState(false);

    /// Build initial values from the loaded product.
    final initialValues = useMemoized(() => _buildInitialValues(product), [
      product,
    ]);

    Future<void> handleSave() async {
      final state = formKey.currentState;
      if (state == null || !state.saveAndValidate()) {
        return;
      }

      isSubmitting.value = true;
      try {
        final data = state.value;
        final request = _buildDeltaRequest(product, data, serviceManualKey);

        await ref.read(productProvider.notifier).updateProduct(request);

        // Invalidate cache so details refresh
        ref.invalidate(productDetailsProvider(product.id.value));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
          context.goNamed(ProductHomeRoute.name);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    void handleCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return FormBuilder(
      key: formKey,
      initialValue: initialValues,
      child: ProductEditDesktop(
        product: product,
        onSave: isSubmitting.value ? null : handleSave,
        onCancel: handleCancel,
        serviceManualKey: serviceManualKey,
        initialGuidelines: product.serviceManual?.preServiceGuidelines ?? [],
        initialRules:
            product.serviceManual?.serviceRules
                .map(
                  (r) => {
                    'iconSlug': r.iconSlug,
                    'title': r.title,
                    'description': r.description,
                  },
                )
                .toList() ??
            [],
        initialSteps:
            product.serviceManual?.procedureSteps
                .map((s) => {'title': s.title, 'description': s.description})
                .toList() ??
            [],
      ),
    );
  }

  /// Builds an [UpdateProductRequest] containing only
  /// fields that differ from the original [product].
  ///
  /// Unchanged fields remain null so the backend
  /// skips them during the partial update.
  static UpdateProductRequest _buildDeltaRequest(
    Product product,
    Map<String, dynamic> data,
    GlobalKey<ProductServiceManualCardState> manualKey,
  ) {
    final newName = data[ProductFormField.productName.key] as String?;
    final newDescription =
        data[ProductFormField.productDescription.key] as String?;
    final newProductType = data[ProductFormField.productType.key] as String?;
    final newCategory = data[ProductFormField.category.key] as String?;
    final newBasePrice = _parseDouble(data[ProductFormField.basePrice.key]);
    final newSalePrice = _parseDouble(data[ProductFormField.salePrice.key]);
    final newStatus = data[ProductFormField.visibilityStatus.key] as String?;
    final newOnlineStore = data[ProductFormField.onlineStore.key] as bool?;
    final newDuration = _parseInt(data[ProductFormField.duration.key]);
    final newBuffer = _parseInt(data[ProductFormField.buffer.key]);
    final newCapacity = _parseInt(data[ProductFormField.capacity.key]);
    final newLeadTime = _parseInt(data[ProductFormField.leadTime.key]);
    final newStaffAllocation =
        data[ProductFormField.staffAllocation.key] as String?;
    final newImages = (data[ProductFormField.productImages.key] as List?)
        ?.map((e) => e.toString())
        .toList();
    final newStaffIds = (data[ProductFormField.selectedStaffIds.key] as List?)
        ?.map((e) => e.toString())
        .toList();
    final newManual = _extractServiceManual(manualKey);
    final definitionChanged =
        newDuration != product.duration ||
        newBuffer != product.buffer ||
        newCapacity != product.capacity ||
        newLeadTime != product.leadTime ||
        newStaffAllocation != product.staffAllocation;

    const listEq = DeepCollectionEquality();

    return UpdateProductRequest(
      id: product.id,
      name: newName != product.name ? newName : null,
      productType: newProductType != product.productType
          ? newProductType
          : null,
      basePrice: newBasePrice != product.basePrice ? newBasePrice : null,
      salePrice: newSalePrice != product.salePrice ? newSalePrice : null,
      clearSalePrice: newSalePrice == null && product.salePrice != null,
      description: newDescription != product.description
          ? newDescription
          : null,
      status: newStatus != product.status ? newStatus : null,
      onlineStore: newOnlineStore != product.onlineStore
          ? newOnlineStore
          : null,
      category: newCategory != product.category.id ? newCategory : null,
      duration: definitionChanged
          ? (newDuration ?? product.duration ?? 60)
          : null,
      buffer: definitionChanged ? (newBuffer ?? 0) : null,
      capacity: definitionChanged ? (newCapacity ?? 1) : null,
      leadTime: definitionChanged ? (newLeadTime ?? 0) : null,
      staffAllocation: definitionChanged
          ? (newStaffAllocation ?? product.staffAllocation)
          : null,
      images: !listEq.equals(newImages, product.images) ? newImages : null,
      staffIds: !listEq.equals(newStaffIds, product.staffIds)
          ? newStaffIds
          : null,
      serviceManual: newManual != product.serviceManual ? newManual : null,
      clearServiceManual: newManual == null && product.serviceManual != null,
    );
  }

  /// Extracts [ServiceManualEntity] from the card.
  static ServiceManualEntity? _extractServiceManual(
    GlobalKey<ProductServiceManualCardState> key,
  ) {
    final data = key.currentState?.extractFormData();
    if (data == null) return null;

    final guidelines =
        (data[ServiceManualKey.guidelines] as List<String>?) ?? [];
    final rules =
        (data[ServiceManualKey.rules] as List<Map<String, String>>?)
            ?.map(
              (r) => ServiceRuleEntity(
                iconSlug: r[ServiceManualKey.iconSlug] ?? '',
                title: r[ServiceManualKey.title] ?? '',
                description: r[ServiceManualKey.description] ?? '',
              ),
            )
            .toList() ??
        [];
    final steps =
        (data[ServiceManualKey.steps] as List<Map<String, String>>?)
            ?.asMap()
            .entries
            .map(
              (e) => ProcedureStepEntity(
                stepNumber: e.key + 1,
                title: e.value[ServiceManualKey.title] ?? '',
                description: e.value[ServiceManualKey.description] ?? '',
              ),
            )
            .toList() ??
        [];

    return ServiceManualEntity(
      preServiceGuidelines: guidelines,
      serviceRules: rules,
      procedureSteps: steps,
    );
  }

  /// Maps [Product] entity fields to FormBuilder
  /// field keys used by the card widgets.
  static Map<String, dynamic> _buildInitialValues(Product product) {
    return {
      ProductFormField.productName.key: product.name,
      ProductFormField.productDescription.key: product.description,
      ProductFormField.productType.key: product.productType,
      ProductFormField.basePrice.key: product.basePrice.toString(),
      ProductFormField.salePrice.key: product.salePrice?.toString(),
      ProductFormField.visibilityStatus.key: product.status,
      ProductFormField.onlineStore.key: product.onlineStore,
      ProductFormField.category.key: product.category.id,
      ProductFormField.duration.key: product.duration?.toString(),
      ProductFormField.buffer.key: product.buffer?.toString(),
      ProductFormField.capacity.key: product.capacity?.toString(),
      ProductFormField.leadTime.key: product.leadTime?.toString(),
      ProductFormField.staffAllocation.key: product.staffAllocation,
      ProductFormField.selectedStaffIds.key: product.staffIds,
      ProductFormField.productImages.key: product.images,
    };
  }

  static double? _parseDouble(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  static int? _parseInt(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return null;
    return int.tryParse(raw);
  }
}
