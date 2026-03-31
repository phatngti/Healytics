import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

import '../providers/conversation_history.provider.dart';
import '../widgets/history/date_section.widget.dart';
import '../widgets/history/history_empty_state.widget.dart';
import '../widgets/history/new_chat_fab.widget.dart';

/// Conversation history page listing past chatbot
/// sessions grouped by date.
///
/// Uses [MainScreenLayout] for consistent
/// header/background across navigation tabs.
///
/// Composes:
/// - Standardised [AppBar] with search toggle
///   action.
/// - Body: date-grouped [DateSection] list.
/// - [NewChatFab] to start a new conversation.
///
/// All dimensions use [AppDimens]; all colours from
/// the active [ColorScheme].
class ConversationHistoryScreen extends ConsumerStatefulWidget {
  const ConversationHistoryScreen({super.key});

  @override
  ConsumerState<ConversationHistoryScreen> createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState
    extends ConsumerState<ConversationHistoryScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(conversationHistoryProvider.notifier).updateSearchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final historyState = ref.watch(conversationHistoryProvider);
    final filtered = historyState.filtered;
    final grouped = groupConversationsByDate(filtered);

    return MainScreenLayout(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  ref
                      .read(conversationHistoryProvider.notifier)
                      .updateSearchQuery(value);
                },
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimens.spaceSm,
                  ),
                ),
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
              _isSearching ? Icons.close : Icons.search,
              color: colorScheme.primary,
            ),
            tooltip: _isSearching ? 'Close search' : 'Search',
            onPressed: _toggleSearch,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppDimens.borderWidth),
          child: Container(
            height: AppDimens.borderWidth,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      body: _buildBody(context, historyState, grouped, colorScheme),
      floatingActionButton: NewChatFab(
        tapKey: keys.chatScreen.newChatButton,
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
        // FAB clearance
        bottom: AppDimens.bottomScrollPadding(context) + 80,
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
