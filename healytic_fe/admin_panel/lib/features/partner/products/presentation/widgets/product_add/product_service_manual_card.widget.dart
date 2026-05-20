import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/service_rule_icon_data.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';

/// A card widget for editing the service manual
/// section of a health service product.
///
/// Contains three dynamic-list sub-sections:
/// 1. Pre-Service Guidelines (simple text list)
/// 2. Service Rules (iconSlug, title, description)
/// 3. Procedure Steps (auto-numbered, title, desc)
///
/// Each row's required fields are validated on submit
/// via [validate]. Section titles show a red asterisk
/// to indicate required fields within.
class ProductServiceManualCard extends StatefulWidget {
  const ProductServiceManualCard({
    super.key,
    this.initialGuidelines = const [],
    this.initialRules = const [],
    this.initialSteps = const [],
  });

  /// Pre-populated guidelines for edit mode.
  final List<String> initialGuidelines;

  /// Pre-populated rules for edit mode.
  /// Each map: {iconSlug, title, description}.
  final List<Map<String, String>> initialRules;

  /// Pre-populated steps for edit mode.
  /// Each map: {title, description}.
  final List<Map<String, String>> initialSteps;

  @override
  State<ProductServiceManualCard> createState() =>
      ProductServiceManualCardState();
}

class ProductServiceManualCardState extends State<ProductServiceManualCard> {
  late List<TextEditingController> _guideControllers;
  late List<_RuleControllers> _ruleControllers;
  late List<_StepControllers> _stepControllers;

  /// Per-section error messages shown after validation.
  String? _guidelineError;
  String? _ruleError;
  String? _stepError;

  /// Whether the current manual content differs from the edit-mode baseline.
  bool get hasChanges =>
      !_sameManualData(_manualDataFromControllers(), _initialManualData());

  @override
  void initState() {
    super.initState();
    _guideControllers = widget.initialGuidelines
        .map((g) => TextEditingController(text: g))
        .toList();
    _ruleControllers = widget.initialRules
        .map(
          (r) => _RuleControllers(
            icon: TextEditingController(
              text: r[ServiceManualKey.iconSlug] ?? '',
            ),
            title: TextEditingController(text: r[ServiceManualKey.title] ?? ''),
            desc: TextEditingController(
              text: r[ServiceManualKey.description] ?? '',
            ),
          ),
        )
        .toList();
    _stepControllers = widget.initialSteps
        .map(
          (s) => _StepControllers(
            title: TextEditingController(text: s[ServiceManualKey.title] ?? ''),
            desc: TextEditingController(
              text: s[ServiceManualKey.description] ?? '',
            ),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final c in _guideControllers) {
      c.dispose();
    }
    for (final r in _ruleControllers) {
      r.dispose();
    }
    for (final s in _stepControllers) {
      s.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
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
            padding: AppDimens.paddingAllLarge,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Manual',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'Guidelines, rules, and procedure '
                  'steps for this service.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuidelinesSection(context, colorScheme),
                AppDimens.verticalLarge,
                _buildRulesSection(context, colorScheme),
                AppDimens.verticalLarge,
                _buildStepsSection(context, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Pre-Service Guidelines ──────────────────────

  Widget _buildGuidelinesSection(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'Pre-Service Guidelines', isRequired: true),
        AppDimens.verticalSmall,
        ..._guideControllers.asMap().entries.map(
          (entry) => _GuidelineRow(
            index: entry.key,
            controller: entry.value,
            onRemove: () => _removeGuideline(entry.key),
          ),
        ),
        if (_guidelineError != null) _ErrorText(message: _guidelineError!),
        AppDimens.verticalSmall,
        _AddButton(label: 'Add Guideline', onPressed: _addGuideline),
      ],
    );
  }

  void _addGuideline() {
    setState(() {
      _guideControllers.add(TextEditingController());
      _guidelineError = null;
    });
  }

  void _removeGuideline(int index) {
    setState(() {
      _guideControllers[index].dispose();
      _guideControllers.removeAt(index);
      _guidelineError = null;
    });
  }

  // ── Service Rules ───────────────────────────────

  Widget _buildRulesSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'Service Rules', isRequired: true),
        AppDimens.verticalSmall,
        ..._ruleControllers.asMap().entries.map(
          (entry) => _RuleRow(
            index: entry.key,
            controllers: entry.value,
            onRemove: () => _removeRule(entry.key),
          ),
        ),
        if (_ruleError != null) _ErrorText(message: _ruleError!),
        AppDimens.verticalSmall,
        _AddButton(label: 'Add Rule', onPressed: _addRule),
      ],
    );
  }

  void _addRule() {
    setState(() {
      _ruleControllers.add(
        _RuleControllers(
          icon: TextEditingController(),
          title: TextEditingController(),
          desc: TextEditingController(),
        ),
      );
      _ruleError = null;
    });
  }

  void _removeRule(int index) {
    setState(() {
      _ruleControllers[index].dispose();
      _ruleControllers.removeAt(index);
      _ruleError = null;
    });
  }

  // ── Procedure Steps ─────────────────────────────

  Widget _buildStepsSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'Procedure Steps', isRequired: true),
        AppDimens.verticalSmall,
        ..._stepControllers.asMap().entries.map(
          (entry) => _StepRow(
            index: entry.key,
            controllers: entry.value,
            onRemove: () => _removeStep(entry.key),
          ),
        ),
        if (_stepError != null) _ErrorText(message: _stepError!),
        AppDimens.verticalSmall,
        _AddButton(label: 'Add Step', onPressed: _addStep),
      ],
    );
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(
        _StepControllers(
          title: TextEditingController(),
          desc: TextEditingController(),
        ),
      );
      _stepError = null;
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
      _stepError = null;
    });
  }

  // ── Helpers ─────────────────────────────────────

  /// Renders a section label with an optional
  /// red asterisk for required sections.
  Widget _sectionLabel(
    BuildContext context,
    String text, {
    bool isRequired = false,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  /// Validates all rows for required field
  /// completeness. Returns `true` when valid.
  ///
  /// Call before [extractFormData] on form submit.
  bool validate() {
    var isValid = true;

    // Guidelines: each added row must have text.
    final emptyGuides = _guideControllers
        .where((c) => c.text.trim().isEmpty)
        .length;
    if (emptyGuides > 0) {
      _guidelineError =
          '$emptyGuides guideline(s) are empty. '
          'Please fill in or remove them.';
      isValid = false;
    } else {
      _guidelineError = null;
    }

    // Rules: each added row must have a title.
    final emptyRuleTitles = _ruleControllers
        .where((r) => r.title.text.trim().isEmpty)
        .length;
    if (emptyRuleTitles > 0) {
      _ruleError =
          '$emptyRuleTitles rule(s) are missing a title. '
          'Please fill in or remove them.';
      isValid = false;
    } else {
      _ruleError = null;
    }

    // Steps: each added row must have a title.
    final emptyStepTitles = _stepControllers
        .where((s) => s.title.text.trim().isEmpty)
        .length;
    if (emptyStepTitles > 0) {
      _stepError =
          '$emptyStepTitles step(s) are missing a title. '
          'Please fill in or remove them.';
      isValid = false;
    } else {
      _stepError = null;
    }

    setState(() {});
    return isValid;
  }

  /// Extracts the current form values as a map
  /// that can be used by the parent screen.
  ///
  /// Returns `null` if all sections are empty.
  Map<String, dynamic>? extractFormData() {
    return _manualDataFromControllers();
  }

  Map<String, dynamic>? _manualDataFromControllers() {
    final guidelines = _guideControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final rules = _ruleControllers
        .map(
          (r) => {
            ServiceManualKey.iconSlug: r.icon.text.trim(),
            ServiceManualKey.title: r.title.text.trim(),
            ServiceManualKey.description: r.desc.text.trim(),
          },
        )
        .where((m) => m[ServiceManualKey.title]!.isNotEmpty)
        .toList();
    final steps = _stepControllers
        .map(
          (s) => {
            ServiceManualKey.title: s.title.text.trim(),
            ServiceManualKey.description: s.desc.text.trim(),
          },
        )
        .where((m) => m[ServiceManualKey.title]!.isNotEmpty)
        .toList();

    if (guidelines.isEmpty && rules.isEmpty && steps.isEmpty) {
      return null;
    }

    return {
      ServiceManualKey.guidelines: guidelines,
      ServiceManualKey.rules: rules,
      ServiceManualKey.steps: steps,
    };
  }

  Map<String, dynamic>? _initialManualData() {
    final guidelines = widget.initialGuidelines
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final rules = widget.initialRules
        .map(
          (r) => {
            ServiceManualKey.iconSlug: (r[ServiceManualKey.iconSlug] ?? '')
                .trim(),
            ServiceManualKey.title: (r[ServiceManualKey.title] ?? '').trim(),
            ServiceManualKey.description:
                (r[ServiceManualKey.description] ?? '').trim(),
          },
        )
        .where((r) => r[ServiceManualKey.title]!.isNotEmpty)
        .toList();
    final steps = widget.initialSteps
        .map(
          (s) => {
            ServiceManualKey.title: (s[ServiceManualKey.title] ?? '').trim(),
            ServiceManualKey.description:
                (s[ServiceManualKey.description] ?? '').trim(),
          },
        )
        .where((s) => s[ServiceManualKey.title]!.isNotEmpty)
        .toList();

    if (guidelines.isEmpty && rules.isEmpty && steps.isEmpty) {
      return null;
    }

    return {
      ServiceManualKey.guidelines: guidelines,
      ServiceManualKey.rules: rules,
      ServiceManualKey.steps: steps,
    };
  }

  bool _sameManualData(
    Map<String, dynamic>? current,
    Map<String, dynamic>? initial,
  ) {
    return _sameStringList(
          current?[ServiceManualKey.guidelines] as List<String>? ?? const [],
          initial?[ServiceManualKey.guidelines] as List<String>? ?? const [],
        ) &&
        _sameStringMapList(
          current?[ServiceManualKey.rules] as List<Map<String, String>>? ??
              const [],
          initial?[ServiceManualKey.rules] as List<Map<String, String>>? ??
              const [],
        ) &&
        _sameStringMapList(
          current?[ServiceManualKey.steps] as List<Map<String, String>>? ??
              const [],
          initial?[ServiceManualKey.steps] as List<Map<String, String>>? ??
              const [],
        );
  }

  bool _sameStringList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _sameStringMapList(
    List<Map<String, String>> a,
    List<Map<String, String>> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final left = a[i];
      final right = b[i];
      if (left.length != right.length) return false;
      for (final key in left.keys) {
        if (left[key] != right[key]) return false;
      }
    }
    return true;
  }
}

// ── Private Row Widgets ───────────────────────────

class _GuidelineRow extends StatelessWidget {
  const _GuidelineRow({
    required this.index,
    required this.controller,
    required this.onRemove,
  });

  final int index;
  final TextEditingController controller;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimens.paddingVerticalExtraSmall,
      child: Row(
        children: [
          Expanded(
            child: FormFieldBuilders.buildTextField(
              context,
              fieldKey:
                  '${ServiceManualKey.guidelinePrefix}'
                  '$index',
              label: 'Guideline ${index + 1}',
              hintText: 'e.g. Arrive 15 min early',
              controller: controller,
              isRequired: true,
            ),
          ),
          _RemoveButton(onPressed: onRemove),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({
    required this.index,
    required this.controllers,
    required this.onRemove,
  });

  final int index;
  final _RuleControllers controllers;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimens.paddingVerticalExtraSmall,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 112,
                child: _IconSlugField(controller: controllers.icon),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey:
                      '${ServiceManualKey.ruleTitlePrefix}'
                      '$index',
                  label: 'Title',
                  hintText: 'e.g. Punctuality',
                  controller: controllers.title,
                  isRequired: true,
                ),
              ),
              _RemoveButton(onPressed: onRemove),
            ],
          ),
          AppDimens.verticalExtraSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey:
                '${ServiceManualKey.ruleDescPrefix}'
                '$index',
            label: 'Description',
            hintText: 'Rule details…',
            controller: controllers.desc,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _IconSlugField extends StatelessWidget {
  const _IconSlugField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final icon = serviceRuleIconData(value.text);
        final colorScheme = Theme.of(context).colorScheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'ICON SLUG',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Select service rule icon',
              value: normalizeServiceRuleIconSlug(value.text),
              child: InkWell(
                onTap: () => _showPicker(context),
                borderRadius: AppDimens.radiusSmall,
                child: InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppDimens.paddingVerticalSmall.top * 1.5,
                      horizontal: AppDimens.paddingHorizontalSmall.left,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppDimens.radiusSmall,
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppDimens.radiusSmall,
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  child: SizedBox(
                    height: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Icon(
                              icon ?? Icons.apps_outlined,
                              size: 24,
                              color: icon == null
                                  ? colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.55,
                                    )
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
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
          _MaterialIconPickerDialog(initialSlug: controller.text),
    );
    if (selected == null) {
      return;
    }

    controller.text = selected;
  }
}

class _MaterialIconPickerDialog extends StatefulWidget {
  const _MaterialIconPickerDialog({required this.initialSlug});

  final String initialSlug;

  @override
  State<_MaterialIconPickerDialog> createState() =>
      _MaterialIconPickerDialogState();
}

class _MaterialIconPickerDialogState extends State<_MaterialIconPickerDialog> {
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
    final normalizedQuery = normalizeServiceRuleIconSlug(_query);
    final options = normalizedQuery.isEmpty
        ? serviceRuleIconOptions
        : serviceRuleIconOptions
              .where((option) => option.slug.contains(normalizedQuery))
              .toList();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
        child: Padding(
          padding: AppDimens.paddingAllLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Material Icon',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              AppDimens.verticalSmall,
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
              Expanded(
                child: options.isEmpty
                    ? Center(
                        child: Text(
                          'No icons found',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
                          final initialIcon = serviceRuleIconData(
                            widget.initialSlug,
                          );
                          final isSelected =
                              option.slug ==
                                  normalizeServiceRuleIconSlug(
                                    widget.initialSlug,
                                  ) ||
                              option.icon == initialIcon;

                          return _MaterialIconOptionTile(
                            option: option,
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.of(context).pop(option.slug);
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

class _MaterialIconOptionTile extends StatelessWidget {
  const _MaterialIconOptionTile({
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.controllers,
    required this.onRemove,
  });

  final int index;
  final _StepControllers controllers;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppDimens.paddingVerticalExtraSmall,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey:
                      '${ServiceManualKey.stepTitlePrefix}'
                      '$index',
                  label: 'Step Title',
                  hintText: 'e.g. Consultation',
                  controller: controllers.title,
                  isRequired: true,
                ),
              ),
              _RemoveButton(onPressed: onRemove),
            ],
          ),
          AppDimens.verticalExtraSmall,
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: FormFieldBuilders.buildTextField(
              context,
              fieldKey:
                  '${ServiceManualKey.stepDescPrefix}'
                  '$index',
              label: 'Description',
              hintText: 'Step details…',
              controller: controllers.desc,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: AppDimens.paddingHorizontalSmall,
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, size: 18),
      onPressed: onPressed,
      tooltip: 'Remove',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

/// Inline error text shown below a section
/// when validation fails.
class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      ),
    );
  }
}

// ── Controller Groups ─────────────────────────────

class _RuleControllers {
  _RuleControllers({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final TextEditingController icon;
  final TextEditingController title;
  final TextEditingController desc;

  void dispose() {
    icon.dispose();
    title.dispose();
    desc.dispose();
  }
}

class _StepControllers {
  _StepControllers({required this.title, required this.desc});

  final TextEditingController title;
  final TextEditingController desc;

  void dispose() {
    title.dispose();
    desc.dispose();
  }
}
