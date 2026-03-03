/// SSE event types emitted by the chatbot stream.
///
/// Maps to the NestJS backend event names:
/// `token`, `ner_location`, `service_recommendation`,
/// `done`, `error`.
enum ChatSseEventType {
  /// Incremental text token for streaming response.
  token,

  /// Named-entity recognition for locations.
  nerLocation,

  /// Ranked service recommendations.
  serviceRecommendation,

  /// Stream completed successfully.
  done,

  /// Stream encountered an error.
  error,
}

/// A single SSE event from the chatbot stream.
///
/// Each event carries a [type] and a [data] map with
/// event-specific fields. Common fields across all
/// events: `request_id` and `conversation_id`.
class ChatSseEvent {
  /// The kind of event received.
  final ChatSseEventType type;

  /// Raw data payload from the event.
  final Map<String, dynamic> data;

  const ChatSseEvent({required this.type, required this.data});

  /// Convenience getter for `request_id`.
  String? get requestId => data['request_id'] as String?;

  /// Convenience getter for `conversation_id`.
  String? get conversationId => data['conversation_id'] as String?;

  /// For [ChatSseEventType.token]: the text fragment.
  String get tokenText => data['text'] as String? ?? '';

  /// For [ChatSseEventType.token]: the token index.
  int get tokenIndex => (data['index'] as num?)?.toInt() ?? 0;

  /// For [ChatSseEventType.done]: completion status.
  String get doneStatus => data['status'] as String? ?? '';

  /// For [ChatSseEventType.error]: error code.
  String get errorCode => data['error_code'] as String? ?? '';

  /// For [ChatSseEventType.error]: error message.
  String get errorMessage => data['message'] as String? ?? '';

  /// Parses the raw SSE event-type string into the
  /// corresponding [ChatSseEventType].
  static ChatSseEventType? parseType(String raw) {
    return switch (raw) {
      'token' => ChatSseEventType.token,
      'ner_location' => ChatSseEventType.nerLocation,
      'service_recommendation' => ChatSseEventType.serviceRecommendation,
      'done' => ChatSseEventType.done,
      'error' => ChatSseEventType.error,
      _ => null,
    };
  }
}
