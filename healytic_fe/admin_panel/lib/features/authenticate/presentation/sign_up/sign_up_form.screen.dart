import 'dart:convert';

import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/config/autofill_config.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/autofill/sign_up_form.autofill.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/account_information_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_location_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_partner_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/document_verification_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/form_section_card.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/legal_representative_section_v2.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_submit_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_title_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_header.widget.dart';
import 'package:common/widgets/toast.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Partner Registration Form Screen.
///
/// A comprehensive multi-section form for business
/// partner registration.
/// Sections include:
/// - Account Information (Section 1)
/// - Business & Partner Information (Section 2)
/// - Legal Representative (Section 3)
/// - Document Verification (Section 4)
class SignUpFormScreen extends HookConsumerWidget {
  const SignUpFormScreen({super.key, this.autofill = false});

  /// When `true` in UAT, pre-fills all
  /// registration fields. Activate via
  /// `?autofill=true` or the `autoFill` store flag.
  final bool autofill;

  /// Extracts business types from form value and
  /// converts to `List<String>`.
  List<String> _extractBusinessTypes(dynamic value) {
    if (value == null) return [];
    if (value is String) return [value];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }

  /// Maps UI ID type label to backend `IdType` enum
  /// value.
  String _mapIdTypeToApiValue(String uiLabel) {
    return switch (uiLabel) {
      'ID Card' => 'CITIZEN_ID',
      'Citizen Identity Card' => 'CITIZEN_ID',
      'Passport' => 'PASSPORT',
      _ => 'CITIZEN_ID',
    };
  }

  /// Extracts user-friendly error message from API
  /// exceptions.
  String _extractErrorMessage(Object error) {
    if (error is ApiException && error.message != null) {
      try {
        final json = jsonDecode(error.message!);
        // Handle nested message structure from backend
        if (json is Map<String, dynamic>) {
          final message = json['message'];
          if (message is Map<String, dynamic>) {
            return message['message'] as String? ?? error.message!;
          } else if (message is String) {
            return message;
          }
        }
      } catch (_) {
        // If parsing fails, return the raw message
        return error.message!;
      }
    }
    return error.toString();
  }

  /// Required field keys that must all be non-empty
  /// before the submit button is enabled.
  static const _requiredFieldKeys = [
    'email',
    'password',
    'confirm_password',
    'brand_name',
    'legal_name',
    'tax_code',
    'business_types',
    'province',
    'street_address',
    'clinic_phone',
    'representative_name',
    'representative_position',
    'representative_phone',
    'id_type',
    'id_number',
    'id_issue_date',
    'documents.identity_front',
    'documents.identity_back',
    'documents.business_license',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final scrollController = useScrollController();
    final isFormComplete = useState(false);

    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(signUpProviderProvider);

    // Resolve autofill for UAT only: URL param
    // OR UAT store config flag.
    final shouldAutofill = AutofillConfig.isUatAutofillEnabled(
      routeAutofill: autofill,
    );

    final initialValue = useMemoized(
      () => shouldAutofill ? _buildAutofillValues() : const <String, dynamic>{},
    );

    // Listen for state changes
    ref.listen(signUpProviderProvider, (previous, next) {
      // Only handle transitions from loading state
      final wasLoading = previous?.isLoading ?? false;
      if (!wasLoading) return;

      next.whenOrNull(
        data: (data) {
          // Only redirect on successful registration
          if (data.registrationSuccess) {
            ref.read(signUpProviderProvider.notifier).reset();
            context.go(const SuccessRegistrationRoute().location);
          }
        },
        error: (error, stackTrace) {
          final message = _extractErrorMessage(error);
          ToastContext.showToast(context, ToastType.error, message);
          // Reset loading state after error
          ref.read(signUpProviderProvider.notifier).reset();
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        final values = formKey.currentState!.value;

        // Build nested entities
        final accountRequest = AccountRequestEntity(
          email: values['email'] ?? '',
          password: values['password'] ?? '',
        );

        final partnerRequest = PartnerRequestEntity(
          taxCode: values['tax_code'] ?? '',
          legalName: values['legal_name'] ?? '',
          brandName: values['brand_name'] ?? '',
          businessType: _extractBusinessTypes(values['business_types']),
          provinceId: values['province'] ?? '',
          districtId: values['district'] ?? '',
          wardId: values['ward'] ?? '',
          streetAddress: values['street_address'] ?? '',
          phoneNumber: values['clinic_phone'] ?? values['representative_phone'],
        );

        // Build documents list
        final documents = <PartnerDocumentVerificationEntity>[];
        for (final entry in values.entries) {
          if (entry.key.startsWith('documents.') && entry.value != null) {
            final value = entry.value;
            if (value is DocumentUploadType) {
              documents.add(
                PartnerDocumentVerificationEntity(
                  fileType: value.fileType,
                  type: value.documentKey.toUpperCase(),
                  documentKey: value.documentKey,
                  urls: [value.url],
                ),
              );
            } else if (value is List<DocumentUploadType> && value.isNotEmpty) {
              final docKey = entry.key.replaceFirst('documents.', '');
              documents.addAll(
                value.indexed
                    .map(
                      (indexed) => PartnerDocumentVerificationEntity(
                        fileType: indexed.$2.fileType,
                        type: docKey.toUpperCase(),
                        documentKey: '${docKey}_${indexed.$1 + 1}',
                        urls: [indexed.$2.url],
                      ),
                    )
                    .toList(),
              );
            }
          }
        }
        final legalRepresentativeRequest = LegalRepresentativeEntity(
          fullName: values['representative_name'] ?? '',
          position: values['representative_position'],
          phoneNumber: values['representative_phone'],
          idType: _mapIdTypeToApiValue(
            values['id_type'] ?? 'Citizen Identity Card',
          ),
          idNumber: values['id_number'] ?? '',
          idIssueDate:
              values['id_issue_date']?.toString().split(' ').first ??
              DateTime.now().toIso8601String().split('T').first,
          documents: documents,
        );

        final request = RegisterPartnerRequestEntity(
          account: accountRequest,
          partner: partnerRequest,
          legalRepresentative: legalRepresentativeRequest,
        );

        await ref
            .read(signUpProviderProvider.notifier)
            .registerPartner(request);
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Sticky header
          const SignUpHeader(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: FormBuilder(
                    key: formKey,
                    initialValue: initialValue,
                    onChanged: () =>
                        _checkFormCompleteness(formKey, isFormComplete),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section
                        const RegistrationTitleSection(),
                        AppDimens.verticalExtraLarge,

                        // Section 1: Account Information
                        FormSectionCard(
                          sectionNumber: '1',
                          title: 'ACCOUNT INFORMATION'.toUpperCase(),
                          child: const AccountInformationSection(),
                        ),
                        AppDimens.verticalLarge,

                        // Section 2: Business & Partner
                        FormSectionCard(
                          sectionNumber: '2',
                          title: 'Business & Partner Information'.toUpperCase(),
                          child: Column(
                            children: [
                              BusinessPartnerSection(
                                initialServiceTags: shouldAutofill
                                    ? SignUpFormAutofill.businessTypes
                                    : null,
                              ),
                              AppDimens.verticalMedium,
                              BusinessLocationSection(
                                initialStreetAddress: shouldAutofill
                                    ? SignUpFormAutofill.streetAddress
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        AppDimens.verticalLarge,

                        // Section 3: Legal Representative
                        FormSectionCard(
                          sectionNumber: '3',
                          title: 'Legal Representative'.toUpperCase(),
                          child: LegalRepresentativeSectionV2(),
                        ),
                        AppDimens.verticalLarge,

                        // Section 4: Document Verification
                        Builder(
                          builder: (context) {
                            final formState = FormBuilder.of(context);
                            final types =
                                formState?.fields['business_types']?.value
                                    as List<dynamic>?;
                            final scope = (types != null && types.isNotEmpty)
                                ? types.first.toString()
                                : 'SPA_BEAUTY';
                            return FormSectionCard(
                              sectionNumber: '4',
                              title: 'Document Verification'.toUpperCase(),
                              child: DocumentVerificationSection(scope: scope),
                            );
                          },
                        ),
                        AppDimens.verticalLarge,

                        // Submit section
                        RegistrationSubmitSection(
                          onSubmit: submit,
                          isLoading: state.isLoading,
                          isEnabled: isFormComplete.value,
                        ),
                        AppDimens.verticalExtraLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Checks whether all [_requiredFieldKeys] have
  /// non-empty values and updates [isFormComplete].
  ///
  /// Also reads underlying [TextEditingController]
  /// text to catch programmatic/autofill values
  /// that may not yet be synced to FormBuilder.
  void _checkFormCompleteness(
    GlobalKey<FormBuilderState> formKey,
    ValueNotifier<bool> isFormComplete,
  ) {
    // Schedule after the current frame so
    // FormBuilder has committed field values.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fields = formKey.currentState?.fields;
      if (fields == null) {
        isFormComplete.value = false;
        return;
      }

      for (final key in _requiredFieldKeys) {
        if (!_isFieldFilled(fields, key)) {
          isFormComplete.value = false;
          return;
        }
      }
      isFormComplete.value = true;
    });
  }

  /// Returns `true` when the field identified by
  /// [key] has a non-empty value.
  ///
  /// Checks both the FormBuilder field value and
  /// the controller text (if available) to handle
  /// edge cases where controllers are updated
  /// programmatically.
  bool _isFieldFilled(Map<String, dynamic> fields, String key) {
    final field = fields[key];
    if (field == null) return false;

    final value = field.value;

    // Check FormBuilder field value
    if (value == null) return false;
    if (value is String && value.isEmpty) return false;
    if (value is List && value.isEmpty) return false;

    return true;
  }

  /// Autofill map for all simple `FormBuilder` fields.
  /// Only used when [shouldAutofill] is active.
  static Map<String, dynamic> _buildAutofillValues() => {
    // Section 1
    'username': SignUpFormAutofill.username,
    'email': SignUpFormAutofill.email,
    'password': SignUpFormAutofill.password,
    'confirm_password': SignUpFormAutofill.confirmPassword,
    // Section 2
    'brand_name': SignUpFormAutofill.brandName,
    'legal_name': SignUpFormAutofill.legalName,
    'tax_code': SignUpFormAutofill.taxCode,
    'street_address': SignUpFormAutofill.streetAddress,
    // Section 3
    'representative_name': SignUpFormAutofill.representativeName,
    'representative_position': SignUpFormAutofill.representativePosition,
    'representative_phone': SignUpFormAutofill.representativePhone,
    'id_type': SignUpFormAutofill.idType,
    'id_number': SignUpFormAutofill.idNumber,
    'id_issue_date': SignUpFormAutofill.idIssueDate,
  };
}
