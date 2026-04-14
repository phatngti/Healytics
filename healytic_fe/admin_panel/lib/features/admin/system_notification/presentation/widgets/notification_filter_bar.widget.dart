import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filter bar with search, dropdowns, and date pickers
/// for narrowing the campaign activity stream.
class NotificationFilterBar extends ConsumerWidget {
  const NotificationFilterBar({
    super.key,
    required this.state,
    required this.onSearchChanged,
    required this.onChannelChanged,
    required this.onAudienceChanged,
    required this.onCreatedByChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onReset,
  });

  final NotificationCampaignIndexState state;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<NotificationChannel?> onChannelChanged;
  final ValueChanged<String?> onAudienceChanged;
  final ValueChanged<String?> onCreatedByChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segmentsAsync = ref.watch(notificationSegmentsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filterLabelStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: AppDimens.fontWeightSemiBold,
    );

    return NotificationSectionCard(
      title: 'Filters',
      subtitle:
          'Slice the activity stream the same way operators '
          'triage campaigns in mature notification platforms.',
      child: Wrap(
        spacing: AppDimens.spaceLg,
        runSpacing: AppDimens.spaceLg,
        children: [
          _FilterInputShell(
            width: 300,
            label: 'Search',
            labelStyle: filterLabelStyle,
            child: _SearchFilterField(
              value: state.filter.searchQuery,
              onChanged: onSearchChanged,
            ),
          ),
          _FilterInputShell(
            width: 180,
            label: 'Channel',
            labelStyle: filterLabelStyle,
            child: DropdownButtonFormField<NotificationChannel?>(
              key: ValueKey(
                state.filter.channels.isEmpty
                    ? 'all-channels'
                    : state.filter.channels.first.name,
              ),
              isExpanded: true,
              initialValue: state.filter.channels.isEmpty
                  ? null
                  : state.filter.channels.first,
              decoration: const InputDecoration(),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All channels'),
                ),
                ...NotificationChannel.values.map(
                  (channel) => DropdownMenuItem(
                    value: channel,
                    child: Text(channel.label),
                  ),
                ),
              ],
              onChanged: onChannelChanged,
            ),
          ),
          _FilterInputShell(
            width: 220,
            label: 'Audience',
            labelStyle: filterLabelStyle,
            child: segmentsAsync.when(
              data: (segments) => DropdownButtonFormField<String?>(
                key: ValueKey(state.filter.audiencePreset ?? 'all-audiences'),
                isExpanded: true,
                initialValue: state.filter.audiencePreset,
                decoration: const InputDecoration(),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All audiences'),
                  ),
                  ...segments.map(
                    (segment) => DropdownMenuItem(
                      value: segment.name,
                      child: Text(segment.name),
                    ),
                  ),
                ],
                onChanged: onAudienceChanged,
              ),
              loading: () => const _FilterLoadingField(),
              error: (error, _) => Text('Audience filter unavailable: $error'),
            ),
          ),
          _FilterInputShell(
            width: 180,
            label: 'Created by',
            labelStyle: filterLabelStyle,
            child: DropdownButtonFormField<String?>(
              key: ValueKey(state.filter.createdBy ?? 'all-admins'),
              isExpanded: true,
              initialValue: state.filter.createdBy,
              decoration: const InputDecoration(),
              items: const [
                DropdownMenuItem(value: null, child: Text('All admins')),
                DropdownMenuItem(
                  value: 'Platform Operations',
                  child: Text('Platform Operations'),
                ),
                DropdownMenuItem(
                  value: 'Current Admin',
                  child: Text('Current Admin'),
                ),
              ],
              onChanged: onCreatedByChanged,
            ),
          ),
          _FilterInputShell(
            width: 190,
            label: 'Start date',
            labelStyle: filterLabelStyle,
            child: _DateFilterField(
              value: state.filter.startDate,
              onChanged: onStartDateChanged,
            ),
          ),
          _FilterInputShell(
            width: 190,
            label: 'End date',
            labelStyle: filterLabelStyle,
            child: _DateFilterField(
              value: state.filter.endDate,
              onChanged: onEndDateChanged,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              AppButton(
                buttonType: ButtonType.outline,
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt),
                child: Text(
                  'Reset',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: AppDimens.fontWeightSemiBold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterInputShell extends StatelessWidget {
  const _FilterInputShell({
    required this.width,
    required this.label,
    required this.child,
    this.labelStyle,
  });

  final double width;
  final String label;
  final Widget child;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _SearchFilterField extends StatefulWidget {
  const _SearchFilterField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchFilterField> createState() => _SearchFilterFieldState();
}

class _SearchFilterFieldState extends State<_SearchFilterField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _SearchFilterField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) return;
    _controller.value = TextEditingValue(
      text: widget.value,
      selection: TextSelection.collapsed(offset: widget.value.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: const InputDecoration(
        hintText: 'Search campaigns',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class _FilterLoadingField extends StatelessWidget {
  const _FilterLoadingField();

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(),
      child: const SizedBox(height: 4, child: LinearProgressIndicator()),
    );
  }
}

/// Date picker field used inside the filter bar.
class _DateFilterField extends StatelessWidget {
  const _DateFilterField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2025),
            lastDate: DateTime(2027),
            initialDate: value ?? DateTime(2026, 4, 11),
          );
          onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            suffixIcon: value == null
                ? null
                : IconButton(
                    onPressed: () => onChanged(null),
                    icon: const Icon(Icons.clear),
                  ),
          ),
          child: Text(
            value == null ? 'Select date' : formatNotificationDate(value!),
            style: value == null
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
