import 'dart:developer' as developer;

import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_impl.repository.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/field_feedback.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/partner_detail.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/review_feedback.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/account_contact_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/business_overview_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/kyc_documents_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/legal_representative_section.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/review_actions_panel.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/review_header.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Desktop layout for the review application page
class ReviewApplicationDesktop extends ConsumerStatefulWidget {
  const ReviewApplicationDesktop({required this.partnerId, super.key});

  final String partnerId;

  @override
  ConsumerState<ReviewApplicationDesktop> createState() =>
      _ReviewApplicationDesktopState();
}

class _ReviewApplicationDesktopState
    extends ConsumerState<ReviewApplicationDesktop> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final partnerDetailAsync = ref.watch(
      partnerDetailProvider(widget.partnerId),
    );

    return partnerDetailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (partnerDetail) => _buildContent(context, partnerDetail),
    );
  }

  /// Converts [FieldFeedback] list to `Map<fieldId, note>` for API submission.
  Map<String, String?> _convertFieldFeedbackToMap(
    List<FieldFeedback> fieldFeedback,
  ) {
    final result = <String, String?>{};
    for (final feedback in fieldFeedback) {
      if (feedback.status == FieldFeedbackStatus.revisionRequested) {
        result[feedback.fieldId] = feedback.note;
      }
    }
    return result;
  }

  /// Handles the review submission with proper error handling.
  Future<void> _submitReview({
    required String decision,
    String? generalComment,
    List<FieldFeedback>? fieldFeedback,
  }) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(partnerVerificationRepositoryProvider);
      final feedbackMap = fieldFeedback != null
          ? _convertFieldFeedbackToMap(fieldFeedback)
          : null;

      await repository.reviewPartner(
        PartnerVerificationId(widget.partnerId),
        decision: decision,
        generalComment: generalComment,
        fieldFeedback: feedbackMap,
      );

      // Clear the review feedback state after successful submission
      ref.invalidate(reviewFeedbackProvider);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getSuccessMessage(decision)),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to partner list
        Navigator.of(context).pop();
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to submit review',
        name: 'ReviewApplicationDesktop',
        error: error,
        stackTrace: stackTrace,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _getSuccessMessage(String decision) {
    return switch (decision) {
      'APPROVED' => 'Partner approved successfully',
      'CHANGES_REQUIRED' => 'Revision request sent successfully',
      'REJECTED' => 'Partner rejected successfully',
      _ => 'Review submitted successfully',
    };
  }

  Widget _buildContent(
    BuildContext context,
    PartnerVerificationDetailEntity partnerDetail,
  ) {
    return Stack(
      children: [
        Column(
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
                        // Responsive: side-by-side on larger screens
                        if (constraints.maxWidth >= 900) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main Content Column (8/12) - Scrollable
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView(
                                  child: _buildMainContent(partnerDetail),
                                ),
                              ),
                              AppDimens.horizontalLarge,
                              // Sidebar Column (4/12) - Sticky
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
        ),
        // Loading overlay
        if (_isSubmitting)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
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
        KycDocumentsSection(
          documents: partner.kycDocuments.map((e) => e.value).toList(),
        ),
        AppDimens.verticalMedium,
        ReviewActionsPanel(
          onApprove: (note) {
            _submitReview(decision: 'APPROVED', generalComment: note);
          },
          onRequestRevision: (note, fieldFeedback) {
            _submitReview(
              decision: 'CHANGES_REQUIRED',
              generalComment: note,
              fieldFeedback: fieldFeedback,
            );
          },
          onReject: (note) {
            _submitReview(decision: 'REJECTED', generalComment: note);
          },
        ),
      ],
    );
  }
}
