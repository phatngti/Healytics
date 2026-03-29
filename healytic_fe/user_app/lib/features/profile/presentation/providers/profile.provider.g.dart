// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountMe)
const accountMeProvider = AccountMeProvider._();

final class AccountMeProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserAccountEntity>,
          UserAccountEntity,
          FutureOr<UserAccountEntity>
        >
    with
        $FutureModifier<UserAccountEntity>,
        $FutureProvider<UserAccountEntity> {
  const AccountMeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountMeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountMeHash();

  @$internal
  @override
  $FutureProviderElement<UserAccountEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserAccountEntity> create(Ref ref) {
    return accountMe(ref);
  }
}

String _$accountMeHash() => r'5760c374e71cbcab483bc0ca40f9645d8e92001a';
