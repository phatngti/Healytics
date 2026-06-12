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
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/presentation/providers/'
    'list_filter.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'filter_sort_controls.widget.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

/// Full specialists list from the home page.
class HomeSpecialistsScreen extends ConsumerWidget {
  const HomeSpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeListScreenLayout(
      title: 'Specialists',
      body: const _SpecialistsBody(),
    );
  }
}

class _SpecialistsBody extends StatelessWidget {
  const _SpecialistsBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppDimens.verticalMedium,
        _SpecialistFilterBar(),
        Expanded(child: _SpecialistListContainer()),
      ],
    );
  }
}

class _SpecialistFilterBar extends ConsumerWidget {
  const _SpecialistFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(specialistListFilterProvider);

    return FilterSortBar<SpecialistListSort>(
      options: SpecialistListSort.values
          .map((sort) => SortOption(value: sort, label: sort.label))
          .toList(),
      selected: filter.sort,
      filtersActive: filter.hasFilters,
      onFilterTap: () async {
        final next = await showSpecialistFilterSheet(context, filter);
        if (next != null) {
          ref.read(specialistListFilterProvider.notifier).state = next;
        }
      },
      onSelected: (sort) {
        ref.read(specialistListFilterProvider.notifier).state = filter.withSort(
          sort,
        );
      },
    );
  }
}

class _SpecialistListContainer extends ConsumerWidget {
  const _SpecialistListContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialistsAsync = ref.watch(employeeListProvider());
    final filterActive = ref.watch(
      specialistListFilterProvider.select((value) => value.isActive),
    );
    final specialists = specialistsAsync.value;

    if (specialists != null) {
      return _RefreshingStack(
        isRefreshing: specialistsAsync.isLoading,
        child: _SpecialistList(
          specialists: specialists,
          filtersActive: filterActive,
          onReset: () {
            ref.read(specialistListFilterProvider.notifier).state =
                const SpecialistListFilter();
          },
        ),
      );
    }

    if (specialistsAsync.hasError) {
      return Center(
        child: Padding(
          padding: AppDimens.paddingAllMedium,
          child: ErrorCard(
            title: 'Could not load specialists',
            error: specialistsAsync.error!,
            stackTrace: specialistsAsync.stackTrace,
            onRetry: () => ref.invalidate(employeeListProvider()),
          ),
        ),
      );
    }

    return const LoadingWidget();
  }
}

class _SpecialistList extends StatelessWidget {
  const _SpecialistList({
    required this.specialists,
    required this.filtersActive,
    required this.onReset,
  });

  final List<EmployeeDetailEntity> specialists;
  final bool filtersActive;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
      return _EmptyState(filtersActive: filtersActive, onReset: onReset);
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
                '${specialist.rating > 0 ? specialist.rating : 5.0}'
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
  const _EmptyState({required this.filtersActive, required this.onReset});

  final bool filtersActive;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filtersActive
                  ? 'No specialists match these filters'
                  : 'No specialists available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (filtersActive) ...[
              AppDimens.verticalSmall,
              TextButton(
                onPressed: onReset,
                child: const Text('Reset filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RefreshingStack extends StatelessWidget {
  const _RefreshingStack({required this.isRefreshing, required this.child});

  final bool isRefreshing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
