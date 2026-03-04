// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the message list for the active conversation
/// with SSE streaming support.
///
/// Each SSE stream can produce **multiple** bot messages:
/// - `token` events accumulate into a text message
/// - `service_recommendation` / `ner_location` events
///   each create a separate message
/// - If tokens arrive after a rich event, a new text
///   segment begins

@ProviderFor(Chat)
const chatProvider = ChatFamily._();

/// Manages the message list for the active conversation
/// with SSE streaming support.
///
/// Each SSE stream can produce **multiple** bot messages:
/// - `token` events accumulate into a text message
/// - `service_recommendation` / `ner_location` events
///   each create a separate message
/// - If tokens arrive after a rich event, a new text
///   segment begins
final class ChatProvider extends $NotifierProvider<Chat, ChatState> {
  /// Manages the message list for the active conversation
  /// with SSE streaming support.
  ///
  /// Each SSE stream can produce **multiple** bot messages:
  /// - `token` events accumulate into a text message
  /// - `service_recommendation` / `ner_location` events
  ///   each create a separate message
  /// - If tokens arrive after a rich event, a new text
  ///   segment begins
  const ChatProvider._({
    required ChatFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'chatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatHash();

  @override
  String toString() {
    return r'chatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Chat create() => Chat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatHash() => r'71030df5acf3b46010276abba4455d9faa228f05';

/// Manages the message list for the active conversation
/// with SSE streaming support.
///
/// Each SSE stream can produce **multiple** bot messages:
/// - `token` events accumulate into a text message
/// - `service_recommendation` / `ner_location` events
///   each create a separate message
/// - If tokens arrive after a rich event, a new text
///   segment begins

final class ChatFamily extends $Family
    with $ClassFamilyOverride<Chat, ChatState, ChatState, ChatState, String?> {
  const ChatFamily._()
    : super(
        retry: null,
        name: r'chatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages the message list for the active conversation
  /// with SSE streaming support.
  ///
  /// Each SSE stream can produce **multiple** bot messages:
  /// - `token` events accumulate into a text message
  /// - `service_recommendation` / `ner_location` events
  ///   each create a separate message
  /// - If tokens arrive after a rich event, a new text
  ///   segment begins

  ChatProvider call(String? conversationId) =>
      ChatProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatProvider';
}

/// Manages the message list for the active conversation
/// with SSE streaming support.
///
/// Each SSE stream can produce **multiple** bot messages:
/// - `token` events accumulate into a text message
/// - `service_recommendation` / `ner_location` events
///   each create a separate message
/// - If tokens arrive after a rich event, a new text
///   segment begins

abstract class _$Chat extends $Notifier<ChatState> {
  late final _$args = ref.$arg as String?;
  String? get conversationId => _$args;

  ChatState build(String? conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
