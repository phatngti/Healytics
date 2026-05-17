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

@ProviderFor(profileSummary)
const profileSummaryProvider = ProfileSummaryProvider._();

final class ProfileSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileSummaryEntity>,
          ProfileSummaryEntity,
          FutureOr<ProfileSummaryEntity>
        >
    with
        $FutureModifier<ProfileSummaryEntity>,
        $FutureProvider<ProfileSummaryEntity> {
  const ProfileSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSummaryHash();

  @$internal
  @override
  $FutureProviderElement<ProfileSummaryEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileSummaryEntity> create(Ref ref) {
    return profileSummary(ref);
  }
}

String _$profileSummaryHash() => r'b2c83e10f2e884f8d7c71f7d9f80b75dfc3d094f';
