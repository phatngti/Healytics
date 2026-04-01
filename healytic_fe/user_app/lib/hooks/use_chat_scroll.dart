import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Return type for the [useChatScroll] hook.
///
/// Bundles the scroll controller, FAB visibility,
/// and a convenience method to animate back to the
/// newest message.
class ChatScrollState {
  /// Controller to attach to a **reversed**
  /// `ListView`.
  final ScrollController controller;

  /// Whether the user has scrolled away from the
  /// newest messages (offset > [_kFabThreshold]).
  final bool showFab;

  /// Smoothly scrolls to the newest message
  /// (offset 0 in a reversed list).
  final VoidCallback scrollToBottom;

  const ChatScrollState({
    required this.controller,
    required this.showFab,
    required this.scrollToBottom,
  });
}

/// Threshold in logical pixels before the FAB
/// becomes visible.
const double _kFabThreshold = 80;

/// Duration of the scroll-to-bottom animation.
const Duration _kScrollDuration = Duration(
  milliseconds: 300,
);

/// Reusable hook for chat screens that use a
/// **`reverse: true`** `ListView`.
///
/// Provides:
/// - A [ScrollController] pre-wired for FAB
///   visibility toggling
/// - [showFab] state
/// - [scrollToBottom] helper (animates to offset 0)
///
/// Usage:
/// ```dart
/// final chat = useChatScroll();
///
/// ListView.builder(
///   controller: chat.controller,
///   reverse: true,
///   ...
/// );
///
/// if (chat.showFab) ChatScrollToBottomFab(
///   onTap: chat.scrollToBottom,
/// );
/// ```
ChatScrollState useChatScroll() {
  final controller = useScrollController();
  final showFab = useState(false);

  useEffect(() {
    void listener() {
      if (!controller.hasClients) return;
      // In a reversed list, offset > 0 means the
      // user scrolled away from the newest messages.
      showFab.value =
          controller.offset > _kFabThreshold;
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, [controller]);

  void scrollToBottom() {
    if (!controller.hasClients) return;
    controller.animateTo(
      0,
      duration: _kScrollDuration,
      curve: Curves.easeOutCubic,
    );
  }

  return ChatScrollState(
    controller: controller,
    showFab: showFab.value,
    scrollToBottom: scrollToBottom,
  );
}
