import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/employee/domain/entities/'
    'employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/'
    'employee_preview.entity.dart';
import 'package:user_app/features/employee/presentation/providers/'
    'employee_list.provider.dart';
import 'package:user_app/features/employee/presentation/providers/'
    'employee_preview_cache.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

/// Full specialists list from the home page.
class HomeSpecialistsScreen extends ConsumerWidget {
  const HomeSpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialistsAsync = ref.watch(employeeListProvider());

    return HomeListScreenLayout(
      title: 'Specialists',
      body: switch (specialistsAsync) {
        AsyncData(:final value) => _SpecialistList(specialists: value),
        AsyncError(:final error, :final stackTrace) => Center(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: ErrorCard(
              title: 'Could not load specialists',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(employeeListProvider()),
            ),
          ),
        ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _SpecialistList extends StatelessWidget {
  const _SpecialistList({required this.specialists});

  final List<EmployeeDetailEntity> specialists;

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
      return const _EmptyState();
    }

    final hPad = AppDimens.horizontalPadding(context);
    final gap = AppDimens.contentPadding(context);

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceLg,
        hPad,
        AppDimens.bottomScrollPadding(context),
      ),
      itemCount: specialists.length,
      separatorBuilder: (_, __) => SizedBox(height: gap),
      itemBuilder: (context, index) {
        return _SpecialistCard(specialist: specialists[index]);
      },
    );
  }
}

class _SpecialistCard extends ConsumerWidget {
  const _SpecialistCard({required this.specialist});

  final EmployeeDetailEntity specialist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);
    final specialty = _specialtyFor(specialist);

    return Semantics(
      button: true,
      label: specialist.fullName,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ref
                .read(employeePreviewCacheProvider.notifier)
                .seed(
                  EmployeePreview(
                    id: specialist.id,
                    name: specialist.fullName,
                    avatarUrl: specialist.avatarUrl,
                    specialty: specialty,
                    roleLabel: _roleLabel(specialist.role),
                    rating: specialist.rating,
                    reviewCount: specialist.reviewCount,
                  ),
                );
            EmployeeDetailRoute(employeeId: specialist.id).push(context);
          },
          child: Container(
            padding: EdgeInsets.all(contentPad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRad),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                AvatarImage(
                  name: specialist.fullName,
                  imageUrl: specialist.avatarUrl,
                  radius: AppDimens.avatarMd / 2,
                ),
                AppDimens.horizontalMedium,
                Expanded(
                  child: _SpecialistDetails(
                    specialist: specialist,
                    specialty: specialty,
                  ),
                ),
                AppDimens.horizontalSmall,
                Icon(
                  Symbols.chevron_right,
                  size: AppDimens.iconLg,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialistDetails extends StatelessWidget {
  const _SpecialistDetails({required this.specialist, required this.specialty});

  final EmployeeDetailEntity specialist;
  final String specialty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          specialist.fullName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (specialty.isNotEmpty) ...[
          AppDimens.verticalExtraSmall,
          Text(
            specialty,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        AppDimens.verticalSmall,
        Row(
          children: [
            Icon(
              Symbols.star,
              size: AppDimens.iconSm,
              color: colorScheme.primary,
            ),
            AppDimens.horizontalExtraSmall,
            Flexible(
              child: Text(
                '${specialist.rating.toStringAsFixed(1)}'
                ' · ${specialist.reviewCount} reviews',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _specialtyFor(EmployeeDetailEntity employee) {
  final jobTitle = employee.jobTitle;
  if (jobTitle != null && jobTitle.isNotEmpty) return jobTitle;

  final doctorSpecializations = employee.doctorProfile?.specializations ?? [];
  if (doctorSpecializations.isNotEmpty) return doctorSpecializations.first;

  final therapistType = employee.therapistProfile?.type;
  if (therapistType != null && therapistType.isNotEmpty) return therapistType;

  return _roleLabel(employee.role);
}

String _roleLabel(EmployeeRole role) {
  return switch (role) {
    EmployeeRole.doctor => 'Doctor',
    EmployeeRole.therapist => 'Therapist',
    EmployeeRole.receptionist => 'Receptionist',
    EmployeeRole.manager => 'Manager',
  };
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Text(
          'No specialists available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
