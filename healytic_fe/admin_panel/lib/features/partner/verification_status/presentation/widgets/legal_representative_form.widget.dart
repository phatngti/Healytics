import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/document_cards.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for the Legal Representative verification step.
///
/// Displays:
/// - Personal info fields (disabled/read-only)
/// - Identity verification upload cards with animated glow for required uploads
/// - Verified document cards with green checkmarks
class LegalRepresentativeForm extends StatefulWidget {
  /// Creates a new [LegalRepresentativeForm].
  const LegalRepresentativeForm({
    required this.section,
    required this.legalRepresentative,
    required this.kycDocuments,
    this.onFieldChanged,
    this.onUploadComplete,
    super.key,
  });

  /// The section entity for displaying step number and status.
  final VerificationSectionEntity section;

  /// The legal representative data.
  final LegalRepresentativeInfo? legalRepresentative;

  /// KYC documents as VerifiedField list.
  final List<VerifiedField> kycDocuments;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  /// Callback when a document upload completes successfully.
  final void Function(DocumentUploadResult result)? onUploadComplete;

  @override
  State<LegalRepresentativeForm> createState() =>
      _LegalRepresentativeFormState();
}

class _LegalRepresentativeFormState extends State<LegalRepresentativeForm> {
  /// Tracks uploaded file URLs by document key for EDITED status and preview.
  final Map<String, String> _uploadedUrls = {};

  void _handleUploadComplete(DocumentUploadResult result) {
    setState(() {
      _uploadedUrls[result.documentKey] = result.url;
    });
    widget.onUploadComplete?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.legalRepresentative == null) {
      return const Center(
        child: Text('No legal representative information available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal info fields (with reduced opacity as they're read-only)
        _buildPersonalInfoGrid(context),
        AppDimens.verticalLarge,
        // Identity verification section
        _buildIdentityVerification(context),
      ],
    );
  }

  Widget _buildPersonalInfoGrid(BuildContext context) {
    final legalRep = widget.legalRepresentative!;

    // Collect all fields with their labels
    final fields = <({String label, VerifiedField field})>[
      (label: 'Full Name', field: legalRep.fullName),
      if (legalRep.position != null)
        (label: 'Position', field: legalRep.position!),
      if (legalRep.phoneNumber != null)
        (label: 'Phone Number', field: legalRep.phoneNumber!),
      if (legalRep.idType != null) (label: 'ID Type', field: legalRep.idType!),
      if (legalRep.idNumber != null)
        (label: 'ID Number', field: legalRep.idNumber!),
      if (legalRep.idIssueDate != null)
        (label: 'Date of Issue', field: legalRep.idIssueDate!),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final itemWidth = isWide
            ? (constraints.maxWidth - 24.0) /
                  2 // 24.0 = large spacing
            : constraints.maxWidth;

        return Wrap(
          spacing: 24.0, // Large spacing between columns
          runSpacing: 16.0, // Medium spacing between rows
          children: fields.map((item) {
            return SizedBox(
              width: itemWidth,
              child: VerificationTextField(
                label: item.label,
                fieldId: item.field.fieldKey,
                field: item.field,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// Finds ID documents from kycDocuments list.
  VerifiedField? _findDocument(String fieldKey) {
    try {
      return widget.kycDocuments.firstWhere((doc) => doc.fieldKey == fieldKey);
    } catch (_) {
      return null;
    }
  }

  Widget _buildIdentityVerification(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final idFront = _findDocument(DocumentTypes.idCardFront.documentKey);
    final idBack = _findDocument(DocumentTypes.idCardBack.documentKey);

    // Check if document requires update (not verified) OR has been edited
    final frontUploadedUrl = _uploadedUrls[idFront?.fieldKey];
    final backUploadedUrl = _uploadedUrls[idBack?.fieldKey];

    final frontRequiresUpdate = !(idFront?.isVerified ?? true);
    final backRequiresUpdate = !(idBack?.isVerified ?? true);
    final anyRequiresUpdate = frontRequiresUpdate || backRequiresUpdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with action badge
        Row(
          children: [
            Text(
              'Identity Verification',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            if (anyRequiresUpdate)
              VerificationActionRequiredBadge(color: colorScheme.error),
          ],
        ),
        AppDimens.verticalMedium,
        // Document upload cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (idFront != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          frontRequiresUpdate
                              ? DocumentUploadCard(
                                  document: idFront,
                                  uploadedPreviewUrl: frontUploadedUrl,
                                  showEditedBadge: frontUploadedUrl != null,
                                  onUploadComplete: _handleUploadComplete,
                                )
                              : CompletedDocumentCard(
                                  document: idFront,
                                  previewUrlOverride: frontUploadedUrl,
                                  showEditedBadge: frontUploadedUrl != null,
                                ),
                          if (idFront.feedback != null &&
                              idFront.feedback!.isNotEmpty)
                            FeedbackMessage(feedback: idFront.feedback!),
                        ],
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (idBack != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          backRequiresUpdate
                              ? DocumentUploadCard(
                                  document: idBack,
                                  uploadedPreviewUrl: backUploadedUrl,
                                  showEditedBadge: backUploadedUrl != null,
                                  onUploadComplete: _handleUploadComplete,
                                )
                              : CompletedDocumentCard(
                                  document: idBack,
                                  previewUrlOverride: backUploadedUrl,
                                  showEditedBadge: backUploadedUrl != null,
                                ),
                          if (idBack.feedback != null &&
                              idBack.feedback!.isNotEmpty)
                            FeedbackMessage(feedback: idBack.feedback!),
                        ],
                      ),
                    ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (idFront != null) ...[
                  frontRequiresUpdate
                      ? DocumentUploadCard(
                          document: idFront,
                          uploadedPreviewUrl: frontUploadedUrl,
                          showEditedBadge: frontUploadedUrl != null,
                          onUploadComplete: _handleUploadComplete,
                        )
                      : CompletedDocumentCard(
                          document: idFront,
                          previewUrlOverride: frontUploadedUrl,
                          showEditedBadge: frontUploadedUrl != null,
                        ),
                  if (idFront.feedback != null && idFront.feedback!.isNotEmpty)
                    FeedbackMessage(feedback: idFront.feedback!),
                ],
                AppDimens.verticalMedium,
                if (idBack != null) ...[
                  backRequiresUpdate
                      ? DocumentUploadCard(
                          document: idBack,
                          uploadedPreviewUrl: backUploadedUrl,
                          showEditedBadge: backUploadedUrl != null,
                          onUploadComplete: _handleUploadComplete,
                        )
                      : CompletedDocumentCard(
                          document: idBack,
                          previewUrlOverride: backUploadedUrl,
                          showEditedBadge: backUploadedUrl != null,
                        ),
                  if (idBack.feedback != null && idBack.feedback!.isNotEmpty)
                    FeedbackMessage(feedback: idBack.feedback!),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
