import 'package:admin_panel/features/partner/products/'
    'presentation/widgets/service_rule_icon_data.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A tappable icon picker field for selecting a
/// Material Symbols icon by slug.
///
/// Opens a [_MaterialIconPickerDialog] on tap and
/// writes the selected slug into [controller].
class CategoryIconPicker extends StatelessWidget {
  const CategoryIconPicker({
    super.key,
    required this.controller,
    this.label = 'Icon',
  });

  /// Receives the selected icon slug as text.
  final TextEditingController controller;

  /// Label displayed above the field.
  final String label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final icon = serviceRuleIconData(value.text);
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Tappable field
            Semantics(
              button: true,
              label: 'Select category icon',
              value: normalizeServiceRuleIconSlug(
                value.text,
              ),
              child: InkWell(
                onTap: () => _showPicker(context),
                borderRadius: AppDimens.radiusSmall,
                child: InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: AppDimens.radiusSmall,
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppDimens.radiusSmall,
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon ?? Icons.apps_outlined,
                        size: 24,
                        color: icon == null
                            ? colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.55)
                            : colorScheme.onSurface,
                      ),
                      AppDimens.horizontalSmall,
                      Expanded(
                        child: Text(
                          value.text.isEmpty
                              ? 'Select an icon…'
                              : value.text,
                          style: textTheme.bodyMedium
                              ?.copyWith(
                                color: value.text.isEmpty
                                    ? colorScheme
                                        .onSurfaceVariant
                                    : colorScheme.onSurface,
                              ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 20,
                        color:
                            colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) =>
          _CategoryIconPickerDialog(
            initialSlug: controller.text,
          ),
    );
    if (selected == null) return;
    controller.text = selected;
  }
}

// ── Dialog ──────────────────────────────────────────

class _CategoryIconPickerDialog extends StatefulWidget {
  const _CategoryIconPickerDialog({
    required this.initialSlug,
  });

  final String initialSlug;

  @override
  State<_CategoryIconPickerDialog> createState() =>
      _CategoryIconPickerDialogState();
}

class _CategoryIconPickerDialogState
    extends State<_CategoryIconPickerDialog> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final normalizedQuery =
        normalizeServiceRuleIconSlug(_query);
    final options = normalizedQuery.isEmpty
        ? serviceRuleIconOptions
        : serviceRuleIconOptions
              .where(
                (o) => o.slug.contains(normalizedQuery),
              )
              .toList();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 720,
          maxHeight: 640,
        ),
        child: Padding(
          padding: AppDimens.paddingAllLarge,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Material Icon',
                      style:
                          textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () =>
                        Navigator.of(context).pop(),
                  ),
                ],
              ),
              AppDimens.verticalSmall,
              // Search field
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search icons',
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _query = value);
                },
              ),
              AppDimens.verticalMedium,
              // Icon grid
              Expanded(
                child: options.isEmpty
                    ? Center(
                        child: Text(
                          'No icons found',
                          style: textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      )
                    : GridView.builder(
                        itemCount: options.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 132,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.25,
                            ),
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final initialIcon =
                              serviceRuleIconData(
                                widget.initialSlug,
                              );
                          final isSelected =
                              option.slug ==
                                  normalizeServiceRuleIconSlug(
                                    widget.initialSlug,
                                  ) ||
                              option.icon == initialIcon;

                          return _IconOptionTile(
                            option: option,
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.of(context)
                                  .pop(option.slug);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Icon Option Tile ────────────────────────────────

class _IconOptionTile extends StatelessWidget {
  const _IconOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ServiceRuleIconOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimens.radiusSmall,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                option.icon,
                size: 24,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                option.slug,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                      color: isSelected
                          ? colorScheme
                              .onPrimaryContainer
                          : colorScheme
                              .onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
