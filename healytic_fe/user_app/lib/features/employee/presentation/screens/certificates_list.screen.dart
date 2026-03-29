import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/certificate.entity.dart';
import 'package:user_app/features/employee/presentation/providers/employee_detail.provider.dart';
import 'package:user_app/router/routes.dart';

/// Full-screen list of employee certificates.
///
/// Reads certificates from the already-cached
/// [employeeDetailProvider] to avoid passing complex
/// objects through GoRouter extras.
class CertificatesListScreen extends ConsumerWidget {
  const CertificatesListScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  final String employeeId;
  final String employeeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final employeeAsync = ref.watch(employeeDetailProvider(employeeId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(employeeName: employeeName),
          employeeAsync.when(
            data: (employee) {
              final certs = employee.certificates;
              if (certs.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              }
              return _CertificatesList(certificates: certs);
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => SliverFillRemaining(
              child: _EmptyState(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App bar ───────────────────────────────────────

class _AppBar extends StatelessWidget {
  const _AppBar({required this.employeeName});

  final String employeeName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: true,
      title: Column(
        children: [
          Text(
            'Certificates',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            employeeName,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.description,
            size: AppDimens.iconXxl,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppDimens.verticalMedium,
          Text(
            'No certificates available',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Certificates list ─────────────────────────────

class _CertificatesList extends StatelessWidget {
  const _CertificatesList({required this.certificates});

  final List<CertificateEntity> certificates;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppDimens.spaceLg,
      ),
      sliver: SliverList.separated(
        itemCount: certificates.length,
        separatorBuilder: (_, __) => AppDimens.verticalSmall,
        itemBuilder: (context, index) =>
            _CertificateCard(certificate: certificates[index]),
      ),
    );
  }
}

// ─── Individual certificate card ───────────────────

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.certificate});

  final CertificateEntity certificate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final radius = AppDimens.cardRadius(context);
    final cardPad = AppDimens.cardPadding(context);

    return Semantics(
      button: true,
      label: 'View ${certificate.name}',
      child: Material(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () => _onTap(context),
          child: Container(
            padding: EdgeInsets.all(cardPad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                _TypeIcon(type: certificate.type),
                SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.name,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppDimens.verticalExtraSmall,
                      Text(
                        _typeLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Symbols.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimens.iconSmMd,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _typeLabel {
    return switch (certificate.type) {
      CertificateType.image => 'Image',
      CertificateType.pdf => 'PDF Document',
      CertificateType.unknown => 'Document',
    };
  }

  void _onTap(BuildContext context) {
    CertificateViewerRoute(
      certificateName: certificate.name,
      url: certificate.url,
      type: certificate.type.name,
    ).push<void>(context);
  }
}

// ─── Type icon ─────────────────────────────────────

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final CertificateType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final (IconData icon, Color fg, Color bg) = switch (type) {
      CertificateType.image => (
        Symbols.image,
        colorScheme.primary,
        colorScheme.primaryContainer.withValues(alpha: 0.4),
      ),
      CertificateType.pdf => (
        Symbols.picture_as_pdf,
        colorScheme.error,
        colorScheme.errorContainer.withValues(alpha: 0.4),
      ),
      CertificateType.unknown => (
        Symbols.description,
        colorScheme.tertiary,
        colorScheme.tertiaryContainer.withValues(alpha: 0.4),
      ),
    };

    return Container(
      height: AppDimens.avatarSm + 4,
      width: AppDimens.avatarSm + 4,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: fg, size: AppDimens.iconSmMd),
    );
  }
}
