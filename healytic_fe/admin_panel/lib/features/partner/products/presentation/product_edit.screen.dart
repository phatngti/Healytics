import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image.entity.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image_key.dart';
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
      final isFormValid = state?.saveAndValidate() ?? false;
      final isManualValid = serviceManualKey.currentState?.validate() ?? true;

      if (!isFormValid || !isManualValid) return;

      isSubmitting.value = true;
      try {
        final data = state!.value;
        // Use the stable memoized map directly.
        // FormBuilderField.initialValue / isDirty are
        // unreliable because child cards rebuild their
        // FormBuilderFields with mutated local state,
        // resetting initialValue to the current value.
        final request = _buildDeltaRequest(
          product,
          data,
          initialValues,
          serviceManualKey,
        );

        if (!_hasDelta(request)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No product changes to save.')),
            );
          }
          return;
        }

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
  ///
  /// Uses pure value comparison against [initialData]
  /// (the stable memoized map built from the [Product]
  /// entity). We intentionally avoid FormBuilder's
  /// `isDirty` because stateful child widgets reset
  /// `initialValue` on rebuild, making it unreliable.
  static UpdateProductRequest _buildDeltaRequest(
    Product product,
    Map<String, dynamic> data,
    Map<String, dynamic> initialData,
    GlobalKey<ProductServiceManualCardState> manualKey,
  ) {
    final newName = data[ProductFormField.productName.key] as String?;
    final newDescription =
        data[ProductFormField.productDescription.key] as String?;
    final newProductType =
        data[ProductFormField.productType.key] as String?;
    final newCategory =
        data[ProductFormField.category.key] as String?;
    final newBasePrice =
        _parseDouble(data[ProductFormField.basePrice.key]);
    final newSalePrice =
        _parseDouble(data[ProductFormField.salePrice.key]);
    final newStatus =
        data[ProductFormField.visibilityStatus.key] as String?;
    final newOnlineStore =
        data[ProductFormField.onlineStore.key] as bool?;
    final newDuration =
        _parseInt(data[ProductFormField.duration.key]);
    final newBuffer =
        _parseInt(data[ProductFormField.buffer.key]);
    final newCapacity =
        _parseInt(data[ProductFormField.capacity.key]);
    final newStaffAllocation =
        data[ProductFormField.staffAllocation.key] as String?;
    final newImages =
        (data[ProductFormField.productImages.key] as List?)
            ?.map((e) => e.toString())
            .toList();
    final newFacilityImages = _extractFacilityImages(
      data[ProductFormField.facilityImages.key],
    );
    final newStaffIds =
        (data[ProductFormField.selectedStaffIds.key] as List?)
            ?.map((e) => e.toString())
            .toList();
    final newTagIds = (data[ProductFormField.tags.key] as List?)
        ?.map((e) => e.toString())
        .toList();
    final manualChanged =
        manualKey.currentState?.hasChanges ?? false;
    final newManual =
        manualChanged ? _extractServiceManual(manualKey) : null;

    final initialBasePrice = _parseDouble(
      initialData[ProductFormField.basePrice.key],
    );
    final initialSalePrice = _parseDouble(
      initialData[ProductFormField.salePrice.key],
    );
    final initialDuration = _parseInt(
      initialData[ProductFormField.duration.key],
    );
    final initialBuffer = _parseInt(
      initialData[ProductFormField.buffer.key],
    );
    final initialCapacity = _parseInt(
      initialData[ProductFormField.capacity.key],
    );

    const orderedListEq = DeepCollectionEquality();
    const unorderedListEq = DeepCollectionEquality.unordered();

    final initialImages = _stringList(
      initialData[ProductFormField.productImages.key],
    );
    final initialStaffIds = _stringList(
      initialData[ProductFormField.selectedStaffIds.key],
    );
    final initialTagIds = _stringList(
      initialData[ProductFormField.tags.key],
    );
    final initialFacilityImages = _extractFacilityImages(
      initialData[ProductFormField.facilityImages.key],
    );

    final nameChanged = _valueChanged(
      newName,
      initialData[ProductFormField.productName.key] as String?,
    );
    final typeChanged = _valueChanged(
      newProductType,
      initialData[ProductFormField.productType.key] as String?,
    );
    final basePriceChanged = _valueChanged(
      newBasePrice,
      initialBasePrice,
    );
    final salePriceChanged = _valueChanged(
      newSalePrice,
      initialSalePrice,
    );
    final descriptionChanged = _valueChanged(
      newDescription,
      initialData[ProductFormField.productDescription.key]
          as String?,
    );
    final statusChanged = _valueChanged(
      newStatus,
      initialData[ProductFormField.visibilityStatus.key]
          as String?,
    );
    final onlineStoreChanged = _valueChanged(
      newOnlineStore,
      initialData[ProductFormField.onlineStore.key] as bool?,
    );
    final categoryChanged = _valueChanged(
      newCategory,
      initialData[ProductFormField.category.key] as String?,
    );
    final durationChanged = _valueChanged(
      newDuration,
      initialDuration,
    );
    final bufferChanged = _valueChanged(
      newBuffer,
      initialBuffer,
    );
    final capacityChanged = _valueChanged(
      newCapacity,
      initialCapacity,
    );
    final staffAllocChanged = _valueChanged(
      newStaffAllocation,
      initialData[ProductFormField.staffAllocation.key]
          as String?,
    );
    final imagesChanged = !orderedListEq.equals(
      newImages ?? const <String>[],
      initialImages ?? const <String>[],
    );
    final facilityChanged = _facilityImagesChanged(
      newFacilityImages,
      initialFacilityImages,
    );
    final staffIdsChanged = !unorderedListEq.equals(
      newStaffIds ?? const <String>[],
      initialStaffIds ?? const <String>[],
    );
    final tagIdsChanged = !unorderedListEq.equals(
      newTagIds ?? const <String>[],
      initialTagIds ?? const <String>[],
    );

    return UpdateProductRequest(
      id: product.id,
      name: nameChanged ? newName : null,
      productType: typeChanged ? newProductType : null,
      basePrice: basePriceChanged ? newBasePrice : null,
      salePrice: salePriceChanged ? newSalePrice : null,
      clearSalePrice:
          salePriceChanged && newSalePrice == null,
      description:
          descriptionChanged ? newDescription : null,
      status: statusChanged ? newStatus : null,
      onlineStore:
          onlineStoreChanged ? newOnlineStore : null,
      category: categoryChanged ? newCategory : null,
      duration: durationChanged ? newDuration : null,
      buffer: bufferChanged ? newBuffer : null,
      capacity: capacityChanged ? newCapacity : null,
      staffAllocation:
          staffAllocChanged ? newStaffAllocation : null,
      images: imagesChanged ? newImages : null,
      facilityImages:
          facilityChanged ? newFacilityImages : null,
      staffIds: staffIdsChanged ? newStaffIds : null,
      tagIds: tagIdsChanged ? newTagIds : null,
      serviceManual:
          manualChanged && newManual != product.serviceManual
              ? newManual
              : null,
      clearServiceManual: manualChanged &&
          newManual == null &&
          product.serviceManual != null,
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

      ProductFormField.staffAllocation.key: product.staffAllocation,
      ProductFormField.selectedStaffIds.key: product.staffIds,
      ProductFormField.productImages.key: product.images,
      ProductFormField.facilityImages.key: product.facilityImages
          .map(
            (image) => {
              FacilityImageKey.imageUrl: image.imageUrl,
              FacilityImageKey.label: image.label,
            },
          )
          .toList(),
      ProductFormField.tags.key: product.tags,
    };
  }

  static List<FacilityImageEntity> _extractFacilityImages(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .where(
          (m) => (m[FacilityImageKey.imageUrl] as String?)?.isNotEmpty == true,
        )
        .map(
          (m) => FacilityImageEntity(
            imageUrl: m[FacilityImageKey.imageUrl] as String? ?? '',
            label: m[FacilityImageKey.label] as String? ?? '',
          ),
        )
        .toList();
  }

  /// Compares two values for inequality.
  static bool _valueChanged<T>(T? current, T? initial) {
    return current != initial;
  }


  static List<String>? _stringList(dynamic raw) {
    if (raw is! List) return null;
    return raw.map((e) => e.toString()).toList();
  }


  static bool _facilityImagesChanged(
    List<FacilityImageEntity> currentValue,
    List<FacilityImageEntity> initialValue,
  ) {
    if (currentValue.length != initialValue.length) return true;
    for (var i = 0; i < currentValue.length; i++) {
      if (currentValue[i].imageUrl != initialValue[i].imageUrl ||
          currentValue[i].label != initialValue[i].label) {
        return true;
      }
    }
    return false;
  }

  static bool _hasDelta(UpdateProductRequest request) {
    return request.name != null ||
        request.productType != null ||
        request.basePrice != null ||
        request.salePrice != null ||
        request.clearSalePrice ||
        request.description != null ||
        request.status != null ||
        request.onlineStore != null ||
        request.duration != null ||
        request.buffer != null ||
        request.capacity != null ||
        request.staffAllocation != null ||
        request.images != null ||
        request.facilityImages != null ||
        request.category != null ||
        request.staffIds != null ||
        request.tagIds != null ||
        request.serviceManual != null ||
        request.clearServiceManual;
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
