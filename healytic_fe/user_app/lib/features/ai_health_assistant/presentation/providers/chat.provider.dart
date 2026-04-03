import 'dart:async';

import 'package:logging/logging.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/ai_health_assistant/domain/repositories/chat.repository.dart';
import 'package:user_app/features/ai_health_assistant/data/repositories/chat_impl.repository.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_message.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_sse_event.entity.dart';

part 'chat.provider.g.dart';

/// Immutable state for the active chat conversation.
class ChatState {
  /// Whether the bot is currently streaming a response.
  final bool isLoading;

  /// Optional error message on failure.
  final String? error;

  /// Messages in the active conversation, ordered
  /// chronologically.
  final List<ChatMessage> messages;

  /// The conversation ID (set after first message).
  final String? activeConversationId;

  const ChatState({
    this.isLoading = false,
    this.error,
    this.messages = const [],
    this.activeConversationId,
  });

  ChatState copyWith({
    bool? isLoading,
    String? error,
    List<ChatMessage>? messages,
    String? activeConversationId,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      messages: messages ?? this.messages,
      activeConversationId: activeConversationId ??
          this.activeConversationId,
    );
  }
}

/// Sentence-ending pattern: `.` `!` or `?` at end
/// of buffer, or followed by whitespace.
final _sentenceEndRegex = RegExp(r'[.!?](?:\s|$)');

/// Manages the message list for the active conversation
/// with SSE streaming support.
///
/// Each SSE stream can produce **multiple** bot messages:
/// - `token` events accumulate into a text message
/// - `service_recommendation` / `ner_location` events
///   each create a separate message
/// - If tokens arrive after a rich event, a new text
///   segment begins
@riverpod
class Chat extends _$Chat {
  static final _log = Logger('Chat');
  late final ChatRepository _repository;
  StreamSubscription<ChatSseEvent>? _sseSubscription;

  // ── Sentence-splitting state ──────────────────
  /// Accumulates tokens for the current sentence.
  final StringBuffer _pendingBuffer = StringBuffer();

  /// Unique ID for the current in-progress message.
  String _currentPendingId = '';

  /// Base ID prefix for the current stream segment.
  String _segmentBaseId = '';

  /// Counter for generating unique sentence IDs.
  int _sentenceCounter = 0;

  @override
  ChatState build(String? conversationId) {
    _repository = ref.read(chatRepositoryProvider);

    // Cancel SSE subscription when provider is
    // disposed.
    ref.onDispose(() {
      _sseSubscription?.cancel();
    });

    // Load messages if we have a valid
    // conversationId.
    if (conversationId != null &&
        conversationId.isNotEmpty) {
      Future.microtask(
        () => loadMessages(conversationId),
      );
    }
    return ChatState(
      activeConversationId: conversationId,
    );
  }

  /// Fetches messages for [conversationId] from the
  /// repository.
  Future<void> loadMessages(
    String conversationId,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final messages = await _repository.getMessages(
        conversationId,
      );
      state = state.copyWith(
        isLoading: false,
        messages: messages,
      );
    } catch (e, st) {
      _log.severe(
        'Error loading chat messages',
        e,
        st,
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages.',
      );
    }
  }

  /// Sends a user [text] message, then listens to the
  /// SSE stream for bot response tokens.
  ///
  /// Each stream can produce multiple bot messages:
  /// 1. Adds user message to state immediately
  /// 2. Sets loading (typing indicator)
  /// 3. Listens to SSE stream events
  /// 4. Creates separate messages per sentence
  /// 5. Finalises on `done` event
  Future<void> sendMessage(String text) async {
    // Cancel any previous stream.
    await _sseSubscription?.cancel();

    final convId =
        state.activeConversationId ?? conversationId;

    // Add user message optimistically.
    final userMessage = ChatMessage(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      text: text,
      timestamp: DateTime.now(),
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final stream =
          _repository.sendMessageAndStream(
            convId,
            text,
          );

      // Initialise sentence-splitting state.
      _segmentBaseId =
          'bot-${DateTime.now().millisecondsSinceEpoch}';
      _sentenceCounter = 0;
      _currentPendingId =
          '$_segmentBaseId-s$_sentenceCounter';
      _pendingBuffer.clear();

      _sseSubscription = stream.listen(
        _handleSseEvent,
        onError: (Object error) {
          _log.severe('SSE stream error', error);
          state = state.copyWith(
            isLoading: false,
            error:
                'Connection lost. Please retry.',
          );
        },
        onDone: () {
          // Stream closed; finalize if still
          // loading.
          if (state.isLoading) {
            _finaliseStream(
              const ChatSseEvent(
                type: ChatSseEventType.done,
                data: {},
              ),
            );
          }
        },
      );
    } catch (e, st) {
      _log.severe('Error sending message', e, st);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send message.',
      );
    }
  }

  /// Handles individual SSE events by dispatching to
  /// the appropriate handler.
  void _handleSseEvent(ChatSseEvent event) {
    switch (event.type) {
      case ChatSseEventType.token:
        _appendToken(event, _segmentBaseId);
        break;

      case ChatSseEventType.serviceRecommendation:
        _handleRichEvent(
          event,
          _segmentBaseId,
          ChatMessageType.serviceRecommendation,
        );
        break;

      case ChatSseEventType.nerLocation:
        _handleRichEvent(
          event,
          _segmentBaseId,
          ChatMessageType.nerLocation,
        );
        break;

      case ChatSseEventType.done:
        _finaliseStream(event);
        break;

      case ChatSseEventType.error:
        state = state.copyWith(
          isLoading: false,
          error: event.errorMessage.isNotEmpty
              ? event.errorMessage
              : 'An error occurred.',
        );
        break;
    }
  }

  /// Appends a token and splits completed sentences
  /// into separate messages.
  ///
  /// Tokens accumulate in [_pendingBuffer]. When a
  /// sentence boundary is found, the completed
  /// sentence is frozen as its own [ChatMessage] and
  /// a new pending message begins.
  void _appendToken(
    ChatSseEvent event,
    String segmentBaseId,
  ) {
    // Space between word-level tokens.
    if (_pendingBuffer.isNotEmpty) {
      _pendingBuffer.write(' ');
    }
    _pendingBuffer.write(event.tokenText);

    final raw = _pendingBuffer.toString();
    final messages = [...state.messages];

    // Check for sentence-ending punctuation.
    final matches =
        _sentenceEndRegex.allMatches(raw).toList();

    if (matches.isNotEmpty) {
      // Split at the last sentence boundary.
      final lastMatch = matches.last;
      final splitPos = lastMatch.start + 1;
      final completed =
          raw.substring(0, splitPos).trim();
      final remainder =
          raw.substring(splitPos).trim();

      // Freeze the completed sentence(s).
      if (completed.isNotEmpty) {
        final frozenId = _currentPendingId;
        final idx = messages.indexWhere(
          (m) => m.id == frozenId,
        );
        final frozen = ChatMessage(
          id: frozenId,
          text: completed,
          timestamp: DateTime.now(),
        );
        if (idx >= 0) {
          messages[idx] = frozen;
        } else {
          messages.add(frozen);
        }

        // Start a new pending message for
        // remainder.
        _sentenceCounter++;
        _currentPendingId =
            '$segmentBaseId-s$_sentenceCounter';
        _pendingBuffer
          ..clear()
          ..write(remainder);
      }

      // Show the remainder as a live pending bubble
      // (or remove stale pending if empty).
      if (remainder.isNotEmpty) {
        final pendingIdx = messages.indexWhere(
          (m) => m.id == _currentPendingId,
        );
        final pending = ChatMessage(
          id: _currentPendingId,
          text: remainder,
          timestamp: DateTime.now(),
        );
        if (pendingIdx >= 0) {
          messages[pendingIdx] = pending;
        } else {
          messages.add(pending);
        }
      }
    } else {
      // No sentence break yet — update live bubble.
      final idx = messages.indexWhere(
        (m) => m.id == _currentPendingId,
      );
      final pending = ChatMessage(
        id: _currentPendingId,
        text: raw,
        timestamp: DateTime.now(),
      );
      if (idx >= 0) {
        messages[idx] = pending;
      } else {
        messages.add(pending);
      }
    }

    state = state.copyWith(messages: messages);
  }

  /// Handles a rich (non-token) SSE event by:
  /// 1. Finalising any in-progress text segment
  /// 2. Adding a new message for the rich content
  /// 3. Resetting pending buffer for subsequent
  ///    tokens
  void _handleRichEvent(
    ChatSseEvent event,
    String segmentBaseId,
    ChatMessageType messageType,
  ) {
    final messages = [...state.messages];

    // Flush any pending text as a frozen message.
    _flushPendingBuffer(messages);

    // Create a rich-content message.
    final richId =
        'rich-${DateTime.now().millisecondsSinceEpoch}';
    final richMessage = ChatMessage(
      id: richId,
      text: _labelForType(messageType),
      timestamp: DateTime.now(),
      messageType: messageType,
      metadata: event.data,
    );
    messages.add(richMessage);

    // Reset pending for tokens after this rich
    // event.
    _sentenceCounter++;
    _currentPendingId =
        '$segmentBaseId-s$_sentenceCounter';
    _pendingBuffer.clear();

    state = state.copyWith(messages: messages);
  }

  /// Returns a human-readable label for non-text
  /// types.
  String _labelForType(ChatMessageType type) {
    return switch (type) {
      ChatMessageType.serviceRecommendation =>
        'Service Recommendations',
      ChatMessageType.nerLocation =>
        'Detected Locations',
      ChatMessageType.text => '',
    };
  }

  /// Flushes any remaining text in [_pendingBuffer]
  /// into [messages] as a frozen message.
  void _flushPendingBuffer(
    List<ChatMessage> messages,
  ) {
    if (_pendingBuffer.isEmpty) return;

    final text = _pendingBuffer.toString().trim();
    if (text.isEmpty) return;

    final idx = messages.indexWhere(
      (m) => m.id == _currentPendingId,
    );
    final frozen = ChatMessage(
      id: _currentPendingId,
      text: text,
      timestamp: DateTime.now(),
    );

    if (idx >= 0) {
      messages[idx] = frozen;
    } else {
      messages.add(frozen);
    }

    // Reset for next potential segment.
    _sentenceCounter++;
    _currentPendingId =
        '$_segmentBaseId-s$_sentenceCounter';
    _pendingBuffer.clear();
  }

  /// Marks the stream as complete, flushing any
  /// remaining pending text.
  void _finaliseStream(ChatSseEvent event) {
    final messages = [...state.messages];
    _flushPendingBuffer(messages);

    final newConvId = event.conversationId;

    state = state.copyWith(
      isLoading: false,
      messages: messages,
      activeConversationId:
          newConvId ?? state.activeConversationId,
    );
  }
}
