import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

class FeatureBanner extends StatelessWidget {
  const FeatureBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bannerPad = AppDimens.bannerPadding(context);
    final cardRad = AppDimens.cardRadius(context);

    // Proportional decorative elements.
    final decorCircleSize = AppDimens.decorSize(
      context,
      small: 120,
      large: 160,
    );
    final decorIconSize = AppDimens.decorSize(context, small: 100, large: 140);

    return Semantics(
      label: 'AI Health Assistant banner',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRad),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.tertiary],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.tertiary.withValues(alpha: 0.2),
              blurRadius: AppDimens.spaceSmMd,
              offset: Offset(0, AppDimens.spaceXs),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardRad),
          child: Stack(
            children: [
              // Background decorations — scaled proportionally.
              Positioned(
                right: -AppDimens.spaceXxl,
                bottom: -AppDimens.spaceXxl,
                child: Container(
                  width: decorCircleSize,
                  height: decorCircleSize,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(AppDimens.spaceLg, AppDimens.spaceLg),
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(
                      Symbols.smart_toy,
                      size: decorIconSize,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(bannerPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Symbols.auto_awesome,
                                color: colorScheme.onPrimary,
                                size: AppDimens.iconSmMd,
                              ),
                              SizedBox(width: AppDimens.spaceSm),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimens.spaceSm,
                                    vertical: AppDimens.spaceXxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onPrimary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: AppDimens.radiusPill,
                                  ),
                                  child: Text(
                                    'NEW FEATURE',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimens.spaceSm),
                          Text(
                            'AI Health Assistant',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimens.spaceXs),
                          Text(
                            'Available 24/7 for guidance',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: AppDimens.adaptive(
                              context,
                              small: AppDimens.spaceMd,
                              medium: AppDimens.spaceLg,
                              large: AppDimens.spaceLg,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.onPrimary,
                              foregroundColor: colorScheme.primary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDimens.radiusPill,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.buttonPaddingH(context),
                                vertical: AppDimens.buttonPaddingV(context),
                              ),
                            ),
                            child: Text(
                              'Start Chat',
                              style: textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: AppDimens.spaceSm),
                          child: Icon(
                            Symbols.forum,
                            size: AppDimens.decorSize(
                              context,
                              small: AppDimens.avatarMd,
                              large: 64,
                            ),
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
