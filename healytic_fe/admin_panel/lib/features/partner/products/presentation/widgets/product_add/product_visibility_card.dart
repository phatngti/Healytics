import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductVisibilityCard extends StatefulWidget {
  final String initialStatus;
  final bool initialOnlineStore;
  final ValueChanged<String>? onStatusChanged;
  final ValueChanged<bool>? onOnlineStoreChanged;

  const ProductVisibilityCard({
    super.key,
    this.initialStatus = 'draft',
    this.initialOnlineStore = false,
    this.onStatusChanged,
    this.onOnlineStoreChanged,
  });

  @override
  State<ProductVisibilityCard> createState() => _ProductVisibilityCardState();
}

class _ProductVisibilityCardState extends State<ProductVisibilityCard> {
  late String _status;
  late bool _onlineStore;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _onlineStore = widget.initialOnlineStore;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppDimens.paddingAllMediumLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISIBILITY',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          AppDimens.verticalMedium,
          // Status Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              FormFieldBuilders.buildCustomDropdownField<String>(
                context,
                fieldKey: 'status',
                label: 'Status',
                initialValue: _status,
                items: const [
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'archived', child: Text('Archived')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value.toString();
                    });
                    widget.onStatusChanged?.call(value.toString());
                  }
                },
              ),
            ],
          ),
          AppDimens.verticalMedium,
          // Online Store Toggle
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Online Store',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Show this product to customers',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _onlineStore,
                  onChanged: (value) {
                    setState(() {
                      _onlineStore = value;
                    });
                    widget.onOnlineStoreChanged?.call(value);
                  },
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
