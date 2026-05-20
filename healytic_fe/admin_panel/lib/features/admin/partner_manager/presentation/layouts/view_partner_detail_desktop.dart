import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/partner_detail.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/account_contact_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/business_overview_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/kyc_documents_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/legal_representative_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/review_header.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Desktop layout for viewing partner details (read-only).
///
/// Reuses the same section widgets as [ReviewApplicationDesktop]
/// but with `readOnly: true` and without the review actions panel.
class ViewPartnerDetailDesktop extends ConsumerWidget {
  const ViewPartnerDetailDesktop({required this.partnerId, super.key});

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerDetailAsync = ref.watch(partnerDetailProvider(partnerId));

    return partnerDetailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: ErrorCard(
          title: 'Failed to load partner details',
          error: error,
          stackTrace: stack,
          onRetry: () => ref.invalidate(partnerDetailProvider(partnerId)),
        ),
      ),
      data: (partnerDetail) => _buildContent(context, partnerDetail),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PartnerVerificationDetailEntity partnerDetail,
  ) {
    return Column(
      children: [
        // Sticky Header
        ReviewHeader(
          brandName: partnerDetail.brandName.value,
          status: partnerDetail.status,
          submittedAt: partnerDetail.submittedAt,
        ),

        // Main Content
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: AppDimens.paddingAllMedium,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Side-by-side on larger screens
                    if (constraints.maxWidth >= 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Content Column
                          Expanded(
                            flex: 8,
                            child: SingleChildScrollView(
                              child: _buildMainContent(partnerDetail),
                            ),
                          ),
                          AppDimens.horizontalLarge,
                          // Sidebar Column (KYC only)
                          SizedBox(
                            width: 360,
                            child: SingleChildScrollView(
                              child: _buildSidebar(partnerDetail),
                            ),
                          ),
                        ],
                      );
                    }
                    // Stacked on smaller screens
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildMainContent(partnerDetail),
                          AppDimens.verticalLarge,
                          _buildSidebar(partnerDetail),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(PartnerVerificationDetailEntity partner) {
    return Column(
      children: [
        BusinessOverviewSection(
          readOnly: true,
          brandName: partner.brandName,
          taxRegistrationCode: partner.taxRegistrationCode,
          isTaxCodeValid: partner.isTaxCodeValid,
          businessTypes: partner.businessType,
          address: partner.address,
        ),
        AppDimens.verticalMedium,
        AccountContactSection(
          readOnly: true,
          email: partner.email,
          isEmailVerified: partner.isEmailVerified,
          phoneNumber: partner.phoneNumber,
        ),
        AppDimens.verticalMedium,
        LegalRepresentativeSection(
          readOnly: true,
          representative: partner.legalRepresentative,
        ),
      ],
    );
  }

  /// Sidebar shows only KYC documents (no actions panel)
  Widget _buildSidebar(PartnerVerificationDetailEntity partner) {
    return KycDocumentsSection(
      readOnly: true,
      documents: partner.kycDocuments.map((e) => e.value).toList(),
    );
  }
}
