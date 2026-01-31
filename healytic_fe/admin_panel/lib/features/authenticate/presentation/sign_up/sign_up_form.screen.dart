import 'dart:convert';

import 'package:admin_openapi/api.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/account_information_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_location_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_partner_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/document_verification_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/form_section_card.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/legal_representative_section_v2.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_submit_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_title_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_header.widget.dart';
import 'package:admin_panel/features/common/widgets/toast.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Partner Registration Form Screen.
///
/// A comprehensive multi-section form for business partner registration.
/// Sections include:
/// - Account Information (Section 1)
/// - Business & Partner Information (Section 2)
/// - Legal Representative (Section 3)
/// - Document Verification (Section 4)

class SignUpFormScreen extends HookConsumerWidget {
  const SignUpFormScreen({super.key});

  /// Extracts user-friendly error message from API exceptions.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final scrollController = useScrollController();

    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(signUpProviderProvider);

    // Listen for state changes
    ref.listen(signUpProviderProvider, (previous, next) {
      // Only handle transitions from loading state (actual API responses)
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
          // Reset loading state after error to re-enable the submit button
          ref.read(signUpProviderProvider.notifier).reset();
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        final values = formKey.currentState!.value;

        // Build nested entities for RegisterPartnerRequestEntity
        final accountRequest = AccountRequestEntity(
          username: values['username'] ?? '',
          email: values['email'] ?? '',
          password: values['password'] ?? '',
        );

        final partnerRequest = PartnerRequestEntity(
          taxCode: values['tax_code'] ?? '',
          legalName: values['legal_name'] ?? '',
          brandName: values['brand_name'] ?? '',
          businessType: values['business_type'] ?? 'Individual Business',
          provinceId: values['province'] ?? '',
          districtId: values['district'] ?? '',
          wardId: values['ward'] ?? '',
          streetAddress: values['street_address'] ?? '',
          phoneNumber: values['representative_phone'],
        );

        // Build documents list from form values matching "documents.*" pattern
        // Exclude id_front and id_back as they are handled separately via images
        final documents = <PartnerDocumentVerificationEntity>[];
        for (final entry in values.entries) {
          if (entry.key.startsWith('documents.') && entry.value != null) {
            final value = entry.value;
            if (value is DocumentUploadType) {
              // Single document field
              documents.add(
                PartnerDocumentVerificationEntity(
                  fileType: value.fileType,
                  type: value.documentKey.toUpperCase(),
                  documentKey: value.documentKey,
                  urls: [value.url],
                ),
              );
            } else if (value is List<DocumentUploadType> && value.isNotEmpty) {
              // Multi-document field (e.g., other_documents)
              final docKey = entry.key.replaceFirst('documents.', '');
              documents.addAll(
                value
                    .map(
                      (d) => PartnerDocumentVerificationEntity(
                        fileType: d.fileType,
                        type: docKey.toUpperCase(),
                        documentKey: docKey,
                        urls: [d.url],
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
          idType: values['id_type'] ?? 'ID Card',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section
                        const RegistrationTitleSection(),
                        AppDimens.verticalExtraLarge,

                        // Section 1: Account Information
                        FormSectionCard(
                          sectionNumber: '1',
                          title: 'Account Information',
                          child: const AccountInformationSection(),
                        ),
                        AppDimens.verticalLarge,

                        // Section 2: Business & Partner Information
                        FormSectionCard(
                          sectionNumber: '2',
                          title: 'Business & Partner Information',
                          child: Column(
                            children: [
                              const BusinessPartnerSection(),
                              AppDimens.verticalMedium,
                              const BusinessLocationSection(),
                            ],
                          ),
                        ),
                        AppDimens.verticalLarge,

                        // Section 3: Legal Representative
                        FormSectionCard(
                          sectionNumber: '3',
                          title: 'Legal Representative',
                          child: LegalRepresentativeSectionV2(),
                        ),
                        AppDimens.verticalLarge,

                        // Section 4: Document Verification
                        FormSectionCard(
                          sectionNumber: '4',
                          title: 'Document Verification',
                          child: const DocumentVerificationSection(
                            scope: 'SPA_BEAUTY',
                          ),
                        ),
                        AppDimens.verticalLarge,

                        // Submit section
                        RegistrationSubmitSection(
                          onSubmit: submit,
                          isLoading: state.isLoading,
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
}
