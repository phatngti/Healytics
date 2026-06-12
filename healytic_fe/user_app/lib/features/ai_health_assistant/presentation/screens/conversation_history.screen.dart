import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

import '../providers/conversation_history.provider.dart';
import '../widgets/history/chat_type_selector.widget.dart';
import '../widgets/history/date_section.widget.dart';
import '../widgets/history/history_empty_state.widget.dart';
import '../widgets/history/new_chat_fab.widget.dart';
import '../widgets/history/partner_date_section.widget.dart';

/// Conversation history page listing past chatbot
/// and partner chat sessions grouped by date.
///
/// Uses [MainScreenLayout] for consistent
/// header/background across navigation tabs.
///
/// Composes:
/// - Standardised [AppBar] with search toggle
///   action.
/// - [ChatTypeSelector] segmented tab bar.
/// - Body: date-grouped list of conversations,
///   switching content based on the selected
///   [ChatType].
/// - [NewChatFab] to start a new conversation.
///
/// All dimensions use [AppDimens]; all colours from
/// the active [ColorScheme].
class ConversationHistoryScreen extends HookConsumerWidget {
  const ConversationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final isSearching = useState(false);
    final selectedChatType = useState(ChatType.aiSession);

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        ref.read(conversationHistoryProvider.notifier).refresh();
      });
      return null;
    }, const []);

    void toggleSearch() {
      isSearching.value = !isSearching.value;
      if (!isSearching.value) {
        searchController.clear();
        ref.read(conversationHistoryProvider.notifier).updateSearchQuery('');
      }
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final historyState = ref.watch(conversationHistoryProvider);

    return MainScreenLayout(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: isSearching.value
            ? _SearchField(
                controller: searchController,
                textTheme: textTheme,
                colorScheme: colorScheme,
                onChanged: (value) {
                  ref
                      .read(conversationHistoryProvider.notifier)
                      .updateSearchQuery(value);
                },
              )
            : Text(
                'Chat History',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightSemiBold,
                  color: colorScheme.onSurface,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching.value ? Icons.close : Icons.search,
              color: colorScheme.primary,
            ),
            tooltip: isSearching.value ? 'Close search' : 'Search',
            onPressed: toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          ChatTypeSelector(
            selected: selectedChatType.value,
            onChanged: (type) {
              selectedChatType.value = type;
            },
          ),
          Expanded(
            child: selectedChatType.value == ChatType.aiSession
                ? _buildAiBody(context, historyState, colorScheme)
                : _buildPartnerBody(context, historyState, colorScheme),
          ),
        ],
      ),
      floatingActionButton: NewChatFab(
        tapKey: keys.chatScreen.newChatButton,
        onPressed: () {
          const ChatRoute().go(context);
        },
      ),
    );
  }

  // ── AI Session Tab ────────────────────────────

  Widget _buildAiBody(
    BuildContext context,
    ConversationHistoryState historyState,
    ColorScheme colorScheme,
  ) {
    if (historyState.isLoading && historyState.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.error != null && historyState.conversations.isEmpty) {
      return _ErrorMessage(
        message: historyState.error!,
        colorScheme: colorScheme,
      );
    }

    final filtered = historyState.filtered;
    final grouped = groupConversationsByDate(filtered);

    if (grouped.isEmpty) {
      return const HistoryEmptyState();
    }

    return ListView.builder(
      padding: _listPadding(context),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final section = grouped[index];
        return DateSection(
          label: section.label,
          conversations: section.conversations,
          isOlder: section.isOlder,
        );
      },
    );
  }

  // ── Partner Chat Tab ──────────────────────────

  Widget _buildPartnerBody(
    BuildContext context,
    ConversationHistoryState historyState,
    ColorScheme colorScheme,
  ) {
    if (historyState.isLoadingPartner &&
        historyState.partnerConversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.partnerError != null &&
        historyState.partnerConversations.isEmpty) {
      return _ErrorMessage(
        message: historyState.partnerError!,
        colorScheme: colorScheme,
      );
    }

    final filtered = historyState.filteredPartner;
    final grouped = groupPartnerConversationsByDate(filtered);

    if (grouped.isEmpty) {
      return const HistoryEmptyState();
    }

    return ListView.builder(
      padding: _listPadding(context),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final section = grouped[index];
        return PartnerDateSection(
          label: section.label,
          conversations: section.conversations,
          isOlder: section.isOlder,
        );
      },
    );
  }

  // ── Shared helpers ────────────────────────────

  EdgeInsets _listPadding(BuildContext context) {
    return EdgeInsets.only(
      left: AppDimens.horizontalPadding(context),
      right: AppDimens.horizontalPadding(context),
      top: AppDimens.spaceLg,
      // FAB clearance
      bottom: AppDimens.bottomScrollPadding(context) + 80,
    );
  }
}

// ─────────────────────────────────────────────────
// Private reusable sub-widgets
// ─────────────────────────────────────────────────

/// Inline search text field for the app bar.
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.textTheme,
    required this.colorScheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: onChanged,
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search conversations...',
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      ),
    );
  }
}

/// Centred error message with the theme's error
/// colour.
class _ErrorMessage extends StatelessWidget {
  final String message;
  final ColorScheme colorScheme;

  const _ErrorMessage({required this.message, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.horizontalPadding(context)),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
