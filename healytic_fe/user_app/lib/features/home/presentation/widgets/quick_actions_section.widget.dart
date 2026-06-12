import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/router/routes.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleGap = AppDimens.titleGap(context);
    final cardGap = AppDimens.adaptive(
      context,
      small: AppDimens.spaceSmMd,
      medium: AppDimens.spaceLg,
      large: AppDimens.spaceLg,
    );
    final cardHeight = AppDimens.adaptive(
      context,
      small: 176,
      medium: 184,
      large: 192,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: titleGap),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: _QuickActionCard(
                  cardKey: keys.homePage.bookAppointmentAction,
                  icon: Symbols.calendar_add_on,
                  iconColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  title: 'Book Appointment',
                  subtitle: 'Quick booking with AI suggestions',
                  onTap: () {
                    const BookAppointmentRoute().push(context);
                  },
                ),
              ),
            ),
            SizedBox(width: cardGap),
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: _QuickActionCard(
                  cardKey: keys.homePage.aiAssistantAction,
                  icon: Symbols.smart_toy,
                  iconColor: theme.colorScheme.secondary,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  title: 'AI Health Assistant',
                  subtitle: 'Get instant health guidance',
                  onTap: () {
                    const AiHealthAssistantRoute().push(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final Key? cardKey;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    this.cardKey,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardPad = AppDimens.cardPadding(context);
    final cardRad = AppDimens.cardRadius(context);

    // Adaptive icon container size.
    final iconBoxSize = AppDimens.adaptive(
      context,
      small: AppDimens.ctaButtonMd,
      medium: AppDimens.avatarMd,
      large: AppDimens.avatarMd,
    );

    // Adaptive gap between icon and text.
    final iconTextGap = AppDimens.adaptive(
      context,
      small: AppDimens.spaceSmMd,
      medium: AppDimens.spaceLg,
      large: AppDimens.spaceLg,
    );

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        key: cardKey,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(cardPad),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(cardRad),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: AppDimens.spaceSm,
                offset: Offset(0, AppDimens.spaceXs),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: iconBoxSize,
                width: iconBoxSize,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: AppDimens.spaceXxs,
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: AppDimens.iconLg),
              ),
              SizedBox(height: iconTextGap),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.adaptive(
                    context,
                    small: AppDimens.spaceMdLg,
                    medium: AppDimens.spaceLg,
                    large: AppDimens.spaceLg,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimens.spaceXs),
              Flexible(
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
