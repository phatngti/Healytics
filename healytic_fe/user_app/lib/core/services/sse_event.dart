/// A raw Server-Sent Event with a named type
/// and a JSON data payload.
///
/// This is the generic, feature-agnostic
/// representation. Feature-level code should map
/// this into domain-specific event types.
class SseEvent {
  /// The SSE `event:` field value
  /// (e.g. `token`, `done`, `error`).
  final String type;

  /// The parsed JSON from the `data:` field.
  final Map<String, dynamic> data;

  /// Creates an [SseEvent].
  const SseEvent({
    required this.type,
    required this.data,
  });

  @override
  String toString() => 'SseEvent(type: $type, data: $data)';
}
