import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_remote.datasource.dart';
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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Desktop layout for the review application page
class ReviewApplicationDesktop extends HookConsumerWidget {
  const ReviewApplicationDesktop({required this.partnerId, super.key});

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(partnerVerificationRemoteDataSourceProvider);
    final partnerDetailFuture = useMemoized(
      () => dataSource.getPartnerDetailById(PartnerVerificationId(partnerId)),
      [partnerId],
    );
    final partnerDetailSnapshot = useFuture(partnerDetailFuture);

    if (partnerDetailSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (partnerDetailSnapshot.hasError) {
      return Center(child: Text('Error: ${partnerDetailSnapshot.error}'));
    }

    final partnerDetail = partnerDetailSnapshot.data;
    if (partnerDetail == null) {
      return const Center(child: Text('Partner not found'));
    }

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
          onRequestRevision: (note, fieldFeedback) {
            // TODO: Implement request revision action
          },
          onReject: (note) {
            // TODO: Implement reject action
          },
        ),
      ],
    );
  }
}
