import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

/// Bottom sheet for extra Services catalog filters.
class ProductFilterSheet extends StatefulWidget {
  const ProductFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  final ClinicProductFilters initialFilters;
  final ValueChanged<ClinicProductFilters> onApply;
  final VoidCallback onReset;

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _minDurationController;
  late final TextEditingController _maxDurationController;
  late bool _discountOnly;

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    _minPriceController = TextEditingController(
      text: _formatNumber(filters.minPrice),
    );
    _maxPriceController = TextEditingController(
      text: _formatNumber(filters.maxPrice),
    );
    _minDurationController = TextEditingController(
      text: filters.minDuration?.toString() ?? '',
    );
    _maxDurationController = TextEditingController(
      text: filters.maxDuration?.toString() ?? '',
    );
    _discountOnly = filters.discountOnly;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minDurationController.dispose();
    _maxDurationController.dispose();
    super.dispose();
  }

  String _formatNumber(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  double? _doubleFrom(TextEditingController controller) {
    return double.tryParse(controller.text.trim());
  }

  int? _intFrom(TextEditingController controller) {
    return int.tryParse(controller.text.trim());
  }

  ClinicProductFilters _currentFilters() {
    return ClinicProductFilters(
      minPrice: _doubleFrom(_minPriceController),
      maxPrice: _doubleFrom(_maxPriceController),
      minDuration: _intFrom(_minDurationController),
      maxDuration: _intFrom(_maxDurationController),
      discountOnly: _discountOnly,
    );
  }

  void _reset() {
    _minPriceController.clear();
    _maxPriceController.clear();
    _minDurationController.clear();
    _maxDurationController.clear();
    setState(() => _discountOnly = false);
    widget.onReset();
  }

  void _apply() {
    widget.onApply(_currentFilters());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimens.spaceLg,
          right: AppDimens.spaceLg,
          top: AppDimens.spaceLg,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppDimens.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filter services',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMd),
            _FieldRow(
              label: 'Price',
              first: _NumberField(controller: _minPriceController, hint: 'Min'),
              second: _NumberField(
                controller: _maxPriceController,
                hint: 'Max',
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            _FieldRow(
              label: 'Duration',
              first: _NumberField(
                controller: _minDurationController,
                hint: 'Min min',
              ),
              second: _NumberField(
                controller: _maxDurationController,
                hint: 'Max min',
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _discountOnly,
              onChanged: (value) => setState(() => _discountOnly = value),
              title: const Text('Discount only'),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: _apply,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.first,
    required this.second,
  });

  final String label;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppDimens.spaceXs),
        Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(child: second),
          ],
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
