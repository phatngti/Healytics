import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';
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
        _sectionLabel(context, 'Pre-Service Guidelines'),
        AppDimens.verticalSmall,
        ..._guideControllers.asMap().entries.map(
          (entry) => _GuidelineRow(
            index: entry.key,
            controller: entry.value,
            onRemove: () => _removeGuideline(entry.key),
          ),
        ),
        AppDimens.verticalSmall,
        _AddButton(label: 'Add Guideline', onPressed: _addGuideline),
      ],
    );
  }

  void _addGuideline() {
    setState(() {
      _guideControllers.add(TextEditingController());
    });
  }

  void _removeGuideline(int index) {
    setState(() {
      _guideControllers[index].dispose();
      _guideControllers.removeAt(index);
    });
  }

  // ── Service Rules ───────────────────────────────

  Widget _buildRulesSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'Service Rules'),
        AppDimens.verticalSmall,
        ..._ruleControllers.asMap().entries.map(
          (entry) => _RuleRow(
            index: entry.key,
            controllers: entry.value,
            onRemove: () => _removeRule(entry.key),
          ),
        ),
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
    });
  }

  void _removeRule(int index) {
    setState(() {
      _ruleControllers[index].dispose();
      _ruleControllers.removeAt(index);
    });
  }

  // ── Procedure Steps ─────────────────────────────

  Widget _buildStepsSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'Procedure Steps'),
        AppDimens.verticalSmall,
        ..._stepControllers.asMap().entries.map(
          (entry) => _StepRow(
            index: entry.key,
            controllers: entry.value,
            onRemove: () => _removeStep(entry.key),
          ),
        ),
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
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  // ── Helpers ─────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  /// Extracts the current form values as a map
  /// that can be used by the parent screen.
  ///
  /// Returns `null` if all sections are empty.
  Map<String, dynamic>? extractFormData() {
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
              fieldKey: '${ServiceManualKey.guidelinePrefix}$index',
              label: 'Guideline ${index + 1}',
              hintText: 'e.g. Arrive 15 min early',
              controller: controller,
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
                width: 120,
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: '${ServiceManualKey.ruleIconPrefix}$index',
                  label: 'Icon Slug',
                  hintText: 'e.g. clock',
                  controller: controllers.icon,
                ),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: '${ServiceManualKey.ruleTitlePrefix}$index',
                  label: 'Title',
                  hintText: 'e.g. Punctuality',
                  controller: controllers.title,
                ),
              ),
              _RemoveButton(onPressed: onRemove),
            ],
          ),
          AppDimens.verticalExtraSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: '${ServiceManualKey.ruleDescPrefix}$index',
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
                  fieldKey: '${ServiceManualKey.stepTitlePrefix}$index',
                  label: 'Step Title',
                  hintText: 'e.g. Consultation',
                  controller: controllers.title,
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
              fieldKey: '${ServiceManualKey.stepDescPrefix}$index',
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
