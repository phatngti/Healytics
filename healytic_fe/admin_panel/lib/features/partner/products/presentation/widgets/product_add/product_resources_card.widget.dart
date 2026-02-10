import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductResourcesCard extends ConsumerStatefulWidget {
  const ProductResourcesCard({super.key});

  @override
  ConsumerState<ProductResourcesCard> createState() =>
      _ProductResourcesCardState();
}

class _ProductResourcesCardState extends ConsumerState<ProductResourcesCard> {
  List<_Resource> _resources = [_Resource(resourceId: 'room_std', quantity: 1)];

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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: AppDimens.paddingAllMediumLarge,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'REQUIRED RESOURCES',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._resources.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ResourceRow(
                      resource: entry.value,
                      onRemove: () {
                        setState(() {
                          _resources.removeAt(entry.key);
                        });
                      },
                      onChanged: (resource) {
                        setState(() {
                          _resources[entry.key] = resource;
                        });
                      },
                    ),
                  );
                }),
                _buildAddResourceButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddResourceButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          _resources.add(_Resource(resourceId: '', quantity: 1));
        });
      },
      borderRadius: AppDimens.radiusSmall,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: colorScheme.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            AppDimens.horizontalSmall,
            Text(
              'Add Resource',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Resource {
  final String resourceId;
  final int quantity;

  _Resource({required this.resourceId, required this.quantity});
}

class _ResourceRow extends StatelessWidget {
  final _Resource resource;
  final VoidCallback onRemove;
  final ValueChanged<_Resource> onChanged;

  const _ResourceRow({
    required this.resource,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: resource.resourceId.isEmpty
                ? null
                : resource.resourceId,
            items: const [
              DropdownMenuItem(value: 'room_std', child: Text('Standard Room')),
              DropdownMenuItem(
                value: 'room_prem',
                child: Text('Premium Suite'),
              ),
              DropdownMenuItem(value: 'laser', child: Text('Laser Machine')),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(
                  _Resource(resourceId: value, quantity: resource.quantity),
                );
              }
            },
            decoration: InputDecoration(
              hintText: 'Select Resource...',
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppDimens.radiusSmall,
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppDimens.radiusSmall,
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppDimens.radiusSmall,
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              contentPadding: AppDimens.paddingAllSmall,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        AppDimens.horizontalSmall,
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              TextFormField(
                initialValue: resource.quantity.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final qty = int.tryParse(value) ?? 1;
                  onChanged(
                    _Resource(resourceId: resource.resourceId, quantity: qty),
                  );
                },
                decoration: InputDecoration(
                  hintText: '1',
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  contentPadding: AppDimens.paddingAllSmall,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    'qty',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppDimens.horizontalSmall,
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.delete_outline,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          style: IconButton.styleFrom(backgroundColor: colorScheme.surface),
        ),
      ],
    );
  }
}
