import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A reusable error card that displays structured error
/// information including the error message, source location,
/// and an expandable full stack trace.
///
/// Place this widget inside a `Center` or `Scaffold.body`
/// when handling `AsyncValue.error` states.
///
/// ```dart
/// asyncValue.when(
///   data: (data) => ...,
///   loading: () => ...,
///   error: (error, stack) => Center(
///     child: ErrorCard(
///       title: 'Failed to load data',
///       error: error,
///       stackTrace: stack,
///       onRetry: () => ref.invalidate(provider),
///     ),
///   ),
/// );
/// ```
class ErrorCard extends StatefulWidget {
  /// Creates an [ErrorCard].
  ///
  /// - [title] — A concise user-facing failure description.
  /// - [error] — The raw error object.
  /// - [stackTrace] — Optional stack trace for debugging.
  /// - [onRetry] — Callback for the retry button. If null,
  ///   the retry button is hidden.
  const ErrorCard({
    super.key,
    required this.title,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  /// User-facing title for the error (e.g. "Failed to load
  /// dashboard").
  final String title;

  /// The raw error object thrown by the failed operation.
  final Object error;

  /// Optional stack trace associated with the error.
  final StackTrace? stackTrace;

  /// Callback invoked when the user taps "Retry". If null
  /// the retry button is not shown.
  final VoidCallback? onRetry;

  @override
  State<ErrorCard> createState() => _ErrorCardState();
}

class _ErrorCardState extends State<ErrorCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _animationController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Extracts the originating class name from the stack
  /// trace, if available.
  String? get _className {
    final trace = widget.stackTrace;
    if (trace == null) return null;
    return _parseFirstFrame(trace.toString())?.className;
  }

  /// Extracts the core error message from [widget.error],
  /// prefixed with the originating class name when available.
  ///
  /// Format: `[ClassName]: [Error message]`
  String get _errorMessage {
    final error = widget.error;
    final message = error is FlutterError
        ? error.message
        : error.toString();
    final cls = _className;
    if (cls != null && cls.isNotEmpty) {
      return '$cls: $message';
    }
    return message;
  }

  /// Attempts to extract the originating file name from
  /// the stack trace.
  String? get _fileName {
    final trace = widget.stackTrace;
    if (trace == null) return null;
    return _parseFirstFrame(trace.toString())?.fileName;
  }

  /// Attempts to extract the originating line number from
  /// the stack trace.
  String? get _lineInfo {
    final trace = widget.stackTrace;
    if (trace == null) return null;
    return _parseFirstFrame(trace.toString())?.lineInfo;
  }

  /// Formats the full stack trace for the expandable section.
  String get _fullStackTrace {
    if (widget.stackTrace == null) return 'No stack trace';
    return widget.stackTrace.toString();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimens.radiusMedium,
          side: BorderSide(
            color: colorScheme.error.withValues(alpha: 0.3),
          ),
        ),
        color: colorScheme.errorContainer.withValues(
          alpha: 0.15,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
              _ErrorIcon(color: colorScheme.error),
              AppDimens.verticalMedium,

              // Title
              Text(
                widget.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              AppDimens.verticalSmall,

              // Error message
              _ErrorMessageChip(
                message: _errorMessage,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              AppDimens.verticalSmall,

              // Source location (file + line)
              if (_fileName != null) ...[
                _SourceLocationRow(
                  fileName: _fileName!,
                  lineInfo: _lineInfo,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                AppDimens.verticalMedium,
              ],

              // Show more / less toggle
              if (widget.stackTrace != null) ...[
                _StackTraceToggle(
                  isExpanded: _isExpanded,
                  onToggle: _toggleExpanded,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1,
                  child: _StackTraceContent(
                    stackTrace: _fullStackTrace,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
                AppDimens.verticalMedium,
              ],

              // Retry button
              if (widget.onRetry != null)
                FilledButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Private sub-widgets
// ════════════════════════════════════════════════════════

class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 32,
        color: color,
      ),
    );
  }
}

class _ErrorMessageChip extends StatelessWidget {
  const _ErrorMessageChip({
    required this.message,
    required this.colorScheme,
    required this.textTheme,
  });

  final String message;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.bug_report_outlined,
            size: 16,
            color: colorScheme.error,
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: SelectableText(
              message,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
                height: 1.5,
              ),
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceLocationRow extends StatelessWidget {
  const _SourceLocationRow({
    required this.fileName,
    required this.lineInfo,
    required this.colorScheme,
    required this.textTheme,
  });

  final String fileName;
  final String? lineInfo;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          AppDimens.horizontalExtraSmall,
          Expanded(
            child: Text(
              fileName,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (lineInfo != null) ...[
            AppDimens.horizontalSmall,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: AppDimens.radiusExtraSmall,
              ),
              child: Text(
                lineInfo!,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StackTraceToggle extends StatelessWidget {
  const _StackTraceToggle({
    required this.isExpanded,
    required this.onToggle,
    required this.colorScheme,
    required this.textTheme,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: AppDimens.radiusSmall,
      child: Padding(
        padding: AppDimens.paddingAllExtraSmall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
            AppDimens.horizontalExtraSmall,
            Text(
              isExpanded ? 'Show less' : 'Show more',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackTraceContent extends StatelessWidget {
  const _StackTraceContent({
    required this.stackTrace,
    required this.colorScheme,
    required this.textTheme,
  });

  final String stackTrace;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 240),
        padding: AppDimens.paddingAllMediumSmall,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            stackTrace,
            style: textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontSize: 11,
              height: 1.6,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Stack trace parsing utilities
// ════════════════════════════════════════════════════════

/// Parsed result from a single stack trace frame.
class _FrameInfo {
  const _FrameInfo({
    required this.fileName,
    this.lineInfo,
    this.className,
  });

  /// Source file name (e.g. "dashboard.provider.dart").
  final String fileName;

  /// Line + column info (e.g. "line 42:8").
  final String? lineInfo;

  /// Originating class name (e.g. "DashboardNotifier").
  final String? className;
}

/// Parses the first meaningful frame from a stack trace
/// string to extract file name and line information.
///
/// Handles both VM-style frames:
///   `#0  FooClass.method (package:app/foo.dart:42:8)`
/// and web-style frames:
///   `packages/app/foo.dart 42:8`
_FrameInfo? _parseFirstFrame(String traceString) {
  final lines = traceString.split('\n').where(
    (l) => l.trim().isNotEmpty,
  );

  for (final line in lines) {
    // Skip framework / generated frames for relevance
    if (line.contains('package:flutter/') ||
        line.contains('package:hooks_riverpod/') ||
        line.contains('package:riverpod/') ||
        line.contains('dart:') ||
        line.contains('.g.dart')) {
      continue;
    }

    // VM-style: #N  Class.method (package:foo/bar.dart:42:8)
    final vmMatch = RegExp(
      r'#\d+\s+(\S+)\s+\((.+?):(\d+):(\d+)\)',
    ).firstMatch(line);
    if (vmMatch != null) {
      final methodPart = vmMatch.group(1)!;
      final fullPath = vmMatch.group(2)!;
      final lineNum = vmMatch.group(3)!;
      final col = vmMatch.group(4)!;
      final fileName = fullPath.split('/').last;
      final cls = _extractClassName(methodPart);
      return _FrameInfo(
        fileName: fileName,
        lineInfo: 'line $lineNum:$col',
        className: cls,
      );
    }

    // Web-style: packages/foo/bar.dart 42:8  Class.method
    final webMatch = RegExp(
      r'(\S+\.dart)\s+(\d+):(\d+)',
    ).firstMatch(line);
    if (webMatch != null) {
      final fullPath = webMatch.group(1)!;
      final lineNum = webMatch.group(2)!;
      final col = webMatch.group(3)!;
      final fileName = fullPath.split('/').last;
      // Try to extract class from web frame method
      final webCls = _extractWebClassName(line);
      return _FrameInfo(
        fileName: fileName,
        lineInfo: 'line $lineNum:$col',
        className: webCls,
      );
    }
  }

  // Fallback: parse first frame regardless
  if (lines.isNotEmpty) {
    final first = lines.first;
    final fallbackMatch = RegExp(
      r'\((.+?):(\d+):(\d+)\)',
    ).firstMatch(first);
    if (fallbackMatch != null) {
      final fullPath = fallbackMatch.group(1)!;
      final lineNum = fallbackMatch.group(2)!;
      final col = fallbackMatch.group(3)!;
      final fileName = fullPath.split('/').last;
      return _FrameInfo(
        fileName: fileName,
        lineInfo: 'line $lineNum:$col',
      );
    }
  }

  return null;
}

/// Extracts the class name from a VM-style method
/// identifier like `ClassName.method` or
/// `ClassName.method.<closure>`.
String? _extractClassName(String methodPart) {
  final dotIndex = methodPart.indexOf('.');
  if (dotIndex <= 0) return null;
  final candidate = methodPart.substring(0, dotIndex);
  // Ignore if it starts with lowercase (top-level fn)
  if (candidate.isEmpty) return null;
  final first = candidate.codeUnitAt(0);
  if (first >= 65 && first <= 90) return candidate; // A-Z
  return null;
}

/// Extracts a class name from a web-style stack frame.
///
/// Web frames often look like:
///   `packages/app/foo.dart 42:8  ClassName.method`
String? _extractWebClassName(String line) {
  // Method part is typically after the line:col info
  final match = RegExp(
    r'\d+:\d+\s+(\S+)',
  ).firstMatch(line);
  if (match == null) return null;
  return _extractClassName(match.group(1)!);
}
