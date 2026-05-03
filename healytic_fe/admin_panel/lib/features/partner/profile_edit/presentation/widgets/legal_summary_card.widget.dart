import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card showing legal representative
/// summary (if available).
class LegalSummaryCardWidget extends StatelessWidget {
  const LegalSummaryCardWidget({required this.summary, super.key});

  final PublicProfileLegalSummary? summary;

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final s = summary!;

    return Card(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.gavel_rounded,
                  color: cs.primary,
                  size: AppDimens.iconMd,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'Legal Representative',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppDimens.verticalMedium,
            _SummaryRow(label: 'Full Name', value: s.fullName),
            _SummaryRow(label: 'Position', value: s.position),
            _SummaryRow(label: 'ID Type', value: s.idType.toUpperCase()),
            _SummaryRow(label: 'ID Number', value: _maskIdNumber(s.idNumber)),
          ],
        ),
      ),
    );
  }

  /// Masks the ID number for privacy, showing
  /// only the last 4 digits.
  String _maskIdNumber(String raw) {
    if (raw.length <= 4) return raw;
    final visible = raw.substring(raw.length - 4);
    final masked = '•' * (raw.length - 4);
    return '$masked$visible';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(child: Text(value, style: tt.bodyMedium)),
        ],
      ),
    );
  }
}
