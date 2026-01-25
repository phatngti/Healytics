import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/account_security_form.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/business_entity_form.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/legal_representative_form.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/location_form.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Collapsed section card for completed or locked verification sections.
///
/// Displays the section label with a status icon and disabled state.
class VerificationSectionCard extends StatefulWidget {
  /// Creates a new [VerificationSectionCard].
  const VerificationSectionCard({
    required this.section,
    required this.verificationStatus,
    super.key,
  });

  /// The verification section to display.
  final VerificationSectionEntity section;

  /// The parent verification status entity containing detailed data.
  final ProviderVerificationStatusEntity verificationStatus;

  @override
  State<VerificationSectionCard> createState() =>
      _VerificationSectionCardState();
}

class _VerificationSectionCardState extends State<VerificationSectionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    final isCompleted = widget.section.status == SectionStatus.completed;
    final successColor = semanticColors?.success ?? Colors.green;

    return Opacity(
      opacity: widget.section.isLocked ? 0.6 : 1.0,
      child: Container(
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: widget.section.isLocked
                  ? null
                  : () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Status icon
                    Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isCompleted ? successColor : colorScheme.outline,
                      size: 24,
                    ),
                    AppDimens.horizontalMediumSmall,
                    // Section label
                    Expanded(
                      child: Text(
                        widget.section.label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // Trailing icon
                    AnimatedCrossFade(
                      firstChild: Icon(
                        Icons.lock_outline,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      secondChild: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      crossFadeState: widget.section.isLocked
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            AnimatedCrossFade(
              firstChild: _buildContent(context),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: _getSectionWidget(),
    );
  }

  Widget _getSectionWidget() {
    switch (widget.section.type) {
      case VerificationSectionType.businessEntity:
        return BusinessEntityForm(
          info: widget.verificationStatus.businessEntity,
        );
      case VerificationSectionType.locationDetails:
        return LocationForm(info: widget.verificationStatus.locationDetails);
      case VerificationSectionType.legalRepresentative:
        return LegalRepresentativeForm(
          section: widget.section,
          legalRepresentative: widget.verificationStatus.legalRepresentative,
          onUploadDocument: (_) {
            // TODO: Handle document upload
          },
        );
      case VerificationSectionType.accountSecurity:
        return const AccountSecurityForm();
    }
  }
}
