import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

final class SurveyTextStyles {
  const SurveyTextStyles._();

  static TextStyle? sectionTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: AppDimens.fontSizeExtraExtraExtraExtraLarge,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );
  }

  static TextStyle? questionLabel(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: AppDimens.fontSizeLarge,
      fontWeight: FontWeight.w700,
      height: 1.35,
    );
  }

  static TextStyle? optionText(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontSize: AppDimens.fontSizeLarge,
      height: 1.3,
    );
  }
}
