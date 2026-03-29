import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/medical_credential.entity.dart';

/// Expandable card displaying two distinct regions:
/// **Education** (timeline) and **Degrees & Licenses**
/// (certification badges).
class DoctorEducationCard extends StatefulWidget {
  const DoctorEducationCard({
    super.key,
    required this.profile,
  });

  final DoctorProfileEntity profile;

  @override
  State<DoctorEducationCard> createState() =>
      _DoctorEducationCardState();
}

class _DoctorEducationCardState
    extends State<DoctorEducationCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardPad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _ExpandableHeader(
            title: 'Education & Degrees',
            expanded: _expanded,
            onTap: () =>
                setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            // ── Region 1: Education ──
            if (widget
                .profile.education.isNotEmpty) ...[
              AppDimens.verticalMedium,
              _SectionLabel(
                icon: Symbols.school,
                label: 'Education',
              ),
              AppDimens.verticalSmall,
              _Timeline(
                entries: widget.profile.education,
              ),
            ],

            // ── Divider between regions ──
            if (widget.profile.education.isNotEmpty &&
                widget.profile.medicalCredentials
                    .isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMd,
                ),
                child: Divider(
                  height: AppDimens.borderWidth,
                  color: colorScheme.outlineVariant
                      .withValues(alpha: 0.3),
                ),
              ),

            // ── Region 2: Degrees & Licenses ──
            if (widget.profile.medicalCredentials
                .isNotEmpty) ...[
              _SectionLabel(
                icon: Symbols.workspace_premium,
                label: 'Degrees & Licenses',
              ),
              AppDimens.verticalSmall,
              _CredentialCards(
                credentials:
                    widget.profile.medicalCredentials,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ─── Shared expandable header ──────────────────────

class _ExpandableHeader extends StatelessWidget {
  const _ExpandableHeader({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: expanded
          ? 'Collapse $title'
          : 'Expand $title',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              expanded
                  ? Symbols.expand_less
                  : Symbols.expand_more,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconLg,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section label with icon ───────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconMd,
          color: colorScheme.primary,
        ),
        const SizedBox(width: AppDimens.spaceXs),
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─── Timeline ──────────────────────────────────────

/// Dot diameter used for timeline circles.
const double _dotSize = AppDimens.spaceLg;

class _Timeline extends StatelessWidget {
  const _Timeline({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(entries.length, (i) {
        return _TimelineItem(
          label: entries[i],
          isLast: i == entries.length - 1,
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.label,
    required this.isLast,
  });

  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DotAndLine(isLast: isLast),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    isLast ? 0 : AppDimens.spaceXxl,
              ),
              child: Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the dot and the vertical connector
/// line below it (omitted for the last item).
class _DotAndLine extends StatelessWidget {
  const _DotAndLine({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: _dotSize,
      child: Column(
        children: [
          Container(
            height: _dotSize,
            width: _dotSize,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surface,
                width: 3,
              ),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: AppDimens.borderWidthThick,
                color: colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Credential cards ──────────────────────────────

class _CredentialCards extends StatelessWidget {
  const _CredentialCards({required this.credentials});

  final List<MedicalCredentialEntity> credentials;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: credentials.map((cred) {
        return _CredentialCard(credential: cred);
      }).toList(),
    );
  }
}

class _CredentialCard extends StatelessWidget {
  const _CredentialCard({
    required this.credential,
  });

  final MedicalCredentialEntity credential;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLicense = credential.isLicense;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceXs,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: colorScheme.outlineVariant
                .withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            _CredentialIcon(isLicense: isLicense),
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: _CredentialText(
                credential: credential,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon badge for a credential card (license vs
/// degree).
class _CredentialIcon extends StatelessWidget {
  const _CredentialIcon({required this.isLicense});

  final bool isLicense;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(
        AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: isLicense
            ? colorScheme.tertiaryContainer
            : colorScheme.primaryContainer,
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Icon(
        isLicense
            ? Symbols.license
            : Symbols.verified,
        size: AppDimens.iconSm,
        color: isLicense
            ? colorScheme.onTertiaryContainer
            : colorScheme.onPrimaryContainer,
      ),
    );
  }
}

/// Displays credential title and optional license
/// ID as two-line text.
class _CredentialText extends StatelessWidget {
  const _CredentialText({required this.credential});

  final MedicalCredentialEntity credential;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          credential.title,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (credential.hasLicense) ...[
          const SizedBox(height: 2),
          Text(
            credential.license!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

