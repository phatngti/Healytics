import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/employee_preview.entity.dart';
import 'package:user_app/features/employee/presentation/providers/employee_detail.provider.dart';
import 'package:user_app/features/employee/presentation/providers/employee_preview_cache.provider.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/contact_info_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/device_proficiency_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/education_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/personal_info_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/practice_details_grid.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/profile_header.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/schedule_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/skills_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/specialties_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/summary_section.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/work_history_card.widget.dart';
import 'package:user_app/features/employee/presentation/widgets/employee_detail/explore_services_section.widget.dart';

/// Employee detail screen that supports multiple
/// navigation flows:
///
/// 1. **With preview** — callers seed
///    [EmployeePreviewCache] so the header renders
///    instantly while full data loads.
/// 2. **Without preview** — shows a loading
///    spinner until data arrives.
class EmployeeDetailScreen extends HookConsumerWidget {
  const EmployeeDetailScreen({
    super.key,
    required this.employeeId,
  });

  final String employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEmployee = ref.watch(
      employeeDetailProvider(employeeId),
    );
    final preview = ref.read(
      employeePreviewCacheProvider.notifier,
    ).get(employeeId);

    return Scaffold(
      body: switch (asyncEmployee) {
        AsyncData(:final value) =>
          _Content(employee: value),
        AsyncError(:final error) =>
          Center(child: Text('Error: $error')),
        _ => preview != null
            ? _PreviewContent(preview: preview)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      },
    );
  }
}

// ─── Preview content (instant partial UI) ──────────

class _PreviewContent extends StatelessWidget {
  const _PreviewContent({required this.preview});

  final EmployeePreview preview;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad =
        AppDimens.horizontalPadding(context);
    final section =
        AppDimens.sectionSpacing(context);

    return CustomScrollView(
      slivers: [
        _SliverAppBar(
          title: preview.roleLabel != null
              ? '${preview.roleLabel} Profile'
              : 'Profile',
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: section,
                ),
                child:
                    EmployeeProfileHeader.fromPreview(
                  preview: preview,
                ),
              ),
              Divider(
                height: AppDimens.borderWidth,
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: section,
                ),
                child: _ShimmerPlaceholders(
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Shimmer placeholders ──────────────────────────

class _ShimmerPlaceholders extends StatelessWidget {
  const _ShimmerPlaceholders({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final shimmer =
        colorScheme.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppDimens.spaceLg,
          width: AppDimens.widthFraction(
            context,
            fraction: 0.5,
          ),
          decoration: BoxDecoration(
            color: shimmer,
            borderRadius:
                AppDimens.radiusExtraSmall,
          ),
        ),
        SizedBox(height: AppDimens.spaceMd),
        for (var i = 0; i < 3; i++) ...[
          Container(
            height: AppDimens.spaceXxl * 2,
            decoration: BoxDecoration(
              color: shimmer,
              borderRadius:
                  AppDimens.radiusMediumSmall,
            ),
          ),
          SizedBox(height: AppDimens.spaceMd),
        ],
      ],
    );
  }
}

// ─── Main content ──────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.employee});

  final EmployeeDetailEntity employee;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final section = AppDimens.sectionSpacing(context);

    return CustomScrollView(
      slivers: [
        _SliverAppBar(title: _appBarTitle),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: section,
                ),
                child: EmployeeProfileHeader(
                  employee: employee,
                ),
              ),
              Divider(
                height: AppDimens.borderWidth,
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.3),
              ),
              if (employee.description != null)
                EmployeeSummarySection(
                  description:
                      employee.description!,
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                ),
                child: Column(
                  children: [
                    ..._roleSpecificCards(context),
                    SizedBox(height: section),
                    EmployeeContactInfoCard(
                      employee: employee,
                    ),
                    SizedBox(height: section),
                    EmployeePersonalInfoCard(
                      employee: employee,
                    ),
                    SizedBox(height: section),
                    EmployeeScheduleCard(
                      schedule: employee.schedule,
                    ),
                    if (employee
                        .workHistory.isNotEmpty) ...[
                      SizedBox(height: section),
                      EmployeeWorkHistoryCard(
                        workHistory:
                            employee.workHistory,
                      ),
                    ],
                  ],
                ),
              ),
              EmployeePracticeDetailsGrid(
                employee: employee,
              ),
              ExploreServicesSection(
                employeeId: employee.id,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _appBarTitle {
    return employee.isDoctor
        ? 'Doctor Profile'
        : 'Therapist Profile';
  }

  List<Widget> _roleSpecificCards(
    BuildContext context,
  ) {
    final gap = AppDimens.sectionSpacing(context);

    if (employee.isDoctor &&
        employee.doctorProfile != null) {
      return [
        DoctorSpecialtiesCard(
          profile: employee.doctorProfile!,
        ),
        SizedBox(height: gap),
        DoctorEducationCard(
          profile: employee.doctorProfile!,
        ),
      ];
    }

    if (employee.isTherapist &&
        employee.therapistProfile != null) {
      return [
        TherapistSkillsCard(
          profile: employee.therapistProfile!,
        ),
        SizedBox(height: gap),
        TherapistDeviceProficiencyCard(
          profile: employee.therapistProfile!,
        ),
      ];
    }

    return [];
  }
}

// ─── Sticky app bar ────────────────────────────────

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: true,
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor:
          colorScheme.surface.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () =>
            Navigator.of(context).maybePop(),
      ),
    );
  }
}
