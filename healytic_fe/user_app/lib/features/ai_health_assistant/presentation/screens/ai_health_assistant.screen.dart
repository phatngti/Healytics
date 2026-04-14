import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/router/routes.dart';

import '../widgets/ai_health_assistant/ai_hero_section.widget.dart';
import '../widgets/ai_health_assistant/capabilities_grid.widget.dart';
import '../widgets/ai_health_assistant/start_conversation_button.widget.dart';

/// AI Health Assistant landing page that showcases
/// the assistant's capabilities and lets the user
/// start a conversation via the existing chat flow.
class AiHealthAssistantScreen extends StatelessWidget {
  const AiHealthAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final hPad =
        AppDimens.horizontalPadding(context);
    final sectionGap =
        AppDimens.sectionSpacing(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const Text('AI Health Assistant'),
        centerTitle: true,
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(
                minScaleFactor: 0.8,
                maxScaleFactor: 1.3,
              ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: hPad,
            vertical: AppDimens.spaceLg,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Hero header
              const AiHeroSection(),
              SizedBox(height: sectionGap),

              // Capabilities grid
              const CapabilitiesGrid(),
              SizedBox(height: sectionGap),

              // CTA button
              StartConversationButton(
                onPressed: () {
                  const ChatRoute().push(context);
                },
              ),
              SizedBox(height: sectionGap),

              // Disclaimer
              _DisclaimerSection(),
              SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small disclaimer at the bottom reminding users
/// that the AI assistant is not a substitute for
/// professional medical advice.
class _DisclaimerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(
        AppDimens.cardPadding(context),
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(
          AppDimens.cardRadius(context),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: AppDimens.iconMd,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              'This AI assistant provides general '
              'health information only. It is not a '
              'substitute for professional medical '
              'advice, diagnosis, or treatment.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
