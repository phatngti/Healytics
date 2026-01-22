import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/account_contact_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/business_overview_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/kyc_documents_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/legal_representative_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/review_actions_panel.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/review_header.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Desktop layout for the review application page
class ReviewApplicationDesktop extends HookConsumerWidget {
  const ReviewApplicationDesktop({required this.partnerId, super.key});

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual data from provider/repository
    final partnerDetail = _getMockPartnerDetail();

    return Column(
      children: [
        // Sticky Header
        ReviewHeader(
          brandName: partnerDetail.brandName,
          status: partnerDetail.status,
          submittedAt: partnerDetail.submittedAt,
        ),

        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: AppDimens.paddingAllMedium,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive: side-by-side on larger screens
                if (constraints.maxWidth >= 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Content Column (8/12)
                      Expanded(
                        flex: 8,
                        child: _buildMainContent(partnerDetail),
                      ),
                      AppDimens.horizontalLarge,
                      // Sidebar Column (4/12)
                      Expanded(flex: 4, child: _buildSidebar(partnerDetail)),
                    ],
                  );
                }
                // Stacked on smaller screens
                return Column(
                  children: [
                    _buildMainContent(partnerDetail),
                    AppDimens.verticalLarge,
                    _buildSidebar(partnerDetail),
                  ],
                );
              },
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
          brandName: partner.brandName,
          taxRegistrationCode: partner.taxRegistrationCode,
          isTaxCodeValid: partner.isTaxCodeValid,
          serviceTags: partner.serviceTags,
          address: partner.address,
        ),
        AppDimens.verticalMedium,
        AccountContactSection(
          username: partner.username,
          email: partner.email,
          isEmailVerified: partner.isEmailVerified,
          phoneNumber: partner.phoneNumber,
        ),
        AppDimens.verticalMedium,
        LegalRepresentativeSection(representative: partner.legalRepresentative),
      ],
    );
  }

  Widget _buildSidebar(PartnerVerificationDetailEntity partner) {
    return Column(
      children: [
        KycDocumentsSection(documents: partner.kycDocuments),
        AppDimens.verticalMedium,
        ReviewActionsPanel(
          onApprove: (note) {
            // TODO: Implement approve action
          },
          onReject: (note) {
            // TODO: Implement reject action
          },
        ),
      ],
    );
  }

  /// Mock data for development - replace with repository call
  PartnerVerificationDetailEntity _getMockPartnerDetail() {
    return PartnerVerificationDetailEntity(
      id: PartnerVerificationId(partnerId),
      brandName: 'Hanoi Spa & Wellness',
      taxRegistrationCode: '0101234567-HN',
      isTaxCodeValid: true,
      serviceTags: ['Spa Treatment', 'Massage Therapy', 'Sauna', 'Facial Care'],
      address: const AddressInfo(
        streetAddress: '18 Au Trieu Street',
        ward: 'Hang Trong Ward',
        district: 'Hoan Kiem District',
        city: 'Hanoi',
        country: 'Vietnam',
      ),
      username: 'hanoispa_admin',
      email: 'contact@hanoispa.vn',
      isEmailVerified: true,
      phoneNumber: '+84 90 123 4567',
      legalRepresentative: const LegalRepresentative(
        fullName: 'Nguyen Van An',
        position: 'General Director',
        citizenId: '001088000XXX',
        verificationNote:
            'The legal representative name matches the name on the '
            'tax registration documents provided.',
      ),
      kycDocuments: [
        KycDocument(
          id: 'doc1',
          type: KycDocumentType.idCardFront,
          fileName: 'ID_Card_Front.jpg',
          uploadedAt: DateTime(2023, 10, 24),
        ),
        KycDocument(
          id: 'doc2',
          type: KycDocumentType.idCardBack,
          fileName: 'ID_Card_Back.jpg',
          uploadedAt: DateTime(2023, 10, 24),
        ),
        KycDocument(
          id: 'doc3',
          type: KycDocumentType.authorizationLetter,
          fileName: 'Auth_Letter_Signed.pdf',
          fileSize: '2.4 MB',
          uploadedAt: DateTime(2023, 10, 24),
        ),
      ],
      status: PartnerVerificationStatus.pending,
      submittedAt: DateTime(2023, 10, 24),
    );
  }
}
