import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';

class SortOption<T> {
  const SortOption({required this.value, required this.label});

  final T value;
  final String label;
}

class FilterSortBar<T> extends StatelessWidget {
  const FilterSortBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.onFilterTap,
    required this.filtersActive,
  });

  final List<SortOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final VoidCallback onFilterTap;
  final bool filtersActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: options.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _FilterButton(active: filtersActive, onTap: onFilterTap);
          }
          final option = options[index - 1];
          return _SortPill<T>(
            option: option,
            selected: option.value == selected,
            onSelected: onSelected,
          );
        },
      ),
    );
  }
}

Future<ServiceListFilter?> showServiceFilterSheet(
  BuildContext context,
  ServiceListFilter initial, {
  bool includeCategory = false,
}) {
  return _showFilterSheet<ServiceListFilter>(
    context,
    child: _ServiceFilterSheet(
      initial: initial,
      includeCategory: includeCategory,
    ),
  );
}

Future<SpecialistListFilter?> showSpecialistFilterSheet(
  BuildContext context,
  SpecialistListFilter initial,
) {
  return _showFilterSheet<SpecialistListFilter>(
    context,
    child: _SpecialistFilterSheet(initial: initial),
  );
}

Future<RecentActivityFilter?> showRecentActivityFilterSheet(
  BuildContext context,
  RecentActivityFilter initial,
) {
  return _showFilterSheet<RecentActivityFilter>(
    context,
    child: _RecentActivityFilterSheet(initial: initial),
  );
}

Future<T?> _showFilterSheet<T>(BuildContext context, {required Widget child}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: active ? 'Edit active filters' : 'Open filters',
      child: _ToolbarPill(
        label: 'Filter',
        icon: Symbols.tune,
        selected: active,
        trailing: active ? _ActiveDot() : null,
        onTap: onTap,
      ),
    );
  }
}

class _SortPill<T> extends StatelessWidget {
  const _SortPill({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  final SortOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return _ToolbarPill(
      label: option.label,
      icon: selected ? Symbols.check : null,
      selected: selected,
      onTap: () => onSelected(option.value),
    );
  }
}

class _ToolbarPill extends StatelessWidget {
  const _ToolbarPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bg = selected ? colors.primaryContainer : colors.surface;
    final fg = selected ? colors.onPrimaryContainer : colors.onSurfaceVariant;
    final borderColor = selected
        ? colors.primaryContainer
        : colors.outlineVariant;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ServiceFilterSheet extends StatefulWidget {
  const _ServiceFilterSheet({
    required this.initial,
    required this.includeCategory,
  });

  final ServiceListFilter initial;
  final bool includeCategory;

  @override
  State<_ServiceFilterSheet> createState() => _ServiceFilterSheetState();
}

class _ServiceFilterSheetState extends State<_ServiceFilterSheet> {
  late final TextEditingController _minPrice;
  late final TextEditingController _maxPrice;
  late final TextEditingController _categoryId;
  late final TextEditingController _clinicId;
  late final TextEditingController _provinceId;
  late final TextEditingController _districtId;
  late final TextEditingController _wardId;

  @override
  void initState() {
    super.initState();
    _minPrice = TextEditingController(
      text: widget.initial.minPrice?.toString() ?? '',
    );
    _maxPrice = TextEditingController(
      text: widget.initial.maxPrice?.toString() ?? '',
    );
    _categoryId = TextEditingController(text: widget.initial.categoryId ?? '');
    _clinicId = TextEditingController(text: widget.initial.clinicId ?? '');
    _provinceId = TextEditingController(text: widget.initial.provinceId ?? '');
    _districtId = TextEditingController(text: widget.initial.districtId ?? '');
    _wardId = TextEditingController(text: widget.initial.wardId ?? '');
  }

  @override
  void dispose() {
    _minPrice.dispose();
    _maxPrice.dispose();
    _categoryId.dispose();
    _clinicId.dispose();
    _provinceId.dispose();
    _districtId.dispose();
    _wardId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Filters',
      subtitle: 'Refine services by price, category, clinic, and location.',
      resetLabel: 'Clear all',
      applyLabel: 'Show results',
      onReset: () => Navigator.of(context).pop(const ServiceListFilter()),
      onApply: () {
        Navigator.of(context).pop(
          ServiceListFilter(
            sort: widget.initial.sort,
            minPrice: _numOrNull(_minPrice.text),
            maxPrice: _numOrNull(_maxPrice.text),
            categoryId: widget.includeCategory
                ? _textOrNull(_categoryId)
                : null,
            clinicId: _textOrNull(_clinicId),
            provinceId: _textOrNull(_provinceId),
            districtId: _textOrNull(_districtId),
            wardId: _textOrNull(_wardId),
          ),
        );
      },
      children: [
        _SectionBlock(
          title: 'Price range',
          icon: Symbols.payments,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TextField(
                      label: 'Minimum',
                      hint: '0',
                      controller: _minPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixText: 'VND ',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TextField(
                      label: 'Maximum',
                      hint: 'Any',
                      controller: _maxPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixText: 'VND ',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _QuickChips(
                chips: [
                  _QuickChipData(
                    label: 'Under 500k',
                    onTap: () => _setPrice(null, 500000),
                  ),
                  _QuickChipData(
                    label: '500k - 1m',
                    onTap: () => _setPrice(500000, 1000000),
                  ),
                  _QuickChipData(
                    label: 'Above 1m',
                    onTap: () => _setPrice(1000000, null),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.includeCategory)
          _SectionBlock(
            title: 'Category',
            icon: Symbols.category,
            child: _TextField(
              label: 'Category',
              hint: 'Paste category ID',
              controller: _categoryId,
            ),
          ),
        _LocationSection(
          clinicController: _clinicId,
          provinceController: _provinceId,
          districtController: _districtId,
          wardController: _wardId,
        ),
      ],
    );
  }

  void _setPrice(num? min, num? max) {
    setState(() {
      _minPrice.text = min?.toString() ?? '';
      _maxPrice.text = max?.toString() ?? '';
    });
  }
}

class _SpecialistFilterSheet extends StatefulWidget {
  const _SpecialistFilterSheet({required this.initial});

  final SpecialistListFilter initial;

  @override
  State<_SpecialistFilterSheet> createState() => _SpecialistFilterSheetState();
}

class _SpecialistFilterSheetState extends State<_SpecialistFilterSheet> {
  late String? _role;
  late final TextEditingController _clinicId;
  late final TextEditingController _provinceId;
  late final TextEditingController _districtId;
  late final TextEditingController _wardId;
  late final TextEditingController _experience;

  @override
  void initState() {
    super.initState();
    _role = widget.initial.role;
    _clinicId = TextEditingController(text: widget.initial.clinicId ?? '');
    _provinceId = TextEditingController(text: widget.initial.provinceId ?? '');
    _districtId = TextEditingController(text: widget.initial.districtId ?? '');
    _wardId = TextEditingController(text: widget.initial.wardId ?? '');
    _experience = TextEditingController(
      text: widget.initial.minExperienceYears?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _clinicId.dispose();
    _provinceId.dispose();
    _districtId.dispose();
    _wardId.dispose();
    _experience.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Filters',
      subtitle: 'Find specialists by role, clinic, location, and experience.',
      resetLabel: 'Clear all',
      applyLabel: 'Show specialists',
      onReset: () => Navigator.of(context).pop(const SpecialistListFilter()),
      onApply: () {
        Navigator.of(context).pop(
          SpecialistListFilter(
            sort: widget.initial.sort,
            role: _role,
            clinicId: _textOrNull(_clinicId),
            provinceId: _textOrNull(_provinceId),
            districtId: _textOrNull(_districtId),
            wardId: _textOrNull(_wardId),
            minExperienceYears: int.tryParse(_experience.text.trim()),
          ),
        );
      },
      children: [
        _SectionBlock(
          title: 'Role',
          icon: Symbols.badge,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ChoicePill(
                label: 'Any',
                selected: _role == null,
                onTap: () => setState(() => _role = null),
              ),
              _ChoicePill(
                label: 'Doctor',
                selected: _role == 'DOCTOR',
                onTap: () => setState(() => _role = 'DOCTOR'),
              ),
              _ChoicePill(
                label: 'Therapist',
                selected: _role == 'THERAPIST',
                onTap: () => setState(() => _role = 'THERAPIST'),
              ),
            ],
          ),
        ),
        _SectionBlock(
          title: 'Experience',
          icon: Symbols.workspace_premium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuickChips(
                chips: [
                  _QuickChipData(label: '1+ years', onTap: () => _setExp(1)),
                  _QuickChipData(label: '3+ years', onTap: () => _setExp(3)),
                  _QuickChipData(label: '5+ years', onTap: () => _setExp(5)),
                  _QuickChipData(label: '10+ years', onTap: () => _setExp(10)),
                ],
              ),
              const SizedBox(height: 12),
              _TextField(
                label: 'Minimum years',
                hint: 'Any',
                controller: _experience,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        _LocationSection(
          clinicController: _clinicId,
          provinceController: _provinceId,
          districtController: _districtId,
          wardController: _wardId,
        ),
      ],
    );
  }

  void _setExp(int value) {
    setState(() => _experience.text = value.toString());
  }
}

class _RecentActivityFilterSheet extends StatefulWidget {
  const _RecentActivityFilterSheet({required this.initial});

  final RecentActivityFilter initial;

  @override
  State<_RecentActivityFilterSheet> createState() =>
      _RecentActivityFilterSheetState();
}

class _RecentActivityFilterSheetState
    extends State<_RecentActivityFilterSheet> {
  late String? _status;
  late final TextEditingController _categoryId;
  late final TextEditingController _clinicId;
  late DateTime? _fromDate;
  late DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _status = widget.initial.status;
    _categoryId = TextEditingController(text: widget.initial.categoryId ?? '');
    _clinicId = TextEditingController(text: widget.initial.clinicId ?? '');
    _fromDate = widget.initial.fromDate;
    _toDate = widget.initial.toDate;
  }

  @override
  void dispose() {
    _categoryId.dispose();
    _clinicId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Filters',
      subtitle: 'Narrow activity by status, clinic, category, and date.',
      resetLabel: 'Clear all',
      applyLabel: 'Show activity',
      onReset: () => Navigator.of(context).pop(const RecentActivityFilter()),
      onApply: () {
        Navigator.of(context).pop(
          RecentActivityFilter(
            sort: widget.initial.sort,
            status: _status,
            categoryId: _textOrNull(_categoryId),
            clinicId: _textOrNull(_clinicId),
            fromDate: _fromDate,
            toDate: _toDate,
          ),
        );
      },
      children: [
        _SectionBlock(
          title: 'Status',
          icon: Symbols.fact_check,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ChoicePill(
                label: 'Any',
                selected: _status == null,
                onTap: () => setState(() => _status = null),
              ),
              _ChoicePill(
                label: 'Scheduled',
                selected: _status == 'scheduled',
                onTap: () => setState(() => _status = 'scheduled'),
              ),
              _ChoicePill(
                label: 'Completed',
                selected: _status == 'completed',
                onTap: () => setState(() => _status = 'completed'),
              ),
              _ChoicePill(
                label: 'Cancelled',
                selected: _status == 'cancelled',
                onTap: () => setState(() => _status = 'cancelled'),
              ),
            ],
          ),
        ),
        _SectionBlock(
          title: 'Date range',
          icon: Symbols.calendar_month,
          child: Row(
            children: [
              Expanded(
                child: _DateTile(
                  label: 'From',
                  value: _fromDate,
                  onChanged: (value) => setState(() => _fromDate = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateTile(
                  label: 'To',
                  value: _toDate,
                  onChanged: (value) => setState(() => _toDate = value),
                ),
              ),
            ],
          ),
        ),
        _SectionBlock(
          title: 'Clinic and category',
          icon: Symbols.local_hospital,
          child: Column(
            children: [
              _TextField(
                label: 'Category',
                hint: 'Paste category ID',
                controller: _categoryId,
                leadingIcon: Symbols.category,
              ),
              const SizedBox(height: 12),
              _TextField(
                label: 'Clinic',
                hint: 'Paste clinic ID',
                controller: _clinicId,
                leadingIcon: Symbols.local_hospital,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({
    required this.clinicController,
    required this.provinceController,
    required this.districtController,
    required this.wardController,
  });

  final TextEditingController clinicController;
  final TextEditingController provinceController;
  final TextEditingController districtController;
  final TextEditingController wardController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionBlock(
      title: 'Clinic and location',
      icon: Symbols.location_on,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextField(
            label: 'Clinic',
            hint: 'Paste clinic ID',
            controller: clinicController,
            leadingIcon: Symbols.local_hospital,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TextField(
                  label: 'Province',
                  hint: 'ID',
                  controller: provinceController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TextField(
                  label: 'District',
                  hint: 'ID',
                  controller: districtController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TextField(
            label: 'Ward',
            hint: 'Optional ID',
            controller: wardController,
          ),
          const SizedBox(height: 10),
          Text(
            'Clinic and location directory pickers are not available yet, so this field accepts IDs from the selected clinic or location.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.onReset,
    required this.onApply,
    required this.resetLabel,
    required this.applyLabel,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final String resetLabel;
  final String applyLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  _SheetHeader(title: title, subtitle: subtitle),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                      shrinkWrap: true,
                      itemCount: children.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => children[index],
                    ),
                  ),
                  _ActionBar(
                    resetLabel: resetLabel,
                    applyLabel: applyLabel,
                    onReset: onReset,
                    onApply: onApply,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Symbols.close),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.resetLabel,
    required this.applyLabel,
    required this.onReset,
    required this.onApply,
  });

  final String resetLabel;
  final String applyLabel;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(resetLabel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: onApply,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(applyLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: colors.onPrimaryContainer),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    this.hint,
    this.leadingIcon,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
  });

  final String label;
  final String? hint;
  final IconData? leadingIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        prefixIcon: leadingIcon == null ? null : Icon(leadingIcon),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Clear',
              onPressed: controller.clear,
              icon: const Icon(Symbols.close),
            );
          },
        ),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasValue = value != null;
    final text = hasValue ? _formatDate(value!) : 'Select date';

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          onChanged(picked);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Symbols.calendar_month, size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: hasValue ? FontWeight.w700 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: colors.primaryContainer,
      backgroundColor: colors.surface,
      side: BorderSide(
        color: selected ? colors.primaryContainer : colors.outlineVariant,
      ),
      avatar: selected
          ? Icon(Symbols.check, size: 16, color: colors.onPrimaryContainer)
          : null,
      onSelected: (_) => onTap(),
    );
  }
}

class _QuickChips extends StatelessWidget {
  const _QuickChips({required this.chips});

  final List<_QuickChipData> chips;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final chip in chips)
          ActionChip(
            label: Text(chip.label),
            avatar: const Icon(Symbols.add, size: 16),
            onPressed: chip.onTap,
          ),
      ],
    );
  }
}

class _QuickChipData {
  const _QuickChipData({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}

String? _textOrNull(TextEditingController controller) {
  final value = controller.text.trim();
  return value.isEmpty ? null : value;
}

num? _numOrNull(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return num.tryParse(trimmed);
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
