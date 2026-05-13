import 'package:admin_panel/core/config/autofill_config.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image.entity.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image_key.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:admin_panel/features/partner/products/domain/product_status.dart';
import 'package:admin_panel/features/partner/products/domain/product_type.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';
import 'package:admin_panel/features/partner/products/domain/staff_allocation.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_add_desktop.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_service_manual_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/autofill/product_add.autofill.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductAddScreen extends HookConsumerWidget {
  const ProductAddScreen({super.key, this.autofill = false});

  /// When `true` in UAT, the
  /// form is pre-populated with sample data.
  /// Activate via `?autofill=true` in the URL.
  final bool autofill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final serviceManualKey = useMemoized(
      () => GlobalKey<ProductServiceManualCardState>(),
    );
    final isSubmitting = useState(false);
    final isFormValid = useState(false);

    // Build initial values in UAT only.
    // Triggered by URL param OR UAT store config flag.
    final shouldAutofill = AutofillConfig.isUatAutofillEnabled(
      routeAutofill: autofill,
    );
    final initialValue = useMemoized(
      () => shouldAutofill ? _buildAutofillValues() : const <String, dynamic>{},
    );

    Future<void> handleSubmit() async {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        final formData = formKey.currentState!.value;
        debugPrint('Form Data: $formData');

        isSubmitting.value = true;

        try {
          await _submitForm(
            ref: ref,
            formData: formData,
            serviceManualKey: serviceManualKey,
          );

          if (context.mounted) {
            final semantic = Theme.of(context).extension<SemanticColors>()!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Product created successfully!'),
                backgroundColor: semantic.success,
              ),
            );
            context.goNamed(ProductHomeRoute.name);
          }
        } catch (e) {
          if (context.mounted) {
            final semantic = Theme.of(context).extension<SemanticColors>()!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create product: $e'),
                backgroundColor: semantic.error,
              ),
            );
          }
        } finally {
          if (context.mounted) {
            isSubmitting.value = false;
          }
        }
      }
    }

    void handleCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return FormBuilder(
      key: formKey,
      initialValue: initialValue,
      onChanged: () {
        // Delay so fields finish updating before we check.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final state = formKey.currentState;
          if (state == null) return;
          isFormValid.value = state.fields.values.every((f) => f.isValid);
        });
      },
      child: ResponsiveWrapper(
        useLayout: true,
        desktop: ProductAddDesktop(
          isFormValid: isFormValid.value,
          onCancel: handleCancel,
          onSubmit: isSubmitting.value ? null : () => handleSubmit(),
          initialStatus: shouldAutofill
              ? ProductAddAutofill.status
              : ProductStatus.draft.apiValue,
          initialOnlineStore: shouldAutofill
              ? ProductAddAutofill.onlineStore
              : false,
          initialDescription: shouldAutofill
              ? ProductAddAutofill.description
              : null,
          serviceManualKey: serviceManualKey,
        ),
      ),
    );
  }

  /// Submits form data to create a product.
  static Future<void> _submitForm({
    required WidgetRef ref,
    required Map<String, dynamic> formData,
    required GlobalKey<ProductServiceManualCardState> serviceManualKey,
  }) async {
    // General Information
    final name = formData[ProductFormField.productName.key] as String? ?? '';
    final description =
        formData[ProductFormField.productDescription.key] as String? ?? '';
    final productType =
        formData[ProductFormField.productType.key] as String? ??
        ProductType.service.apiValue;

    // Pricing & Inventory
    final basePrice =
        double.tryParse(
          formData[ProductFormField.basePrice.key]?.toString() ?? '0',
        ) ??
        0.0;
    final salePrice = double.tryParse(
      formData[ProductFormField.salePrice.key]?.toString() ?? '',
    );

    // Visibility
    final status =
        formData[ProductFormField.visibilityStatus.key] as String? ??
        ProductStatus.draft.apiValue;
    final onlineStore =
        formData[ProductFormField.onlineStore.key] as bool? ?? true;

    // Organization
    final category = formData[ProductFormField.category.key] as String? ?? '';

    // Operations & Scheduling
    final duration = int.tryParse(
      formData[ProductFormField.duration.key]?.toString() ?? '',
    );
    final buffer = int.tryParse(
      formData[ProductFormField.buffer.key]?.toString() ?? '',
    );
    final capacity = int.tryParse(
      formData[ProductFormField.capacity.key]?.toString() ?? '',
    );
    final leadTime = int.tryParse(
      formData[ProductFormField.leadTime.key]?.toString() ?? '',
    );
    final staffAllocation =
        formData[ProductFormField.staffAllocation.key] as String? ??
        StaffAllocation.any.apiValue;
    final selectedStaffIds =
        (formData[ProductFormField.selectedStaffIds.key] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Media
    final productImages =
        (formData[ProductFormField.productImages.key] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Facility Images
    final facilityImages = _extractFacilityImages(
      formData[ProductFormField.facilityImages.key],
    );

    final request = CreateProductRequest(
      name: name,
      description: description,
      productType: productType,
      basePrice: basePrice,
      salePrice: salePrice,
      status: status,
      onlineStore: onlineStore,
      category: category,
      duration: duration,
      buffer: buffer,
      capacity: capacity,
      leadTime: leadTime,
      staffAllocation: staffAllocation,
      staffIds: selectedStaffIds,
      images: productImages,
      facilityImages: facilityImages,
      serviceManual: _extractServiceManual(serviceManualKey),
    );

    await ref.read(productProvider.notifier).addProduct(request);
  }

  /// Sample data map for all `FormBuilder` fields.
  /// Only used when autofill is active.
  static Map<String, dynamic> _buildAutofillValues() => {
    ProductFormField.productName.key: ProductAddAutofill.name,
    ProductFormField.productType.key: ProductAddAutofill.productType,
    ProductFormField.basePrice.key: ProductAddAutofill.basePrice,
    ProductFormField.salePrice.key: ProductAddAutofill.salePrice,
    ProductFormField.duration.key: ProductAddAutofill.duration,
    ProductFormField.buffer.key: ProductAddAutofill.buffer,
    ProductFormField.capacity.key: ProductAddAutofill.capacity,
    ProductFormField.leadTime.key: ProductAddAutofill.leadTime,
    ProductFormField.productImages.key: ProductAddAutofill.productImages,
    ProductFormField.facilityImages.key: ProductAddAutofill.facilityImages,
  };

  /// Extract facility images from form data.
  static List<FacilityImageEntity> _extractFacilityImages(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
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
}
