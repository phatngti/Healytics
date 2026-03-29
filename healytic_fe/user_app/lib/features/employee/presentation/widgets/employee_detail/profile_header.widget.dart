import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/employee_preview.entity.dart';

/// Center-aligned profile header with avatar, name,
/// role badge, experience, and specialization tag.
///
/// Use [EmployeeProfileHeader.fromPreview] to render a
/// lightweight version from [EmployeePreview] data
/// while the full detail loads.
class EmployeeProfileHeader extends StatelessWidget {
  const EmployeeProfileHeader({
    super.key,
    required this.employee,
  }) : preview = null;

  /// Creates a header from lightweight preview
  /// data for instant rendering.
  const EmployeeProfileHeader.fromPreview({
    super.key,
    required EmployeePreview this.preview,
  }) : employee = null;

  final EmployeeDetailEntity? employee;
  final EmployeePreview? preview;

  @override
  Widget build(BuildContext context) {
    if (employee != null) {
      return _FullHeader(employee: employee!);
    }
    return _PreviewHeader(preview: preview!);
  }
}

/// Full header rendered from [EmployeeDetailEntity].
class _FullHeader extends StatelessWidget {
  const _FullHeader({required this.employee});

  final EmployeeDetailEntity employee;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Avatar(avatarUrl: employee.avatarUrl),
        AppDimens.verticalMedium,
        _StatusBadge(status: employee.status),
        AppDimens.verticalExtraSmall,
        _RoleBadge(
          label: employee.jobTitle ??
              employee.roleLabel,
        ),
        AppDimens.verticalExtraSmall,
        _EmployeeName(name: employee.displayName),
        AppDimens.verticalExtraSmall,
        _EmployeeCode(code: employee.employeeCode),
        AppDimens.verticalSmall,
        _ExperienceRow(employee: employee),
        AppDimens.verticalMedium,
        _SpecializationTag(employee: employee),
      ],
    );
  }
}

/// Lightweight header rendered from
/// [EmployeePreview] data.
class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.preview});

  final EmployeePreview preview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Avatar(avatarUrl: preview.avatarUrl),
        AppDimens.verticalMedium,
        if (preview.roleLabel != null) ...[
          _RoleBadge(label: preview.roleLabel!),
          AppDimens.verticalExtraSmall,
        ],
        _EmployeeName(name: preview.name),
        if (preview.specialty != null) ...[
          AppDimens.verticalSmall,
          _PreviewSpecialtyRow(
            specialty: preview.specialty!,
            rating: preview.rating,
            reviewCount: preview.reviewCount,
          ),
        ],
      ],
    );
  }
}

/// Specialty + rating row for preview mode.
class _PreviewSpecialtyRow extends StatelessWidget {
  const _PreviewSpecialtyRow({
    required this.specialty,
    this.rating,
    this.reviewCount,
  });

  final String specialty;
  final double? rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final muted = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(specialty, style: muted),
        if (rating != null) ...[
          Padding(
            padding:
                AppDimens.paddingHorizontalSmall,
            child: Container(
              height: AppDimens.spaceXs,
              width: AppDimens.spaceXs,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
          Icon(
            Symbols.star,
            size: AppDimens.iconSm,
            color: colorScheme.primary,
          ),
          const SizedBox(
            width: AppDimens.spaceXxs,
          ),
          Text(
            '$rating',
            style: muted?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (reviewCount != null)
            Text(
              ' ($reviewCount)',
              style: muted,
            ),
        ],
      ],
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          height: AppDimens.avatarLg * 1.7,
          width: AppDimens.avatarLg * 1.7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: AppDimens.borderWidthThick,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: AppDimens.spaceMd,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? NetworkImageAuto(
                    imageUrl: avatarUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_) => _placeholder(colorScheme),
                  )
                : _placeholder(colorScheme),
          ),
        ),
        Positioned(
          bottom: AppDimens.spaceXs,
          right: AppDimens.spaceXs,
          child: Container(
            height: AppDimens.spaceLg,
            width: AppDimens.spaceLg,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surface,
                width: AppDimens.borderWidthThick,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Icon(
      Icons.person,
      size: AppDimens.avatarMd,
      color: colorScheme.onSurfaceVariant,
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      label.toUpperCase(),
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: AppDimens.letterSpacingLarge,
      ),
    );
  }
}

class _EmployeeName extends StatelessWidget {
  const _EmployeeName({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _EmployeeCode extends StatelessWidget {
  const _EmployeeCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Symbols.badge,
          size: AppDimens.iconSm,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppDimens.spaceXs),
        Text(
          code,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: AppDimens.letterSpacingMedium,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final EmployeeStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (Color dotColor, Color bgColor) = switch (status) {
      EmployeeStatus.active => (
        colorScheme.primary,
        colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
      EmployeeStatus.inactive => (
        colorScheme.error,
        colorScheme.errorContainer.withValues(alpha: 0.3),
      ),
      EmployeeStatus.onLeave => (
        colorScheme.tertiary,
        colorScheme.tertiaryContainer.withValues(alpha: 0.3),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: AppDimens.spaceXs,
            width: AppDimens.spaceXs,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppDimens.spaceXs),
          Text(
            status.label,
            style: textTheme.labelSmall?.copyWith(
              color: dotColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.employee});

  final EmployeeDetailEntity employee;

  @override
  Widget build(BuildContext context) {
    final experience = _experienceText;
    final specialty = _specialtyText;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (experience == null && specialty == null) {
      return const SizedBox.shrink();
    }

    final muted = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (experience != null) Text(experience, style: muted),
        if (experience != null && specialty != null)
          Padding(
            padding: AppDimens.paddingHorizontalSmall,
            child: Container(
              height: AppDimens.spaceXs,
              width: AppDimens.spaceXs,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
        if (specialty != null) Text(specialty, style: muted),
      ],
    );
  }

  String? get _experienceText {
    if (employee.isDoctor) {
      final years = employee.doctorProfile?.experienceYears;
      if (years != null) {
        return '$years years experience';
      }
    }
    if (employee.isTherapist) {
      return employee.therapistProfile?.level;
    }
    return null;
  }

  String? get _specialtyText {
    if (employee.isDoctor) {
      final specs = employee.doctorProfile?.specializations;
      return specs?.isNotEmpty == true ? specs!.first : null;
    }
    if (employee.isTherapist) {
      return employee.therapistProfile?.type;
    }
    return null;
  }
}

class _SpecializationTag extends StatelessWidget {
  const _SpecializationTag({required this.employee});

  final EmployeeDetailEntity employee;

  @override
  Widget build(BuildContext context) {
    final label = _tagLabel;
    if (label == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceXs + 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String? get _tagLabel {
    if (employee.isDoctor) {
      final specs = employee.doctorProfile?.specializations ?? [];
      return specs.isNotEmpty ? specs.join(' & ') : null;
    }
    if (employee.isTherapist) {
      final skills = employee.therapistProfile?.skills ?? [];
      return skills.isNotEmpty ? skills.take(2).join(' & ') : null;
    }
    return null;
  }
}
