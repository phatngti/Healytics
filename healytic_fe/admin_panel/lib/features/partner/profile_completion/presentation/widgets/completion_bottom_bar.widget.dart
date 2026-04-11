import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Sticky bottom bar with save draft / complete
/// profile actions and a responsive layout.
class CompletionBottomBarWidget
    extends StatelessWidget {
  const CompletionBottomBarWidget({
    required this.isBusy,
    required this.isSavingDraft,
    required this.isCompletingProfile,
    required this.isReadyToComplete,
    required this.requiredCompletedCount,
    required this.onSaveDraft,
    required this.onCompleteProfile,
    super.key,
  });

  final bool isBusy;
  final bool isSavingDraft;
  final bool isCompletingProfile;
  final bool isReadyToComplete;
  final int requiredCompletedCount;
  final VoidCallback onSaveDraft;
  final VoidCallback onCompleteProfile;

  /// Breakpoint for compact layout.
  static const double _compactBreakpoint = 720;

  /// Max content width to match the screen.
  static const double _maxContentWidth = 1100;

  /// Blur sigma for frosted glass effect.
  static const double _blurSigma = 16;

  /// Spinner size for the completing state.
  static const double _spinnerSize = 16;

  /// Spinner stroke width.
  static const double _spinnerStroke = 2;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blurSigma,
            sigmaY: _blurSigma,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceXxl,
              vertical: AppDimens.spaceLg,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme
                      .surfaceContainerLow
                      .withValues(alpha: 0.92)
                  : colorScheme.surface
                      .withValues(alpha: 0.88),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.4)
                      : colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.6),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow
                      .withValues(alpha: 0.12),
                  blurRadius: _blurSigma,
                  offset: const Offset(
                    0,
                    -AppDimens.spaceXs,
                  ),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: _maxContentWidth,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) {
                      final isCompact =
                          constraints.maxWidth <
                              _compactBreakpoint;
                      final actionButtons = Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: isBusy
                                ? null
                                : onSaveDraft,
                            child: Text(
                              isSavingDraft
                                  ? 'Saving...'
                                  : 'Save draft',
                            ),
                          ),
                          AppDimens
                              .horizontalMediumSmall,
                          FilledButton.icon(
                            onPressed: isBusy
                                ? null
                                : onCompleteProfile,
                            icon: isCompletingProfile
                                ? SizedBox(
                                    width:
                                        _spinnerSize,
                                    height:
                                        _spinnerSize,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          _spinnerStroke,
                                      color: colorScheme
                                          .onPrimary,
                                    ),
                                  )
                                : const Icon(
                                    Icons
                                        .arrow_forward_rounded,
                                  ),
                            label: Text(
                              isCompletingProfile
                                  ? 'Completing...'
                                  : 'Complete '
                                      'profile',
                            ),
                          ),
                        ],
                      );

                      final summary = Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            isReadyToComplete
                                ? 'All required '
                                    'sections '
                                    'are ready.'
                                : 'Complete the '
                                    'required '
                                    'fields to '
                                    'unlock the '
                                    'dashboard.',
                            style: textTheme
                                .titleSmall
                                ?.copyWith(
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          AppDimens
                              .verticalExtraSmall,
                          Text(
                            'Required '
                            'completion: '
                            '$requiredCompletedCount'
                            '/4',
                            style: textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      );

                      if (isCompact) {
                        return Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,
                          children: [
                            summary,
                            const SizedBox(
                              height: AppDimens
                                  .spaceMdLg,
                            ),
                            SizedBox(
                              width:
                                  double.infinity,
                              child:
                                  actionButtons,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: summary,
                          ),
                          actionButtons,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
