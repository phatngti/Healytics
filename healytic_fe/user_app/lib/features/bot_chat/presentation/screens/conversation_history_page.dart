import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/router/routes.dart';

import '../providers/conversation_history.provider.dart';
import '../widgets/history/date_section.widget.dart';
import '../widgets/history/history_app_bar.widget.dart';
import '../widgets/history/history_empty_state.widget.dart';
import '../widgets/history/new_chat_fab.widget.dart';

/// Conversation history page listing past chatbot sessions
/// grouped by date.
///
/// Composes:
/// - [HistoryAppBar] — back button, centred title, search toggle.
/// - Body: date-grouped [DateSection] list.
/// - [NewChatFab] to start a new conversation.
///
/// All dimensions use [AppDimens]; all colours from the active
/// [ColorScheme].
class ConversationHistoryPage extends ConsumerStatefulWidget {
  const ConversationHistoryPage({super.key});

  @override
  ConsumerState<ConversationHistoryPage> createState() =>
      _ConversationHistoryPageState();
}

class _ConversationHistoryPageState
    extends ConsumerState<ConversationHistoryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final historyState = ref.watch(conversationHistoryProvider);
    final filtered = historyState.filtered;
    final grouped = groupConversationsByDate(filtered);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: HistoryAppBar(
        onSearchChanged: (value) {
          ref
              .read(conversationHistoryProvider.notifier)
              .updateSearchQuery(value);
        },
        searchController: _searchController,
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(
            context,
          ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
        ),
        child: _buildBody(context, historyState, grouped, colorScheme),
      ),
      floatingActionButton: NewChatFab(
        onPressed: () {
          const ChatRoute().go(context);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConversationHistoryState historyState,
    List<DateGroup> grouped,
    ColorScheme colorScheme,
  ) {
    if (historyState.isLoading && historyState.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.error != null && historyState.conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.horizontalPadding(context)),
          child: Text(
            historyState.error!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (grouped.isEmpty) {
      return const HistoryEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppDimens.horizontalPadding(context),
        right: AppDimens.horizontalPadding(context),
        top: AppDimens.spaceLg,
        bottom: AppDimens.bottomScrollPadding(context) + 80, // FAB clearance
      ),
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
}
