import 'dart:convert';

import 'package:admin_panel/core/config/autofill_config.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image.entity.dart';
import 'package:admin_panel/features/partner/products/domain/facility_image_key.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:admin_panel/features/partner/products/domain/product_status.dart';
import 'package:admin_panel/features/partner/products/domain/product_type.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
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

  static final List<String> _requiredFields = [
    ProductFormField.productName.key,
    ProductFormField.productDescription.key,
    ProductFormField.basePrice.key,
    ProductFormField.productImages.key,
    ProductFormField.facilityImages.key,
    // Visibility
    ProductFormField.visibilityStatus.key,
    // Organization
    ProductFormField.category.key,
    // Operations & Scheduling
    ProductFormField.duration.key,
    ProductFormField.buffer.key,
    ProductFormField.capacity.key,
    ProductFormField.staffAllocation.key,
  ];

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

    void updateFormValidity() {
      final state = formKey.currentState;
      if (state == null) return;
      isFormValid.value = _requiredFields.every(
        (fieldKey) => _hasValue(state.fields[fieldKey]?.value),
      );
    }

    void scheduleFormValidityUpdate() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateFormValidity();
      });
    }

    useEffect(() {
      scheduleFormValidityUpdate();
      return null;
    }, [initialValue]);

    Future<void> handleSubmit() async {
      final isFormValid = formKey.currentState?.saveAndValidate() ?? false;
      final isManualValid = serviceManualKey.currentState?.validate() ?? true;

      if (!isFormValid || !isManualValid) return;

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

    void handleCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return FormBuilder(
      key: formKey,
      initialValue: initialValue,
      onChanged: () {
        scheduleFormValidityUpdate();
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
          initialGuidelines: shouldAutofill
              ? ProductAddAutofill.guidelines
              : const [],
          initialRules: shouldAutofill ? ProductAddAutofill.rules : const [],
          initialSteps: shouldAutofill ? ProductAddAutofill.steps : const [],
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

    final staffAllocation =
        formData[ProductFormField.staffAllocation.key] as String? ??
        StaffAllocation.any.apiValue;
    final selectedStaffIds =
        (formData[ProductFormField.selectedStaffIds.key] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Organization — Tags
    final selectedTagIds =
        (formData[ProductFormField.tags.key] as List<dynamic>?)
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
      tags: selectedTagIds,
      duration: duration,
      buffer: buffer,
      capacity: capacity,
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
    // Visibility
    ProductFormField.visibilityStatus.key: ProductAddAutofill.status,
    // Operations & Scheduling
    ProductFormField.duration.key: ProductAddAutofill.duration,
    ProductFormField.buffer.key: ProductAddAutofill.buffer,
    ProductFormField.capacity.key: ProductAddAutofill.capacity,
    ProductFormField.staffAllocation.key: StaffAllocation.any.apiValue,

    ProductFormField.facilityImages.key: ProductAddAutofill.facilityImages,
  };

  static bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String) return _hasMeaningfulText(value);
    if (value is Iterable) return value.isNotEmpty;
    return true;
  }

  static bool _hasMeaningfulText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        final plainText = decoded
            .whereType<Map>()
            .map((operation) => operation['insert'])
            .whereType<String>()
            .join()
            .trim();
        return plainText.isNotEmpty;
      }
    } catch (_) {
      // Plain text is valid for existing non-Delta descriptions.
    }

    return true;
  }

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
