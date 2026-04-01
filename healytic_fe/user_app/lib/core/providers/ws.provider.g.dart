// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Singleton [WsService] provider — the centralised
/// façade for all WebSocket namespaces.
///
/// Mirrors [apiServiceProvider] for REST.
/// Disposing this provider tears down every active
/// socket connection.

@ProviderFor(wsService)
const wsServiceProvider = WsServiceProvider._();

/// Singleton [WsService] provider — the centralised
/// façade for all WebSocket namespaces.
///
/// Mirrors [apiServiceProvider] for REST.
/// Disposing this provider tears down every active
/// socket connection.

final class WsServiceProvider
    extends $FunctionalProvider<WsService, WsService, WsService>
    with $Provider<WsService> {
  /// Singleton [WsService] provider — the centralised
  /// façade for all WebSocket namespaces.
  ///
  /// Mirrors [apiServiceProvider] for REST.
  /// Disposing this provider tears down every active
  /// socket connection.
  const WsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wsServiceHash();

  @$internal
  @override
  $ProviderElement<WsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WsService create(Ref ref) {
    return wsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WsService>(value),
    );
  }
}

String _$wsServiceHash() => r'57a31bf32d26bbcbb93ac45ee67c52d1a84e56e0';
