/// JSON keys for service manual map entries.
///
/// Usage:
/// ```dart
/// final guidelines =
///     data[ServiceManualKey.guidelines] as List;
/// final rules =
///     data[ServiceManualKey.rules] as List;
/// ```
abstract final class ServiceManualKey {
  // ── Data map keys ──────────────────────────────
  static const guidelines = 'guidelines';
  static const rules = 'rules';
  static const steps = 'steps';
  static const iconSlug = 'iconSlug';
  static const title = 'title';
  static const description = 'description';

  // ── Form field prefixes (indexed) ──────────────
  static const guidelinePrefix = 'guideline_';
  static const ruleIconPrefix = 'rule_icon_';
  static const ruleTitlePrefix = 'rule_title_';
  static const ruleDescPrefix = 'rule_desc_';
  static const stepTitlePrefix = 'step_title_';
  static const stepDescPrefix = 'step_desc_';
}
