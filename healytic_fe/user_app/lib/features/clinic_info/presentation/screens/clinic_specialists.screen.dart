import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_info.provider.dart';
import 'package:user_app/features/home/presentation/widgets/home_list_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

/// Clinic-scoped list of specialists from the clinic
/// profile payload.
class ClinicSpecialistsScreen extends ConsumerWidget {
  const ClinicSpecialistsScreen({super.key, required this.clinicId});

  final String clinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicAsync = ref.watch(clinicInfoProvider(clinicId: clinicId));

    return HomeListScreenLayout(
      title: 'Specialists',
      body: switch (clinicAsync) {
        AsyncData(:final value) => _ClinicSpecialistsList(
          specialists: value.specialists,
        ),
        AsyncError(:final error) => _ClinicSpecialistsError(
          error: error,
          onRetry: () => ref.invalidate(clinicInfoProvider(clinicId: clinicId)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ClinicSpecialistsList extends StatelessWidget {
  const _ClinicSpecialistsList({required this.specialists});

  final List<ClinicSpecialistPreview> specialists;

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
      return const _ClinicSpecialistsEmpty();
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
        return _ClinicSpecialistCard(specialist: specialists[index]);
      },
    );
  }
}

class _ClinicSpecialistCard extends StatelessWidget {
  const _ClinicSpecialistCard({required this.specialist});

  final ClinicSpecialistPreview specialist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);

    return Semantics(
      button: true,
      label: specialist.name,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
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
                _ClinicSpecialistAvatar(specialist: specialist),
                AppDimens.horizontalMedium,
                Expanded(
                  child: _ClinicSpecialistDetails(specialist: specialist),
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

class _ClinicSpecialistAvatar extends StatelessWidget {
  const _ClinicSpecialistAvatar({required this.specialist});

  final ClinicSpecialistPreview specialist;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: SizedBox.square(
        dimension: AppDimens.avatarMd,
        child: specialist.imageUrl != null
            ? NetworkImageAuto(
                imageUrl: specialist.imageUrl!,
                fit: BoxFit.cover,
              )
            : ColoredBox(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Symbols.person,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}

class _ClinicSpecialistDetails extends StatelessWidget {
  const _ClinicSpecialistDetails({required this.specialist});

  final ClinicSpecialistPreview specialist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final experience = specialist.experienceLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          specialist.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalExtraSmall,
        Text(
          specialist.role,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (experience != null && experience.isNotEmpty) ...[
          AppDimens.verticalSmall,
          Text(
            experience,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: AppDimens.fontWeightSemiBold,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _ClinicSpecialistsError extends StatelessWidget {
  const _ClinicSpecialistsError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

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
              'Could not load specialists',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
              textAlign: TextAlign.center,
            ),
            AppDimens.verticalSmall,
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            AppDimens.verticalMedium,
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _ClinicSpecialistsEmpty extends StatelessWidget {
  const _ClinicSpecialistsEmpty();

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
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
