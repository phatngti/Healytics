import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/verification_status.provider.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/business_entity_form.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/legal_representative_form.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/location_form.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Collapsible section card for verification sections.
///
/// Displays:
/// - Step number badge
/// - Section title
/// - Action Required badge for sections needing revision
/// - Expandable content with form widgets
class VerificationSectionCard extends ConsumerStatefulWidget {
  /// Creates a new [VerificationSectionCard].
  const VerificationSectionCard({
    required this.section,
    required this.verificationStatus,
    this.provinces = const [],
    this.districts = const [],
    this.wards = const [],
    super.key,
  });

  /// The verification section to display.
  final VerificationSectionEntity section;

  /// The parent verification status entity containing detailed data.
  final ProviderVerificationStatusEntity verificationStatus;

  /// List of available provinces for location dropdown selection.
  final List<LocationEntity> provinces;

  /// List of available districts for location dropdown selection.
  final List<LocationEntity> districts;

  /// List of available wards for location dropdown selection.
  final List<LocationEntity> wards;

  @override
  ConsumerState<VerificationSectionCard> createState() =>
      _VerificationSectionCardState();
}

class _VerificationSectionCardState
    extends ConsumerState<VerificationSectionCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand sections that require action
    if (widget.section.status == SectionStatus.revisionRequired) {
      _isExpanded = true;
    }
  }

  bool get _requiresAction =>
      widget.section.status == SectionStatus.revisionRequired;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    final warningColor = semanticColors?.warning ?? Colors.orange;
    final isCompleted = widget.section.status == SectionStatus.completed;

    return Opacity(
      opacity: widget.section.isLocked ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header (outside card)
          _buildSectionHeader(
            context,
            colorScheme: colorScheme,
            textTheme: textTheme,
            warningColor: warningColor,
            isCompleted: isCompleted,
          ),
          // Expandable content card
          AnimatedCrossFade(
            firstChild: _buildContentCard(context, colorScheme),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required Color warningColor,
    required bool isCompleted,
  }) {
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    return InkWell(
      onTap: widget.section.isLocked
          ? null
          : () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
      borderRadius: AppDimens.radiusSmall,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Step number badge
            _StepBadge(
              stepNumber: widget.section.stepNumber ?? 1,
              isActive: _requiresAction || _isExpanded,
              colorScheme: colorScheme,
            ),
            AppDimens.horizontalMediumSmall,
            // Section title
            Expanded(
              child: Row(
                children: [
                  Text(
                    widget.section.label,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  // Completed badge
                  if (isCompleted && !_requiresAction) ...[
                    AppDimens.horizontalSmall,
                    Icon(
                      Icons.check_circle,
                      color: semanticColors?.success ?? Colors.green,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
            // Status badges and chevron
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Action Required badge
                if (_requiresAction) ...[
                  _ActionRequiredBadge(warningColor: warningColor),
                  AppDimens.horizontalSmall,
                ],
                // Expand/Collapse chevron
                if (!widget.section.isLocked)
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  )
                else
                  Icon(
                    Icons.lock_outline,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _getSectionWidget(),
    );
  }

  Widget _getSectionWidget() {
    switch (widget.section.type) {
      case VerificationSectionType.businessEntity:
        return BusinessEntityForm(info: widget.verificationStatus.businessInfo);
      case VerificationSectionType.locationDetails:
        return LocationForm(
          info: widget.verificationStatus.businessInfo.address,
          provinces: widget.provinces,
          districts: widget.districts,
          wards: widget.wards,
        );
      case VerificationSectionType.legalRepresentative:
        return LegalRepresentativeForm(
          section: widget.section,
          legalRepresentative: widget.verificationStatus.legalRepresentative,
          kycDocuments: widget.verificationStatus.kycDocuments,
          onUploadComplete: (result) {
            ref.read(pendingUploadsProvider.notifier).addUpload(result);
          },
        );
      case VerificationSectionType.accountSecurity:
        return DocumentVerificationSection(
          documents: widget.verificationStatus.kycDocuments,
          onUploadComplete: (result) {
            ref.read(pendingUploadsProvider.notifier).addUpload(result);
          },
        );
    }
  }
}

/// Circular step number badge.
class _StepBadge extends StatelessWidget {
  const _StepBadge({
    required this.stepNumber,
    required this.isActive,
    required this.colorScheme,
  });

  final int stepNumber;
  final bool isActive;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isActive
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Action Required warning badge.
class _ActionRequiredBadge extends StatelessWidget {
  const _ActionRequiredBadge({required this.warningColor});

  final Color warningColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warningColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_rounded, color: warningColor, size: 14),
          const SizedBox(width: 4),
          Text(
            'ACTION REQUIRED',
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: warningColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
