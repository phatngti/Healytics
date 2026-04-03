// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_chat.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Datasource provider with mock switching.
///
/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations.

@ProviderFor(partnerChatRemoteDatasource)
const partnerChatRemoteDatasourceProvider =
    PartnerChatRemoteDatasourceProvider._();

/// Datasource provider with mock switching.
///
/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations.

final class PartnerChatRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          PartnerChatRemoteDatasource,
          PartnerChatRemoteDatasource,
          PartnerChatRemoteDatasource
        >
    with $Provider<PartnerChatRemoteDatasource> {
  /// Datasource provider with mock switching.
  ///
  /// Uses [AppEnvironment.useMock] to switch between
  /// real and mock implementations.
  const PartnerChatRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerChatRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerChatRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<PartnerChatRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PartnerChatRemoteDatasource create(Ref ref) {
    return partnerChatRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerChatRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerChatRemoteDatasource>(value),
    );
  }
}

String _$partnerChatRemoteDatasourceHash() =>
    r'c1bf77751906a33696801454b5db4ad583fee497';

/// Repository provider.

@ProviderFor(partnerChatRepository)
const partnerChatRepositoryProvider = PartnerChatRepositoryProvider._();

/// Repository provider.

final class PartnerChatRepositoryProvider
    extends
        $FunctionalProvider<
          PartnerChatRepository,
          PartnerChatRepository,
          PartnerChatRepository
        >
    with $Provider<PartnerChatRepository> {
  /// Repository provider.
  const PartnerChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerChatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<PartnerChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PartnerChatRepository create(Ref ref) {
    return partnerChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerChatRepository>(value),
    );
  }
}

String _$partnerChatRepositoryHash() =>
    r'5ca2331a34909861c51baaa1369f8aaf507fee6d';

/// Main chat notifier — manages the full lifecycle of
/// a partner chat conversation.
///
/// Parameters:
/// - [partnerAccountId]: The partner to chat with
/// - [partnerName]: Display name for the header

@ProviderFor(PartnerChat)
const partnerChatProvider = PartnerChatFamily._();

/// Main chat notifier — manages the full lifecycle of
/// a partner chat conversation.
///
/// Parameters:
/// - [partnerAccountId]: The partner to chat with
/// - [partnerName]: Display name for the header
final class PartnerChatProvider
    extends $NotifierProvider<PartnerChat, PartnerChatState> {
  /// Main chat notifier — manages the full lifecycle of
  /// a partner chat conversation.
  ///
  /// Parameters:
  /// - [partnerAccountId]: The partner to chat with
  /// - [partnerName]: Display name for the header
  const PartnerChatProvider._({
    required PartnerChatFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'partnerChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$partnerChatHash();

  @override
  String toString() {
    return r'partnerChatProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PartnerChat create() => PartnerChat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerChatState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PartnerChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$partnerChatHash() => r'3af226c8fe603259f356ccec456af6ff32abe066';

/// Main chat notifier — manages the full lifecycle of
/// a partner chat conversation.
///
/// Parameters:
/// - [partnerAccountId]: The partner to chat with
/// - [partnerName]: Display name for the header

final class PartnerChatFamily extends $Family
    with
        $ClassFamilyOverride<
          PartnerChat,
          PartnerChatState,
          PartnerChatState,
          PartnerChatState,
          (String, String)
        > {
  const PartnerChatFamily._()
    : super(
        retry: null,
        name: r'partnerChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Main chat notifier — manages the full lifecycle of
  /// a partner chat conversation.
  ///
  /// Parameters:
  /// - [partnerAccountId]: The partner to chat with
  /// - [partnerName]: Display name for the header

  PartnerChatProvider call(String partnerAccountId, String partnerName) =>
      PartnerChatProvider._(
        argument: (partnerAccountId, partnerName),
        from: this,
      );

  @override
  String toString() => r'partnerChatProvider';
}

/// Main chat notifier — manages the full lifecycle of
/// a partner chat conversation.
///
/// Parameters:
/// - [partnerAccountId]: The partner to chat with
/// - [partnerName]: Display name for the header

abstract class _$PartnerChat extends $Notifier<PartnerChatState> {
  late final _$args = ref.$arg as (String, String);
  String get partnerAccountId => _$args.$1;
  String get partnerName => _$args.$2;

  PartnerChatState build(String partnerAccountId, String partnerName);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<PartnerChatState, PartnerChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PartnerChatState, PartnerChatState>,
              PartnerChatState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
